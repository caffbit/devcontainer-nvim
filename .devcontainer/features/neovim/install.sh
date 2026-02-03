#!/bin/bash
set -euo pipefail

# Configuration
VERSION=${VERSION:-"stable"}
INSTALL_DIR=${INSTALL_DIR:-"/usr/local"}
DOWNLOAD_DIR=$(mktemp -d)

# Cleanup function
cleanup() {
  rm -rf "$DOWNLOAD_DIR"
}
trap cleanup EXIT

# Detect architecture
detect_arch() {
  case $(uname -m) in
    x86_64) echo "linux64" ;;
    aarch64|arm64) echo "linux-arm64" ;;
    *) echo "Error: Unsupported architecture $(uname -m)" >&2; exit 1 ;;
  esac
}

NVIM_ARCH=$(detect_arch)

# Build download URL
BASE_URL="https://github.com/neovim/neovim/releases/download"

if [ "$VERSION" = "stable" ]; then
  VERSION_TAG="stable"
else
  VERSION_TAG="v${VERSION}"
fi

URL="${BASE_URL}/${VERSION_TAG}/nvim-${NVIM_ARCH}.tar.gz"

echo "Installing Neovim ${VERSION} (${NVIM_ARCH})..."

# Download and extract
cd "$DOWNLOAD_DIR"
if ! curl -fsSL "$URL" | tar xz; then
  echo "Error: Download or extraction failed" >&2
  exit 1
fi

# Install (requires permissions)
if [ ! -w "$INSTALL_DIR" ]; then
  echo "Sudo required for installation to $INSTALL_DIR"
  sudo cp -r nvim-${NVIM_ARCH}/* "$INSTALL_DIR/"
else
  cp -r nvim-${NVIM_ARCH}/* "$INSTALL_DIR/"
fi

# Verify installation
if nvim --version >/dev/null 2>&1; then
  echo "✓ Neovim installed successfully"
  nvim --version | head -n1
else
  echo "Error: Installation verification failed" >&2
  exit 1
fi