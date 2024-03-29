#!/bin/bash
set -euo pipefail

# class;title
to_focus=""
to_watch=""

# Checker si c'est la fenetre de splash (class:vesktop,title:vesktop)
# stocker son workspace
# Checker si c'est la fenetre discord(class:vesktop,title: != vesktop)
# la move sur le workspace en silent

function handle {
  command=$(echo -n "$1" | cut -d '>' -f 1)
  params=$(echo -n "$1" | cut -d '>' -f 3) # parce qu'il y a deux > d'affilée on skip un champ (le vide entre les deux)
  if [[ "$command" == "openwindow" ]]; then
    window_address=$(echo -n "$params" | cut -d ',' -f 1)
    workspace=$(echo -n "$params" | cut -d ',' -f 2 | tr -s ' ' | cut -d ' ' -f 1)
    class=$(echo -n "$params" | cut -d ',' -f 3)
    title=$(echo -n "$params" | cut -d ',' -f 4)
    echo "class: $class"
    echo "title: '$title'"

    if [[ "$class" =~ jetbrains-(.*) &&  "$title" == "" ]]; then
      to_focus="$class"
      to_watch="$window_address"
      echo "focus: $to_focus"
    fi
  fi
  if [[ "$command" == "closewindow" && "$window_address" == "$to_watch" ]]; then
      window_address=$(echo -n "$params" | cut -d ',' -f 1)
      workspace=$(echo -n "$params" | cut -d ',' -f 2 | tr -s ' ' | cut -d ' ' -f 1)
      class=$(echo -n "$params" | cut -d ',' -f 3)
      title=$(echo -n "$params" | cut -d ',' -f 4)
      echo "focusing : $to_focus"
      hyprctl dispatch focuswindow "$to_focus"
      to_watch=""
      to_focus=""
  fi
}

socat - "UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do handle "$line"; done
