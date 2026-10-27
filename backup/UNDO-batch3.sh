#!/bin/sh
# Undo batch 3: re-enable all 4 packages
adb -s 192.168.86.90:5555 shell pm enable --user 0 com.google.android.onetimeinitializer
adb -s 192.168.86.90:5555 shell pm enable --user 0 com.android.wallpaper.livepicker
adb -s 192.168.86.90:5555 shell pm enable --user 0 com.android.htmlviewer
adb -s 192.168.86.90:5555 shell pm enable --user 0 com.google.android.syncadapters.calendar
