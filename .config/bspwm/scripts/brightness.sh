#!/bin/bash

NOTIFY_ID=9993

case "$1" in
  up)
    brightnessctl set +10%
    ;;
  down)
    brightnessctl set 10%-
    ;;
esac

level=$(brightnessctl | grep -oP '\(\K[0-9]+(?=%)')

dunstify -a "Brightness" -r "$NOTIFY_ID" " Brightness" "$level%" -u low
