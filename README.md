# agent_config

This repository is the source of truth for `~/.claude` — the global Claude Code configuration directory. Clone and symlink (or copy) its contents into `~/.claude` to replicate this setup on any machine.

## Directory structure

```
~/.claude/
├── agents/          # Sub-agent definitions loaded by Claude Code
└── skills/          # Slash-command skills invokable via /skill-name
```

## agents/

Each file defines a named sub-agent that Claude Code can spawn via the `Agent` tool. Agents are markdown files with YAML frontmatter (`name`, `description`, `color`, `emoji`) followed by a system prompt that shapes the agent's identity, capabilities, and workflow.

| Agent | Purpose |
|---|---|
| `engineering-ai-data-remediation-engineer` | Self-healing data pipelines — detects, classifies, and fixes data anomalies |
| `engineering-ai-engineer` | ML model development, deployment, and AI-powered feature integration |
| `engineering-autonomous-optimization-architect` | Shadow-tests APIs for performance while enforcing cost and security guardrails |
| `engineering-backend-architect` | Scalable system design, database architecture, and API development |
| `engineering-code-reviewer` | Constructive code review focused on correctness, maintainability, security |
| `engineering-codebase-onboarding-engineer` | Helps new engineers understand unfamiliar codebases fast |
| `engineering-data-engineer` | Data pipelines, lakehouse architectures, ETL/ELT, and streaming systems |
| `engineering-database-optimizer` | Schema design, query optimization, and indexing strategies |
| `engineering-devops-automator` | Infrastructure automation, CI/CD, and cloud operations |
| `engineering-frontend-developer` | Modern web, React/Vue/Angular, UI implementation, and performance |
| `engineering-git-workflow-master` | Git workflows, branching strategies, and version control best practices |
| `engineering-minimal-change-engineer` | Minimum-viable diffs — fixes only what was asked, resists scope creep |
| `engineering-mobile-app-builder` | Native iOS/Android and cross-platform mobile development |
| `engineering-rapid-prototyper` | Ultra-fast proof-of-concept and MVP creation |
| `engineering-security-engineer` | Threat modeling, vulnerability assessment, and secure code review |
| `engineering-senior-developer` | Laravel/Livewire/FluxUI, advanced CSS, Three.js integration |
| `engineering-software-architect` | System design, DDD, architectural patterns, and technical decision-making |
| `engineering-technical-writer` | Developer documentation, API references, READMEs, and tutorials |

## skills/

Each subdirectory is a skill invokable as a slash command (`/<skill-name>`) inside Claude Code. A skill is driven by a `SKILL.md` file that tells Claude exactly what to do when triggered.

| Skill | Command | Purpose |
|---|---|---|
| `agent-md` | `/agent-md` | Generates or updates `AGENT.md` at a repo root — an AI agent identity file grounded in the actual codebase |
| `session-summary` | `/session-summary` | Produces a structured two-part summary (short + extended) of a research or planning session, saved to `~/sessions/<project>/` as a handoff brief for the next session |
| `task-export` | `/task-export` | Exports planning-session tasks as structured JSON files to `~/tasks/<repo>/` for a consuming agent to implement |

## Installation

```bash
git clone <repo-url> ~/repos/agent_config

# Link agents and skills into ~/.claude
ln -sf ~/repos/agent_config/agents ~/.claude/agents
ln -sf ~/repos/agent_config/skills ~/.claude/skills
```

Or copy instead of symlink if you prefer isolated snapshots.

## Adding a new agent

1. Create `agents/<category>-<role>.md` with YAML frontmatter (`name`, `description`, `color`, `emoji`) and a full system prompt.
2. Commit and push — Claude Code picks up new agent files automatically on next launch.

## Adding a new skill

1. Create `skills/<skill-name>/SKILL.md` with YAML frontmatter (`name`, `description`, `when_to_use`) and step-by-step instructions.
2. Add any supporting files (templates, examples) alongside `SKILL.md`.
3. Commit and push.
