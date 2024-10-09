#!/bin/bash
set -euo pipefail

# il faut que le script soit mis en handler URL
url="$1"

workspace=$(hyprctl clients -j | jq '[.[] | select(.class == "org.mozilla.firefox")][0] | .workspace.name' -r)

address=$(hyprctl clients -j | jq '[.[] | select(.class == "org.mozilla.firefox")][0] | .address' -r)

flatpak run org.mozilla.firefox -new-tab "$url"

# if workspace starts with special: use togglespecialworkspace (without the special:)
#else use focusworkspaceoncurrentmonitor
#echo "$workspace"
#echo "${workspace:8}"
#if [[ "$workspace" == "special:"* ]]; then
##  hyprctl dispatch togglespecialworkspace "${workspace:8}"
#  echo special
#else
#  hyprctl dispatch focusworkspaceoncurrentmonitor "$workspace"
#fi

sleep 0.1
hyprctl dispatch focuswindow address:$address

# 56 L_ALT
# 10 9
ydotool key 56:1 10:1 56:0 10:0
