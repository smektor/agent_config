---
name: session-summary
description: Produces a structured summary of the current research or planning session, saves it to ~/sessions/<project>/, and prepares a handoff brief for the next session.
when_to_use: Triggers when the user says "summarize this session", "session summary", "save session", "wrap up", or "prepare handoff". Also triggers at the end of any research, exploration, or planning session when the user asks for a rich summary.
argument-hint: "[project-name]"
disable-model-invocation: true
allowed-tools: Bash Write Read
effort: medium
---

# Session Summary Skill

## Session context (auto-detected)

```!
echo "Today's date: $(date +%d-%m-%Y)"
echo "Time: $(date +%H:%M)"
echo "Project from args: ${ARGUMENTS:-not provided}"
echo "Git repo: $(git remote get-url origin 2>/dev/null | sed 's/.*\///' | sed 's/\.git//' || echo 'not a git repo')"
SESSIONS_DIR=~/sessions
echo "Sessions dir: $(test -d $SESSIONS_DIR && echo 'exists' || echo 'will be created')"
if [ -n "$ARGUMENTS" ]; then
  PROJECT="$ARGUMENTS"
elif git remote get-url origin &>/dev/null; then
  PROJECT=$(git remote get-url origin | sed 's/.*\///' | sed 's/\.git//')
fi
if [ -n "$PROJECT" ]; then
  PREV=$(ls ~/sessions/$PROJECT/*.md 2>/dev/null | sort | tail -1)
  echo "Previous session: ${PREV:-none}"
fi
```

## Purpose

At the end of a research, exploration, or planning session, produce a two-part summary:

1. **Short summary** — the essential findings in ≤7 bullets. A reader should understand the session's value in 30 seconds.
2. **Extended notes** — full detail: what was explored, what was ruled out, open questions, and a recommended handoff for the next session.

Save to `~/sessions/<project>/session-NN-<topic>.md`. Each file becomes the input brief for the next session.

## Project name resolution

- If `$ARGUMENTS` is provided, use it as `project`.
- Else if git auto-detection succeeded, confirm it with the user.
- Else ask the user.

## Session number resolution

- List existing files in `~/sessions/<project>/` and increment the last session number.
- If no prior sessions exist, start at `01`.

## Previous session (if any)

If a previous session file was detected above, read its **Handoff Brief** section and include it in context before generating the summary. This ensures continuity — note what was carried over vs. what is new.

## Output format

File: `~/sessions/<project>/session-NN-<topic>.md`

- `NN`: zero-padded session number (01, 02, …)
- `topic`: kebab-case label for the session's main theme (e.g., `architecture-options`, `auth-deep-dive`)

```markdown
# Session NN — <Human-Readable Topic>

**Project:** <project>
**Date:** <dd-mm-yyyy>
**Session type:** research | exploration | planning | deep-dive
**Carried over from:** Session NN-1 — <prior topic>, or "none"

---

## Short Summary

> One sentence: what this session was fundamentally about.

- Finding 1
- Finding 2
- Finding 3
- Finding 4 (max 7 bullets total)

**Key decision / insight:** one sentence — the single most important thing learned.

---

## Open Questions

Questions that were raised but not resolved. These drive the next session.

1. Question A — *why it matters*
2. Question B — *why it matters*

---

## Recommended Next Session

**Focus:** what the next session should tackle
**Suggested agent:** which specialized subagent type to use (e.g., Software Architect, Backend Architect, Security Engineer, Explore)
**Input:** which parts of this file the next session should read first

---

## Extended Notes

### What was explored

Detailed narrative of the session — topics covered, options considered, sources consulted.

### What was ruled out (and why)

Explicitly record dead ends. This prevents revisiting them.

### Findings in detail

Expand each Short Summary bullet with full reasoning, evidence, or references.

### Constraints and assumptions

Any constraints discovered (technical, business, time) or assumptions made that should be validated.
```

## Steps

1. **Read previous session** if detected — extract its Handoff Brief or Open Questions to inform continuity.
2. **Generate Short Summary** from the current conversation: extract key findings, decisions, and the single most important insight.
3. **Generate Open Questions**: what was raised but not answered. Be honest — unresolved is valuable signal.
4. **Generate Recommended Next Session**: suggest focus, agent type, and which parts of this file to read first.
5. **Generate Extended Notes**: narrative of what was explored, what was ruled out, and full reasoning behind each finding.
6. **Resolve project name and session number** using the logic above.
7. **Confirm topic slug** with the user (one word or short phrase describing this session's theme).
8. **Create directory** `~/sessions/<project>/` if it doesn't exist.
9. **Save the file**.
10. **Print the Short Summary** to the conversation so the user sees it inline without opening the file.
11. **Report** the file path and note the recommended next session.

## Notes

- Write every section as if the reader has zero memory of this conversation — fully self-contained.
- The **Short Summary** is the primary artifact. Make it dense with signal, not filler.
- **Open Questions** are as important as findings. Explicit unknowns prevent the next session from wasting time re-discovering them.
- Do not invent findings not discussed. Stick strictly to what happened in the conversation.
- If the session was pure research with no decisions, say so — do not fabricate conclusions.
- The **Recommended Next Session** section is the handoff mechanism. Be specific: name the agent type from the available list, not a vague direction.
