#!/bin/bash


# Checker si c'est la fenetre de splash (class:vesktop,title:vesktop)
# stocker son workspace
# Checker si c'est la fenetre discord(class:vesktop,title: != vesktop)
# la move sur le workspace en silent




function handle {
  command=$(echo -n "$1" | cut -d '>' -f 1)
  params=$(echo -n "$1" | cut -d '>' -f 3) # parce qu'il y a deux > d'affilée on skip un champ (le vide entre les deux)
  if [[ "$command" == "openwindow" || "$command" == "movewindow" ]]; then
    window_address=$(echo -n "$params" | cut -d ',' -f 1)
    workspace=$(echo -n "$params" | cut -d ',' -f 2 | tr -s ' ' | cut -d ' ' -f 1)
    class=$(echo -n "$params" | cut -d ',' -f 3)
    title=$(echo -n "$params" | cut -d ',' -f 4)
    if [[ "$workspace" == "special:space" ]]; then
        hyprctl setprop "address:0x$window_address" activebordercolor "rgb(FFFF00)" lock
    else
        hyprctl setprop "address:0x$window_address" activebordercolor "rgb(17DCF5)"
    fi
  fi

}

socat - "UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do handle "$line"; done
