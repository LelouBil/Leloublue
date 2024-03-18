#!/bin/sh
# custom variables
export DESKTOP_CONFIG_DIR="/usr/share/desktop-config"

export HYPRLAND_CONFIG_DIR="$DESKTOP_CONFIG_DIR/hyprland"
export HYPRLAND_CONFIG_FILE="$HYPRLAND_CONFIG_DIR/hyprland.conf"

export KITTY_CONFIG_DIR="$DESKTOP_CONFIG_DIR/kitty"

export WAYBAR_CONFIG_DIR="$DESKTOP_CONFIG_DIR/waybar"
export WAYBAR_CONFIG_FILE="$WAYBAR_CONFIG_DIR/config"
export WAYBAR_STYLE_FILE="$WAYBAR_CONFIG_DIR/style.css"

export EWW_CONFIG_DIR="$DESKTOP_CONFIG_DIR/eww"
export SYSTEM_EWW="eww -c \"$EWW_CONFIG_DIR\" "

export DUNST_CONFIG_DIR="$DESKTOP_CONFIG_DIR/dunst"
export DUNST_CONFIG_FILE="$DUNST_CONFIG_DIR/dunstrc"

export WOFI_CONFIG_DIR="$DESKTOP_CONFIG_DIR/wofi"
export WOFI_CONFIG_FILE="$WOFI_CONFIG_DIR/config"
export WOFI_STYLE_FILE="$WOFI_CONFIG_DIR/style.css"


# used variables
export KITTY_CONFIG_DIRECTORY="$KITTY_CONFIG_DIR"

# run wm
Hyprland --config "$HYPRLAND_CONFIG_FILE"
