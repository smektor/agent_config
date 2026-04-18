---
paths:
  - "skills/*/SKILL.md"
---

# Skill File Rules

Each skill lives in `skills/<skill-name>/SKILL.md`. Required frontmatter fields:

```yaml
---
name: skill-name              # matches the directory name, kebab-case
description: What it does and when to use it — Claude reads this to decide when to invoke
when_to_use: Trigger phrases and example user requests
argument-hint: "[arg]"        # shown in autocomplete, omit if no args
disable-model-invocation: true  # set true for manual-only skills (side effects, deploys)
allowed-tools: Bash Read Write  # space-separated, pre-approved without prompting
effort: low | medium | high
context: fork                 # set to run in an isolated subagent
agent: general-purpose        # which subagent type when context: fork is set
---
```

- `name` must match the directory name exactly
- `description` + `when_to_use` are truncated at 1,536 chars — front-load the key use case
- Keep `SKILL.md` under 500 lines; move reference material to supporting files in the same directory
- Use `disable-model-invocation: true` for any skill with side effects the user should control
