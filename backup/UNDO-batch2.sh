#!/bin/sh
# Undo batch 2: re-enable all 10 packages
adb -s 192.168.86.90:5555 shell pm enable --user 0 com.android.printspooler
adb -s 192.168.86.90:5555 shell pm enable --user 0 com.android.gallery3d
adb -s 192.168.86.90:5555 shell pm enable --user 0 com.android.camera2
adb -s 192.168.86.90:5555 shell pm enable --user 0 com.sony.dtv.helpguidecontents
adb -s 192.168.86.90:5555 shell pm enable --user 0 com.sony.dtv.smarthelp
adb -s 192.168.86.90:5555 shell pm enable --user 0 com.google.android.backdrop
adb -s 192.168.86.90:5555 shell pm enable --user 0 com.google.android.youtube.tvmusic
adb -s 192.168.86.90:5555 shell pm enable --user 0 com.spotify.tv.android
adb -s 192.168.86.90:5555 shell pm enable --user 0 com.peacocktv.peacockandroid
adb -s 192.168.86.90:5555 shell pm enable --user 0 com.gotv.nflgamecenter.us.lite
