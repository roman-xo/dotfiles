#!/bin/bash

NOTIFY_ID=9992

case "$1" in
  play)
    playerctl play-pause
    status=$(playerctl status)
    song=$(playerctl metadata --format '{{ artist }} - {{ title }}')
    dunstify -a "Media" -r "$NOTIFY_ID" " $status" "$song" -u low
    ;;
  next)
    playerctl next
    song=$(playerctl metadata --format '{{ artist }} - {{ title }}')
    dunstify -a "Media" -r "$NOTIFY_ID" " Next" "$song" -u low
    ;;
  prev)
    playerctl previous
    song=$(playerctl metadata --format '{{ artist }} - {{ title }}')
    dunstify -a "Media" -r "$NOTIFY_ID" " Previous" "$song" -u low
    ;;
esac
