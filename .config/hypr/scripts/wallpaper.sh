#!/bin/bash
# -----------------------------------------------------
# Const
# -----------------------------------------------------
CACHE_DIR="$HOME/.config/wallpapercache"
LOCKFILE="$CACHE_DIR/waypaper-running"
WAYPAPER_CONFIG="$HOME/.config/waypaper/config.ini"
CURRENT_WALLPAPER="$CACHE_DIR/current_wallpaper.png"
BLURRED_WALLPAPER="$CACHE_DIR/blurred_wallpaper.png"
SQUARE_WALLPAPER="$CACHE_DIR/square_wallpaper.png"
RASI_FILE="$CACHE_DIR/current_wallpaper.rasi"
BLUR="50x30"

# -----------------------------------------------------
# Cleanup
# -----------------------------------------------------
cleanup() {
  rm -f "$LOCKFILE"
}
trap cleanup EXIT

mkdir -p "$CACHE_DIR"

# -----------------------------------------------------
# Lock
# -----------------------------------------------------
[[ -f "$LOCKFILE" ]] && exit 0
touch "$LOCKFILE"

# -----------------------------------------------------
# Resolve wallpaper
# -----------------------------------------------------
get_from_waypaper() {
  grep '^wallpaper =' "$WAYPAPER_CONFIG" |
    cut -d '=' -f2- |
    sed 's/^[[:space:]]*//;s/[[:space:]]*$//' |
    sed "s|~|$HOME|"
}

if [[ "${1:-}" == "init" ]]; then
  WALLPAPER="$(get_from_waypaper)"
else
  WALLPAPER="${1:-$(get_from_waypaper)}"
fi

WALLPAPER="${WALLPAPER/#\~/$HOME}"
[[ -f "$WALLPAPER" ]] || exit 1

# -----------------------------------------------------
# Apply wallpaper
# -----------------------------------------------------
cp "$WALLPAPER" "$CURRENT_WALLPAPER"
pkill hyprpaper 2>/dev/null || true
sleep 0.2
hyprpaper >/dev/null 2>&1 &

# -----------------------------------------------------
# Kill picker
# -----------------------------------------------------
pkill -f waypaper 2>/dev/null || true

# -----------------------------------------------------
# Derived images
# -----------------------------------------------------
magick "$WALLPAPER" -resize 75% "$BLURRED_WALLPAPER"

[[ "$BLUR" != "0x0" ]] &&
  magick "$BLURRED_WALLPAPER" -blur "$BLUR" "$BLURRED_WALLPAPER"

magick "$WALLPAPER" -gravity Center -extent 1:1 "$SQUARE_WALLPAPER"

touch "$RASI_FILE"
