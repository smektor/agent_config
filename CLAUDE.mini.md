# Global Claude Code Configuration (Usage-Optimized)

Personal preferences and behavioral guidance applied to every project.

## Agents

Delegate to specialized subagents for complex or domain-specific work. Use the `Agent` tool with the subagent name from `~/.claude/agents/`.

**CRITICAL USAGE RULE: ONLY delegate when explicitly requested by the user or when a task is too large to complete in the main context. Do not proactively delegate.** 

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

Skills live in `~/.claude/skills/`. Read each `SKILL.md` so you know every available skill and its trigger phrases. 

**CRITICAL USAGE RULE: ONLY invoke a skill if the user explicitly types its slash command (e.g., `/task-distill`). Do NOT proactively run them or offer them.**

Available skills:
- `/task-distill` (Extract actionable tasks)
- `/tasks-export` (Save tasks as JSON)
- `/session-summary` (Preserve findings)
- `/agent-md` (Generate agent identity file)
- `/issues-from-tasks` (Create GitHub issues)
- `/topic-summary` (Summarize a topic)

## Project context

- Read the `AGENT.md` file ONLY if the user explicitly asks you to, or if you strictly need local repository context to solve a problem. Do NOT read it automatically at the start of every session.

## Behavior

- **Always answer directly in the main thread** to save token usage, unless instructed otherwise.
- **Do not proactively delegate** — wait for the user to ask for a specific sub-agent.
- **Do not proactively run background summaries or suggest running skills.**
- Delegate to `engineering-minimal-change-engineer` ONLY when the user explicitly says "just fix X" or "don't change anything else."
- After any implementation (new agent, new skill, renamed skill, changed behavior) — update `README.md` and any relevant docs in the repo to reflect the change.
