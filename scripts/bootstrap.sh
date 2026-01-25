#!/usr/bin/env bash
set -euo pipefail

REPO_URL="https://github.com/jappyjan/nix-mac-setup.git"
TARGET_DIR="${TARGET_DIR:-$HOME/code/jappyjan/nix-mac-setup}"

if [ -e "$TARGET_DIR" ] && [ ! -d "$TARGET_DIR/.git" ]; then
  echo "Target exists but is not a git repo: $TARGET_DIR" >&2
  exit 1
fi

mkdir -p "$(dirname "$TARGET_DIR")"

if [ ! -d "$TARGET_DIR/.git" ]; then
  git clone "$REPO_URL" "$TARGET_DIR"
fi

bash "$TARGET_DIR/scripts/setup.sh"
