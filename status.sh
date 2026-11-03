#!/bin/sh
# Short-lived tokens clear when the active pane or workspace changes.
herdr=${HERDR_BIN_PATH:-herdr}
pane=${HERDR_ACTIVE_PANE_ID:?}
workspace=${HERDR_ACTIVE_WORKSPACE_ID:?}
zoomed=$("$herdr" pane layout --pane "$pane" | jq -er '.result.layout.zoomed | if type == "boolean" then tostring else error("missing zoom state") end') || exit 1
if [ "$zoomed" = true ]; then
  "$herdr" pane report-metadata "$pane" --source zoom-indicator --token 'zoom=💠' --ttl-ms 5000 >/dev/null || exit 1
  "$herdr" workspace report-metadata "$workspace" --source zoom-indicator --token 'zoom=💠' --ttl-ms 5000 >/dev/null || exit 1
  printf '💠\n'
else
  "$herdr" pane report-metadata "$pane" --source zoom-indicator --clear-token zoom >/dev/null || exit 1
  "$herdr" workspace report-metadata "$workspace" --source zoom-indicator --clear-token zoom >/dev/null || exit 1
fi
