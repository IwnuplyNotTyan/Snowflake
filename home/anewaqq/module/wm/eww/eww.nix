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
    PATH="''${PATH}:${pkgs.lib.makeBinPath [ pkgs.eww pkgs.procps ]}"
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
in {
  programs.eww = {
    enable = true;
    configDir = ./.;
  };

  home.packages = [ 
    # Eww Script's
    volListener 
    volPopup 
  ];
}
