#!/bin/sh
# Undo batch 1: re-enable all 6 packages
adb -s 192.168.86.90:5555 shell pm enable --user 0 android.autoinstalls.config.Sony.BRAVIA_VU1
adb -s 192.168.86.90:5555 shell pm enable --user 0 com.google.android.tvrecommendations
adb -s 192.168.86.90:5555 shell pm enable --user 0 com.google.android.feedback
adb -s 192.168.86.90:5555 shell pm enable --user 0 com.sony.dtv.demo
adb -s 192.168.86.90:5555 shell pm enable --user 0 com.google.android.play.games
adb -s 192.168.86.90:5555 shell pm enable --user 0 com.google.android.videos
