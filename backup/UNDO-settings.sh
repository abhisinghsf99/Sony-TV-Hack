#!/bin/sh
# Restore the original values captured in settings-before.txt
A="adb -s 192.168.86.90:5555 shell"
$A settings put global window_animation_scale 1.0
$A settings put global transition_animation_scale 1.0
$A settings delete global animator_duration_scale
$A settings delete global private_dns_mode
$A settings delete global private_dns_specifier
# Screensaver back to Ambient mode (only shows once Backdrop is re-enabled: pm enable --user 0 com.google.android.backdrop)
$A settings put secure screensaver_components com.google.android.backdrop/.Backdrop
