---
name: review-agent
description: Reviews and refactors an AGENT.md file for performance and cost effectiveness.
argument-hint: "[path/to/agent.md]"
disable-model-invocation: true
context: fork
agent: general-purpose
allowed-tools: Read Write
effort: medium
---

# Review Agent Skill

## Task

Review and refactor the agent file at `$ARGUMENTS` for performance and cost effectiveness.
If no path given, look for agent files in `.claude/agents/` and `~/.claude/agents/`.

## Rules to apply

### Frontmatter
- `name` and `description` are required — description must be one sentence, front-loaded with the key use case
- `model` must be set explicitly — never rely on inherit for a custom agent:
  - `haiku` for search/read-only, mechanical tasks
  - `sonnet` for implementation and analysis (default for most agents)
  - `opus` only for deep review or complex multi-step reasoning
- `tools` must be set explicitly — never inherit all tools; grant only what the agent actually needs
- `maxTurns` should be set for any agent that reads files or runs commands — prevents runaway execution
- Remove non-standard fields (`emoji`, `vibe`, and any other fields not in the supported list)
- Supported fields: `name`, `description`, `tools`, `disallowedTools`, `model`, `permissionMode`, `maxTurns`, `skills`, `mcpServers`, `hooks`, `memory`, `background`, `isolation`, `color`

### Body — what to cut
Every line in the body is paid on every turn. Remove:
- Personality adjectives ("creative, detail-oriented") — don't change any decision
- Identity and memory sections — agents have no cross-session memory unless `memory` is configured
- Success metrics — restate rules already present elsewhere
- Communication style sections — reduce to one line if needed at all
- Advanced capabilities sections — describe what the agent can do, not what it should do
- Learning and memory sections — aspirational, not operational
- Scripted opening lines — replace with a rule about how to start
- Anything Claude already knows (standard conventions, generic best practices)

### Body — what to keep and strengthen
- Critical rules — specific, actionable, with the "why" embedded
- Workflow steps — concrete sequence, ending with lint/verify
- Recommendation killers or early checks — high-value, prevents common failure modes
- Scope constraints — what the agent must not do
- Output format — if the agent produces structured output, define the format explicitly

### Code examples
- Must use real file paths from the actual codebase — not invented paths
- Must use correct imports, types, and method signatures
- If examples are generic and not grounded in real files, remove them or flag for the user to replace
- Keep examples to 10–25 lines — enough to show the pattern, not a full implementation

### Supporting files
- Large reference material belongs in supporting files, not the body
- Reference supporting files with a relative link so Claude loads them on demand
- Keep the body under 500 lines

### Honesty constraints (for advisor/conversational agents)
- Verify that uncertainty is surfaced explicitly — the agent should name what it doesn't know
- Verify that recommendations are tied to stated constraints, not presented as universal
- Verify that contradictions in user input are surfaced, not silently resolved

## Output

1. Rewritten agent file
2. List of what was changed and why, referencing the rules above
3. Flag anything requiring human judgement — e.g. code examples that need real file paths, `memory` scope decisions, or whether a section should move to a supporting file