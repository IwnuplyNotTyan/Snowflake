{ pkgs, ... }:

let
  volListener = pkgs.writeShellScriptBin "vol-listener" ''
    PATH="''${PATH}:${pkgs.lib.makeBinPath [ pkgs.pamixer pkgs.pulseaudio pkgs.ripgrep ]}"
    
    get_vol() { pamixer --get-volume-human | tr -d '%'; }
    
    get_vol
    pactl subscribe | rg --line-buffered "on sink" | while read -r _; do
        get_vol
    done
  '';

  volPopup = pkgs.writeShellScriptBin "vol-popup" ''
    PATH="''${PATH}:${pkgs.lib.makeBinPath [ pkgs.eww pkgs.procps pkgs.playerctl ]}"
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
    PATH="''${PATH}:${pkgs.lib.makeBinPath [ pkgs.playerctl pkgs.coreutils pkgs.gawk ]}"

    COVER_DIR="/tmp/eww-covers"
    mkdir -p "$COVER_DIR"

    get_player_info() {
      local status title artist arturl duration position

      status=$(playerctl -l 2>/dev/null | head -1)
      if [ -z "$status" ]; then
        echo '{"title": "", "artist": "", "cover": "", "duration": 0, "position": 0}'
        return
      fi

      title=$(playerctl metadata title 2>/dev/null | head -1)
      artist=$(playerctl metadata artist 2>/dev/null | head -1)
      arturl=$(playerctl metadata mpris:artUrl 2>/dev/null | head -1 | sed 's/file:\/\///')
      duration=$(playerctl metadata mpris:length 2>/dev/null | head -1)
      position=$(playerctl position 2>/dev/null | head -1)

      if [ -z "$title" ]; then
        title=$(playerctl metadata xesam:title 2>/dev/null | head -1)
      fi
      if [ -z "$artist" ]; then
        artist=$(playerctl metadata xesam:artist 2>/dev/null | head -1)
      fi

      duration=$((duration / 1000000))
      position=$(printf "%.0f" "$position")

      local cover_path=""
      if [ -n "$arturl" ] && [ -f "$arturl" ]; then
        cover_path="$arturl"
      elif [ -n "$arturl" ]; then
        local filename
        filename=$(basename "$arturl")
        local cached="$COVER_DIR/$filename"
        if [ ! -f "$cached" ] && [ -r "$arturl" ]; then
          cp "$arturl" "$cached" 2>/dev/null
        fi
        if [ -f "$cached" ]; then
          cover_path="$cached"
        fi
      fi

      format_time() {
      local secs=$1
      local mins=$((secs / 60))
      local rem=$((secs % 60))
      printf "%d:%02d" $mins $rem
    }

    elapsed=$(format_time $position)
    remaining=$((duration - position))
    remaining_formatted=$(format_time $remaining)

    title=$(echo "$title" | sed 's/"/\\"/g')
    artist=$(echo "$artist" | sed 's/"/\\"/g')

    echo "{\"title\": \"$title\", \"artist\": \"$artist\", \"cover\": \"$cover_path\", \"duration\": $duration, \"position\": $position, \"elapsed\": \"$elapsed\", \"remaining\": \"$remaining_formatted\"}"
    }

    get_player_info
    playerctl -F position 2>/dev/null | while read -r _; do
      get_player_info
    done
  '';
in {
  programs.eww = {
    enable = true;
    configDir = ./.;
  };

  home.packages = [ 
    # Eww Script's
    volListener 
    volPopup 
    playerListener
  ];
}
