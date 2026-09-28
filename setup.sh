#!/usr/bin/env bash
set -eu

script_dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
apply=false
install_ghostty=false
install_shell=false
install_claude=false

while [ "$#" -gt 0 ]; do
  case "$1" in
    --apply) apply=true ;;
    --ghostty) install_ghostty=true ;;
    --shell) install_shell=true ;;
    --claude) install_claude=true ;;
    --all) install_ghostty=true; install_shell=true; install_claude=true ;;
    *) printf 'Usage: %s [--apply] [--ghostty] [--shell] [--claude] [--all]\n' "$0" >&2; exit 2 ;;
  esac
  shift
done

config_root=${XDG_CONFIG_HOME:-"$HOME/.config"}
tmux_dir="$config_root/tmux"
ghostty_dir="$config_root/ghostty"
agent_config_dir="$config_root/agent-dotfiles"
claude_dir=${CLAUDE_CONFIG_DIR:-"$HOME/.claude"}
backup_root="$HOME/.agent-dotfiles-backup"
timestamp=$(date '+%Y%m%d-%H%M%S')

printf 'Agent dotfiles setup plan:\n'
printf '  link %s -> %s\n' "$tmux_dir/tmux.conf" "$script_dir/tmux/tmux.conf"
printf '  link %s -> %s\n' "$tmux_dir/theme.conf" "$script_dir/tmux/theme.conf"
printf '  link %s -> %s\n' "$tmux_dir/scripts/window-name" "$script_dir/tmux/scripts/window-name"
printf '  link %s -> %s\n' "$tmux_dir/scripts/git-status" "$script_dir/tmux/scripts/git-status"
if [ "$install_ghostty" = true ]; then
  printf '  link %s -> %s\n' "$ghostty_dir/config" "$script_dir/ghostty/config"
fi
if [ "$install_shell" = true ]; then
  printf '  link %s -> %s\n' "$HOME/.zshenv" "$script_dir/zsh/.zshenv"
  printf '  link %s -> %s\n' "$config_root/zsh/.zprofile" "$script_dir/zsh/.zprofile"
  printf '  link %s -> %s\n' "$config_root/zsh/.zshrc" "$script_dir/zsh/.zshrc"
  printf '  link %s -> %s\n' "$config_root/zsh/conf.d" "$script_dir/zsh/conf.d"
  printf '  link %s -> %s\n' "$config_root/starship.toml" "$script_dir/zsh/starship.toml"
fi
if [ "$install_claude" = true ]; then
  printf '  link %s -> %s\n' "$agent_config_dir/scripts/agent-state" "$script_dir/scripts/agent-state"
  printf '  link %s -> %s\n' "$agent_config_dir/scripts/agent-notify" "$script_dir/scripts/agent-notify"
  printf '  link %s -> %s\n' "$agent_config_dir/scripts/claude-statusline" "$script_dir/scripts/claude-statusline"
  printf '  link %s -> %s\n' "$claude_dir/settings.json" "$script_dir/claude/settings.json"
  for skill_dir in "$script_dir"/skills/*; do
    skill_name=${skill_dir##*/}
    printf '  link %s -> %s\n' "$claude_dir/skills/$skill_name" "$skill_dir"
  done
fi
printf '  existing files, if any, move under %s/%s/\n' "$backup_root" "$timestamp"

if [ "$apply" != true ]; then
  printf '\nDry run only. Re-run with --apply to make these changes.\n'
  exit 0
fi

mkdir -p "$tmux_dir/scripts"

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

install_link "$script_dir/tmux/tmux.conf" "$tmux_dir/tmux.conf" tmux.conf
install_link "$script_dir/tmux/theme.conf" "$tmux_dir/theme.conf" theme.conf
install_link "$script_dir/tmux/scripts/window-name" "$tmux_dir/scripts/window-name" window-name
install_link "$script_dir/tmux/scripts/git-status" "$tmux_dir/scripts/git-status" git-status

if [ "$install_ghostty" = true ]; then
  mkdir -p "$ghostty_dir"
  install_link "$script_dir/ghostty/config" "$ghostty_dir/config" ghostty-config
fi

if [ "$install_shell" = true ]; then
  mkdir -p "$config_root/zsh"
  install_link "$script_dir/zsh/.zshenv" "$HOME/.zshenv" zshenv
  install_link "$script_dir/zsh/.zprofile" "$config_root/zsh/.zprofile" zprofile
  install_link "$script_dir/zsh/.zshrc" "$config_root/zsh/.zshrc" zshrc
  install_link "$script_dir/zsh/conf.d" "$config_root/zsh/conf.d" zsh-conf.d
  install_link "$script_dir/zsh/starship.toml" "$config_root/starship.toml" starship.toml
fi

if [ "$install_claude" = true ]; then
  mkdir -p "$agent_config_dir/scripts" "$claude_dir/skills"
  install_link "$script_dir/scripts/agent-state" "$agent_config_dir/scripts/agent-state" agent-state
  install_link "$script_dir/scripts/agent-notify" "$agent_config_dir/scripts/agent-notify" agent-notify
  install_link "$script_dir/scripts/claude-statusline" "$agent_config_dir/scripts/claude-statusline" claude-statusline
  install_link "$script_dir/claude/settings.json" "$claude_dir/settings.json" claude-settings.json
  for skill_dir in "$script_dir"/skills/*; do
    skill_name=${skill_dir##*/}
    install_link "$skill_dir" "$claude_dir/skills/$skill_name" "claude-skill-$skill_name"
  done
fi

printf '\nDone. Start tmux normally, then launch your approved agent command inside it.\n'
