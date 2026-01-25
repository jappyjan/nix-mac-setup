#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/.." && pwd)"
source_dir="${repo_root}/.githooks"
target_dir="${repo_root}/.git/hooks"

if [[ ! -d "${source_dir}" ]]; then
  echo "No .githooks directory found."
  exit 1
fi

mkdir -p "${target_dir}"

for hook in "${source_dir}"/*; do
  [[ -f "${hook}" ]] || continue
  hook_name="$(basename "${hook}")"
  install -m 0755 "${hook}" "${target_dir}/${hook_name}"
done

echo "Installed hooks into ${target_dir}"
