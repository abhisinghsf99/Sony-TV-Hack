#!/bin/sh
# Undo the Apple TV style theme: remove the theme files (the launcher's files dir was empty before) and restart Home.
cd "$(dirname "$0")/.." && scripts/theme-push.sh --reset
