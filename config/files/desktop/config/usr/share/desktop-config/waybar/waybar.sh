#!/usr/bin/bash
set -euo pipefail
# launch waybar with script's arguments

# replacement
sed "s|\$WAYBAR_CONFIG_DIR|$WAYBAR_CONFIG_DIR|g" "$WAYBAR_STYLE_FILE" > /tmp/waybar.css

# launch waybar
waybar -c "$WAYBAR_CONFIG_FILE" -s /tmp/waybar.css "$@"