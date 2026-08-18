---
name: implementation-plan
description: Researches the current repo for a given feature and writes a persistent implementation plan folder — plan doc, ordered task list, and progress checklist. Fully standalone, no other skill required.
when_to_use: Triggers on "create an implementation plan", "plan this feature", "write an implementation plan for X", "draft a feature plan". Produces everything needed to start and track implementation in one run.
argument-hint: "<feature description>"
disable-model-invocation: true
context: fork
agent: general-purpose
allowed-tools: Read Grep Glob Bash Write
effort: high
---

# Implementation Plan Skill

## Session context (auto-detected)

```!
echo "Today's date: $(date +%d-%m-%Y)"
ORIGIN=$(git remote get-url origin 2>/dev/null)
GIT_PROJECT=$(echo "$ORIGIN" | sed 's/.*\///; s/\.git//')
echo "Git repo: ${GIT_PROJECT:-not a git repo}"
echo "Branch: $(git branch --show-current 2>/dev/null || echo unknown)"
echo "docs/implementation-plans/: $(test -d docs/implementation-plans && echo 'exists' || echo 'will be created')"
```

## Purpose

Given a feature description, research the current repo and produce a persistent, self-contained set of three documents under `docs/implementation-plans/<slug>/`:

- **implementation-plan.md** — the reference doc: goal, current state, approach, affected areas. Coarse-grained, the starting point for everything else.
- **implementation-tasks.md** — the plan broken into small, ordered, actionable tasks.
- **implementation-progress.md** — a simple checklist mirroring the task list, used to track what's done.

This skill does not depend on, call, or hand off to any other skill. Everything — research, planning, and task breakdown — happens in this one run.

## Argument resolution

`$ARGUMENTS` is the feature description. If empty, ask the user for it before doing anything else — do not proceed on a guess.

## Output location

```
docs/implementation-plans/<slug>/
  implementation-plan.md
  implementation-tasks.md
  implementation-progress.md
```

- `slug`: kebab-case, confirmed with the user before writing (e.g. `oauth-login`).
- Create `docs/implementation-plans/` and `docs/implementation-plans/<slug>/` if they don't exist.
- If `docs/implementation-plans/<slug>/` already exists, ask the user whether to regenerate everything from scratch or only update `implementation-tasks.md`/`implementation-progress.md` from new discussion (keeping the existing plan doc). Default to a fresh run when no folder exists yet.

## Output formats

### implementation-plan.md

```markdown
# Implementation Plan — <Feature Name>

**Status:** draft
**Date:** <dd-mm-yyyy>
**Repo:** <repo-name> (branch: <branch>)

## Goal
One paragraph: what this feature does and why it's being built.

## Current State
Relevant existing code, patterns, and conventions found in the repo — with file paths. What already exists that this feature builds on or must integrate with.

## Proposed Approach
The chosen implementation approach and key architecture decisions. Note alternatives only if a real tradeoff was considered.

## Affected Areas
List of components/directories/files expected to change or be created, with a one-line reason each. Not full task granularity — that's implementation-tasks.md's job.

## Out of Scope
What this explicitly does not cover.

## Open Questions / Risks
Anything unresolved that should be flagged before or during implementation.

## Next Step
See `implementation-tasks.md` in this folder for the ordered task list, and `implementation-progress.md` to track progress.
```

### implementation-tasks.md

```markdown
# Implementation Tasks — <Feature Name>

Ordered task list derived from `implementation-plan.md`. Work top to bottom unless a task's "Depends on" says otherwise.

## Tasks

| # | Title | Status | Priority | Model | Depends on |
|---|-------|--------|----------|-------|------------|
| 1 | Short human-readable name | todo | high/medium/low | haiku/sonnet/opus | — or task # |
...

### Task 1 — <Title>
**Status:** todo
**Priority:** high | medium | low
**Model:** haiku | sonnet | opus
**Depends on:** none | Task N
**Description:** [Context line if needed.] [Imperative body: what to implement, with exact project-relative paths and target directories.] [Patterns: see `<file>` for the existing pattern — omit if nothing comparable exists.] Out of scope: [what this task explicitly does NOT include]. Verify: [concrete command to run after implementing and what to confirm].
```

