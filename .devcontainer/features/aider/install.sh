#!/bin/bash
set -e

echo "Installing aider-chat..."

# Install pipx
python -m pip install pipx

# Install aider-chat
pipx install aider-chat[playwright]

echo "aider-chat installation complete!"
