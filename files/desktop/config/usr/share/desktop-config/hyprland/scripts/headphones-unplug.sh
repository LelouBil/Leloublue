#!/bin/bash

acpi_listen | while read -r line; do
  echo "${line}"
  if grep -q "HEADPHONE unplug" <<< "${line}"; then
    echo "EVENT: Unplugged, pause here."
    playerctl pause
  fi
done
