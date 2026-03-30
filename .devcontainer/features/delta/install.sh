#!/bin/bash
set -e

VERSION="${VERSION:-"latest"}"

# Detect architecture (delta uses amd64/arm64)
ARCHITECTURE="$(uname -m)"
case ${ARCHITECTURE} in
    x86_64) ARCH="amd64";;
    aarch64 | armv8* | arm64) ARCH="arm64";;
    *) echo "(!) Architecture ${ARCHITECTURE} unsupported"; exit 1 ;;
esac

# Get latest version if needed
if [ "${VERSION}" = "latest" ]; then
    VERSION=$(curl -s https://api.github.com/repos/dandavison/delta/releases/latest | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
fi

echo "Installing delta version ${VERSION} (${ARCH})..."

# Download .deb package
DEB_FILE="/tmp/git-delta.deb"
DOWNLOAD_URL="https://github.com/dandavison/delta/releases/download/v${VERSION}/git-delta_${VERSION}_${ARCH}.deb"

curl -fsSL -o "${DEB_FILE}" "${DOWNLOAD_URL}"

# Install using dpkg -i (as requested), then fix dependencies
dpkg -i "${DEB_FILE}" || true
apt-get update
apt-get install -f -y

# Cleanup
rm -f "${DEB_FILE}"

# Verify installation
if delta --version >/dev/null 2>&1; then
  echo "✓ Delta installed successfully"
  delta --version | head -n1
else
  echo "Error: Installation verification failed" >&2
  exit 1
fi
