# Security

This repository is intentionally small enough to audit before use on a managed device.

## Trust model

- `setup.sh` is local-only. It creates directories, moves conflicting configuration files into a timestamped backup, and creates symlinks.
- Agent hooks receive event JSON on standard input. `agent-state` discards it and does not persist or transmit event content.
- The Claude statusline reads documented session metadata from standard input and prints a local summary. It does not persist or transmit that input.
- Hooks only update tmux window options. `agent-notify` may show a tmux message and, on macOS, a local notification when an agent needs attention.
- The tmux status helpers read the current process name and local Git worktree state. They do not read file contents or contact a remote.
- The optional Zsh setup is framework-free. It only sources user-owned `~/.zshenv.local`, `~/.zprofile.local`, and `~/.zshrc.local` overrides when present; Starship is used only if it is already installed.
- There are no downloads, analytics, update checks, credential readers, daemons, or package-manager commands.

Hooks and statusline commands are executable code and should never be trusted sight unseen. Review `claude/`, `hooks/`, `scripts/`, and any changes after pulling. If an organizational sandbox blocks tmux socket access or user hooks, do not weaken that policy; use the configuration without automatic indicators.

## Reporting

Please open a GitHub issue for suspected vulnerabilities. Do not include credentials, proprietary source, or private logs in a public report.
