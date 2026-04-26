# agent_config

This repository is the **staging area and source of truth** for `~/.claude` — the global Claude Code configuration directory. Files are authored and versioned here, then synced into `~/.claude` by running `sync.sh`.

The directory structure mirrors `~/.claude` exactly. Everything except `README.md` and `sync.sh` is destined to land there as-is.

## Directory structure

```
agent_config/        # mirrors ~/.claude/ exactly
├── agents/          # sub-agent definitions
├── skills/          # slash-command skills
├── rules/           # path-scoped authoring rules (applied by Claude Code when editing matched files)
├── scripts/         # helper scripts used by skills
└── CLAUDE.md        # global behavioral instructions for Claude Code
```

## agents/

Each file defines a named sub-agent that Claude Code can spawn via the `Agent` tool. Agents are markdown files with YAML frontmatter (`name`, `description`, `color`, `emoji`) followed by a system prompt that shapes the agent's identity, capabilities, and workflow.

Files ending in `.skip` are disabled and not synced to `~/.claude`.

| Agent | Purpose |
|---|---|
| `ai-engineer` | ML model development, deployment, and AI-powered feature integration |
| `backend-architect` | Scalable system design, database architecture, and API development |
| `code-reviewer` | Constructive code review focused on correctness, maintainability, security |
| `codebase-onboarding-engineer` | Helps new engineers understand unfamiliar codebases fast |
| `database-optimizer` | Schema design, query optimization, and indexing strategies |
| `devops-automator` | Infrastructure automation, CI/CD, and cloud operations |
| `explorer` | Fast codebase search — grep, glob, find, and reading many files |
| `frontend-developer` | Modern web, React/Vue/Angular, UI implementation, and performance |
| `laravel-developer` | Laravel/Livewire/FluxUI specialist — advanced CSS, Three.js integration |
| `minimal-change-engineer` | Minimum-viable diffs — fixes only what was asked, resists scope creep |
| `project-tech-advisor` | Interactive advisor for new project technology discovery — structured sessions to evaluate options and produce honest recommendations |
| `python-developer` | Senior Python specialist — FastAPI/Django/Flask, async, uv, ruff, mypy, pytest |
| `rails-developer` | Ruby on Rails full-stack specialist — Rails, Hotwire, Turbo, Stimulus.js |
| `rails-reviewer` | Rails code review specialist — controllers, models, migrations, views, specs |
| `security-engineer` | Threat modeling, vulnerability assessment, and secure code review |
| `software-architect` | System design, DDD, architectural patterns, and technical decision-making |
| `technical-writer` | Developer documentation, API references, READMEs, and tutorials |

## skills/

Each subdirectory is a skill invokable as a slash command (`/<skill-name>`) inside Claude Code. A skill is driven by a `SKILL.md` file that tells Claude exactly what to do when triggered.

| Skill | Command | Purpose |
|---|---|---|
| `agent-md` | `/agent-md` | Creates or updates `AGENT.md` at a repo root — an AI agent identity file grounded in the actual codebase |
| `hook-setup` | `/hook-setup` | Sets up Claude Code hooks in `settings.json` and documents them in `CLAUDE.md` to automate recurring operations |
| `issues-from-tasks` | `/issues-from-tasks` | Creates GitHub issues from task JSON files in `~/tasks/<repo>/`, one issue per file, using the `gh` CLI |
| `review-agent` | `/review-agent` | Reviews and refactors an `AGENT.md` file for performance and cost effectiveness |
| `review-skill` | `/review-skill` | Reviews and refactors a `SKILL.md` file for performance and cost effectiveness |
| `session-summary` | `/session-summary` | Produces a structured two-part summary (short + extended) of a research or planning session, saved to `~/sessions/<project>/` as a handoff brief for the next session |
| `task-distill` | `/task-distill` | Rethinks the session discussion and distills it into a concise, prioritized list of small actionable tasks |
| `tasks-export` | `/tasks-export` | Runs the full pipeline — distills session into tasks, confirms with the user, then saves as JSON |
| `tasks-to-json` | `/tasks-to-json` | Saves a confirmed task list from the current session as a structured JSON file to `~/tasks/<repo>/` |
| `topic-summary` | `/topic-summary` | Produces a structured summary of a specific topic discussed during a session — options considered, pros/cons, open questions, and a recommended starting point |

## scripts/

Helper scripts used by skills. Not synced to `~/.claude`.

| Script | Purpose |
|---|---|
| `issues-from-tasks.sh` | Shell implementation backing the `/issues-from-tasks` skill |

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

1. Create `agents/<role>.md` with YAML frontmatter (`name`, `description`, `color`, `emoji`) and a full system prompt.
2. Commit and push — Claude Code picks up new agent files automatically on next launch.

## Adding a new skill

1. Create `skills/<skill-name>/SKILL.md` with YAML frontmatter (`name`, `description`, `when_to_use`) and step-by-step instructions.
2. Add any supporting files (templates, examples) alongside `SKILL.md`.
3. Commit and push.
