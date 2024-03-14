#!/bin/env bash
#usage <up|down> <percentage>
set -euo pipefail

action="$1"
value="$2"

case "$action" in
  "up")
  brillo -A "$value%" -q -u 100000
  ;;

  "down")
  brillo -U "$value%" -q -u 100000
  ;;
esac
brillo | xargs -i dunstify brightness -a brightness -h int:value:{}