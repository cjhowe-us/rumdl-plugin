#!/usr/bin/env bash
# PostToolUse: rumdl fmt + rumdl check for .md after Write / Edit / MultiEdit.
#
# `rumdl fmt` rewrites fixable issues and exits 0 even when diagnostics remain
# (its exit code only signals formatter failure), so we follow up with `rumdl
# check` to detect leftover warnings. When warnings remain we emit a Claude
# Code PostToolUse JSON response with `hookSpecificOutput.additionalContext`
# so the assistant sees the diagnostics and fixes them in a follow-up edit —
# without hard-blocking the original tool call.
INPUT=$(cat)

command -v rumdl >/dev/null 2>&1 || exit 0
command -v jq    >/dev/null 2>&1 || exit 0

LEFTOVER=""

process_md() {
  local FILE="$1"
  [[ -n "$FILE" && "$FILE" == *.md && -f "$FILE" ]] || return 0

  local FMT_OUT FMT_RC
  FMT_OUT=$(rumdl fmt "$FILE" 2>&1)
  FMT_RC=$?
  if [ "$FMT_RC" -ne 0 ]; then
    LEFTOVER+="rumdl fmt failed for $FILE (exit $FMT_RC):"$'\n'"$FMT_OUT"$'\n\n'
    return 0
  fi

  local CHECK_OUT CHECK_RC
  CHECK_OUT=$(rumdl check "$FILE" 2>&1)
  CHECK_RC=$?
  if [ "$CHECK_RC" -ne 0 ]; then
    LEFTOVER+="Unfixed rumdl diagnostics in $FILE:"$'\n'"$CHECK_OUT"$'\n\n'
  fi
}

while IFS= read -r FILE; do
  process_md "$FILE"
done < <(
  echo "$INPUT" | jq -r '
    (.tool_input // {})
    | [
        (.file_path // ""),
        (.edits // [] | map(.file_path // .path // "") | .[])
      ]
    | map(select(length > 0))
    | unique
    | .[]
  '
)

if [ -n "$LEFTOVER" ]; then
  MSG="rumdl auto-formatted the file(s) but left warnings the formatter cannot fix automatically. Please address them in a follow-up edit:"$'\n\n'"$LEFTOVER"
  jq -n --arg ctx "$MSG" '{
    hookSpecificOutput: {
      hookEventName: "PostToolUse",
      additionalContext: $ctx
    }
  }'
fi

exit 0
