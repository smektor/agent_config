# agent_config

This repository is the **staging area and source of truth** for `~/.claude` — the global Claude Code configuration directory. Files are authored and versioned here, then synced into `~/.claude` by running `sync.sh`.

The directory structure mirrors `~/.claude` exactly. Everything except `README.md` and `sync.sh` is destined to land there as-is.

## Directory structure

```
agent_config/        # mirrors ~/.claude/ exactly
├── agents/          # sub-agent definitions
├── skills/          # slash-command skills
├── rules/           # path-scoped authoring rules (applied by Claude Code when editing matched files)
└── CLAUDE.md        # global behavioral instructions for Claude Code
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
| `engineering-project-tech-advisor` | Interactive advisor for new project technology discovery — structured sessions to evaluate options and produce honest recommendations |
| `engineering-rails-developer` | Ruby on Rails full-stack specialist — Rails, Hotwire, Turbo, Stimulus.js, ViewComponent |
| `engineering-senior-developer` | Laravel/Livewire/FluxUI, advanced CSS, Three.js integration |
| `engineering-software-architect` | System design, DDD, architectural patterns, and technical decision-making |
| `engineering-technical-writer` | Developer documentation, API references, READMEs, and tutorials |

## skills/

Each subdirectory is a skill invokable as a slash command (`/<skill-name>`) inside Claude Code. A skill is driven by a `SKILL.md` file that tells Claude exactly what to do when triggered.

| Skill | Command | Purpose |
|---|---|---|
| `agent-md` | `/agent-md` | Generates or updates `AGENT.md` at a repo root — an AI agent identity file grounded in the actual codebase |
| `issues-from-tasks` | `/issues-from-tasks` | Creates GitHub issues from task JSON files in `~/tasks/<repo>/`, one issue per file, using the `gh` CLI |
| `session-summary` | `/session-summary` | Produces a structured two-part summary (short + extended) of a research or planning session, saved to `~/sessions/<project>/` as a handoff brief for the next session |
| `task-distill` | `/task-distill` | Rethinks the session discussion and distills it into a concise, prioritized list of small actionable tasks |
| `tasks-export` | `/tasks-export` | Exports all planning-session tasks as a single JSON file to `~/tasks/<repo>/` for a consuming agent to implement |
| `topic-summary` | `/topic-summary` | Produces a structured summary of a specific topic discussed during a session — options considered, pros/cons, open questions, and a recommended starting point |

## Workflow

Edit files here, commit, then run `sync.sh` to push everything into `~/.claude`:

```bash
./sync.sh
```

The script copies `CLAUDE.md`, `agents/`, `skills/`, and `rules/` to `~/.claude`, creating any missing subdirectories. It only adds/updates — it never deletes files from `~/.claude`.

## rules/

Path-scoped authoring rules that Claude Code loads automatically when editing matched files. Each rule file has a `paths` frontmatter field that targets specific file patterns.

| Rule | Applies to | Purpose |
|---|---|---|
| `rules/agents.md` | `agents/*.md` | Required frontmatter schema and naming conventions for agent files |
| `rules/skills.md` | `skills/*/SKILL.md` | Required frontmatter schema and conventions for skill files |

## Adding a new agent

1. Create `agents/<category>-<role>.md` with YAML frontmatter (`name`, `description`, `color`, `emoji`) and a full system prompt.
2. Commit and push — Claude Code picks up new agent files automatically on next launch.

## Adding a new skill

1. Create `skills/<skill-name>/SKILL.md` with YAML frontmatter (`name`, `description`, `when_to_use`) and step-by-step instructions.
2. Add any supporting files (templates, examples) alongside `SKILL.md`.
3. Commit and push.
