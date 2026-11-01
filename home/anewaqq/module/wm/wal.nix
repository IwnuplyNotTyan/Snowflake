{ pkgs, isSway ? false, ... }:
let
  walpick = pkgs.writeShellScriptBin "walpick" ''
    PATH="${pkgs.lib.makeBinPath [
      pkgs.gum
      pkgs.bash
      pkgs.ffmpeg
      pkgs.feh
      pkgs.swaybg
      pkgs.procps # pkill, used to replace a running swaybg instance
    ]}:$PATH"
set -euo pipefail
IS_SWAY=${if isSway then "1" else "0"}
WALLPAPER_DIR="$HOME/Documents/Pics/"
TOLERANCE=0.05
MIN_WIDTH=1920
MIN_HEIGHT=1080
usage() {
    cat <<EOF
Usage: $(basename "$0") [option] [folder]
Option:
  -t, --tolerance N     Tolerance of deviation from 16:9 (Default: $TOLERANCE)
  -w, --min-width N     Minimal width (Default: $MIN_WIDTH)
  -h, --min-height N    Minimal height (Default: $MIN_HEIGHT)
Example:
  $(basename "$0") -t 0.1 -w 2560 -h 1440 ~/Wallpapers
EOF
}
while [[ $# -gt 0 ]]; do
    case "$1" in
        -t|--tolerance) TOLERANCE="$2"; shift 2 ;;
        -w|--min-width) MIN_WIDTH="$2"; shift 2 ;;
        -h|--min-height) MIN_HEIGHT="$2"; shift 2 ;;
        --help) usage; exit 0 ;;
        *) WALLPAPER_DIR="$1"; shift ;;
    esac
done
if [[ "$IS_SWAY" -eq 1 ]]; then
    SETTER_BIN="swaybg"
else
    SETTER_BIN="feh"
fi
for bin in ffprobe gum shuf "$SETTER_BIN"; do
    if ! command -v "$bin" &>/dev/null; then
        echo "App doesnt founded: $bin" >&2
        exit 1
    fi
done
if [[ ! -d "$WALLPAPER_DIR" ]]; then
    gum log -l error "Catalog not found" dir "$WALLPAPER_DIR"
    exit 1
fi
gum log -l info "Start wallpaper searching" \
    dir "$WALLPAPER_DIR" \
    tolerance "$TOLERANCE" \
    min_resolution "''${MIN_WIDTH}x''${MIN_HEIGHT}"
RESULT_FILE=$(mktemp)
trap 'rm -f "$RESULT_FILE"' EXIT
search() {
    mapfile -d ''' -t files < <(find "$WALLPAPER_DIR" -type f \
        \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.bmp' -o -iname '*.webp' \) \
        -print0 | shuf -z)
    if [[ ''${#files[@]} -eq 0 ]]; then
        echo "NONE|-|-|0|no_files" > "$RESULT_FILE"
        return
    fi
    checked=0
    skipped_res=0
    for file in "''${files[@]}"; do
        checked=$((checked+1))
        dims=$(timeout 5 ffprobe -v error -select_streams v:0 \
            -show_entries stream=width,height \
            -of csv=s=x:p=0 "$file" 2>/dev/null || true)
        [[ -z "$dims" ]] && continue
        width="''${dims%x*}"
        height="''${dims#*x}"
        [[ "$width" =~ ^[0-9]+$ ]] || continue
        [[ "$height" =~ ^[0-9]+$ ]] || continue
        [[ "$height" -eq 0 ]] && continue
        if (( width < MIN_WIDTH || height < MIN_HEIGHT )); then
            skipped_res=$((skipped_res+1))
            continue
        fi
        within=$(awk -v w="$width" -v h="$height" -v tol="$TOLERANCE" 'BEGIN {
            target = 16/9
            ratio = w/h
            diff = ratio - target
            if (diff < 0) diff = -diff
            print (diff < tol) ? 1 : 0
        }')
        if [[ "$within" -eq 1 ]]; then
            echo "$file|$width|$height|$checked|ok" > "$RESULT_FILE"
            return
        fi
    done
    echo "NONE|-|-|$checked|not_found (Skipped: $skipped_res)" > "$RESULT_FILE"
}
export -f search
export WALLPAPER_DIR TOLERANCE MIN_WIDTH MIN_HEIGHT RESULT_FILE
gum spin --spinner dot --title "Searching" -- \
    bash -c "$(declare -f search); search"
IFS='|' read -r found width height checked status < "$RESULT_FILE"
if [[ "$found" == "NONE" ]]; then
    gum log -l error "Image not founded" checked_files "$checked" reason "$status"
    exit 1
fi
gum log -l info "Image found" \
    file "$found" \
    resolution "''${width}x''${height}" \
    checked_files "$checked"
if [[ "$IS_SWAY" -eq 1 ]]; then
    pkill -x swaybg &>/dev/null || true
    setsid swaybg -i "$found" -m fill >/dev/null 2>&1 &
    disown
else
    # X11 (i3, etc.)
    feh --bg-fill "$found"
fi
gum log -l info "Check wallpaper!" file "$found"
'';
in

{
 home.packages = [
   walpick
 ];

 
  home.file.".local/share/vicinae/scripts/walpickvicinae.sh" = {
    executable = true;
    text = ''
#!/usr/bin/env bash
# @vicinae.schemaVersion 1
# @vicinae.title Wallpaper Pick
# @vicinae.mode compact

walpick
  '';};
}
