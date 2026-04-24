# Hook Setup — Quick Example

User says: *"Run tests and lint automatically after every task."*

Stack detected: Node.js with `npm test` and `npm run lint` scripts.

Hook written to `.claude/settings.json`:
```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "*",
        "hooks": [{ "type": "command", "command": "npm test && npm run lint", "timeout": 60 }]
      }
    ]
  }
}
```

CLAUDE.md entry added:
```
## Automated Hooks

Tests and linting run automatically via a Stop hook. Do not run `npm test` or `npm run lint` manually unless explicitly asked.
```
