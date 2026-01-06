#!/bin/bash

# Install Homebrew for the current user
# This script installs Homebrew to the user's home directory

set -e

echo "Installing Homebrew for current user: $(whoami)"

# Detect OS
OS="$(uname -s)"

if [ "$OS" = "Darwin" ]; then
    # macOS - Homebrew installs to /usr/local or /opt/homebrew
    HOMEBREW_PREFIX="/opt/homebrew"
    if [ "$(uname -m)" = "x86_64" ]; then
        HOMEBREW_PREFIX="/usr/local"
    fi
elif [ "$OS" = "Linux" ]; then
    # Linux - Install to user's home directory
    HOMEBREW_PREFIX="$HOME/.linuxbrew"
else
    echo "Unsupported operating system: $OS"
    exit 1
fi

# Check if Homebrew is already installed
if [ -f "$HOMEBREW_PREFIX/bin/brew" ]; then
    echo "Homebrew is already installed at $HOMEBREW_PREFIX"
    eval "$("$HOMEBREW_PREFIX/bin/brew" shellenv)"
    brew --version
    exit 0
fi

echo "Installing Homebrew to $HOMEBREW_PREFIX..."

# Download and run the official Homebrew installation script
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Verify installation
if [ -f "$HOMEBREW_PREFIX/bin/brew" ]; then
    echo "Homebrew successfully installed!"
    eval "$("$HOMEBREW_PREFIX/bin/brew" shellenv)"
    brew --version
else
    echo "Homebrew installation failed!"
    exit 1
fi

echo ""
echo "To use Homebrew in your current shell, run:"
echo "  eval \"\$($HOMEBREW_PREFIX/bin/brew shellenv)\""
