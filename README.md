# Herdr Zoom Indicator

Shows 💠 in the right side of Herdr's tab bar and, optionally, in expanded Agent and Space sidebar rows when the active pane is zoomed. Herdr's built-in tab `Z` remains. Only the active pane and workspace are marked; markers expire after focus changes.

Requires Herdr 0.9.5 or newer, `sh`, and `jq` on Linux or macOS.

## Install

```sh
herdr plugin install riogesulgon/herdr-zoom-indicator
herdr plugin action invoke herdr-zoom-indicator.setup
herdr plugin config-dir herdr-zoom-indicator
```

The setup action copies `status.sh` to the printed plugin config directory. It also runs at server startup; after a plugin update, invoke setup again or restart the server to refresh that copy.

Add the following entry to the existing `ui.tab_bar_right` array in `~/.config/herdr/config.toml`, substituting the absolute path printed by `config-dir`. If no array exists, create one under `[ui]`. Preserve other entries; TOML does not allow duplicate keys.

```toml
[ui]
tab_bar_right = [
  { type = 'command', command = 'sh /absolute/plugin-config-directory/status.sh', interval_seconds = 2, timeout_seconds = 1 },
]
```

To show sidebar indicators, add `"$zoom"` to the desired row in `[ui.sidebar.agents]` and `[ui.sidebar.spaces]`. Add it to each `[ui.sidebar.agents.rows_by_agent]` override too. Each row accepts at most 16 tokens. The command refreshes metadata every two seconds, with a five-second expiry to clear stale markers after focus changes. The sidebar only renders the active agent's marker when that agent has an expanded sidebar row; the space marker follows the active workspace.

```toml
[ui.sidebar.agents]
rows = [["$zoom", "state_icon", "agent"]]

[ui.sidebar.spaces]
rows = [["$zoom", "state_icon", "workspace"]]
```

These examples replace the full row layouts: merge `$zoom` into your existing layouts rather than duplicating those keys. Tools such as Herdr Radar can overwrite their managed config blocks during reconfiguration or appearance changes.

Apply changes with `herdr server reload-config`. The command must remain in `tab_bar_right` even if only sidebar indicators are wanted: it supplies their metadata. It runs through the Herdr status-command context and must not use `--current`.

## Local development

```sh
herdr plugin link /absolute/path/to/herdr-zoom-indicator
herdr plugin action invoke herdr-zoom-indicator.setup
```
