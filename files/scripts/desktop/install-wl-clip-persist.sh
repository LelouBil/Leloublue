#!/usr/bin/env bash
set -euxo pipefail
git clone https://github.com/Linus789/wl-clip-persist /tmp/wl-clip-persist
cd /tmp/wl-clip-persist
export CARGO_HOME=/tmp/cargo
cargo build --release
cp target/release/wl-clip-persist /usr/bin/wl-clip-persist
chmod +x /usr/bin/wl-clip-persist