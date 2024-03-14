#!/bin/bash
set -euo pipefail

# class;title
splashes=("vesktop;vesktop" "jetbrains-(.*);splash" "krita;Krita")
declare -A workspaces=()
blacklist=()

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

      for app_class in "${!workspaces[@]}"; do
        target_wp="${workspaces[$app_class]}"
        if [[ "$class" == "$app_class"  ]]; then
           echo "moving window $window_address" to workspace "$target_wp"
           hyprctl dispatch movetoworkspacesilent "$target_wp,address:0x$window_address"
           blacklist+=("$window_address")
           unset workspaces[$app_class] # pour ne pas le faire si la fenêtre repop
        fi
      done

    for splash_ident in "${splashes[@]}"; do
    if [[ "$class;$title" =~ $splash_ident ]]; then
      if [[ ! ${blacklist[*]} =~ $window_address ]]; then
        echo "detected $splash_ident splash on workspace $workspace"
        # splash
        workspaces[$class]="$workspace"
      fi

    fi
    done

  fi
}

socat - "UNIX-CONNECT:/tmp/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do handle "$line"; done
