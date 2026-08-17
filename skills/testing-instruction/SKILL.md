---
name: testing-instruction
description: Analyzes the current implementation/diff (or a named feature/task) and writes docs/testing-instructions/<slug>.md — a step-by-step guide for manually testing the change plus low-effort unit/integration/feature test suggestions.
when_to_use: Triggers on "write testing instructions", "how do I test this", "create testing-instruction.md", "document how to test this feature/task". Useful after implementing a feature or finishing an implementation-plan task, before handing off for QA/review.
argument-hint: "[slug or task/feature description]"
disable-model-invocation: true
allowed-tools: Read Grep Glob Bash Write
effort: medium
---

# Testing Instruction Skill

## Purpose

Analyze an implementation (a diff, a plan task, or a described feature) and produce a `testing-instructions` doc explaining how to test it — manual steps plus low-effort automated test suggestions. This skill documents how to test; it does not write or run the tests itself.

## Argument resolution

`$ARGUMENTS` may be empty, a plan slug, or free text describing a feature/task.

- **Empty**: analyze the current change via `git status` and `git diff` (fall back to `git diff HEAD~1` if the working tree is clean) to determine scope.
- **Matches `docs/implementation-plans/<slug>/`**: use that plan's `implementation-tasks.md` (and `implementation-progress.md` for what's done) as the scope instead of raw diff.
- **Free text**: treat it as a feature/task description; locate the relevant code with Grep/Glob.

## Steps

1. **Determine scope** per Argument resolution above. Identify the changed/added files, entry points, and the behavior affected.
2. **Read the changed files** to understand what actually changed: inputs, outputs, edge cases, error paths, side effects.
3. **Find existing test conventions**: locate the test framework and test file locations/naming already used in the repo (Grep for existing `*.test.*`, `*_test.*`, `spec/`, `test/` dirs, config like `jest.config`, `pytest.ini`, etc.). Match these — do not invent a new framework or introduce one that isn't already present.
4. **Draft manual testing steps**: preconditions/setup, numbered actions, expected result after each, and at least one edge case or failure-path check.
5. **Draft automated test suggestions**: a handful of concrete, high-value unit/integration/feature test cases (input → expected output, or given/when/then), written against the framework and file locations found in step 3. Keep it low-effort — not exhaustive coverage, not full test code unless trivial to include.
6. **Write the doc** to `docs/testing-instructions/<slug>.md`. Derive `<slug>` from the plan slug, current branch name, or a short kebab-case description of the feature. Use this structure:
   - `## Scope` — what changed and why (1-2 sentences + file list)
   - `## Manual Testing Steps` — numbered setup + steps + expected results
   - `## Automated Test Suggestions` — proposed test cases with target file paths
   - `## Notes / Edge Cases` — anything risky, untested, or worth flagging
7. **Report** the file path written and a short summary of what's covered.

## Notes

- Read-only analysis plus a single `Write` — do not implement or run the suggested tests as part of this skill.
- If no test framework is detected in the repo, say so explicitly in the doc instead of guessing one.
- If scope is ambiguous (multiple plan folders, no diff, no clear feature match), ask the user rather than guessing.
