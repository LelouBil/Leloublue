#!/bin/env bash
#usage <up|down> <percentage>
set -euo pipefail

action="$1"
value="$2"

case "$action" in
  "up")
   amixer set Master "$value%+"
  ;;

  "down")
     amixer set Master "$value%-"
  ;;
esac
current_value=$(awk -F"[][]" '/Left:/ { print $2 }' <(amixer sget Master) | tr -d "%")
dunstify volume -a volume -h "int:value:$current_value"