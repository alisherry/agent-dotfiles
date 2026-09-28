# Security

This repository is intentionally small enough to audit before use on a managed device.

## Trust model

- `setup.sh` is local-only. It creates directories, moves conflicting tmux config files into a timestamped backup, and creates symlinks.
- Agent hooks receive event JSON on standard input. `agent-state` discards it except for detecting Claude's generic `Task` tool event; it does not persist or transmit event content.
- Hooks only update tmux window options. `agent-notify` may show a tmux message and, on macOS, a local notification when an agent needs attention.
- There are no downloads, analytics, update checks, credential readers, daemons, or package-manager commands.

Plugin hooks are executable code and should never be trusted sight unseen. Review `hooks/`, `scripts/`, and any changes after pulling. If an organizational sandbox blocks tmux socket access or user hooks, do not weaken that policy; use the configuration without automatic indicators.

## Reporting

Please open a GitHub issue for suspected vulnerabilities. Do not include credentials, proprietary source, or private logs in a public report.
