#!/usr/bin/env bash
LOCATION="Tulsa"
ICON=$(curl -s "wttr.in/${LOCATION}?format=%c" | tr -d '[:space:]')
TEMP=$(curl -s "wttr.in/${LOCATION}?format=%t" | tr -d '[:space:]')

echo "${ICON} ${TEMP}"
