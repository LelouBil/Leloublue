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
is_muted='1'
amixer get Master | grep -q '\[on\]' && is_muted='0'

if [[ $is_muted -eq '1' ]]; then
character="󰝟"

else

if [[ $current_value -gt 50 ]]; then
  character="󰕾"
elif [[ $current_value -gt 20 ]]; then
  character="󰖀"
else
  character="󰕿"
fi

fi

dunstify -a volume -h "int:value:$current_value" "$character" -r 1000