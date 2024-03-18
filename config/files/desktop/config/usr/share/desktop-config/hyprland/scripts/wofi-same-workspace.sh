#!/bin/bash
set -euo pipefail


function handle {
  command=$(echo -n "$1" | cut -d '>' -f 1)
  params=$(echo -n "$1" | cut -d '>' -f 3) # parce qu'il y a deux > d'affilée on skip un champ (le vide entre les deux)
  if [[ "$command" == "openwindow" ]]; then
    window_address=$(echo -n "$params" | cut -d ',' -f 1)
    workspace=$(echo -n "$params" | cut -d ',' -f 2 | tr -s ' ' | cut -d ' ' -f 1)
    class=$(echo -n "$params" | cut -d ',' -f 3)
    title=$(echo -n "$params" | cut -d ',' -f 4)

    hyprctl dispatch movetoworkspacesilent "$target_wp,address:0x$window_address"
    exit 0

  fi
}
target_wp="$(hyprctl activeworkspace -j | jq .id)"
wofi --config "$WOFI_CONFIG_FILE"
timeout 4 socat - "UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do handle "$line"; done
