#!/usr/bin/env bash
set -euo pipefail

export NIX_CONFIG="experimental-features = nix-command flakes"

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
HOSTNAME="$(scutil --get LocalHostName)"

if [ ! -d "$REPO_DIR/nix/hosts" ]; then
  echo "No nix/hosts directory found."
  exit 1
fi

if [ ! -f "$REPO_DIR/nix/hosts/${HOSTNAME}.nix" ]; then
  echo "No host config for ${HOSTNAME}."
  echo "Select a host configuration to apply:"

  mapfile -t HOST_FILES < <(ls -1 "$REPO_DIR/nix/hosts"/*.nix 2>/dev/null || true)
  if [ "${#HOST_FILES[@]}" -eq 0 ]; then
    echo "No host configs found in nix/hosts."
    echo "Create nix/hosts/<host>.nix and add it to flake.nix."
    exit 1
  fi

  HOST_CHOICES=()
  for host_file in "${HOST_FILES[@]}"; do
    HOST_CHOICES+=("$(basename "${host_file%.nix}")")
  done

  PS3="Host: "
  select HOSTNAME in "${HOST_CHOICES[@]}"; do
    if [ -n "${HOSTNAME:-}" ]; then
      break
    fi
    echo "Invalid selection. Choose a number from the list."
  done
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