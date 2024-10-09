#!/usr/bin/env bash
set -euxo pipefail
cliphist_download_url=$(curl -L https://api.github.com/repos/sentriz/cliphist/releases | jq -r ".[0].assets | .[] | select(.name | test(\"linux-amd64$\")) | .[\"browser_download_url\"]")
curl -L -o /usr/bin/cliphist "$cliphist_download_url"
chmod +x /usr/bin/cliphist