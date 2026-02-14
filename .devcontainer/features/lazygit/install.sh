#!/bin/bash
set -e

VERSION="${VERSION:-"latest"}"

# Install required packages
apt-get update
apt-get install -y --no-install-recommends \
    git \
    ca-certificates \
    curl
rm -rf /var/lib/apt/lists/*

# Detect architecture
ARCHITECTURE="$(uname -m)"
case ${ARCHITECTURE} in
    x86_64) ARCHITECTURE="x86_64";;
    aarch64 | armv8* | arm64) ARCHITECTURE="arm64";;
    *) echo "(!) Architecture ${ARCHITECTURE} unsupported"; exit 1 ;;
esac

# Get latest version or use specified version
if [ "${VERSION}" = "latest" ]; then
    VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
fi

echo "Installing lazygit version ${VERSION}..."

# Download and install lazygit
DOWNLOAD_URL="https://github.com/jesseduffield/lazygit/releases/download/v${VERSION}/lazygit_${VERSION}_Linux_${ARCHITECTURE}.tar.gz"
curl -sLo /tmp/lazygit.tar.gz "${DOWNLOAD_URL}"
tar -xzf /tmp/lazygit.tar.gz -C /tmp
install /tmp/lazygit /usr/local/bin
rm -rf /tmp/lazygit*

echo "Done!"