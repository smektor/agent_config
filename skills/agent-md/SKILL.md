---
name: agent-md
description: Creates or updates AGENT.md at the repo root — an AI agent identity file grounded in the actual codebase (architecture, rules, code examples). Follows the agency-agents format with personality, mission, critical rules, deliverables, and workflow sections.
when_to_use: Triggers when the user says "create AGENT.md", "generate agent file", "add an agent definition", "set up the agent for this repo", or "update AGENT.md".
argument-hint: "[repo-name or leave blank]"
disable-model-invocation: true
context: fork
agent: general-purpose
allowed-tools: Read Glob Grep Write
effort: high
---

# Agent MD Skill

## Repo context (auto-detected)

```!
echo "Stack files present: $(ls package.json pyproject.toml go.mod Cargo.toml 2>/dev/null | tr '\n' ' ' || echo 'none detected')"
echo "CLAUDE.md: $(test -f CLAUDE.md && echo 'present' || echo 'absent')"
echo "README.md: $(test -f README.md && echo 'present' || echo 'absent')"
echo "AGENT.md: $(test -f AGENT.md && echo 'EXISTS — read it first, then update' || echo 'does not exist — create fresh')"
echo "src/ dir: $(test -d src && echo 'present' || echo 'absent')"
```

## Purpose

Generate `AGENT.md` at the repository root describing how an AI agent should think, behave, and produce output for this specific repository. Every section must be grounded in the actual codebase — code examples must use real file paths, real imports, and real type names.

See [template.md](template.md) for the exact output structure.

## Step 1: Discover the repository

Read these sources in parallel:

- `CLAUDE.md` (root) — authoritative rules, conventions, commands, architecture
- `README.md` (root) — user-facing description and setup
- `pyproject.toml` / `package.json` / `Cargo.toml` / `go.mod` — tech stack and dependencies
- Directory listing of `src/` or equivalent — to understand the layer structure

## Step 2: Read representative source files

Identify and read 3–5 files that best illustrate the architectural patterns:

- Entry point (`main.py`, `index.ts`, `cmd/main.go`, etc.)
- A domain/business logic file (flow, service, handler, controller)
- A persistence/repository file (repository, DAO, store)
- An entity/model file (Pydantic model, TypeScript interface, struct)
- An infrastructure file (DB facade, HTTP client, config loader)

Goal: make code examples in AGENT.md accurate — correct method signatures, correct imports, correct type names.

## Step 3: Identify the core patterns to enforce

From `CLAUDE.md` and the source files, extract:

- **Forbidden patterns** (e.g. no `print()`, no direct DB access in controllers)
- **Required patterns** (e.g. deduplication before insert, UUID primary keys, named loggers)
- **Layer boundaries** (which layer calls which, what must never cross layers)
- **Naming conventions** (snake_case, UPPER_CASE constants, file naming)
- **Tooling requirements** (linter commands, migration commands, test commands)
- **Documentation update rules** (when to update CLAUDE.md, README.md)

## Step 4: Check AGENT.md status (already detected above)

- If AGENT.md **exists**: read it first, then update — preserve accurate sections, fix only what is wrong or missing.
- If AGENT.md **does not exist**: create it fresh using [template.md](template.md).

## Step 5: Verify before writing

Before writing the file, confirm:

- [ ] Every code example uses correct types, imports, and method signatures from real files
- [ ] No raw dicts where the codebase uses typed models/entities
- [ ] Layer names match the actual directory structure
- [ ] Forbidden patterns from `CLAUDE.md` appear in Critical Rules
- [ ] The documentation update rule is present in Critical Rules
- [ ] The linter/formatter command appears in Workflow Process
- [ ] All code example file paths are real paths (not invented)

## Step 6: Write AGENT.md

Write `AGENT.md` to the repository root. Follow the structure in [template.md](template.md) exactly.

## Step 7: Report back

After writing, tell the user:

1. Which files were read during discovery
2. The top 3 critical rules the AGENT.md enforces (so they can spot anything wrong)
3. Whether this was a fresh create or an update

## Notes

- If `CLAUDE.md` does not exist, derive rules from source files and ask the user to confirm the top 3 invariants before writing.
- Memory and Learning sections must name specific failure modes from this codebase, not generic software wisdom.
- Keep code examples short (10–25 lines) — enough to show the pattern, not a full implementation.
