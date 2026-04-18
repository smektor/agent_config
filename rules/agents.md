---
paths:
  - "agents/*.md"
---

# Agent File Rules

Agent files live in `agents/<category>-<role>.md`. Required YAML frontmatter:

```yaml
---
name: Display Name
description: One-sentence description — Claude uses this to decide when to delegate
color: blue        # UI accent color (blue, green, red, purple, orange, yellow, pink, gray)
emoji: 🤖          # UI icon
vibe: Short punchy tagline.
---
```

- `name`: human-readable display name
- `description`: used by Claude to match tasks to this agent — be specific about domain and capabilities
- Naming convention: `<category>-<role>.md` in kebab-case (e.g. `engineering-backend-architect.md`)
- The markdown body after frontmatter is the agent's full system prompt
