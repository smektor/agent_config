---
name: issues-from-tasks
description: Creates GitHub issues from a tasks JSON file in ~/tasks/<repo_name>/, one issue per task entry, using the gh CLI.
argument-hint: "[repo-name] [github-owner/repo]"
disable-model-invocation: true
allowed-tools: Bash
effort: low
---

# Issues From Tasks Skill

## Session context (auto-detected)

```!
echo "Today's date: $(date +%d-%m-%Y)"
ORIGIN=$(git remote get-url origin 2>/dev/null)
GIT_PROJECT=$(echo "$ORIGIN" | sed 's/.*\///; s/\.git//')
echo "Git repo name: ${GIT_PROJECT:-unknown — ask user}"
echo "GitHub remote: ${ORIGIN:-unknown — ask user}"
echo "gh auth: $(gh auth status 2>&1 | head -1)"
```

## Purpose

Read a tasks JSON file from `~/tasks/<repo_name>/` and create one GitHub issue per task entry using the `gh` CLI. Issues are created on the target GitHub repository with a title and body built from the task description.

## Steps

1. **Resolve `repo_name`** — use the first word of `$ARGUMENTS` if provided; else use the git-detected repo name and confirm with user; else ask.
2. **Resolve `owner/repo`** — use the second word of `$ARGUMENTS` if provided; else derive from the git remote URL and confirm with user; else ask.
3. **Find the tasks file** in `~/tasks/<repo_name>/` matching `*-tasks.json`. If the directory is empty or missing, tell the user to run `/tasks-export` first. If multiple files exist, pick the most recent by filename date and confirm with user.
4. **Parse the `tasks` array** from the JSON file, sorted by `order` field ascending.
5. **Check `gh` auth** — if not authenticated, tell the user to run `gh auth login` and stop.
6. **Confirm with the user** — show a table of tasks (title → model → priority → order → depends_on) before creating any issues. `depends_on` is for human review only — it will not appear in the issue body.
7. **For each task entry** (in `order` ascending, sequentially — not in parallel):
   - Check for an existing open issue with the same title: `gh issue list --repo <owner/repo> --search "<title>" --state open`. If one exists, skip and warn the user.
   - Build the issue body (see format below).
   - Create the issue: `gh issue create --repo <owner/repo> --title "<title>" --body "<body>"`
   - Print the created issue URL after each creation.
8. **Summarise** — print a table of created issues (title → URL).

## Issue body format

```markdown
## Description

<task description>

---

**Feature:** `<feature_name>`
**Model:** <model>
**Priority:** <priority>
**Order:** <order>
```

See [example.md](example.md) for a full worked example.
