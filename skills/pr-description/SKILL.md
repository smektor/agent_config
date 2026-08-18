---
name: pr-description
description: Generates a short, descriptive Pull Request description from the diff between the current branch and main/master (or a specified branch/diff file).
when_to_use: Triggers on "write a PR description", "generate PR description", "describe this diff for a PR", "summarize this branch's changes for a pull request".
argument-hint: "[branch|diff-file]"
allowed-tools: Bash Read Grep
effort: medium
---

# PR Description

## Purpose

Produce a short, descriptive Pull Request description from a code change. Optimize for brevity — a reviewer should understand the change from the summary alone, with per-file detail only when the diff is large enough to need it.

## Target resolution

`$ARGUMENTS` may be empty, an existing file path, or a branch name.

1. **Empty** — detect the base branch: `git show-ref --verify --quiet refs/heads/main` → `main`, else check for `master`. Diff the current branch against it: `git diff <base>...HEAD` (three-dot/merge-base diff — this is what a PR actually shows, not uncommitted working-tree changes).
2. **Existing file path** — read it directly as a unified diff; use its contents as-is.
3. **Branch name** — diff the detected base branch against the named branch: `git diff <base>...<branch>`.
4. If neither `main` nor `master` exists as a local branch, stop and ask the user which branch to use as the base — don't guess.

## Steps

1. Resolve target per above.
2. `git diff --stat <base>...<target>` for the file list and change volume.
3. Full `git diff <base>...<target>` for content. If commits exist on the branch, `git log <base>..<target> --oneline` can help infer intent/why.
4. Classify each changed file from its actual hunks (not filename guessing):
   - **Cosmetic-only**: whitespace/formatting/import-reordering, lockfiles, generated files — no behavior change.
   - **Substantive**: real logic/behavior/API/content changes.
5. Draft the description:
   - Always open with 1–3 tight sentences: what changed and, if inferable, why. Never pad with "this PR changes N files."
   - Small diff or few substantive files: the summary alone is the whole description — stop there.
   - Large diff (roughly more than 5 substantive files, or otherwise clearly too much for one summary): add a bullet list below the summary, one or two sentences per *substantive* file only. Skip cosmetic-only files entirely — don't list them, don't mention them.
6. Output the finished description as a markdown block in the chat response, ready to paste into a PR. Do not save it to a file and do not run `gh` commands against it.

## Output format rules

- No title, no "## Summary" headers unless the bullet list is present (in which case a bare summary paragraph followed by a plain bullet list is enough — no extra section labels needed).
- No filler phrasing ("this change", "in order to", "various improvements").
- File bullets: `path` — one or two sentences on what changed and its effect, not a restatement of the diff.
