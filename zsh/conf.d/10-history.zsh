HISTFILE="$HOME/.zsh_history"
HISTSIZE=200000
SAVEHIST=200000

setopt EXTENDED_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_SAVE_NO_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_VERIFY

# Do not persist common inline credential shapes. Prefix any other sensitive
# command with a space to exclude it through HIST_IGNORE_SPACE.
HISTORY_IGNORE='(*_TOKEN=*|*_KEY=*|*_SECRET=*|*PASSWORD*|*password=*|*[Aa][Pp][Ii][-_][Kk][Ee][Yy]*|*Bearer *)'
