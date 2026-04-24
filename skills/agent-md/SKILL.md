---
name: agent-md
description: Creates or updates AGENT.md at the repo root based on the actual codebase.
argument-hint: "[repo-name or leave blank]"
disable-model-invocation: true
context: fork
agent: general-purpose
allowed-tools: Read Glob Grep Write Bash
effort: high
---

# Agent MD Skill

## Repo context

```!
echo "Stack: $(ls package.json pyproject.toml go.mod Cargo.toml requirements.txt Gemfile 2>/dev/null | tr '\n' ' ' || echo 'none')"
echo "CLAUDE.md: $(test -f CLAUDE.md && echo 'present' || echo 'absent')"
echo "AGENT.md: $(test -f AGENT.md && echo 'exists — update' || echo 'absent — create fresh')"
echo "Source dirs: $(ls -d src lib app cmd internal 2>/dev/null | tr '\n' ' ' || echo 'none detected')"
```

## Task

Generate or update `AGENT.md` at the repo root. Follow [template.md](template.md) exactly.

All content must be grounded in the real codebase — correct imports, real file paths, real type names.

## Discovery

1. Use Glob to list top-level dirs (`src/`, `lib/`, `app/`, `cmd/`) — pick 3–5 representative files
2. Read in parallel: `CLAUDE.md` (forbidden/required patterns), `README.md` (domain overview), stack manifest
3. Read chosen source files: prioritise entry point, one domain model, one persistence/infra file
4. Extract: forbidden patterns → Critical Rules; lint command → Workflow step 3; layer names → rule groups

## Rules before writing

- Every code example must use real file paths and correct method signatures (verify with Glob/Grep before writing)
- Forbidden patterns from `CLAUDE.md` must appear in Critical Rules
- Linter/formatter command must appear in Workflow
- If AGENT.md exists, read it first — preserve accurate sections, fix only what is wrong

## Edge cases

- No `CLAUDE.md`: write Critical Rules from code patterns alone; add a note in the generated file
- No stack manifest detected: infer stack from source file extensions
- AGENT.md exists but structurally malformed: rewrite from scratch following template

## Output

Write `AGENT.md`. Then output a short report covering:
- Files read (list)
- Top 3 critical rules extracted and their source
- Whether AGENT.md was created or updated
- Any sections skipped and why (e.g. "no CLAUDE.md found")