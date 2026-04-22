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

Read [template.json](template.json) for the JSON schema and a worked example.

## Closing phrase (added to every task description)

Each task `description` must end with one of these phrases. The consuming agent checks at **run time** — do not try to resolve this at export time.

| Situation | Closing phrase |
|---|---|
| Default (most tasks) | `Follow AGENT.md if present in the repository root; otherwise apply standard conventions.` |
| Specific subagent override | `Use the @<agent-name> agent defined in .claude/agents/.` |
| No agent guidelines | `Implement without following any predefined agent guidelines.` |

Use the default for every task unless the user explicitly specifies an override during confirmation.

## Steps

1. **Extract tasks** from the current conversation. Break tasks down as small as possible — one concern per task (one component, one endpoint, one model change). If a task has two steps, split it.
2. **Resolve repo_name** using the logic above.
3. **Clarify** priority and order if ambiguous.
4. **Confirm the task list** with the user before writing any files. Note the closing phrase for each task (default or override) — this is the moment for per-task overrides.
5. **Construct and save** the JSON using the Output Format above. Create `~/tasks/<repo_name>/` if needed. Save to `~/tasks/<repo_name>/<dd-mm-yyyy>-tasks.json`.
6. **Report** to the user: the saved file path, a summary table of tasks, and — if AGENT.md was absent — the warning: *"No AGENT.md found in this repo — tasks will fall back to standard conventions. Consider running /agent-md first."*

