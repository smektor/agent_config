---
name: topic-summary
description: Produces a structured summary of a specific topic discussed during a session (e.g., security, deployment, API design). Captures all options considered, with pros/cons for each, open questions, and a recommended starting point for a future session on the same topic.
when_to_use: Triggers when the user says "summarize this topic", "topic summary", "save this discussion", "summarize security discussion", "summarize deployment options", or any variant like "save what we discussed about X". Also triggers when the user wants to preserve a multi-option technical discussion for future reference.
argument-hint: "<topic-name> [project-name]"
disable-model-invocation: true
allowed-tools: Bash Write Read
effort: medium
---

# Topic Summary Skill

## Session context (auto-detected)

```!
echo "Today's date: $(date +%d-%m-%Y)"
echo "Time: $(date +%H:%M)"
echo "Args provided: ${ARGUMENTS:-not provided}"
echo "Git repo: $(git remote get-url origin 2>/dev/null | sed 's/.*\///' | sed 's/\.git//' || echo 'not a git repo')"
SESSIONS_DIR=~/sessions
echo "Sessions dir: $(test -d $SESSIONS_DIR && echo 'exists' || echo 'will be created')"
if git remote get-url origin &>/dev/null; then
  PROJECT=$(git remote get-url origin | sed 's/.*\///' | sed 's/\.git//')
  echo "Detected project: $PROJECT"
fi
```

## Purpose

During a session, one topic (e.g., security, deployment, API design, caching) is discussed in depth — multiple solutions or approaches are proposed, each with trade-offs. This skill captures that discussion as a standalone reference document so you can:

- Revisit the options and reasoning without re-reading the full session
- Restart a future session from exactly where this one left off
- Avoid re-discovering dead ends or re-litigating settled points

## Argument resolution

`$ARGUMENTS` may contain one or two words:
- First word → **topic slug** (e.g., `security`, `deployment`, `caching`)
- Second word (optional) → **project name override**

If topic is not in `$ARGUMENTS`, ask the user: *"What topic should I label this summary? (e.g., security, deployment, api-design)"*

If project is not in `$ARGUMENTS` and git auto-detection succeeded, use the detected project name without asking.

## Output location

File: `~/sessions/<project>/topic-<topic-slug>-<NN>.md`

- `topic-slug`: kebab-case label for the discussion topic (e.g., `security`, `api-design`, `deployment`)
- `NN`: incremented if a file for the same topic already exists (01, 02, …), so past snapshots are preserved

## Output format

```markdown
# Topic: <Human-Readable Topic Name>

**Project:** <project>
**Date:** <dd-mm-yyyy>
**Context:** one sentence — where in the broader project this topic arose

---

## TL;DR

One paragraph (3–5 sentences) that gives a reader full context with zero prior knowledge:
what problem was being solved, what options were on the table, and what (if anything) was decided.

---

## Options Considered

For each option/solution discussed, one section:

### Option N: <Name>

**What it is:** one sentence description.

**Upsides:**
- point 1
- point 2

**Downsides / Risks:**
- point 1
- point 2

**Verdict:** recommended | rejected | deferred | undecided — and why in one sentence.

---

## Decision / Current Standing

What was agreed, recommended, or left open at the end of the discussion.
If nothing was decided, say so explicitly — "no decision reached, all options still open."

---

## Open Questions

Questions raised but not resolved. Each one is a potential starting point for a future session.

1. Question A — *why it matters*
2. Question B — *why it matters*

---

## Constraints & Assumptions

Technical, business, or time constraints that shaped the discussion.
Assumptions that were made but not verified.

---

## Recommended Starting Point for Next Session

**Goal:** what a follow-up session on this topic should accomplish
**Suggested agent:** which specialized subagent to use (e.g., Security Engineer, Backend Architect, Software Architect)
**Read first:** which section(s) of this file to read before starting
**Key question to answer:** the single most important open question to resolve

---

## Raw Notes

Any additional detail, quotes, links, or references from the discussion that didn't fit above.
Omit this section if there's nothing to add.
```

## Steps

1. **Resolve topic and project** using the argument logic above. If topic is missing, ask the user before proceeding.
2. **Generate TL;DR** — a self-contained paragraph that orients a reader with no memory of the conversation.
3. **Generate Options Considered** — one section per option/approach discussed. Pull upsides and downsides from what was actually said. Do not invent trade-offs not discussed.
4. **Generate Decision / Current Standing** — what was agreed or left open. Be honest if nothing was decided.
5. **Generate Open Questions** — unresolved questions with a note on why each matters.
6. **Generate Constraints & Assumptions** — any constraints or unvalidated assumptions that shaped the discussion.
7. **Generate Recommended Starting Point** — concrete guidance for a future session: goal, agent type, what to read first, key question.
8. **Resolve file path**: check `~/sessions/<project>/` for existing `topic-<slug>-*.md` files, increment NN.
9. **Create directory** `~/sessions/<project>/` if it doesn't exist.
10. **Save the file**.
11. **Print the TL;DR and Options Considered** sections to the conversation so the user sees the key content inline.
12. **Report** the saved file path and the recommended starting point for next time.

## Notes

- Write every section as if the reader has zero memory of this conversation — fully self-contained.
- The **Options Considered** sections are the primary artifact. Each option must stand alone: a reader should understand it without reading the others.
- **Verdicts** are important — if a recommendation was made or an option was rejected, say so clearly and give the reason.
- **Open Questions** prevent the next session from wasting time re-discovering unknowns.
- Do not invent options, trade-offs, or decisions not present in the conversation. Stick strictly to what was discussed.
- If the discussion was exploratory with no conclusions, say so — do not fabricate a decision.
- The **Recommended Starting Point** is the handoff mechanism. Name the agent type from the available list; be specific about the goal.
