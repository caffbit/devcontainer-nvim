#!/bin/bash
set -e

curl -fsSL -O https://raw.githubusercontent.com/raine/tmux-file-picker/main/tmux-file-picker
chmod +x tmux-file-picker
mv tmux-file-picker /usr/local/bin/

echo "Done!"
