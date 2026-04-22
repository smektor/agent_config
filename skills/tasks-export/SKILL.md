---
name: tasks-export
description: Exports all tasks from the current planning session as a single structured JSON file to ~/tasks/<repo_name>/, formatted for a Claude agent to implement.
argument-hint: "[repo-name]"
disable-model-invocation: true
allowed-tools: Bash Read Write
effort: medium
---

# Tasks Export Skill

## Session context (auto-detected)

```!
echo "Today's date: $(date +%d-%m-%Y)"
ORIGIN=$(git remote get-url origin 2>/dev/null)
GIT_PROJECT=$(echo "$ORIGIN" | sed 's/.*\///; s/\.git//')
echo "Git repo name: ${GIT_PROJECT:-unknown — ask user}"
echo "~/tasks/ dir: $(test -d ~/tasks && echo 'exists' || echo 'will be created')"
echo "AGENT.md: $(test -f AGENT.md && echo 'present — consuming agent will follow it' || echo 'ABSENT — recommend running /agent-md first')"
```

## Purpose

After a planning or research session, export all resulting tasks as a single JSON file to `~/tasks/<repo_name>/`. The file is consumed by a Claude agent that implements the tasks. Tasks must be as small as possible and each description must end with a phrase that triggers the appropriate technology skill in the consuming agent.

## Repo name resolution

- If `$ARGUMENTS` is provided, use it as `repo_name`.
- If git auto-detection succeeded above, confirm it with the user before proceeding.
- If both are unavailable, ask the user.

## Output Format

One file for all tasks: `~/tasks/<repo_name>/<dd-mm-yyyy>-tasks.json`

Read [skills/tasks-export/template.json](skills/tasks-export/template.json) for the JSON schema and a worked example.

## Closing phrase (added to every task description)

Each task `description` must end with this phrase:

> If a `CLAUDE.md` file exists in the repository root, read it to familiarize yourself with the project conventions and let it guide your implementation. Follow its rules unless this task description explicitly says otherwise.

## Steps

1. **Extract tasks** from the current conversation. Break tasks down as small as possible — one concern per task (one component, one endpoint, one model change). If a task has two steps, split it.
2. **Verify explicitness** — For every task description, ensure it is explicit about:
   - **File paths**: use project-relative paths (e.g., `app/models/user.rb`), not vague references like "the user model" or "the config file".
   - **Filenames**: name the exact file to create or edit (e.g., `app/controllers/sessions_controller.rb`), not "a controller" or "a new file".
   - **Directories**: when creating new files, state the target directory explicitly (e.g., "create `app/services/auth_service.rb`").
   - **Expected output**: every description must state what a successful result looks like — either a concrete artifact (e.g., "a new `AuthService` class with a `#call` method") or a verifiable behaviour (e.g., "visiting `/login` renders the form and returns HTTP 200").
   - If a description is vague on any of the above, rewrite it to be concrete before proceeding.
3. **Resolve repo_name** using the logic above.
4. **Clarify** priority and order if ambiguous.
5. **Confirm the task list** with the user before writing any files.
6. **Construct and save** the JSON using the Output Format above. Create `~/tasks/<repo_name>/` if needed. Save to `~/tasks/<repo_name>/<dd-mm-yyyy>-tasks.json`.
7. **Report** to the user: the saved file path, a summary table of tasks, and — if AGENT.md was absent — the warning: *"No AGENT.md found in this repo — tasks will fall back to standard conventions. Consider running /agent-md first."*

