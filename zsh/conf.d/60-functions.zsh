git_main_branch() {
  command git rev-parse --git-dir >/dev/null 2>&1 || return 1
  local ref
  for ref in refs/{heads,remotes/{origin,upstream}}/{main,master,trunk,develop}; do
    if command git show-ref -q --verify "$ref"; then
      printf '%s' "${ref:t}"
      return 0
    fi
  done
  printf 'main'
}

mkcd() {
  mkdir -p "$1" && cd "$1"
}
