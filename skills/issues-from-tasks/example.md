# Example

Tasks file: `~/tasks/my-app/19-04-2026-tasks.json`
```json
{
  "repo": "my-app",
  "exported_at": "19-04-2026",
  "tasks": [
    {
      "feature_name": "oauth-login-page",
      "title": "Add OAuth Login Page",
      "model": "haiku",
      "description": "Create `pages/login.tsx` with a 'Sign in with Google' button that links to `/api/auth/google`. Use Next.js 14 App Router. Patterns: see `pages/signup.tsx` for the button pattern. Out of scope: do not implement the OAuth callback — that is a separate task. Verify: run `npx next build` and confirm no type errors.",
      "priority": "high",
      "order": 1,
      "depends_on": []
    }
  ]
}
```

Command run:
```bash
gh issue create \
  --repo wedlu/my-app \
  --title "Add OAuth Login Page" \
  --body "## Description\n\nCreate \`pages/login.tsx\` with a 'Sign in with Google' button...\n\n---\n\n**Feature:** \`oauth-login-page\`\n**Model:** haiku\n**Priority:** high\n**Order:** 1\n**Source file:** \`~/tasks/my-app/19-04-2026-tasks.json\`"
```
