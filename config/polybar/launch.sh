#!/bin/bash

# Terminate already running bar instances
killall -q polybar
sleep 0.5

# Launch the bar
polybar top &

if [[ $(xrandr -q | grep 'eDP-1 connected') ]]; then
	polybar second &
