#!/usr/bin/env bash
set -euxo pipefail
git clone https://gitlab.com/cameronnemo/brillo /tmp/brillo
cd /tmp/brillo
make
make install install.polkit SYSCONFIGDIR=/etc PREFIX=/usr
