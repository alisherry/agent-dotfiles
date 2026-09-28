if (( $+commands[starship] )); then
  export STARSHIP_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/starship.toml"
  eval "$(starship init zsh)"
else
  # Ghostty's configured blue/magenta slots map these to the Moonlight palette.
  setopt PROMPT_SUBST
  PROMPT='%F{blue}%~%f %F{magenta}${${$(git symbolic-ref --short HEAD 2>/dev/null):+ ${$(git symbolic-ref --short HEAD 2>/dev/null)}}}%f
%(?.%F{blue}.%F{red})❯%f '
fi
