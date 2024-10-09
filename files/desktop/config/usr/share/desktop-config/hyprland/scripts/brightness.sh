#!/bin/env bash
#usage <up|down> <percentage>
set -euo pipefail

action="$1"
value="$2"

case "$action" in
  "up")
  brillo -A "$value%" -u 100000
  ;;

  "down")
  brillo -U "$value%" -u 100000
  ;;
esac

value=$(brillo | cut -d '.' -f 1)

if [[ $value -gt 70 ]]; then
  character="󰃠"
elif [[ $value -gt 40 ]]; then
  character="󰃟"
else
  character="󰃞"
fi


dunstify -a brightness -h "int:value:$value" "$character" -r 10001