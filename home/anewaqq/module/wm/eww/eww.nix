{ pkgs, ... }:

let
  python = pkgs.python3.withPackages (ps: [ ps.dbus-next ]);

  volListener = pkgs.writeShellScriptBin "vol-listener" ''
    PATH="${pkgs.lib.makeBinPath [ pkgs.pamixer pkgs.gnused pkgs.pulseaudio pkgs.ripgrep ]}:$PATH"

    get_vol() {
      local vol=$(pamixer --get-volume-human | tr -d '%')
      local sink_name=$(pactl get-default-sink)
      local device=$(pactl list sinks | grep -A 50 "Name: $sink_name" | grep "Description:" | cut -d: -f2- | xargs)
      local short_device=$(echo "$device" | sed 's/Built-in Audio //; s/Digital Stereo //')
      echo "{\"percent\": \"$vol\", \"device\": \"$short_device\"}"
    }

    get_vol
    pactl subscribe | rg --line-buffered "on sink" | while read -r _; do
      get_vol
    done
  '';

  volPopup = pkgs.writeShellScriptBin "vol-popup" ''
    PATH="${pkgs.lib.makeBinPath [ pkgs.eww pkgs.procps pkgs.playerctl ]}:$PATH"
    LOCK_FILE="/tmp/eww-volume-timer.lock"

    if ! eww active-windows | grep -q "volume"; then
      eww open volume >/dev/null 2>&1
    fi

    if [ -f "$LOCK_FILE" ]; then
      PID=$(cat "$LOCK_FILE")
      kill "$PID" >/dev/null 2>&1
      rm -f "$LOCK_FILE"
    fi

    (
      sleep 2
      eww close volume >/dev/null 2>&1
      rm -f "$LOCK_FILE"
    ) &
    echo $! > "$LOCK_FILE"
  '';

  playerListener = pkgs.writeShellScriptBin "player-listener" ''
    PATH="${pkgs.lib.makeBinPath [ pkgs.playerctl pkgs.coreutils pkgs.gnused pkgs.gnugrep ]}:$PATH"
    export LC_NUMERIC=C

    NO_TRACK='{"title": "No track", "artist": "Unknown", "cover": "", "duration": 100, "position": 0, "elapsed": "0:00", "remaining": "0:00"}'

    format_time() {
      local secs=$1
      [ -z "$secs" ] || [ "$secs" -lt 0 ] && secs=0
      printf "%d:%02d" $((secs / 60)) $((secs % 60))
    }

    get_player_info() {
      local player
      player=$(playerctl --list-all 2>/dev/null | xargs -I {} playerctl -p {} status -f "{} {{status}}" 2>/dev/null | grep "Playing" | cut -d' ' -f1 | head -1)

      if [ -z "$player" ]; then
        player=$(playerctl --list-all 2>/dev/null | xargs -I {} playerctl -p {} status -f "{} {{status}}" 2>/dev/null | grep "Paused" | cut -d' ' -f1 | head -1)
      fi

      if [ -z "$player" ]; then
        echo "$NO_TRACK"
        return
      fi

      local status
      status=$(playerctl -p "$player" status 2>/dev/null)
      if [ -z "$status" ] || [ "$status" = "Stopped" ]; then
        echo "$NO_TRACK"
        return
      fi

      local title artist arturl mpris_len pos
      title=$(playerctl -p "$player" metadata title 2>/dev/null)
      artist=$(playerctl -p "$player" metadata artist 2>/dev/null)
      arturl=$(playerctl -p "$player" metadata mpris:artUrl 2>/dev/null)
      mpris_len=$(playerctl -p "$player" metadata mpris:length 2>/dev/null)
      pos=$(playerctl -p "$player" position 2>/dev/null)

      if [ -z "$title" ]; then
        echo "$NO_TRACK"
        return
      fi

      if [[ "$mpris_len" =~ ^[0-9]+$ ]]; then
        duration_secs=$((mpris_len / 1000000))
      else
        duration_secs=100
      fi
      [ "$duration_secs" -eq 0 ] && duration_secs=100

      pos_secs=$(echo "$pos" | sed 's/\..*//')
      [ -z "$pos_secs" ] && pos_secs=0

      local cover_path=""
      clean_url=$(echo "$arturl" | sed 's/file:\/\///g')
      [ -f "$clean_url" ] && cover_path="$clean_url"

      clean_title=$(echo "''${title}" | sed 's/"/\\"/g')
      clean_artist=$(echo "''${artist:-Unknown}" | sed 's/"/\\"/g')

      echo "{\"title\": \"$clean_title\", \"artist\": \"$clean_artist\", \"cover\": \"$cover_path\", \"duration\": $duration_secs, \"position\": $pos_secs, \"elapsed\": \"$(format_time $pos_secs)\", \"remaining\": \"$(format_time $((duration_secs - pos_secs)))\"}"
    }

    while true; do
      get_player_info
      sleep 1
    done
  '';

  notifListener = pkgs.writeScriptBin "notif-listener" ''
#!${python}/bin/python3
import asyncio, json, os, re, subprocess
from collections import OrderedDict
from dbus_next.aio import MessageBus
from dbus_next.service import ServiceInterface, method
from dbus_next import BusType

