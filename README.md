# agent-dotfiles

A small, public agent cockpit for locked-down laptops: a Moonlight-themed tmux setup tuned for Ghostty, lifecycle state indicators, and provider-neutral coding skills. It is designed for running an approved command such as `sandbox-ai claude` or `sandbox-ai codex` inside tmux while editing in another IDE.

The repository deliberately does **not** install an editor, package manager, runtime, shell framework, font, or agent binary. It contains no company-specific material, credentials, gateway configuration, daemon, or network bootstrap.

## What it shows

Each tmux window is named for its project and Git branch. Lifecycle hooks add agent state directly to the window tab:

| Mark | State |
| --- | --- |
| `●` | working |
| `▲` | waiting for attention or permission |
| `✓` | turn finished |
| `⑂N` | active subagent count |

The right side shows the provider, current Git branch and dirty state, and time. Agent state is event-driven rather than polled; the Git and window-name helpers are small local scripts that run on tmux's five-second status refresh.

## Install

Requirements: Bash 3.2+, Git, and tmux 3.2+. Clone using whatever workflow your company permits, then inspect and run:

```sh
./setup.sh
./setup.sh --apply
```

The first command is a dry run. `--apply` creates `~/.config/tmux`, backs up conflicting files under `~/.agent-dotfiles-backup/<timestamp>/`, and symlinks the checked-in configuration. It never invokes `sudo`, a package manager, or the network.

For the matching Ghostty palette and window treatment, opt in explicitly:

```sh
./setup.sh --ghostty
./setup.sh --apply --ghostty
```

This backs up and replaces `~/.config/ghostty/config`, so omit `--ghostty` if you want to keep your existing terminal settings. The tmux config still enables Ghostty RGB, hyperlinks, extended keys, styled underlines, and passthrough either way.

Start tmux normally and launch the approved agent command inside it. `prefix + r` reloads the config; the prefix is `C-a`.

## Enable agent hooks and skills

This repository is a portable Agent Plugin with Codex and Claude manifests. Point your organization's approved plugin importer at the checkout root. Hooks are executable code: inspect `hooks/` and `scripts/` and approve them only through your employer's supported flow.

Included provider-neutral skills:

- `source-drafting`
- `summarize-change`
- `strict-code-review`
- `parallel-work`

If your sandbox does not permit plugins, the skills remain plain `SKILL.md` files and can be copied or referenced using its approved configuration mechanism. Tmux works independently; only automatic agent state requires hooks.

## Sandbox compatibility

The state hook exits successfully without doing anything unless it runs inside tmux, `TMUX` and `TMUX_PANE` survive the sandbox boundary, the sandbox can access the tmux server socket, and hooks are enabled by policy.

Check the environment from inside the agent shell:

```sh
printf '%s\n' "$TMUX_PANE"
tmux display-message -p '#{pane_id}'
```

If either command produces no pane identifier, keep using the cockpit but expect no automatic indicator until the administrator permits the socket/environment bridge.

## Audit and test

```sh
bash tests/check-public.sh
bash tests/test-agent-state.sh
```

See [SECURITY.md](SECURITY.md) for the trust model. Contributions should keep the default path free of private organization material and external runtime dependencies.
