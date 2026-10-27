#!/bin/sh
# Undo the launcher swap: bring back the stock launcher + partner customizer and make stock Home again.
A="adb -s 192.168.86.90:5555 shell"
$A pm enable --user 0 com.google.android.tvlauncher
$A pm enable --user 0 com.google.android.tvsetup.partnercustomizer
$A cmd package set-home-activity --user 0 com.google.android.tvlauncher/.MainActivity
$A input keyevent KEYCODE_HOME
# Optional, to remove the new launcher entirely afterwards: adb uninstall com.gathin.tvhome
