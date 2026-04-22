# Performance / context management
- Delegate to `explorer` for codebase-wide searches, reading 10+ files, or verbose output (full test suite runs, large logs). Not for reading a few known files or running a single test.
- Run only the relevant test file, not the full suite, unless asked
- When compacting, always preserve: list of modified files, failing tests, commands to reproduce issues
- After two failed correction attempts, stop and ask for clarification instead of retrying

# Workflow
- Run the linter and type checker after finishing a series of changes
- Run only the relevant test file, not the full suite, unless I ask otherwise
- IMPORTANT: when adding a feature, check if a pattern already exists in the codebase before inventing a new one

# Shell
- Preferred shell: zsh
- Package manager: prefer pnpm over npm when available
- Use gh CLI for GitHub operations (PRs, issues, reviews)

# Context management
- When compacting, always preserve: list of modified files, failing tests, and any commands needed to reproduce issues