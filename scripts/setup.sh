#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Install Nix if missing
if ! command -v nix >/dev/null 2>&1; then
  echo "Installing Nix..."
  curl -L https://nixos.org/nix/install | sh
fi

# Source nix profile (for current shell)
if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
  # shellcheck disable=SC1090
  . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

# Enable flakes in global config (if not already)
mkdir -p "$HOME/.config/nix"
if ! grep -q "experimental-features =.*flakes" "$HOME/.config/nix/nix.conf" 2>/dev/null; then
  echo "experimental-features = nix-command flakes" >> "$HOME/.config/nix/nix.conf"
fi

echo "Setup complete. You can now run scripts/apply.sh"