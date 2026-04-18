---
name: issues-from-tasks
description: Creates GitHub issues from task JSON files in ~/tasks/<repo_name>/, one issue per file, using the gh CLI.
when_to_use: Triggers when the user says "create issues", "push tasks to GitHub", "open issues from tasks", "create GitHub issues from tasks", or similar. Requires task JSON files to already exist (run /task-export first).
argument-hint: "[repo-name] [github-owner/repo]"
disable-model-invocation: true
allowed-tools: Bash
effort: low
---

# Issues From Tasks Skill

## Session context (auto-detected)

```!
echo "Today's date: $(date +%d-%m-%Y)"
echo "Git repo name: $(git remote get-url origin 2>/dev/null | sed 's/.*\///' | sed 's/\.git//' || echo 'unknown — ask user')"
echo "GitHub remote: $(git remote get-url origin 2>/dev/null || echo 'unknown — ask user')"
echo "gh auth: $(gh auth status 2>&1 | head -1)"
```

## Purpose

Read task JSON files from `~/tasks/<repo_name>/` and create one GitHub issue per file using the `gh` CLI. Issues are created on the target GitHub repository with a title and body built from the task description.

## Argument resolution

- `$ARGUMENTS` may contain `repo_name` and/or `owner/repo` (e.g. `my-app wedlu/my-app`).
- If `repo_name` is not provided, use auto-detected git repo name and confirm with user.
- If `owner/repo` is not provided, derive it from the git remote URL and confirm with user.
- If neither can be resolved, ask the user.

## Steps

1. **Resolve `repo_name`** — the local task folder name under `~/tasks/`.
2. **Resolve `owner/repo`** — the GitHub repository to open issues on.
3. **List task files** in `~/tasks/<repo_name>/` matching `*.json`, sorted by `order` field ascending.
4. **Check `gh` auth** — if not authenticated, tell the user to run `gh auth login` and stop.
5. **Confirm with the user** — show a table of tasks (filename → title → priority → order) before creating any issues.
6. **For each task file** (in `order` ascending):
   - Parse the JSON.
   - Build the issue body (see format below).
   - Create the issue: `gh issue create --repo <owner/repo> --title "<title>" --body "<body>"`
   - Print the created issue URL after each creation.
7. **Summarise** — print a table of created issues (title → URL).

## Issue body format

```markdown
## Description

<task description>

---

**Feature:** `<feature_name>`
**Priority:** <priority>
**Order:** <order>
**Source file:** `~/tasks/<repo_name>/<filename>`
```

## Notes

- Do not create duplicate issues. Before creating, optionally check for an existing open issue with the same title: `gh issue list --repo <owner/repo> --search "<title>" --state open`. If one exists, skip and warn the user.
- Do not delete or modify task JSON files after issue creation.
- If `~/tasks/<repo_name>/` is empty or does not exist, tell the user to run `/task-export` first.
- Issues are created sequentially (not in parallel) to preserve order and avoid rate limits.

## Example

Task file: `~/tasks/my-app/18-04-2026-oauth-login-page.json`
```json
{
  "feature_name": "oauth-login-page",
  "title": "Add OAuth Login Page",
  "description": "Create a login page at /login with a 'Sign in with Google' button...",
  "priority": "high",
  "order": 1
}
```

Command run:
```bash
gh issue create \
  --repo wedlu/my-app \
  --title "Add OAuth Login Page" \
  --body "## Description\n\nCreate a login page..."
```
