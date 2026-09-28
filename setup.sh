#!/usr/bin/env bash
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
apply=false

case "${1:-}" in
  --apply) apply=true ;;
  '') ;;
  *) printf 'Usage: %s [--apply]\n' "$0" >&2; exit 2 ;;
esac

config_dir=${XDG_CONFIG_HOME:-"$HOME/.config"}/tmux
backup_root="$HOME/.agent-dotfiles-backup"
timestamp=$(date '+%Y%m%d-%H%M%S')

printf 'Agent dotfiles setup plan:\n'
printf '  link %s -> %s\n' "$config_dir/tmux.conf" "$script_dir/tmux/tmux.conf"
printf '  link %s -> %s\n' "$config_dir/theme.conf" "$script_dir/tmux/theme.conf"
printf '  existing files, if any, move under %s/%s/\n' "$backup_root" "$timestamp"

if [ "$apply" != true ]; then
  printf '\nDry run only. Re-run with --apply to make these changes.\n'
  exit 0
fi

mkdir -p "$config_dir"

install_link() {
  source_path=$1
  target_path=$2
  target_name=$3

  if [ -L "$target_path" ] && [ "$(readlink "$target_path")" = "$source_path" ]; then
    printf 'Already linked: %s\n' "$target_path"
    return
  fi

  if [ -e "$target_path" ] || [ -L "$target_path" ]; then
    mkdir -p "$backup_root/$timestamp"
    mv "$target_path" "$backup_root/$timestamp/$target_name"
    printf 'Backed up: %s\n' "$target_path"
  fi

  ln -s "$source_path" "$target_path"
  printf 'Linked: %s\n' "$target_path"
}

install_link "$script_dir/tmux/tmux.conf" "$config_dir/tmux.conf" tmux.conf
install_link "$script_dir/tmux/theme.conf" "$config_dir/theme.conf" theme.conf

printf '\nDone. Start tmux normally, then launch your approved agent command inside it.\n'
