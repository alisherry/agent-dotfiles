typeset -U path PATH fpath
path=("$HOME/bin" "$HOME/.local/bin" $path)

[[ -d /opt/homebrew/share/zsh/site-functions ]] && \
  fpath=(/opt/homebrew/share/zsh/site-functions $fpath)
