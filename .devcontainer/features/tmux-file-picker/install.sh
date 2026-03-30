#!/bin/bash
set -e

apt-get update
apt-get install -y --no-install-recommends curl ca-certificates bat
rm -rf /var/lib/apt/lists/*

ln -sf "$(which batcat)" /usr/local/bin/bat 2>/dev/null || true

cd /tmp
curl -fsSL -O https://raw.githubusercontent.com/raine/tmux-file-picker/main/tmux-file-picker
chmod +x tmux-file-picker
mv tmux-file-picker /usr/local/bin/

echo "Done!"
