---
name: implement-task
description: Implements exactly one task from an implementation-plan folder's implementation-tasks.md, marks it done in both tasks and progress files, then stops.
when_to_use: Triggers on "implement task", "implement the next task", "do task N", "work on the next task from progress". Requires an existing docs/implementation-plans/<slug>/ folder (produced by the implementation-plan skill).
argument-hint: "[slug] [task number or 'next']"
disable-model-invocation: true
allowed-tools: Read Edit Write Grep Glob Bash
effort: medium
---

# Implement Task Skill

## Purpose

Implement **exactly one task** from `docs/implementation-plans/<slug>/implementation-tasks.md`, then stop. Do not cascade into the next task. The only exception: the user's request explicitly names more than one task (a range, a list, or "all remaining") — in that case implement exactly the tasks named, in order, and no others.

## Argument resolution

`$ARGUMENTS` may contain a slug and/or a task selector (a task number, "next", or an explicit range/list like "1-3" or "1, 2, 4").

- **Slug**: if omitted, look under `docs/implementation-plans/`. If exactly one folder exists, use it. If more than one exists, ask the user which one. If none exist, tell the user to run `implementation-plan` first.
- **Task selector**: if omitted, default to "next" — the first task in `implementation-tasks.md` order whose `implementation-progress.md` checkbox is unchecked. If the user gave a specific number or list, use that instead. Anything beyond a single task number must come from an explicit user instruction, not an assumption.

## Steps

1. **Resolve slug and locate the folder** `docs/implementation-plans/<slug>/`. Read `implementation-tasks.md` and `implementation-progress.md`.
2. **Resolve the target task(s)** per Argument resolution above. If defaulting to "next" and every task is already checked off, report that the task list is complete and stop.
3. **Check dependencies**: read the target task's `Depends on` field. If a dependency task is not checked off in `implementation-progress.md`, warn the user and ask whether to proceed anyway or implement the dependency first — do not silently skip this.
4. **Read the full task block** for the target task from `implementation-tasks.md` (Description, Patterns, Out of scope, Verify).
5. **Implement only what the task describes:**
   - Follow any `Patterns: see <file>` reference — match the existing convention rather than inventing a new one.
   - Touch only the files/paths named or clearly implied by the task description.
   - Respect the task's `Out of scope` line — do not fold in adjacent work, even if tempting or related.
   - If the task is a test-writing task (tests marked skip/pending per `implementation-plan`'s TDD split), write only the tests, all skipped — do not implement the feature.
   - If the task is an implementation task following a test task, enable those tests by removing skip/pending markers as part of the work.
6. **Run the task's `Verify` command.**
   - Pass: mark the task done (step 7) and report success with the verify output/result.
   - Fail: do NOT mark it done. Report the failure clearly and stop — ask the user how to proceed rather than retrying repeatedly or moving to another task.
7. **On success, update both files for this task only:**
   - `implementation-tasks.md`: set `Status` to `done` in both the table row and the per-task block.
   - `implementation-progress.md`: check the box (`- [x]`) for this task.
8. **Report**: which task was implemented, files changed, verify result, and — if more unchecked tasks remain — name the next one without starting it.

## Notes

- Never auto-continue to the next task. Stopping after one task is the default; only an explicit user instruction changes that.
- If `Verify` fails twice in a row while attempting fixes, stop and ask for clarification rather than continuing to retry (per project convention).
- Before writing new code, check whether an existing pattern in the repo already covers the task — the task's `Patterns` line is a hint, not the only place to look.
- Do not edit tasks/progress entries for any task other than the one(s) just implemented.
