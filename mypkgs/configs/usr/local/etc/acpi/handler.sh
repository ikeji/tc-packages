#!/bin/sh

echo get event $1 - $2 - $3 - $4 >> /tmp/acpilog

case "$1" in
  "button/power")
    if [ "$2" == "PBTN" ]; then
      echo -n mem > /sys/power/state
    fi
    ;;
  "button/volumeup")
    amixer sset Master 3%+
    ;;
  "button/volumedown")
    amixer sset Master 3%-
    ;;
  "button/mute")
    amixer sset Master toggle
    ;;
esac

