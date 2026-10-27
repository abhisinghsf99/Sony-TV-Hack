#!/bin/sh
# Undo the lock-screen fork: reinstall the unmodified launcher build (76a9312), put the Apple TV theme back and
# make the launcher Home again. Keeps the launcher's data (tile order, settings).
cd "$(dirname "$0")/.." || exit 1
adb -s 192.168.86.90:5555 install -r downloads/cleanyourtv/tvhome-3.0-76a9312.apk
adb -s 192.168.86.90:5555 shell cmd package set-home-activity --user 0 com.gathin.tvhome/.MainActivity
scripts/theme-push.sh themes/appletv
