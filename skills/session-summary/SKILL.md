---
name: session-summary
description: Saves a structured session summary and handoff brief to ~/sessions/<project>/.
when_to_use: Triggers when the user says "session summary", "save the session", "end of session", "summarize what we did", "write a handoff", or any variant asking to capture or save the current session's work and decisions.
argument-hint: "[project-name]"
disable-model-invocation: true
context: fork
allowed-tools: Bash Write Read
effort: low
---

# Session Summary Skill

## Session context (auto-detected)

```!
echo "Today's date: $(date +%d-%m-%Y)"
echo "Time: $(date +%H:%M)"
echo "Project from args: ${ARGUMENTS:-not provided}"
ORIGIN=$(git remote get-url origin 2>/dev/null)
GIT_PROJECT=$(echo "$ORIGIN" | sed 's/.*\///; s/\.git//')
echo "Git repo: ${GIT_PROJECT:-not a git repo}"
PROJECT="${ARGUMENTS:-$GIT_PROJECT}"
if [ -n "$PROJECT" ]; then
  PREV=$(ls ~/sessions/$PROJECT/*.md 2>/dev/null | sort | tail -1)
  echo "Previous session: ${PREV:-none}"
fi
```

## Purpose

After a working session, key decisions, findings, and open questions are scattered across the conversation. This skill captures them as a standalone handoff document so the next session can start with full context and avoid re-discovering dead ends. It produces a dense short summary for quick review and extended notes for when detail matters.

## Argument resolution

`$ARGUMENTS` may contain a project name override.

- If `$ARGUMENTS` is set → use it as the project name.
- If not set and git auto-detection succeeded → use the detected name without asking.
- If both fail → ask the user for the project name.

Topic slug: always confirm a kebab-case label with the user before writing (e.g., `auth-deep-dive`, `db-schema-review`).

## Output location

File: `~/sessions/<project>/session-NN-<topic>.md`

- `NN`: increment from the last existing session number in `~/sessions/<project>/`; start at `01` if none.
- `topic`: the confirmed kebab-case slug.

## Output format

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

1. Question A — *why it matters*
2. Question B — *why it matters*

---

## Recommended Next Session

**Focus:** what the next session should tackle
**Suggested agent:** which specialized subagent type (e.g., Software Architect, Backend Architect, Security Engineer, Explore)
**Input:** which parts of this file the next session should read first

---

## Extended Notes

### What was explored

### What was ruled out (and why)

### Findings in detail

### Constraints and assumptions
```

## Steps

1. **Resolve project name** using the argument logic above.
2. **Confirm topic slug** with the user before proceeding.
3. **Read previous session's Open Questions** if a previous file was detected — note which carried over vs. which are new.
4. **Generate Short Summary** — ≤7 bullets dense with signal, plus one "Key decision / insight" sentence.
5. **Generate Open Questions** — unresolved questions with *why each matters*.
6. **Generate Recommended Next Session** — concrete focus, agent type, and what to read first.
7. **Generate Extended Notes** — what was explored, what was ruled out, findings in detail, constraints.
8. **Create** `~/sessions/<project>/` if it doesn't exist, then save the file.
9. **Print the Short Summary inline** so the user sees it without opening the file. Report the saved path.

## Notes

- Write every section as if the reader has zero memory of this conversation — fully self-contained.
- Do not invent findings, decisions, or questions not discussed in the session.
- If the session was pure research with no decisions, say so explicitly — do not fabricate conclusions.
- Open Questions prevent the next session from wasting time re-discovering unknowns — include *why each matters*.
