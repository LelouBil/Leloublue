#!/bin/env bash
set -euxo pipefail
RPM_URL=$(curl https://api.github.com/repos/quexten/goldwarden/releases/latest 2> /dev/null | grep -oE "https://(.*)\.rpm"https://github.com/quexten/goldwarden/releases/download/v0.3.2/goldwarden-0.3.2-1.el7.x86_64.rpm)
curl -o /tmp/goldwarden.rpm -L $RPM_URL
rpm-ostree install /tmp/goldwarden.rpm
rm /tmp/goldwarden.rpm
goldwarden setup polkit