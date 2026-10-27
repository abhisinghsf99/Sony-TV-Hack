# Shared helpers for driving the BRAVIA over ADB. Source it: . scripts/tvlib.sh
TV="${TV:-192.168.86.90:5555}"
TVLIB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
MONITOR_LOG="${MONITOR_LOG:-$TVLIB_DIR/../logs/commands.log}"
mkdir -p "$(dirname "$MONITOR_LOG")"

# START/END lines are what scripts/monitor.sh follows. While it runs, wait a moment after START so its
# logcat is attached before the command reaches the TV.
log_start() {
  printf '%s START %s\n' "$(date '+%H:%M:%S')" "$*" >> "$MONITOR_LOG"
  local pid; pid=$(cat "$(dirname "$MONITOR_LOG")/monitor.pid" 2>/dev/null || true)
  if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then sleep 0.4; fi
}
log_end() { printf '%s END   rc=%s\n' "$(date '+%H:%M:%S')" "$1" >> "$MONITOR_LOG"; }

# Every TV command goes through here so the live monitor can show it.
D() {
  log_start "$*"
  adb -s "$TV" shell "$@"; local rc=$?
  log_end "$rc"
  return $rc
}

tv_connect() {
  adb connect "$TV" >/dev/null 2>&1
  adb -s "$TV" get-state >/dev/null 2>&1 || { echo "TV not reachable at $TV (asleep? wake it with the remote)" >&2; return 1; }
}

key() { D input keyevent "$1"; sleep "${2:-1}"; }

ui_dump() { D uiautomator dump /sdcard/ui.xml >/dev/null 2>&1; adb -s "$TV" shell cat /sdcard/ui.xml; }

# Bounds of the focused node, e.g. [144,713][534,932]
focused_bounds() { ui_dump | grep -oE '<node [^>]*focused="true"[^>]*>' | grep -oE 'bounds="[^"]*"' | head -1 | cut -d'"' -f2; }

resumed() { D dumpsys activity activities | grep -m1 mResumedActivity | grep -oE 'u0 [^ ]+' | cut -d' ' -f2; }

wakefulness() { D dumpsys power | grep -m1 -oE 'mWakefulness=[A-Za-z]+' | cut -d= -f2; }

# Dock row shows the focused app as heroName; grid rows label only the focused card (id/name). Tiles without a
# visible label (the lock-screen fork's single row) carry the name as the focused card's content-desc instead.
launcher_title() {
  local xml; xml=$(ui_dump)
  { grep -oE '<node [^>]*resource-id="com.gathin.tvhome:id/(heroName|name)"[^>]*>' <<< "$xml" | sed -E 's/.* text="([^"]*)".*/\1/'
    grep -oE '<node [^>]*resource-id="com.gathin.tvhome:id/card"[^>]*focused="true"[^>]*>' <<< "$xml" | sed -E 's/.* content-desc="([^"]*)".*/\1/'
  } | grep -v '^$' | head -1
}
