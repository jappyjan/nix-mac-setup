#!/usr/bin/env bash
set -euo pipefail

if ! command -v cursor >/dev/null 2>&1; then
  echo "cursor CLI not found; skipping extension sync."
  exit 0
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "${script_dir}/../.." && pwd)"
list_file="${repo_root}/cursor/extensions/list.txt"

mkdir -p "$(dirname "${list_file}")"

case "${1:-}" in
  --refresh|--update-list)
    cursor --list-extensions | sort -u > "${list_file}"
    echo "Wrote ${list_file}"
    exit 0
    ;;
esac

if [[ ! -f "${list_file}" ]]; then
  echo "Missing ${list_file}. Run with --refresh to create it."
  exit 1
fi

mapfile -t desired < <(
  sed -e 's/#.*$//' -e '/^[[:space:]]*$/d' "${list_file}" | sort -u
)
mapfile -t installed < <(cursor --list-extensions | sort -u)

mapfile -t to_install < <(
  comm -23 <(printf '%s\n' "${desired[@]}") <(printf '%s\n' "${installed[@]}")
)
mapfile -t to_remove < <(
  comm -13 <(printf '%s\n' "${desired[@]}") <(printf '%s\n' "${installed[@]}")
)

for ext in "${to_install[@]}"; do
  [[ -n "${ext}" ]] || continue
  cursor --install-extension "${ext}"
done

for ext in "${to_remove[@]}"; do
  [[ -n "${ext}" ]] || continue
  if ! cursor --uninstall-extension "${ext}"; then
    echo "Failed to uninstall ${ext}"
  fi
done
