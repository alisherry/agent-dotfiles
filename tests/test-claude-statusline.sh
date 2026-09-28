#!/usr/bin/env bash
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
input=$(printf '{"workspace":{"current_dir":"%s"},"model":{"display_name":"Claude Test"},"cost":{"total_cost_usd":1.234,"total_lines_added":12,"total_lines_removed":3},"context_window":{"used_percentage":42.2},"exceeds_200k_tokens":false}' "$repo_dir")

output=$(printf '%s' "$input" | "$repo_dir/scripts/claude-statusline")
plain=$(printf '%s' "$output" | sed $'s/\033\\[[0-9;]*m//g')

printf '%s' "$plain" | grep -q 'Claude Test'
printf '%s' "$plain" | grep -q '42% ctx'
printf '%s' "$plain" | grep -q '\$1.23'
printf '%s' "$plain" | grep -q '+12/-3'
printf '%s' "$plain" | grep -q 'git:main'

printf 'claude statusline tests passed\n'
