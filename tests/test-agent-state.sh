#!/usr/bin/env bash
set -eu

repo_dir=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
tmp_dir=$(mktemp -d "${TMPDIR:-/tmp}/agent-state-test.XXXXXX")
trap 'rm -rf "$tmp_dir"' EXIT HUP INT TERM

cat >"$tmp_dir/tmux" <<'MOCK'
#!/usr/bin/env bash
printf '%s\n' "$*" >>"$AGENT_STATE_TEST_LOG"
if [ "${1:-}" = show-option ]; then
  printf '0\n'
fi
MOCK
chmod +x "$tmp_dir/tmux"

export PATH="$tmp_dir:$PATH"
export TMUX=test
export TMUX_PANE=%7
export AGENT_STATE_TEST_LOG="$tmp_dir/tmux.log"

: >"$AGENT_STATE_TEST_LOG"
printf '{}' | "$repo_dir/scripts/agent-state" codex SessionStart
grep -q 'set-option -wq -t %7 @agent_provider codex' "$AGENT_STATE_TEST_LOG"
grep -q 'set-option -wq -t %7 @agent_state idle' "$AGENT_STATE_TEST_LOG"

: >"$AGENT_STATE_TEST_LOG"
printf '{}' | "$repo_dir/scripts/agent-state" codex PermissionRequest
grep -q 'set-option -wq -t %7 @agent_state waiting' "$AGENT_STATE_TEST_LOG"

: >"$AGENT_STATE_TEST_LOG"
printf '{"tool_name":"Task"}' | "$repo_dir/scripts/agent-state" claude PreToolUse
grep -q 'set-option -wq -t %7 @agent_subagents 1' "$AGENT_STATE_TEST_LOG"
grep -q 'set-option -wq -t %7 @agent_state working' "$AGENT_STATE_TEST_LOG"

: >"$AGENT_STATE_TEST_LOG"
printf '{}' | "$repo_dir/scripts/agent-state" codex Stop
grep -q 'set-option -wq -t %7 @agent_state done' "$AGENT_STATE_TEST_LOG"

: >"$AGENT_STATE_TEST_LOG"
printf '{}' | "$repo_dir/scripts/agent-state" codex SessionEnd
grep -q 'set-option -wq -t %7 @agent_provider ' "$AGENT_STATE_TEST_LOG"

printf 'agent-state tests passed\n'
