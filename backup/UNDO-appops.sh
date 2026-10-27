#!/bin/sh
# Undo background restriction
adb -s 192.168.86.90:5555 shell cmd appops set com.espn.score_center RUN_ANY_IN_BACKGROUND allow
adb -s 192.168.86.90:5555 shell cmd appops set com.cbs.ott RUN_ANY_IN_BACKGROUND allow
