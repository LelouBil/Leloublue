#!/usr/bin/env bash
set -euxo pipefail

git clone https://github.com/prey/prey-node-client /usr/share/prey-agent
cd /usr/share/prey-agent
npm ci
groupadd --system prey
useradd --system --no-create-home --group prey --home-dir /usr/share/prey-agent --shell /bin/false prey