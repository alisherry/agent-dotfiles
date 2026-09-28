# Small, framework-free interactive config. Files load in lexical order.
for _config_file in "${ZDOTDIR:-$HOME/.config/zsh}"/conf.d/*.zsh(N); do
  source "$_config_file"
done
unset _config_file

[[ -f "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"
