#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/../.." && pwd)"
source_dir="${repo_root}/cursor/Library/Application Support/Cursor/User"
target_dir="${HOME}/Library/Application Support/Cursor/User"

if [[ ! -d "${source_dir}" ]]; then
  echo "Source directory not found: ${source_dir}"
  exit 1
fi

mkdir -p "${target_dir}"

backup_if_needed() {
  local dst="$1"
  if [[ -e "${dst}" && ! -L "${dst}" ]]; then
    local ts
    ts="$(date +%Y%m%d%H%M%S)"
    mv "${dst}" "${dst}.bak.${ts}"
  fi
}

link_item() {
  local src="$1"
  local dst="$2"
  backup_if_needed "${dst}"
  ln -sfn "${src}" "${dst}"
}

for item in "${source_dir}"/*; do
  [[ -e "${item}" ]] || continue
  name="$(basename "${item}")"
  link_item "${item}" "${target_dir}/${name}"
done
