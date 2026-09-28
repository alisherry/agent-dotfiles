#!/usr/bin/env bash
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
cd "$repo_dir"

if grep -RinE --exclude-dir=.git --exclude='check-public.sh' '(workos|bearer[[:space:]]+[A-Za-z0-9._-]+|api[_-]?key[[:space:]]*[:=]|/Users/[^/]+)' .; then
  printf 'Potential private or machine-specific material found.\n' >&2
  exit 1
fi

if grep -RinE '(curl[^|]*\||wget[^|]*\||sudo[[:space:]]|brew[[:space:]]+install|npm[[:space:]]+install)' setup.sh scripts hooks; then
  printf 'Unexpected installer or privileged command found.\n' >&2
  exit 1
fi

printf 'public-content checks passed\n'
