# Global Claude Code Configuration

Personal preferences and behavioral guidance applied to every project.

## Agents

Delegate to specialized subagents for complex or domain-specific work. Use the `Agent` tool with the subagent name from `~/.claude/agents/`.

**When to delegate proactively — don't wait to be asked:**

| Task type | Subagent to use |
|---|---|
| Code review or audit | `engineering-code-reviewer` |
| System design or architecture decisions | `engineering-software-architect` |
| Backend APIs, databases, microservices | `engineering-backend-architect` |
| Frontend, React/Vue/Angular, UI | `engineering-frontend-developer` |
| Data pipelines, ETL/ELT, Spark, dbt | `engineering-data-engineer` |
| Database schema, query optimization | `engineering-database-optimizer` |
| CI/CD, infrastructure, cloud ops | `engineering-devops-automator` |
| Security review, threat modeling | `engineering-security-engineer` |
| Bug fix where scope must stay narrow | `engineering-minimal-change-engineer` |
| Exploring an unfamiliar codebase | `engineering-codebase-onboarding-engineer` |
| New project technology evaluation | `engineering-project-tech-advisor` |
| Proof of concept or MVP | `engineering-rapid-prototyper` |
| Rails / Hotwire / Turbo / Stimulus | `engineering-rails-developer` |
| Laravel / Livewire / FluxUI / Three.js | `engineering-senior-developer` |
| ML models, LLMs, AI features | `engineering-ai-engineer` |
| Self-healing data pipelines, anomaly fix | `engineering-ai-data-remediation-engineer` |
| API performance + cost guardrails | `engineering-autonomous-optimization-architect` |
| Docs, READMEs, API references | `engineering-technical-writer` |
| Mobile iOS/Android/cross-platform | `engineering-mobile-app-builder` |
| Git workflows, branching, rebasing | `engineering-git-workflow-master` |
| Python frameworks, pipelines, workflows, packaging | `engineering-python-developer` |

## Skills

Skills live in `~/.claude/skills/`. Read each `SKILL.md` so you know every available skill and its trigger phrases. Invoke a skill whenever the user's request matches its `description` or `when_to_use`.

**Proactively offer these at natural moments — don't wait to be asked:**

- After any planning or design discussion → offer `/task-distill` to extract actionable tasks
- After `/task-distill` confirms a task list → mention `/task-export` to save as JSON
- At the end of a research session → offer `/session-summary` to preserve findings
- When working in a new repo → offer `/agent-md` to generate an agent identity file
- When the user has task JSON files → mention `/issues-from-tasks` to create GitHub issues

## Project context

- If the current repo contains an `AGENT.md` file, read it at the start of the session and apply its rules, identity, and constraints throughout all work in that repo.

## Behavior

- **Always tell the user before delegating** — state which agent or skill you are about to use and why, before invoking it.
- Prefer specialized subagents for work that would flood the main context (exploration, research, audit).
- Delegate to `engineering-minimal-change-engineer` when the user says "just fix X" or "don't change anything else."
- After completing a multi-step planning session, always ask if the user wants to distill or export tasks.
