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
      "description": "Create a login page at /login with a 'Sign in with Google' button...",
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
  --body "## Description\n\nCreate a login page..."
```
