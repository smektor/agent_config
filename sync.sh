#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"

sync_file() {
  local src="$1"
  local dst="$2"
  mkdir -p "$(dirname "$dst")"
  cp "$src" "$dst"
  echo "  synced: $dst"
}

sync_dir() {
  local src_dir="$1"
  local dst_dir="$2"
  if [[ ! -d "$src_dir" ]]; then return; fi
  mkdir -p "$dst_dir"
  find "$src_dir" -type f | while read -r src; do
    # Skip files ending with .skip
    if [[ "$src" == *.skip ]]; then continue; fi
    local rel="${src#"$src_dir"/}"
    sync_file "$src" "$dst_dir/$rel"
  done
}

echo "Syncing agent_config → ~/.claude"

sync_file "$REPO_DIR/CLAUDE.md"              "$CLAUDE_DIR/CLAUDE.md"
sync_dir  "$REPO_DIR/agents"                 "$CLAUDE_DIR/agents"
sync_dir  "$REPO_DIR/skills"                 "$CLAUDE_DIR/skills"
sync_dir  "$REPO_DIR/scripts"               "$CLAUDE_DIR/scripts"

echo "Done."
