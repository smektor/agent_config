---
name: task-export
description: >
  Use this skill at the end of a research or planning session when the output includes tasks, features, or goals to implement.
  Triggers when the user says things like "save tasks", "export tasks", "create task files", "generate task JSONs",
  "we have our plan, let's save it", or after a planning session produces actionable items.
  Creates one JSON file per task in ~/tasks/<repo_name>/, formatted for consumption by a Claude agent that fetches a repo and implements the task.
---

# Task Export Skill

## Purpose

After a planning or research session, export the resulting tasks as structured JSON files to `~/tasks/<repo_name>/`. Each file is consumed by a Claude agent that implements it. Tasks must be as small as possible and end with a phrase that triggers the appropriate technology skill in the consuming agent.

## Output Format

One file per task: `~/tasks/<repo_name>/<dd-mm-yyyy>-<feature-name>.json`

- `repo_name`: the GitHub repository name (ask user if not mentioned in session)
- `dd-mm-yyyy`: today's date
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

## Steps

1. **Extract tasks** from the current conversation. **Break tasks down as small as possible** — a single task should touch one concern (one component, one endpoint, one model change). If a task feels like it has two steps, split it.
2. **Ask user** for `repo_name` if not mentioned, and confirm the exact technology name for the implement phrase (must match the target skill's trigger).
3. **Clarify** priority and order if ambiguous.
4. **For each task**, construct the JSON object:
   - `feature_name`: kebab-case identifier
   - `title`: concise human-readable label
   - `description`: self-contained prompt ending with `Implement according to skill for <language/framework/technology>.`
   - `priority`: high / medium / low
   - `order`: integer, execution order within the feature (1 = first)
5. **Create directory** `~/tasks/<repo_name>/` if it doesn't exist.
6. **Save files** to `~/tasks/<repo_name>/<dd-mm-yyyy>-<feature-name>.json`.
7. **Confirm** to the user which files were created, with a summary table.

## Example

Repo: `my-app`, date: 17-04-2026, tech: Next.js

File: `~/tasks/my-app/17-04-2026-oauth-login-page.json`
```json
{
  "feature_name": "oauth-login-page",
  "title": "Add OAuth Login Page",
  "description": "Create a login page at /login with a 'Sign in with Google' button. Use Next.js 14 App Router. The button should redirect to the OAuth provider. No session logic in this task. Implement according to skill for Next.js.",
  "priority": "high",
  "order": 1
}
```

File: `~/tasks/my-app/17-04-2026-oauth-callback.json`
```json
{
  "feature_name": "oauth-callback",
  "title": "Handle OAuth Callback",
  "description": "Add an API route at /api/auth/callback that receives the OAuth code, exchanges it for a token, and stores the session in an httpOnly cookie. Use the existing User model in /models/user.ts to persist the user record. Implement according to skill for Next.js.",
  "priority": "high",
  "order": 2
}
```

## Notes

- The `Implement according to skill for <X>` phrase at the end of every description is mandatory — it triggers the appropriate technology skill in the consuming agent.
- Be consistent with the technology name — it must match the trigger phrase of the target skill exactly.
- Write `description` as if the agent has no memory of this session — fully self-contained.
- Do not invent tasks not discussed in the session. Ask the user to confirm the list before writing files.
