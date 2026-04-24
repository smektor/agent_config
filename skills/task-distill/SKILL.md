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

| # | Title | Priority | Model | Depends on |
|---|-------|----------|-------|------------|
| 1 | Short human-readable name | high/medium/low | haiku/sonnet/opus | — or task # |
...

### Task 1 — <Title>
**Priority:** high | medium | low
**Model:** haiku | sonnet | opus
**Depends on:** none | Task N
**Description:** [Context line — see Step 5.] [Imperative body: what to implement, with exact project-relative paths and target directories.] [Patterns: see `<file>` for the existing pattern — omit if nothing comparable exists.] Out of scope: [what this task explicitly does NOT include]. Verify: [concrete command to run after implementing and what to confirm].
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
5. **Write self-contained descriptions.** For each task:
   - **Model** — assign based on scope: `haiku` for a single named file with a clearly bounded change; `sonnet` for multi-file work or when an existing pattern must be understood first; `opus` for architectural decisions touching many systems. **Default to `sonnet` when in doubt.**
   - **Context line** (first sentence of Description): only add for sonnet/opus when the agent genuinely needs to understand existing code first — `"Before implementing, read \`<dir-or-files>\` to understand <pattern>."` Omit entirely for haiku tasks and for any task where the file path and change are already explicit.
   - **Body** — imperative, no "as discussed" references. Name exact project-relative paths for every file to create or edit. State the target directory explicitly when creating new files.
   - **Patterns** — if a similar implementation exists, name its path: `"Patterns: see \`<file>\` for the existing pattern."` Omit if nothing comparable exists.
   - **Out of scope** — one sentence on what is explicitly NOT part of this task: `"Out of scope: do not implement <X> — that is a separate task."`
   - **Verify** — a concrete command to run after implementing: `"Verify: run \`<command>\` and confirm <result>."` Not a description of a result — an executable check.
6. **Print the task table** followed by the per-task detail blocks (see Output format).
7. **Ask the user** if the list looks right, and whether any tasks should be split, merged, reprioritized, or dropped.

## Notes

- Do not invent tasks that were not discussed. Stick strictly to what emerged from the conversation.
- Do not include tasks for things already completed during the session.
- Write descriptions in the imperative ("Create...", "Add...", "Fix...", "Extract...").
- If the session produced no actionable tasks (e.g., it was pure Q&A), say so explicitly rather than fabricating work.
- After the user confirms the list, mention that they can run `/tasks-export` to save these as structured JSON files if needed.
