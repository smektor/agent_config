# agent_config

This repository is the **staging area and source of truth** for `~/.claude` — the global Claude Code configuration directory. Files are authored and versioned here, then synced into `~/.claude` by running `sync.sh`.

The directory structure mirrors `~/.claude` exactly. Everything except `README.md` and `sync.sh` is destined to land there as-is.

## Directory structure

```
agent_config/        # mirrors ~/.claude/ exactly
├── skills/          # slash-command skills
├── rules/           # path-scoped authoring rules (applied by Claude Code when editing matched files)
├── scripts/         # helper scripts used by skills
└── CLAUDE.md        # global behavioral instructions for Claude Code
```

## skills/

Each subdirectory is a skill invokable as a slash command (`/<skill-name>`) inside Claude Code. A skill is driven by a `SKILL.md` file that tells Claude exactly what to do when triggered.

| Skill | Command | Purpose |
|---|---|---|
| `explain-diff-html` | `/explain-diff-html` | Generates a rich, interactive standalone HTML explainer (background, intuition, code walkthrough, quiz) for a diff, branch, or PR |
| `hook-setup` | `/hook-setup` | Sets up Claude Code hooks in `settings.json` and documents them in `CLAUDE.md` to automate recurring operations |
| `implementation-plan` | `/implementation-plan` | Researches the repo for a feature and writes a standalone plan folder (`docs/implementation-plans/<slug>/`) with a plan doc, ordered task list, and progress checklist |
| `implement-task` | `/implement-task` | Implements exactly one task from an implementation-plan folder's task list, marks it done, and stops |
| `issues-from-tasks` | `/issues-from-tasks` | Creates GitHub issues from task JSON files in `~/tasks/<repo>/`, one issue per file, using the `gh` CLI |
| `pr-description` | `/pr-description` | Generates a short PR description from the diff between current branch and main/master (or a given branch/diff file) |
| `review-skill` | `/review-skill` | Reviews and refactors a `SKILL.md` file for performance and cost effectiveness |
| `session-summary` | `/session-summary` | Produces a structured two-part summary (short + extended) of a research or planning session, saved to `~/sessions/<project>/` as a handoff brief for the next session |
| `task-distill` | `/task-distill` | Rethinks the session discussion and distills it into a concise, prioritized list of small actionable tasks |
| `testing-instruction` | `/testing-instruction` | Analyzes an implementation/diff/task and writes `docs/testing-instructions/<slug>.md` with manual testing steps and low-effort automated test suggestions |
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

The script copies `CLAUDE.md`, `skills/`, and `rules/` to `~/.claude`, creating any missing subdirectories. It only adds/updates — it never deletes files from `~/.claude`.

## rules/

Path-scoped authoring rules that Claude Code loads automatically when editing matched files. Each rule file has a `paths` frontmatter field that targets specific file patterns.

| Rule | Applies to | Purpose |
|---|---|---|
| `rules/skills.md` | `skills/*/SKILL.md` | Required frontmatter schema and conventions for skill files |

## Adding a new skill

1. Create `skills/<skill-name>/SKILL.md` with YAML frontmatter (`name`, `description`, `when_to_use`) and step-by-step instructions.
2. Add any supporting files (templates, examples) alongside `SKILL.md`.
3. Commit and push.
