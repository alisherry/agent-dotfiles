#!/usr/bin/env bash
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
test_home=$(mktemp -d "${TMPDIR:-/tmp}/agent-shell-test.XXXXXX")
trap 'rm -rf "$test_home"' EXIT HUP INT TERM

HOME="$test_home" XDG_CONFIG_HOME="$test_home/.config" \
  "$repo_dir/setup.sh" --apply --all >/dev/null

test -L "$test_home/.zshenv"
test -L "$test_home/.config/zsh/.zshrc"
test -L "$test_home/.config/zsh/conf.d"
test -L "$test_home/.config/starship.toml"
test -L "$test_home/.config/ghostty/config"

env -u ZDOTDIR -u XDG_CACHE_HOME -u XDG_DATA_HOME -u XDG_STATE_HOME \
  HOME="$test_home" XDG_CONFIG_HOME="$test_home/.config" \
  zsh -lic '
    alias gst >/dev/null
    whence git_main_branch >/dev/null
    [[ "$ZDOTDIR" = "$XDG_CONFIG_HOME/zsh" ]]
    [[ "$XDG_CACHE_HOME" = "$HOME/.cache" ]]
  '

printf 'shell setup tests passed\n'
