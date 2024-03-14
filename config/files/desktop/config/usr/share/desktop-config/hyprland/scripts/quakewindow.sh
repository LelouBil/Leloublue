#!/bin/bash
# S'assure qu'il n'y ai que le terminal sur le workspace special:quake
function handle {
  if [[ ${1:0:10} == "openwindow" ]]; then
    if [[ ${1:25:13} == "special:quake" ]]; then
        if [[ ${1:46:9} != "quaketerm" ]]; then
            echo ${1:46:9}
            win_id="${1:12:12}"
            hyprctl dispatch movetoworkspacesilent "e+0,address:0x$win_id" > /dev/null
        fi
    fi
  fi
}

socat - "UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do handle "$line"; done
