#!/usr/bin/env bash
# PreToolUse hook: refuse any Bash command that runs `git commit` or `git push`.
cmd=$(jq -r '.tool_input.command // empty')
[ -z "$cmd" ] && exit 0

# Check each command segment (split on ; & | newline) for `git ... commit|push`,
# allowing any global flags in between (-C, -c, --no-pager, …) and quoting (bash -c '…').
if printf '%s\n' "$cmd" | tr ';&|' '\n\n\n' \
  | grep -Eq '(^|[^[:alnum:]_./-])git([[:space:]].*)?[[:space:]](commit|push)([^[:alnum:]_-]|$)'; then
  echo "Blocked by hook: git commit/push is reserved for the user. Ask them to run it." >&2
  exit 2
fi
exit 0
