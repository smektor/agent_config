---
name: tasks-to-json
description: Saves a confirmed task list from the current session as a single structured JSON file to ~/tasks/<repo_name>/, formatted for a Claude agent to implement. Use when you already have a distilled and confirmed task list.
when_to_use: Use when the user already has a confirmed task list and wants to save or re-export it as JSON. Triggers on "save as json", "re-export tasks", "write tasks to file", or when the user edits a previously exported list and wants to persist the changes.
argument-hint: "[repo-name]"
disable-model-invocation: true
allowed-tools: Bash Read Write
effort: medium
---

# Tasks to JSON Skill

## Session context (auto-detected)

```!
echo "Today's date: $(date +%d-%m-%Y)"
ORIGIN=$(git remote get-url origin 2>/dev/null)
GIT_PROJECT=$(echo "$ORIGIN" | sed 's/.*\///; s/\.git//')
echo "Git repo name: ${GIT_PROJECT:-unknown — ask user}"
echo "~/tasks/ dir: $(test -d ~/tasks && echo 'exists' || echo 'will be created')"
```

## Purpose

After a planning session where tasks have already been distilled and confirmed (e.g., via `/tasks-export`), save them as a single JSON file to `~/tasks/<repo_name>/`. The file is consumed by a Claude agent that implements the tasks. Tasks must be as small as possible — one concern per task.

## Output Format

One file for all tasks: `~/tasks/<repo_name>/<dd-mm-yyyy>-tasks.json`

Read [skills/tasks-to-json/template.json](skills/tasks-to-json/template.json) for the JSON schema and a worked example.

## Steps

1. **Extract tasks** from the current conversation. Break tasks down as small as possible — one concern per task (one component, one endpoint, one model change). If a task has two steps, split it.
2. **Verify explicitness** — For every task description, ensure it is explicit about:
   - **File paths**: use project-relative paths (e.g., `app/models/user.rb`), not vague references like "the user model" or "the config file".
   - **Filenames**: name the exact file to create or edit (e.g., `app/controllers/sessions_controller.rb`), not "a controller" or "a new file".
   - **Directories**: when creating new files, state the target directory explicitly (e.g., "create `app/services/auth_service.rb`").
   - **Expected output**: every description must state what a successful result looks like — either a concrete artifact (e.g., "a new `AuthService` class with a `#call` method") or a verifiable behaviour (e.g., "visiting `/login` renders the form and returns HTTP 200").
   - If a description is vague on any of the above, rewrite it to be concrete before proceeding.
3. **Resolve repo_name**: use `$ARGUMENTS` if set; else confirm the git-detected name with the user; else ask.
4. **Clarify** priority and order if ambiguous.
5. **Confirm the task list** with the user before writing any files.
6. **Construct and save** the JSON using the Output Format above. Create `~/tasks/<repo_name>/` if needed. Save to `~/tasks/<repo_name>/<dd-mm-yyyy>-tasks.json`.
7. **Report** to the user: the saved file path and a summary table of tasks (title → model → priority → order → depends_on).
