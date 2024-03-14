setup-hibernate:
    #!/bin/bash
    gum confirm "Do you want to setup hibernation ?"
    set -euo pipefail
    #todo check sawpon pour une ligne qui n'est pas zram
    swap_subvol_exists=0
    sudo btrfs subvolume list /var/swap > /dev/null 2> /dev/null || swap_subvol_exists=$?
    if [[ swap_subvol_exists -ne 0 ]]; then
    echo "Creating swap subvolume"
    sudo btrfs subvolume create /var/swap
    fi

    swapfile_path="/var/swap/swapfile"

    if [[ ! -f "$swapfile_path" ]]; then
    echo "Creating swap file at $swapfile_path"
    zram_size=$(swapon --raw --noheading --bytes | grep /dev/zram0 | cut -d ' ' -f 3)
    ram_size=$(free -b | grep "Mem" | tr -s ' ' | cut -d ' ' -f 2)
    swap_file_size=$(($zram_size + $ram_size + 2073741824))
    formatted_swap_size=$(numfmt --to=iec-i --suffix=B $swap_file_size)
    gum style --border rounded "Calculated swap size : $formatted_swap_size"
    gum confirm

    sudo btrfs filesystem mkswapfile --size $swap_file_size "$swapfile_path"
    fi
    swap_uuid=$(sudo findmnt -no UUID -T "$swapfile_path")
    echo "swap file uuid is $swap_uuid"
    swap_file_offset=$(sudo btrfs inspect-internal map-swapfile -r "$swapfile_path")
    echo "swap offset is $swap_file_offset"

    echo removing old arguments
    remove_args=""
    old_arguments=$(rpm-ostree kargs | grep -oP "(resume_offset=(.*?) |resume=UUID=([a-z0-9\-]*))" | tr -d ' ' || true)
    OLD_IFS=$IFS; IFS=$'\n';
    for old_arg in $old_arguments; do
    remove_args="$remove_args --delete $old_arg"
    done
    IFS=$OLD_IFS
    echo "Removing arguments: $remove_args"
    rpm-ostree kargs $remove_args
    echo adding new arguments
    rpm-ostree kargs --append "resume_offset=$swap_file_offset" --append "resume=UUID=$swap_uuid"
    rpm-ostree kargs


    swap_in_fstab=0
    sudo cat /etc/fstab | grep -E "^\W*$swapfile_path" > /dev/null || swap_in_fstab=$?


    if [[ $swap_in_fstab -ne 0 ]]; then
        echo "Adding swapfile to fstab"
        back_path=$(sudo mktemp -p /etc fstab.XXXXX)
        sudo cp /etc/fstab $back_path
        echo "/etc/fstab backed up at $back_path"
        sudo tee -a /etc/fstab > /dev/null <<EOF
    # add swapfile, but set priority as low as possible so it only gets used if zra(pri=100) can't be
    /var/swap/swapfile                        none                    swap  defaults,pri=0 0 0
    EOF
        sudo cat /etc/fstab
    fi
    swap_in_swapon=0
    sudo swapon | grep $swapfile_path > /dev/null || swap_in_swapon=$?
    if [[ $swap_in_swapon -ne 0 ]]; then
        echo "Swapping on"
        sudo swapon $swapfile_path
    fi
    selinux_labeled=0
    sudo semanage fcontext -l | grep /var/swap > /dev/null || selinux_labeled=1
    if [[ $swap_in_swapon -ne 0 ]]; then
        echo "Adding selinux labeling"
        sudo semanage fcontext -a -t swapfile_t '/var/swap(/.*)?' || true
    fi
    echo "Restorecon"
    sudo restorecon -RF /var/swap
    sudo systemctl daemon-reload


    selinux_policy=0
    sudo semodule -l | grep systemd_hibernate || selinux_policy=1
    if [[ $selinux_policy -ne 0 ]]; then
        echo "Adding selinux policy to make systemctl be able to read swapfile"
        temp_dir=$(mktemp -d)
        temp_file="$temp_dir/systemd_hibernate"
        sudo tee "$temp_file.te" <<EOF
    module systemd_hibernate 1.0;

    require {
        type systemd_logind_t;
        type systemd_sleep_t;
        type swapfile_t;
        class dir search;
    }

    #============= systemd_logind_t ==============
    allow systemd_logind_t swapfile_t:dir search;

    #============= systemd_sleep_t ==============
    allow systemd_sleep_t swapfile_t:dir search;

    EOF
    sudo checkmodule -M -m -o "$temp_file.mod" "$temp_file.te"
    sudo semodule_package -o "$temp_file.pp" -m "$temp_file.mod"
    sudo semodule -i "$temp_file.pp"
    fi
