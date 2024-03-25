#!/bin/bash
set -euxo pipefail

pid_file="/tmp/media-notification.pid"

if [[ -f $pid_file ]]; then
  echo "already exists"
  other_pid=$(cat $pid_file)
  kill $other_pid
fi

echo $$ > $pid_file

eww open media-notification -c "$EWW_CONFIG_DIR"
sleep 3
eww close media-notification -c "$EWW_CONFIG_DIR"

rm $pid_file