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
    PATH="''${PATH}:${pkgs.lib.makeBinPath [ pkgs.playerctl pkgs.coreutils pkgs.gnused pkgs.gnugrep ]}"
    export LC_NUMERIC=C 

    COVER_DIR="/tmp/eww-covers"
    mkdir -p "$COVER_DIR"

    format_time() {
        local secs=$1
        [ -z "$secs" ] || [ "$secs" -lt 0 ] && secs=0
        printf "%d:%02d" $((secs / 60)) $((secs % 60))
    }

    get_player_info() {
      local player
      player=$(playerctl --list-all 2>/dev/null | xargs -I {} playerctl -p {} status -f "{} {{status}}" 2>/dev/null | grep "Playing" | cut -d' ' -f1 | head -1)

      if [ -z "$player" ]; then
        player=$(playerctl --list-all 2>/dev/null | head -1)
      fi

      if [ -z "$player" ] || [ "$player" = "No players found" ]; then
        echo '{"title": "No track", "artist": "Unknown", "cover": "", "duration": 100, "position": 0, "elapsed": "0:00", "remaining": "0:00"}'
        return
      fi

      local title artist arturl mpris_len pos
      title=$(playerctl -p "$player" metadata title 2>/dev/null)
      artist=$(playerctl -p "$player" metadata artist 2>/dev/null)
      arturl=$(playerctl -p "$player" metadata mpris:artUrl 2>/dev/null)
      mpris_len=$(playerctl -p "$player" metadata mpris:length 2>/dev/null)
      pos=$(playerctl -p "$player" position 2>/dev/null)

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
      if [ -f "$clean_url" ]; then
          cover_path="$clean_url"
      fi

      clean_title=$(echo "''${title:-No Title}" | sed 's/"/\\"/g')
      clean_artist=$(echo "''${artist:-Unknown Artist}" | sed 's/"/\\"/g')

      echo "{\"title\": \"$clean_title\", \"artist\": \"$clean_artist\", \"cover\": \"$cover_path\", \"duration\": $duration_secs, \"position\": $pos_secs, \"elapsed\": \"$(format_time $pos_secs)\", \"remaining\": \"$(format_time $((duration_secs - pos_secs)))\"}"
    }

    get_player_info
    playerctl metadata -F --format '{{status}}' 2>/dev/null | while read -r _; do
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
