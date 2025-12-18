#!/usr/bin/env bash
set -euo pipefail

REPO_SSH="git@github.com:TheKeyholdingCompany/kutter.git"
SCRIPT_NAME="kutter.sh"
INSTALL_DIR="$HOME/.local/bin"

echo "Installing Kutter..."

command -v git >/dev/null 2>&1 || {
  echo "❌ git is required"
  exit 1
}

command -v brew >/dev/null 2>&1 || {
  echo "❌ Homebrew is required to install Copier"
  echo "   https://brew.sh"
  exit 1
}

if ! command -v copier >/dev/null 2>&1; then
  echo "Installing Copier..."
  brew install copier
else
  echo "Copier already installed, skipping installation"
fi

mkdir -p "$INSTALL_DIR"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

echo "Cloning kutter repository..."
git clone --depth 1 "$REPO_SSH" "$TMP_DIR"

echo "Installing kutter command to $INSTALL_DIR..."
install -m 0755 "$TMP_DIR/$SCRIPT_NAME" "$INSTALL_DIR/kutter"

case ":${PATH:-}:" in
  *":$INSTALL_DIR:"*) ;;
  *)
    echo ""
    echo "⚠️  $INSTALL_DIR is not in your PATH"
    echo "Add this line to your shell config (~/.zshrc or ~/.bashrc):"
    echo ""
    echo "  export PATH=\"$INSTALL_DIR:\$PATH\""
    ;;
esac

echo ""
echo "✨ Kutter installed successfully"
echo ""
echo "Usage:"
echo "  kutter new my-little-project"
