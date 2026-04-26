#!/usr/bin/env bash
set -euo pipefail

usage() {
  echo "Usage: $(basename "$0") <owner/repo>"
  echo "  Creates GitHub issues from the most recent tasks JSON in ~/tasks/<repo>/"
  exit 1
}

[[ $# -lt 1 ]] && usage

OWNER_REPO="$1"
REPO_NAME="${OWNER_REPO##*/}"
TASKS_DIR="$HOME/tasks/$REPO_NAME"

# --- locate tasks file ---
if [[ ! -d "$TASKS_DIR" ]]; then
  echo "Error: directory $TASKS_DIR not found. Run /tasks-export first." >&2
  exit 1
fi

TASKS_FILE=$(find "$TASKS_DIR" -maxdepth 1 -name "*-tasks.json" | sort | tail -1)
if [[ -z "$TASKS_FILE" ]]; then
  echo "Error: no *-tasks.json found in $TASKS_DIR. Run /tasks-export first." >&2
  exit 1
fi

echo "Tasks file: $TASKS_FILE"

# --- check gh auth ---
if ! gh auth status &>/dev/null; then
  echo "Error: not authenticated with gh. Run: gh auth login" >&2
  exit 1
fi

# --- parse tasks ---
TASKS_JSON=$(jq -c '[.tasks[] | select(type == "object")] | sort_by(.order)' "$TASKS_FILE")
TASK_COUNT=$(echo "$TASKS_JSON" | jq 'length')

if [[ "$TASK_COUNT" -eq 0 ]]; then
  echo "No tasks found in $TASKS_FILE." >&2
  exit 1
fi

# --- preview table ---
echo ""
echo "Tasks to import into $OWNER_REPO:"
echo ""
printf "%-4s  %-40s  %-8s  %-8s  %s\n" "Ord" "Title" "Model" "Priority" "Depends On"
printf "%-4s  %-40s  %-8s  %-8s  %s\n" "---" "-----" "-----" "--------" "----------"

echo "$TASKS_JSON" | jq -r '.[] | [
  (.order | tostring),
  .title,
  .model,
  .priority,
  (if (.depends_on | length) > 0 then (.depends_on | join(", ")) else "-" end)
] | @tsv' | while IFS=$'\t' read -r order title model priority deps; do
  printf "%-4s  %-40s  %-8s  %-8s  %s\n" "$order" "${title:0:40}" "$model" "$priority" "$deps"
done

echo ""
read -rp "Create $TASK_COUNT issue(s) on $OWNER_REPO? [y/N] " confirm
[[ "$confirm" =~ ^[Yy]$ ]] || { echo "Aborted."; exit 0; }

# --- create issues ---
echo ""
declare -A CREATED_ISSUES

while IFS= read -r task; do
  title=$(echo "$task" | jq -r '.title')
  description=$(echo "$task" | jq -r '.description')
  feature_name=$(echo "$task" | jq -r '.feature_name')
  model=$(echo "$task" | jq -r '.model')
  priority=$(echo "$task" | jq -r '.priority')
  order=$(echo "$task" | jq -r '.order')

  # check for existing open issue
  existing=$(gh issue list --repo "$OWNER_REPO" --search "\"$title\"" --state open --json title --jq '.[0].title // empty')
  if [[ -n "$existing" ]]; then
    echo "  SKIP (exists): $title"
    continue
  fi

  body="## Description

$description

---

**Feature:** \`$feature_name\`
**Model:** $model
**Priority:** $priority
**Order:** $order"

  url=$(gh issue create --repo "$OWNER_REPO" --title "$title" --body "$body")
  echo "  CREATED: $url"
  CREATED_ISSUES["$title"]="$url"
done < <(echo "$TASKS_JSON" | jq -c '.[]')

# --- summary ---
echo ""
echo "Summary:"
printf "%-50s  %s\n" "Title" "URL"
printf "%-50s  %s\n" "-----" "---"
for title in "${!CREATED_ISSUES[@]}"; do
  printf "%-50s  %s\n" "${title:0:50}" "${CREATED_ISSUES[$title]}"
done
