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

## How to distill

Read the full conversation and ask:

1. **What was decided?** — Concrete decisions become tasks.
2. **What was identified as broken or missing?** — Gaps become tasks.
3. **What was deferred or flagged for later?** — These become lower-priority tasks.
4. **What is implicit but necessary?** — Prerequisites or scaffolding that must exist for other tasks to work.

Discard: opinions, exploratory tangents, questions that were answered inline, and anything that did not produce a concrete outcome.

## Task size rules

- One task = one concern. If you find yourself writing "and" in a task title, split it.
- Prefer 3–8 tasks over 1 big one or 20 tiny ones.
- Infrastructure/setup tasks come first (order 1, 2…); feature tasks follow.
- A task touching a single file or function is ideal. A task touching an entire system is too large.

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
**Description:** Self-contained, one-paragraph description of what needs to be done and why. Written as if the implementer has no memory of this session.
```

## Steps

1. **Re-read the session** from the top. Identify every concrete decision, gap, or deferred item.
2. **Draft a raw list** of candidate tasks (internal — do not print this).
3. **Prune and split**: remove duplicates, merge trivially related items, split anything with "and" in the title.
4. **Assign priority**: high = blocks other work or core to the goal; medium = important but not blocking; low = nice-to-have or deferred.
5. **Assign order**: execution order within this session's scope, starting from 1. Infrastructure before features.
6. **Write descriptions**: each description must be fully self-contained — no references to "as discussed" or "as mentioned above". A reader with zero session memory must understand the task.
7. **Print the task table** followed by the per-task detail blocks.
8. **Ask the user** if the list looks right, and whether any tasks should be split, merged, reprioritized, or dropped.

## Notes

- Do not invent tasks that were not discussed. Stick strictly to what emerged from the conversation.
- Do not include tasks for things already completed during the session.
- Write descriptions in the imperative ("Create...", "Add...", "Fix...", "Extract...").
- If the session produced no actionable tasks (e.g., it was pure Q&A), say so explicitly rather than fabricating work.
- After the user confirms the list, mention that they can run `/task-export` to save these as structured JSON files if needed.
