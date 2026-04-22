---
name: session-summary
description: Saves a structured session summary and handoff brief to ~/sessions/<project>/.
argument-hint: "[project-name]"
disable-model-invocation: true
context: fork
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

## Task

Produce a two-part session summary and save to `~/sessions/<project>/session-NN-<topic>.md`. Follow [template.md](template.md).

## Resolution

- **Project:** use `$ARGUMENTS` if set; else confirm the git-detected name with the user; else ask.
- **Session number:** increment the last `NN` in `~/sessions/<project>/`; start at `01` if none.
- **Topic slug:** confirm a kebab-case label with the user (e.g. `auth-deep-dive`).

## Rules

- If a previous session file was detected, read its Open Questions before generating — note what carried over vs. what is new.
- Write every section as if the reader has zero memory of this conversation — fully self-contained.
- Short Summary: ≤7 bullets, dense with signal. Include one "Key decision / insight" sentence.
- Open Questions: list unresolved questions with *why each matters*. Explicit unknowns prevent the next session re-discovering them.
- Recommended Next Session: name a specific agent type from the available list, not a vague direction.
- Do not invent findings not discussed. If the session was pure research with no decisions, say so.
- Create `~/sessions/<project>/` if it doesn't exist, then save the file.
- Print the Short Summary inline so the user sees it without opening the file. Report the saved path.
