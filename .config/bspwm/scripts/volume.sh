#!/bin/bash

NOTIFY_ID=9991

case "$1" in
  up)
    pamixer -i 5
    action="Volume Up"
    ;;
  down)
    pamixer -d 5
    action="Volume Down"
    ;;
  mute)
    pamixer -t
    action="Muted"
    ;;
esac

volume=$(pamixer --get-volume)
muted=$(pamixer --get-mute)

if [ "$muted" = "true" ]; then
  icon=""
  message="Muted"
else
  if [ "$volume" -lt 30 ]; then
    icon=" "
  else
    icon=" "
  fi
  message="${volume}%"
fi

dunstify -a "Volume" -r "$NOTIFY_ID" "$icon $action" "$message" -u low