APP_ICONS = {
    "firefox": "󰈹", "chromium": "󰈹", "google-chrome": "󰈹",
    "telegram": "", "discord": "󰙯", "spotify": "",
    "mpv": "󰐊", "vlc": "󰕼", "thunderbird": "󰇮",
    "code": "󰨞", "bash": "", "zsh": "", "default": "󰂚"
}
TIMEOUT_DEFAULT = 5
MAX_NOTIFS      = 3
MAX_HISTORY     = 3
notifications   = OrderedDict()
history         = []          # постоянная память последних 3 уведомлений
next_id         = 1

# Звук: ищем стандартный message.oga из freedesktop sound theme
_SOUND_CANDIDATES = [
    "/run/current-system/sw/share/sounds/freedesktop/stereo/message.oga",
    "/run/current-system/sw/share/sounds/freedesktop/stereo/message-new-instant.oga",
    "/run/current-system/sw/share/sounds/freedesktop/stereo/bell.oga",
    "/usr/share/sounds/freedesktop/stereo/message.oga",
    "/usr/share/sounds/freedesktop/stereo/bell.oga",
]

def _find_sound():
    for p in _SOUND_CANDIDATES:
        if os.path.exists(p):
            return p
    # fallback: поиск через find в типичных prefix'ах
    for base in ["/run/current-system/sw", "/usr"]:
        d = os.path.join(base, "share/sounds/freedesktop/stereo")
        if os.path.isdir(d):
            for f in os.listdir(d):
                if f.endswith(".oga") or f.endswith(".wav"):
                    return os.path.join(d, f)
    return None

_SOUND_FILE = _find_sound()

def play_sound():
    if _SOUND_FILE:
        # paplay из пакета pulseaudio/pipewire-pulse
        subprocess.Popen(
            ["paplay", _SOUND_FILE],
            stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
        )

def get_icon(app):
    return APP_ICONS.get((app or "").lower().split()[0], APP_ICONS["default"])

def eww_update(data):
    arr  = json.dumps(list(data.values()), ensure_ascii=False)
    hist = json.dumps(history, ensure_ascii=False)
    cnt  = str(len(data))
    subprocess.Popen(
        ["eww", "update",
         f"notifications={arr}",
         f"notif-count={cnt}",
         f"notif-history={hist}"],
        stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL
    )

def remove_notif(nid):
    if nid in notifications:
        del notifications[nid]
        eww_update(notifications)

class Notifs(ServiceInterface):
    def __init__(self, loop):
        super().__init__("org.freedesktop.Notifications")
        self._loop = loop

    @method()
    def GetCapabilities(self) -> "as":
        return ["body", "body-markup", "icon-static"]

    @method()
    def GetServerInformation(self) -> "ssss":
        return ["eww-notif", "eww", "1.0", "1.2"]

    @method()
    def Notify(self, app_name:"s", replaces_id:"u", app_icon:"s",
               summary:"s", body:"s", actions:"as",
               hints:"a{sv}", expire_timeout:"i") -> "u":
        global next_id
        nid = replaces_id if replaces_id != 0 else next_id
        if replaces_id == 0:
            next_id += 1
        
        clean_body = re.sub(r"<[^>]+>", "", body).strip()
        
        # Поиск изображения в hints и app_icon [cite: 34, 35]
        img_path = ""
        if "image-path" in hints:
            img_path = hints["image-path"].value
        elif "image_path" in hints:
            img_path = hints["image_path"].value
        
        if not img_path:
            if app_icon.startswith("/") or app_icon.startswith("file://"):
                img_path = app_icon.replace("file://", "")
        
        notifications[nid] = {
            "id": nid, 
            "app": app_name or "notify",
            "summary": summary, 
            "body": clean_body,
            "icon": get_icon(app_name),
            "image": img_path
        }
        
        while len(notifications) > MAX_NOTIFS:
            notifications.popitem(last=False)

        # Записать в постоянную историю (не зависит от таймаута)
        entry = {
            "id": nid,
            "app": app_name or "notify",
            "summary": summary,
            "body": clean_body,
            "icon": get_icon(app_name),
            "image": img_path
        }
        # Обновить существующую запись или добавить новую
        for i, h in enumerate(history):
            if h["id"] == nid:
                history[i] = entry
                break
        else:
            history.append(entry)
        if len(history) > MAX_HISTORY:
            history.pop(0)

        eww_update(notifications)
        play_sound()

        secs = expire_timeout / 1000 if expire_timeout > 0 else TIMEOUT_DEFAULT
        self._loop.call_later(secs, lambda: remove_notif(nid))
        return nid

    @method()
    def CloseNotification(self, id:"u"):
        remove_notif(id)

async def main():
    loop = asyncio.get_event_loop()
    bus  = await MessageBus(bus_type=BusType.SESSION).connect()
    bus.export("/org/freedesktop/Notifications", Notifs(loop))
    await bus.request_name("org.freedesktop.Notifications")
    eww_update(notifications)
    await loop.create_future()

if __name__ == "__main__":
    asyncio.run(main())
  '';
in {
  programs.eww = {
    enable = true;
    configDir = ./.;
  };

  home.packages = [
    volListener
    volPopup
    playerListener
    notifListener
    pkgs.pulseaudio   # paplay для звука уведомлений
  ];
}
