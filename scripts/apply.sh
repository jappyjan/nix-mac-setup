#!/usr/bin/env bash
set -euo pipefail

export NIX_CONFIG="experimental-features = nix-command flakes"

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOSTNAME="$(scutil --get LocalHostName)"

if [ ! -d "$REPO_DIR/nix/hosts" ] || [ ! -f "$REPO_DIR/nix/hosts/${HOSTNAME}.nix" ]; then
  echo "No host config for ${HOSTNAME}."
  echo "Create nix/hosts/${HOSTNAME}.nix and add it to flake.nix."
  exit 1
fi

# Ensure nix is available in this shell
if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
  # shellcheck disable=SC1090
  . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

# Ensure Homebrew exists for nix-darwin homebrew module
if ! command -v brew >/dev/null 2>&1 && [ ! -x /opt/homebrew/bin/brew ] && [ ! -x /usr/local/bin/brew ]; then
  echo "Homebrew not found. Installing..."
  if [ "${EUID}" -eq 0 ]; then
    if [ -z "${SUDO_USER:-}" ]; then
      echo "Cannot install Homebrew as root without a user context."
      echo "Please run ./scripts/apply.sh without sudo once to install Homebrew."
      exit 1
    fi
    sudo -u "${SUDO_USER}" /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
fi

# Apply configuration
nix run nix-darwin -- switch --flake "$REPO_DIR#${HOSTNAME}"