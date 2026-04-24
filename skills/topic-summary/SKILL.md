---
name: topic-summary
description: Produces a structured summary of a specific topic discussed during a session (e.g., security, deployment, API design). Captures all options considered, with pros/cons for each, open questions, and a recommended starting point for a future session on the same topic.
when_to_use: Triggers when the user says "summarize this topic", "topic summary", "save this discussion", "summarize security discussion", "summarize deployment options", or any variant like "save what we discussed about X". Also triggers when the user wants to preserve a multi-option technical discussion for future reference.
argument-hint: "<topic-name> [project-name]"
disable-model-invocation: true
context: fork
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

During a session, one topic (e.g., security, deployment, API design, caching) is discussed in depth — multiple solutions or approaches are proposed, each with trade-offs. This skill captures that discussion as a standalone reference document so you can revisit the options and reasoning without re-reading the full session, restart a future session from exactly where this one left off, and avoid re-discovering dead ends.

## Argument resolution

`$ARGUMENTS` may contain one or two words:
- First word → **topic slug** (e.g., `security`, `deployment`, `caching`)
- Second word (optional) → **project name override**

If topic is not in `$ARGUMENTS`, ask the user: *"What topic should I label this summary? (e.g., security, deployment, api-design)"*

If project is not in `$ARGUMENTS` and git auto-detection succeeded, use the detected project name without asking.

## Output location

File: `~/sessions/<project>/topic-<topic-slug>-<NN>.md`

- `topic-slug`: kebab-case label for the discussion topic
- `NN`: incremented if a file for the same topic already exists (01, 02, …), so past snapshots are preserved

## Steps

1. **Resolve topic and project** using the argument logic above. If topic is missing, ask the user before proceeding.
2. **Read `./template.md`** then generate all sections for this session, filling in each section from the conversation. Do not invent options, trade-offs, or decisions not present in the conversation.
3. **Resolve file path**: check `~/sessions/<project>/` for existing `topic-<slug>-*.md` files, increment NN.
4. **Create directory** `~/sessions/<project>/` if it doesn't exist.
5. **Save the file**.
6. **Print the TL;DR and Options Considered** sections inline so the user sees the key content without opening the file.
7. **Report** the saved file path and the recommended starting point for next time.

## Notes

- Do not invent options, trade-offs, or decisions not present in the conversation.
- If the discussion was exploratory with no conclusions, say so — do not fabricate a decision.
- The **Recommended Starting Point** is the handoff mechanism. Name the agent type from the available list; be specific about the goal.
