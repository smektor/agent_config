---
name: agent-md
description: >
  Creates an AGENT.md file for the current repository, modelled after the agency-agents format
  (https://github.com/msitarzewski/agency-agents). The agent file defines the AI agent's identity,
  mission, critical rules, code examples, workflow process, and success metrics — all grounded in
  the actual codebase, not generic boilerplate.
  Triggers when the user says things like "create AGENT.md", "generate agent file",
  "add an agent definition", or "set up the agent for this repo".
---

# Agent MD Skill

## Purpose

Generate an `AGENT.md` at the repository root that describes how an AI agent should think, behave,
and produce output when working on this specific repository. The file follows the agency-agents
format: YAML frontmatter + personality/mission/rules/deliverables/process/metrics sections.

The result must be grounded in the actual codebase — code examples must match real files, layer
names must reflect the real architecture, and rules must be derived from `CLAUDE.md` (if present).

## Steps

### 1. Discover the repository

Read these sources in parallel:

- `CLAUDE.md` (root) — authoritative rules, conventions, commands, architecture
- `README.md` (root) — user-facing description and setup
- `pyproject.toml` / `package.json` / `Cargo.toml` / `go.mod` — tech stack and dependencies
- Directory listing of `src/` or equivalent — to understand the layer structure

### 2. Read representative source files

Identify and read 3–5 files that best illustrate the architectural patterns:
- Entry point (`main.py`, `index.ts`, `cmd/main.go`, etc.)
- A domain/business logic file (flow, service, handler, controller)
- A persistence/repository file (repository, DAO, store)
- An entity/model file (Pydantic model, TypeScript interface, struct)
- An infrastructure file (DB facade, HTTP client, config loader)

The goal: make code examples in AGENT.md accurate — correct method signatures, correct imports,
correct type names, correct layer boundaries.

### 3. Identify the core patterns to enforce

From `CLAUDE.md` and the source files, extract:
- **Forbidden patterns** (e.g. no `print()`, no direct DB access in controllers, no raw dicts where typed models exist)
- **Required patterns** (e.g. deduplication before insert, UUID primary keys, named loggers)
- **Layer boundaries** (which layer calls which, what must never cross layers)
- **Naming conventions** (snake_case, UPPER_CASE constants, file naming)
- **Tooling requirements** (linter commands to run, migration commands, test commands)
- **Documentation update rules** (when to update CLAUDE.md, README.md)

### 4. Write AGENT.md

Create `AGENT.md` at the repository root using this exact structure:

```markdown
---
name: <Agent Name>
description: <One sentence: role + tech stack + key responsibility>
color: <blue|green|orange|purple|red|yellow>
emoji: <single relevant emoji>
vibe: <One punchy sentence — what this agent does in plain language>
---

# <Agent Name> Agent

You are a **<Agent Name>**, a specialist in <tech stack and domain>. <One sentence on what you deliver>.

## 🧠 Your Identity & Memory
- **Role**: <specialist role>
- **Personality**: <3–4 adjectives that describe how this agent approaches work>
- **Memory**: You remember <2–3 specific failure modes or hard-won lessons from this codebase>
- **Experience**: You've <1–2 concrete past experiences that shaped your instincts>

## 🎯 Your Core Mission

### <Mission Area 1>
- <Bullet: what you do and how>
- ...

### <Mission Area 2>
- ...

(3–5 mission areas total, each with 3–5 bullets)

## 🚨 Critical Rules You Must Follow

### <Rule Group 1>
- <Rule: specific, actionable, with the "why" embedded>
- ...

### <Rule Group 2>
- ...

(Cover: layer boundaries, deduplication/safety, code style, tooling, documentation updates)

## 📋 Your Technical Deliverables

### <Pattern Name> (e.g. "Service with repository injection")
```<language>
# path/to/real/file.py
<accurate code example — correct imports, correct types, correct method signatures>
```

### <Pattern Name 2>
```<language>
<second example>
```

(2–4 examples, each grounded in real files read in Step 2)

## 🔄 Your Workflow Process

### Step 1: <First step name>
- <What to read or check before starting>

### Step 2: <Second step name>
- <What to do>

(4–6 steps ending with: lint/verify + documentation update check)

## 💭 Your Communication Style

- **<Trait>**: "<Example statement this agent makes>"
- ...

(4–6 bullets showing how this agent phrases its output)

## 🔄 Learning & Memory

You learn from:
- <Failure mode 1 specific to this repo>
- <Failure mode 2>
- ...

## 🎯 Your Success Metrics

You're successful when:
- <Measurable outcome 1>
- ...

## 🚀 Advanced Capabilities

### <Advanced topic 1>
- <Bullet>

### <Advanced topic 2>
- <Bullet>

---

**Instructions Reference**: <Where the canonical rules live, e.g. "Architectural rules and conventions are defined in `CLAUDE.md`">
```

### 5. Review before saving

Before writing the file, verify:
- [ ] Every code example uses the correct types, imports, and method signatures from the real files
- [ ] No raw dicts where the codebase uses typed models/entities
- [ ] Layer names match the actual directory structure
- [ ] Forbidden patterns from `CLAUDE.md` appear in Critical Rules
- [ ] The documentation update rule is present in Critical Rules
- [ ] The linter/formatter command appears in the Workflow Process
- [ ] Code example file paths are real paths (not invented)

### 6. Check if AGENT.md already exists

- If `AGENT.md` exists: read it first, then update it rather than overwriting wholesale. Preserve
  sections that are still accurate; fix only what is wrong or missing.
- If it does not exist: create it fresh.

## Notes

- Ground everything in the actual source — read files before writing examples
- The Memory and Learning sections should name specific failure modes observed in this codebase, not generic software wisdom
- Keep code examples short (10–25 lines) — enough to show the pattern, not a full implementation
- If `CLAUDE.md` does not exist, derive rules from the source files and ask the user to confirm the top 3 invariants before writing
- After writing, tell the user what was read and what top 3 rules the AGENT.md enforces, so they can spot anything wrong
