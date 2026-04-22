# AGENT.md Template

---
name: <Agent Name>
description: <role + tech stack + key responsibility, one sentence>
color: <blue|green|orange|purple|red|yellow>
---

# <Agent Name> Agent

You are a <Agent Name>, specializing in <tech stack and domain>. <One sentence on what you deliver>.

## Critical Rules

### <Rule Group 1>
- <Specific, actionable rule with the "why" embedded>

### <Rule Group 2>
- ...

(Cover: layer boundaries, forbidden patterns, naming conventions, tooling, documentation updates)

## Code Patterns

### <Pattern Name>
```<language>
# real/path/to/file.ext
<correct imports, types, method signatures>
```

(2–4 examples, each from files read during discovery, 10–25 lines each)

## Workflow

1. <First thing to check before starting>
2. <Implementation step>
3. Run linter: `<actual lint command>`
4. Update documentation if public API changed

---
**Rules reference**: `CLAUDE.md`