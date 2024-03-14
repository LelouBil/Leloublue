#!/usr/bin/env bash
set -euxo pipefail
tarball_url=$(curl -L https://api.github.com/repos/LGFae/swww/releases | jq -r '.[0].tarball_url')
curl -L -o /tmp/swww-source.tgz "$tarball_url"
mkdir /tmp/swww-sources
tar --strip-components=1 -xvf /tmp/swww-source.tgz -C /tmp/swww-sources
cd /tmp/swww-sources
export CARGO_HOME=/tmp/cargo
cargo build --release
cp target/release/swww /usr/bin/swww
chmod +x /usr/bin/swww
cp target/release/swww-daemon /usr/bin/swww-daemon
chmod +x /usr/bin/swww-daemon
# completions
cp completions/swww.bash /usr/share/bash-completion/completions/swww
cp completions/swww.fish /usr/share/fish/vendor_completions.d/swww.fish
cp completions/_swww /usr/share/zsh/site-functions/_swww
#doc
sh ./doc/gen.sh

for file in ./doc/generated/*.1; do
  file_basename=$(basename "$file")
  gzip "$file" -c > "/usr/share/man/man1/$file_basename.gz"
done

