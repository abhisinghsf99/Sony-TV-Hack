#!/usr/bin/env bash
# Push a cleanyourtv launcher theme (folder with config.json, optional wallpaper.jpg, wallpaper_front.png and a
# wallpapers/ folder of pictures that rotate when config.json sets wallpaper_rotation_minutes) to the TV and
# restart Home. Same steps as cleanyourtv's tools/theme.sh, with plain adb instead of its Python venv:
# files are written through the launcher's ThemeProvider so the launcher owns them, falling back to cp.
#   scripts/theme-push.sh themes/appletv
#   scripts/theme-push.sh --reset            # back to the launcher's built-in look
set -u
cd "$(dirname "$0")/.." || exit 1
. scripts/tvlib.sh

PKG=com.gathin.tvhome
DIR=/sdcard/Android/data/$PKG/files
URI=content://$PKG.theme
TMP=/data/local/tmp/cyt-theme

put() {   # put <local file> <name in the launcher's files dir>; stops the run if the file did not land
  local tmp="$TMP-${2//\//_}"
  adb -s "$TV" push "$1" "$tmp" >/dev/null || { echo "adb push of $1 failed" >&2; exit 1; }
  D "rm -f $DIR/$2; content write --uri $URI/$2 < $tmp 2>/dev/null || cp $tmp $DIR/$2; rm -f $tmp"
  D "[ -s $DIR/$2 ]" || { echo "$2 is not on the TV after the write" >&2; exit 1; }
}
del() { D "rm -f $DIR/$1 2>/dev/null; content delete --uri $URI/$1 2>/dev/null; true"; }

tv_connect || exit 1
D mkdir -p "$DIR"
if [ "${1:-}" = --reset ]; then
  del config.json; del wallpaper.jpg; del wallpaper_front.png; del wallpapers; D "rm -rf $DIR/wallpapers"
else
  THEME="${1:?usage: scripts/theme-push.sh <theme folder> | --reset}"
  python3 -I -c 'import json,sys; assert isinstance(json.load(open(sys.argv[1])), dict)' "$THEME/config.json" \
    || { echo "$THEME/config.json is not a JSON object; nothing sent" >&2; exit 1; }
  put "$THEME/config.json" config.json
  if [ -f "$THEME/wallpaper.jpg" ]; then put "$THEME/wallpaper.jpg" wallpaper.jpg; else del wallpaper.jpg; fi
  # lock_clock's foreground layer; only the lock-screen fork of the launcher reads it.
  if [ -f "$THEME/wallpaper_front.png" ]; then put "$THEME/wallpaper_front.png" wallpaper_front.png; else del wallpaper_front.png; fi
  # The rotating collection is replaced as a whole, so pictures removed from the folder leave the TV too.
  del wallpapers; D "rm -rf $DIR/wallpapers"
  if [ -d "$THEME/wallpapers" ]; then
    D mkdir -p "$DIR/wallpapers"
    for f in "$THEME"/wallpapers/*; do [ -f "$f" ] && put "$f" "wallpapers/$(basename "$f")"; done
  fi
fi
# A new revision tells the launcher to drop on-TV layout choices and re-read the theme.
REV=$(uuidgen | tr -d - | tr '[:upper:]' '[:lower:]')
printf '%s' "$REV" > "${TMPDIR:-/tmp}/theme_revision"
put "${TMPDIR:-/tmp}/theme_revision" theme_revision
D am force-stop "$PKG"
key KEYCODE_HOME 3
D ls -la "$DIR"
echo "Home is now: $(resumed)"
