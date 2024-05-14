#!/bin/env bash
set -euxo pipefail
RPM_URL=$(curl https://api.github.com/repos/quexten/goldwarden/releases/latest 2> /dev/null | grep -oE "https://(.*)\.rpm")
curl -o /tmp/goldwarden.rpm -L $RPM_URL
rpm-ostree install /tmp/goldwarden.rpm
rm /tmp/goldwarden.rpm
goldwarden setup polkit