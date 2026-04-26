---
name: issues-from-tasks
description: Creates GitHub issues from a tasks JSON file in ~/tasks/<repo_name>/, one issue per task entry, using the gh CLI.
argument-hint: "[github-owner/repo]"
disable-model-invocation: true
allowed-tools: Bash
effort: low
---

# Issues From Tasks Skill

This skill runs the `scripts/issues-from-tasks.sh` script from the agent_config repo.

## Steps

1. **Resolve `owner/repo`** — use `$ARGUMENTS` if provided; else derive from the current git remote and confirm with user; else ask.
2. **Find the script** at `$REPO_DIR/scripts/issues-from-tasks.sh` where `$REPO_DIR` is the agent_config repo root (usually `~/workspace/agent_config`).
3. **Run the script**:

```bash
~/workspace/agent_config/scripts/issues-from-tasks.sh <owner/repo>
```

The script handles everything: locating the tasks file, previewing, confirming, deduplicating, and creating issues.

## What the script does

- Reads the most recent `*-tasks.json` from `~/tasks/<repo_name>/`
- Shows a preview table and asks for confirmation before creating any issues
- Skips tasks whose issue title already exists as an open issue
- Creates issues sequentially (not in parallel) in `order` ascending
- Prints a summary table of created issue URLs