### implementation-progress.md

```markdown
# Implementation Progress — <Feature Name>

Checklist mirrors `implementation-tasks.md` 1:1. Check a box off (`- [x]`) when that task is done. This file is the running status view; `implementation-tasks.md` stays the static reference — don't edit task descriptions here.

- [ ] Task 1 — <title>
- [ ] Task 2 — <title>
...
```

## Steps

1. **Resolve the feature description** from `$ARGUMENTS`; ask the user if missing.
2. **Confirm a kebab-case feature slug** with the user before writing anything (e.g. `oauth-login`).
3. **Check for an existing folder** at `docs/implementation-plans/<slug>/`. If present, ask the user: regenerate everything, or only refresh tasks/progress on top of the existing plan doc.
4. **Explore the repo** for context relevant to the feature:
   - Existing similar features or patterns to build on.
   - Conventions in `CLAUDE.md` / `AGENT.md` if present.
   - Directories and files likely to be affected.
   - Existing test structure/conventions.
   Use Grep/Glob/Read directly — no nested Agent calls needed, this skill already runs isolated via `context: fork`.
   If exploration surfaces ambiguity — multiple plausible integration points, an unclear scope boundary, no existing convention to follow — stop and ask the user directly rather than picking one silently.
5. **Draft implementation-plan.md** using the format above, grounded only in what exploration actually found.
6. **Summarize, then present, then wait.** Give a short (2-4 sentence) plain-language summary of what was found in the repo and the chosen approach, then show the drafted plan inline. Stop and wait for the user's explicit go-ahead — approve, or request changes — before doing anything else. Do not start the task breakdown until the user has responded.
7. **Derive the task list** from the confirmed plan's Affected Areas / Proposed Approach:
   - One task = one concern (one atomic unit of work). Split any task whose title contains "and".
   - Prefer 3–8 tasks. Order infrastructure before features; respect real dependencies via "Depends on".
   - **TDD splitting**: if a task produces a concrete, deterministic artifact (file, function, API endpoint, schema) whose behavior can be asserted without an LLM or heavy integration setup, split it into a test task (writes tests marked skipped/pending, ends description with "All tests must use the framework's skip/pending marker — do not implement the feature.") followed by an implement task that depends on it (description includes "Enable the tests written in the previous task by removing skip/pending markers."). Skip this split for pure config/infra/prompt-authoring tasks or ones already low priority.
   - **Priority**: high = blocks other work; medium = important but not blocking; low = deferred/nice-to-have.
   - **Model**: haiku for a single named file with a clearly bounded change; sonnet for multi-file work or when an existing pattern must be understood first; opus for architectural decisions touching many systems. Default to sonnet when unsure.
   - **Description**: imperative, no "as discussed" references. Exact project-relative paths for every file to create or edit. Name patterns to reuse (`Patterns: see \`<file>\``) if found. State out-of-scope items. End with a concrete `Verify:` command.
8. **Present the task list, then wait.** Show the drafted task list inline and ask if anything should be split, merged, reprioritized, or dropped. Stop and wait for explicit approval — do not write files until the user has confirmed.
9. **Write all three files** under `docs/implementation-plans/<slug>/`, creating the directory if needed. `implementation-progress.md` task titles/order must match `implementation-tasks.md` exactly, all starting unchecked (unless in update mode preserving prior checked state).
10. **Report** the folder path and list the three files written.

## Notes

- **Cooperation is the default mode.** Never silently resolve ambiguity — unclear scope, no matching pattern, unclear priority/model choice — by guessing. Ask the user a direct question instead, at any step, not only at the two confirmation checkpoints.
- Do not invent affected files, patterns, architecture decisions, or tasks that exploration/discussion didn't actually support — say "no existing pattern found" rather than fabricating one.
- The task-splitting/priority/model rules above are intentionally self-contained (not shared with any other skill) so this skill has no cross-skill coupling.
- Do not write any files until the user has confirmed the slug, the drafted plan, and the drafted task list.
