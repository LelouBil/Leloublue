diff:
    sudo ostree admin config-diff | grep -E -v -f /usr/share/ublue-os/transient-etc-files.grep

diff-fix path:
    #!/bin/env bash
    set -euo pipefail
    letter=$(sudo ostree admin config-diff | grep -E "^[AMD]    {{path}}$" | cut -c 1)
    case "$letter" in

    "A")
        gum style --border rounded --bold "Le fichier /etc/{{path}} a été ajouté, il n'existe pas dans la source, voici son contenu"
        sudo cat "/etc/{{path}}"
        gum style --border rounded "Que faire ?"
        restore="Laisser"
        delete="Supprimer"
        result=$(gum choose "$restore" "$delete")
        if [[ "$result" == "$delete" ]]; then
            sudo rm /etc/{{path}}
        fi
        ;;

    "D")
        gum style --border rounded --bold "Le fichier /etc/{{path}} a été supprimé localement, voici le contenu de la source"
        sudo cat "/usr/etc/{{path}}"
        gum style --border rounded "Que faire ?"
        restore="Restaurer"
        delete="Laisser supprimé"
        result=$(gum choose "$restore" "$delete")
        if [[ "$result" == "$restore" ]]; then
            sudo rsync -av "/usr/etc/{{path}}" "/etc/{{path}}"
        fi
        ;;

    "M")
        gum style --border rounded --bold --margin '2 7' 'gauche: original(/usr/etc/{{path}})'
        gum style --border rounded --bold --margin '2 7' 'droite: modifié(/etc/{{path}})'
        sudo delta -s --paging never '/usr/etc/{{path}}' '/etc/{{path}}' || true
        keep="Garder la version modifiée localement - droite"
        take_new="Appliquer la version de source - gauche"
        gum style --border rounded "Que faire ?"
        result="$(gum choose "$keep" "$take_new" )"
        if [[ "$result" == "$take_new" ]]; then
            save_path="$(mktemp)"
            sudo rsync -av "/etc/{{path}}" "$save_path"
            echo "Fichier sauvegardé dans $save_path"
            sudo rsync -av "/usr/etc/{{path}}" "/etc/{{path}}"
        fi
        ;;

    *)
          gum style --bold --foreground=red "Le fichier /etc/{{path}} n'est pas un fichier modifié";
            exit 1;
        ;;
    esac

diff-all:
    #!/bin/env bash
    set -euo pipefail
    data=$(just diff |  grep -E "^[AMD]    (.*)$" | tr -s ' ' | cut -d ' ' -f 2)
    OLDIFS=$IFS; IFS=$'\n';
    for line in $data; do
        gum style --bold --border thick $line
        just diff-fix $line
    done
    IFS=$OLDIFS

