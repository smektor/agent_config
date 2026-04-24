---
name: task-distill
description: Rethinks the current session discussion and distills it into a concise, prioritized list of small, actionable tasks — ready for review, refinement, or export.
when_to_use: Triggers when the user says "distill tasks", "extract tasks", "what are the tasks", "summarize tasks", "pull out the tasks", or "what should we build from this". Use after any planning, design, or problem-solving discussion to crystallize actionable next steps.
argument-hint: ""
disable-model-invocation: true
allowed-tools: Bash
effort: low
---

# Task Distill Skill

## Session context (auto-detected)

```!
echo "Today's date: $(date +%d-%m-%Y)"
echo "Git repo: $(git remote get-url origin 2>/dev/null | sed 's/.*\///' | sed 's/\.git//' || echo 'not a git repo')"
```

## Purpose

Rethink the entire session conversation and distill it into a **minimal, prioritized list of small tasks**. Each task should represent one atomic unit of work — one concern, one component, one change. If a task feels like it has two steps, split it.

This skill produces a structured task list for the user to review and refine. It does **not** export or save files — that is a separate optional step.

## Output format

Print the distilled task list inline in the conversation. Do **not** write files.

For each task, output:

```
## Tasks

| # | Title | Priority | Depends on |
|---|-------|----------|------------|
| 1 | Short human-readable name | high/medium/low | — or task # |
...

### Task 1 — <Title>
**Priority:** high | medium | low
**Depends on:** none | Task N
**Description:** Self-contained, one-paragraph description of what needs to be done and why. Written as if the implementer has no memory of this session. Must include:
- Exact project-relative file paths for every file to create or edit (e.g., `app/models/user.rb`).
- Explicit target directory when creating new files.
- A concrete expected output — either a named artifact (e.g., "a new `AuthService` class with a `#call` method") or a verifiable behaviour (e.g., "visiting `/login` returns HTTP 200 and renders the login form").
```

## Steps

1. **Re-read the session.** For each item ask:
   - What was decided? → becomes a task
   - What is broken or missing? → becomes a task
   - What was deferred or flagged for later? → lower-priority task
   - What is implicit but required? → prerequisite task
   Discard: opinions, exploratory tangents, questions answered inline, anything without a concrete outcome.
2. **Draft candidate tasks** (internal — do not print this).
3. **Prune and split**: remove duplicates; split any task whose title contains "and".
   One task = one concern. Prefer 3–8 tasks. Infrastructure before features.
4. **Assign priority**: high = blocks other work; medium = important but not blocking; low = deferred/nice-to-have.
5. **Write self-contained descriptions** — no "as discussed" references. Every description must name exact project-relative file paths, the target directory when creating files, and end with a concrete expected output (named artifact or verifiable behaviour).
6. **Print the task table** followed by the per-task detail blocks (see Output format).
7. **Ask the user** if the list looks right, and whether any tasks should be split, merged, reprioritized, or dropped.

## Notes

- Do not invent tasks that were not discussed. Stick strictly to what emerged from the conversation.
- Do not include tasks for things already completed during the session.
- Write descriptions in the imperative ("Create...", "Add...", "Fix...", "Extract...").
- If the session produced no actionable tasks (e.g., it was pure Q&A), say so explicitly rather than fabricating work.
- After the user confirms the list, mention that they can run `/tasks-export` to save these as structured JSON files if needed.
