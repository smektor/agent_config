# Token efficiency — main session
- Read only the files you need. Use line ranges (`offset`/`limit`) for large files instead of reading them whole.
- Run only the relevant test file, not the full suite, unless asked.
- After two failed correction attempts, stop and ask for clarification instead of retrying.
- When compacting, preserve: list of modified files, failing tests, commands to reproduce issues.

# Token efficiency — subagents
- Before spawning a subagent, ask: is the task large enough to justify it? If not, handle it inline.
- If a task seems large, inform the user that it can be split into smaller tasks and ask how to proceed — do not silently spawn a large agent to absorb it.
- Use `agents/explorer.md` (haiku, maxTurns 20) for codebase-wide searches, reading 10+ files, or processing verbose output. Do NOT use it for reading 1–3 known files.
- When spawning any subagent, always set `model` (prefer haiku for read-only work, sonnet for writing) and `maxTurns` to the minimum needed. Never leave these unset.
- Pass a tight, self-contained prompt: include exact file paths, line numbers, and a word limit on the response when possible.

# Hooks — check before acting
- Before running lint, type-check, format, or tests manually, check `.claude/settings.json` and `~/.claude/settings.json` for existing hooks that already do it.
- Do not re-run or duplicate work that a configured hook handles automatically.
- If no hook exists for a recurring operation, suggest adding one via the `hook-setup` skill rather than repeating the command each session.

# Workflow
- Run the linter and type checker after finishing a series of changes, unless it is already defined as hook.
- IMPORTANT: when adding a feature, check if a pattern already exists in the codebase before inventing a new one.

# Shell
- Preferred shell: zsh
- Package manager: prefer pnpm over npm when available
- Use gh CLI for GitHub operations (PRs, issues, reviews)