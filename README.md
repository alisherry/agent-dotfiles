# agent-dotfiles

A small, public agent cockpit for locked-down laptops: tmux ergonomics, lifecycle state indicators, and provider-neutral coding skills. It is designed for running an approved command such as `sandbox-ai claude` or `sandbox-ai codex` inside tmux while editing in another IDE.

The repository deliberately does **not** install an editor, package manager, runtime, shell framework, or agent binary. It contains no company-specific material, credentials, gateway configuration, background daemon, or network bootstrap.

## What it shows

Lifecycle hooks update tmux's window-local options, and the status bar renders them without polling:

| Mark | State |
| --- | --- |
| `●` | working |
| `▲` | waiting for attention or permission |
| `✓` | turn finished |
| `⑂N` | active subagent count |

The provider name (`claude` or `codex`) appears beside the state. The design assumes one agent session per tmux window; panes in the same window share its indicator.

## Install the tmux config

Requirements: Bash 3.2+ and tmux. Clone the repository using whatever Git workflow your company permits, then inspect and run:

```sh
./setup.sh
./setup.sh --apply
```

The first command is a dry run. `--apply` only creates `~/.config/tmux`, backs up conflicting tmux files under `~/.agent-dotfiles-backup/<timestamp>/`, and symlinks the two checked-in config files. It never invokes `sudo`, a package manager, or the network.

Start tmux normally and launch the approved agent command inside it. `prefix + r` reloads the config; the prefix is `C-a`.

## Enable agent hooks and skills

This repository is laid out as a portable Agent Plugin and includes manifests for Codex and Claude. Point your organization's approved plugin importer at the checkout root. Plugin hooks are executable code: inspect `hooks/` and `scripts/` and approve them only through your employer's supported flow.

The included skills are intentionally provider-neutral:

- `source-drafting`
- `summarize-change`
- `strict-code-review`
- `parallel-work`

If your sandbox does not permit plugins, the skills remain plain `SKILL.md` files and can be copied or referenced using its approved configuration mechanism. The tmux configuration works independently; only automatic state changes require hooks.

For Codex, user-installed hooks must be reviewed and trusted before they run. An organization may also enforce managed-only hooks. For Claude, use the equivalent plugin trust flow exposed by your managed wrapper.

## Sandbox compatibility

The state hook exits successfully without doing anything unless all of these are true:

- it is running inside tmux;
- `TMUX` and `TMUX_PANE` survive the sandbox boundary;
- the sandbox can access the tmux server socket;
- the plugin's hooks are enabled by policy.

To check the first three from inside the agent shell:

```sh
printf '%s\n' "$TMUX_PANE"
tmux display-message -p '#{pane_id}'
```

If either command produces no pane identifier, the sandbox is isolating tmux. Keep using the config, but expect no automatic indicator until the administrator permits the socket/environment bridge.

## Audit and test

Everything operational is in two short shell scripts. Run the local checks with:

```sh
bash tests/check-public.sh
bash tests/test-agent-state.sh
```

See [SECURITY.md](SECURITY.md) for the trust model. Contributions should keep the default path dependency-free and free of private organization material.
