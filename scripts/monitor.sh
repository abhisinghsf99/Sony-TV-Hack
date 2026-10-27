#!/usr/bin/env bash
# Live monitor: prints every TV command sent through scripts/tvlib.sh with a timestamp, and streams the
# TV's logcat only while that command runs. Run it in a second terminal, then use the other scripts.
#   scripts/monitor.sh                      # logcat at Info and above
#   LOGCAT_FILTER='*:W' scripts/monitor.sh  # warnings and errors only
cd "$(dirname "$0")/.." || exit 1
. scripts/tvlib.sh

LOGCAT_FILTER="${LOGCAT_FILTER:-*:I}"
PIDFILE="$(dirname "$MONITOR_LOG")/monitor.pid"
touch "$MONITOR_LOG"
echo $$ > "$PIDFILE"

lc_pid=""
stop_logcat() {
  [ -n "$lc_pid" ] || return 0
  kill "$lc_pid" 2>/dev/null; wait "$lc_pid" 2>/dev/null; lc_pid=""
}
# The tail below runs in a process substitution, which outlives this shell unless stopped by name.
cleanup() { stop_logcat; pkill -f "tail -n 0 -F $MONITOR_LOG" 2>/dev/null; rm -f "$PIDFILE"; exit 0; }
trap cleanup INT TERM

adb connect "$TV" >/dev/null 2>&1
printf 'Monitoring %s  (logcat %s while a command runs; Ctrl-C to stop)\n' "$TV" "$LOGCAT_FILTER"

while IFS= read -r line; do
  case "$line" in
    *" START "*)
      stop_logcat
      printf '\033[1;36m▶ %s\033[0m\n' "$line"
      # -T 1: start from the newest line, so earlier history is not replayed.
      adb -s "$TV" logcat -T 1 -v time $LOGCAT_FILTER > >(sed -u 's/^/    │ /') 2>/dev/null &
      lc_pid=$!
      ;;
    *" END "*)
      sleep 0.3   # let the last log lines of the command arrive
      stop_logcat
      printf '\033[2m■ %s\033[0m\n' "$line"
      ;;
  esac
done < <(tail -n 0 -F "$MONITOR_LOG" 2>/dev/null)
