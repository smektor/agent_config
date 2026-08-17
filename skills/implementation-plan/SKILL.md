---
name: implementation-plan
description: Researches the current repo for a given feature and writes a persistent implementation-plan document — the reference doc that task-distill and tasks-to-json build tasks from later.
when_to_use: Triggers on "create an implementation plan", "plan this feature", "write an implementation plan for X", "draft a feature plan". Use before task-distill when no prior planning conversation exists yet — this skill produces the durable input task-distill reads instead of relying on session scrollback.
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

Given a feature description, research the current repo and produce a persistent **implementation plan document**. This is the main reference document a feature starts from — coarse-grained (goal, current state, approach, affected areas), not a task list. It is written to disk so it survives past the current session and becomes the input for `task-distill` (which breaks it into small actionable tasks) and, later, `tasks-to-json` (which exports the confirmed tasks).

## Argument resolution

`$ARGUMENTS` is the feature description. If empty, ask the user for it before doing anything else — do not proceed on a guess.

## Output location

`docs/implementation-plans/<slug>.md`

- `slug`: kebab-case, confirmed with the user before writing (e.g. `oauth-login`).
- Create `docs/implementation-plans/` if it doesn't exist.

## Output format

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
List of components/directories/files expected to change or be created, with a one-line reason each. Not full task granularity — that's task-distill's job.

## Out of Scope
What this explicitly does not cover.

## Open Questions / Risks
Anything unresolved that should be flagged before or during implementation.

## Next Step
Run `/task-distill` referencing this document to break it into small actionable tasks.
```

## Steps

1. **Resolve the feature description** from `$ARGUMENTS`; ask the user if missing.
2. **Confirm a kebab-case feature slug** with the user before writing anything (e.g. `oauth-login`).
3. **Explore the repo** for context relevant to the feature:
   - Existing similar features or patterns to build on.
   - Conventions in `CLAUDE.md` / `AGENT.md` if present.
   - Directories and files likely to be affected.
   - Existing test structure/conventions.
   Use Grep/Glob/Read directly — no nested Agent calls needed, this skill already runs isolated via `context: fork`.
4. **Draft the plan document** using the Output Format above, grounded only in what exploration actually found.
5. **Show the drafted plan inline** and confirm with the user before writing to disk.
6. **Write the file**: create `docs/implementation-plans/` if missing, save to `docs/implementation-plans/<slug>.md`.
7. **Report** the saved path, and tell the user they can now run `/task-distill` (having this document read into context) or reference the file path directly to get the granular task list.

## Notes

- Do not invent affected files, patterns, or architecture decisions that exploration didn't actually find — say "no existing pattern found" rather than fabricating one.
- This is a coarse plan, not a task list. Leave task-level granularity (splitting, TDD pairing, priority, model assignment) to `task-distill`.
- Do not write files until the user has confirmed both the slug and the drafted content.
