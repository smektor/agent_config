---
name: explain-diff-html
description: Generates a rich, interactive standalone HTML explainer for a code change (diff, branch, or PR) — background, intuition, code walkthrough, and an interactive quiz.
when_to_use: Triggers when user asks to "explain this diff/PR/branch", "make an HTML explanation of this change", "write me a walkthrough of this PR", or wants a rich/visual explainer of a code change to read later or share.
argument-hint: "[diff|branch|PR]"
allowed-tools: Bash Read Write Grep Glob
effort: high
---

# Explain Diff (HTML)

## Purpose

Produce a rich, interactive standalone HTML explanation of a specified code change. Reader may know little or nothing about the surrounding system, so the doc builds background, intuition, and a code walkthrough, then checks understanding with a quiz.

## Target resolution

`$ARGUMENTS` may name a diff, branch, or PR. If unset, use the current working diff (`git diff`, or `git diff main...HEAD` if working tree is clean).

## Required sections

1. **Background** — Explain the existing system relevant to this change. Explore surrounding code broadly, not just the diff. Two layers:
   - Deep background for beginners (should be clearly skippable for readers who already know it)
   - Narrow background directly relevant to the change
2. **Intuition** — Core idea behind the change, not full implementation detail. Use concrete toy-data examples. Diagrams liberally.
3. **Code** — High-level walkthrough of the actual changes, grouped/ordered for understandability (not necessarily file order).
4. **Quiz** — Five interactive multiple-choice questions, medium difficulty (require real understanding of the PR, not gotchas). Click an answer → reveal correct/incorrect + explanatory feedback.

## Steps

1. Resolve target per above.
2. Explore surrounding code (not just the diff) to gather Background material.
3. Draft each section per "Required sections".
4. Pick a small, reused set of diagram families rather than inventing new visuals per section — e.g.:
   - Simplified mock of the UI the user sees, for UI-facing changes
   - System/data-flow diagram between components, always with concrete example data flowing through it
5. Assemble as a single self-contained HTML file (inline CSS + JS, no external requests).
6. Save to `/tmp/YYYY-MM-DD-explanation-<slug>.html` (today's date, kebab-case topic slug) — outside the repo, not version-controlled.
7. Report the saved file path to the user.

## Output format rules

- Single HTML file, section headers + table of contents, one long page — no tabs for top-level structure.
- Basic responsive styling (usable on a phone).
- Writing style: engaging, smooth transitions between sections, in the clear expository style of Martin Kleppmann.
- Diagrams: plain HTML/CSS only, never ASCII art.
- Lists: real HTML lists, not prose paragraphs pretending to be lists.
- Code blocks: use `<pre>` tags. If a custom-styled div is used instead, it **must** include `white-space: pre-wrap` in its CSS or the browser will collapse newlines. Before saving, scan every code block in the generated HTML and confirm each has `white-space: pre` or `pre-wrap`.
- Callouts for key concepts/definitions and important edge cases.
