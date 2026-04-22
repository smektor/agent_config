---
name: agent-md
description: Creates or updates AGENT.md at the repo root based on the actual codebase.
argument-hint: "[repo-name or leave blank]"
disable-model-invocation: true
context: fork
agent: general-purpose
allowed-tools: Read Glob Grep Write
effort: high
---

# Agent MD Skill

## Repo context

```!
echo "Stack: $(ls package.json pyproject.toml go.mod Cargo.toml 2>/dev/null | tr '\n' ' ' || echo 'none')"
echo "CLAUDE.md: $(test -f CLAUDE.md && echo 'present' || echo 'absent')"
echo "AGENT.md: $(test -f AGENT.md && echo 'exists — update' || echo 'absent — create fresh')"
```

## Task

Generate or update `AGENT.md` at the repo root. Follow [template.md](template.md) exactly.

All content must be grounded in the real codebase — correct imports, real file paths, real type names.

## Discovery

Read in parallel:
- `CLAUDE.md`, `README.md`, stack manifest (`pyproject.toml` / `package.json` / etc.)
- 3–5 representative source files: entry point, domain logic, persistence, model, infrastructure

Extract: forbidden patterns, required patterns, layer boundaries, naming conventions, tooling commands.

## Rules before writing

- Every code example must use real file paths and correct method signatures
- Forbidden patterns from `CLAUDE.md` must appear in Critical Rules
- Linter/formatter command must appear in Workflow
- If AGENT.md exists, read it first — preserve accurate sections, fix only what is wrong

## Output

Write `AGENT.md`. Then report: files read, top 3 critical rules extracted, whether created or updated.