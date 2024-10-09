#!/usr/bin/env bash
set -euxo pipefail
tarball_url=$(curl -L https://api.github.com/repos/elkowar/eww/releases | jq -r '.[0].tarball_url')
curl -L -o /tmp/eww-source.tgz "$tarball_url"
mkdir /tmp/eww-sources
tar --strip-components=1 -xvf /tmp/eww-source.tgz -C /tmp/eww-sources
cd /tmp/eww-sources
export CARGO_HOME=/tmp/cargo
cargo build --release --no-default-features --features=wayland
cp target/release/eww /usr/bin/eww
chmod +x /usr/bin/eww


