---
name: task-export
description: Exports tasks from the current planning session as structured JSON files to ~/tasks/<repo_name>/, one file per task, formatted for a Claude agent to implement.
when_to_use: Triggers when the user says "save tasks", "export tasks", "create task files", "generate task JSONs", "we have our plan, let's save it", or after a planning session produces actionable items.
argument-hint: "[repo-name]"
disable-model-invocation: true
allowed-tools: Bash Write
effort: medium
---

# Task Export Skill

## Session context (auto-detected)

```!
echo "Today's date: $(date +%d-%m-%Y)"
echo "Git repo name: $(git remote get-url origin 2>/dev/null | sed 's/.*\///' | sed 's/\.git//' || echo 'unknown — ask user')"
echo "~/tasks/ dir: $(test -d ~/tasks && echo 'exists' || echo 'will be created')"
echo "AGENT.md: $(test -f AGENT.md && echo 'present — consuming agent will follow it' || echo 'ABSENT — recommend running /agent-md first')"
```

## Purpose

After a planning or research session, export the resulting tasks as structured JSON files to `~/tasks/<repo_name>/`. Each file is consumed by a Claude agent that implements it. Tasks must be as small as possible and end with a phrase that triggers the appropriate technology skill in the consuming agent.

## Repo name resolution

- If `$ARGUMENTS` is provided, use it as `repo_name`.
- If git auto-detection succeeded above, confirm it with the user before proceeding.
- If both are unavailable, ask the user.

## Output Format

One file per task: `~/tasks/<repo_name>/<dd-mm-yyyy>-<feature-name>.json`

- `repo_name`: the GitHub repository name
- `dd-mm-yyyy`: today's date (auto-detected above)
- `feature-name`: kebab-case task identifier

```json
{
  "feature_name": "string (kebab-case, matches filename suffix)",
  "title": "string (short human-readable name)",
  "description": "string (self-contained agent prompt ending with the implement phrase)",
  "priority": "high | medium | low",
  "order": "number (execution order within this feature, starting from 1)"
}
```

## Closing phrase (added to every task description)

Each task `description` must end with one of these phrases. The consuming agent checks at **run time** — do not try to resolve this at export time.

| Situation | Closing phrase |
|---|---|
| Default (most tasks) | `Follow AGENT.md if present in the repository root; otherwise apply standard conventions.` |
| Specific subagent override | `Use the @<agent-name> agent defined in .claude/agents/.` |
| No agent guidelines | `Implement without following any predefined agent guidelines.` |

Use the default for every task unless the user explicitly specifies an override for a particular task during confirmation.

## Steps

1. **Extract tasks** from the current conversation. **Break tasks down as small as possible** — a single task should touch one concern (one component, one endpoint, one model change). If a task feels like it has two steps, split it.
2. **Resolve repo_name** using the logic above.
3. **Clarify** priority and order if ambiguous.
4. **Confirm the task list** with the user before writing any files. For each task, note the closing phrase that will be used (default or override). This is the moment for the user to specify per-task overrides.
5. **For each task**, construct the JSON object:
   - `feature_name`: kebab-case identifier
   - `title`: concise human-readable label
   - `description`: self-contained prompt ending with the appropriate closing phrase from the table above
   - `priority`: high / medium / low
   - `order`: integer, execution order within the feature (1 = first)
6. **Create directory** `~/tasks/<repo_name>/` if it doesn't exist.
7. **Save files** to `~/tasks/<repo_name>/<dd-mm-yyyy>-<feature-name>.json`.
8. **Confirm** to the user which files were created, with a summary table. If AGENT.md was absent (detected above), add a warning: *"No AGENT.md found in this repo — tasks will fall back to standard conventions. Consider running /agent-md first."*

## Example

Repo: `my-app`, date: 17-04-2026, tech: Next.js

File: `~/tasks/my-app/17-04-2026-oauth-login-page.json`
```json
{
  "feature_name": "oauth-login-page",
  "title": "Add OAuth Login Page",
  "description": "Create a login page at /login with a 'Sign in with Google' button. Use Next.js 14 App Router. The button should redirect to the OAuth provider. No session logic in this task. Follow AGENT.md if present in the repository root; otherwise apply standard conventions.",
  "priority": "high",
  "order": 1
}
```

File: `~/tasks/my-app/17-04-2026-oauth-callback.json`
```json
{
  "feature_name": "oauth-callback",
  "title": "Handle OAuth Callback",
  "description": "Add an API route at /api/auth/callback that receives the OAuth code, exchanges it for a token, and stores the session in an httpOnly cookie. Use the existing User model in /models/user.ts to persist the user record. Follow AGENT.md if present in the repository root; otherwise apply standard conventions.",
  "priority": "high",
  "order": 2
}
```

## Notes

- The closing phrase at the end of every description is mandatory — it tells the consuming agent which guidelines to follow.
- The consuming agent resolves AGENT.md at **run time** in the target repo — do not try to check for it at export time unless you are currently inside the target repo.
- Write `description` as if the agent has no memory of this session — fully self-contained.
- Do not invent tasks not discussed in the session. Always confirm the list with the user before writing files.
