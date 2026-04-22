# Code style
- Use 2-space indentation for all languages unless a project config overrides it
- Prefer explicit over implicit: name variables clearly, avoid single-letter names outside loops
- Use early returns to reduce nesting

# Performance / context management
- Delegate to `explorer` for codebase-wide searches, reading 10+ files, or verbose output (full test suite runs, large logs). Not for reading a few known files or running a single test.
- Run only the relevant test file, not the full suite, unless asked
- When compacting, always preserve: list of modified files, failing tests, commands to reproduce issues
- After two failed correction attempts, stop and ask for clarification instead of retrying

# Python
- Use 4-space indentation (PEP 8)
- Type hints required on all function signatures
- Use f-strings over .format() or %
- Prefer pathlib over os.path
- Use ruff for linting, mypy for type checking
- Run: ruff check . && mypy . after changes

# Ruby / Ruby on Rails
- Follow standard Ruby style (2-space indent)
- Prefer symbols over strings for hash keys
- Use keyword arguments for methods with 3+ parameters
- Rails: follow RESTful conventions for controllers; one action per controller method
- Rails: use scopes over class methods for ActiveRecord queries
- Rails: avoid logic in views; move to helpers or presenters
- Run: bundle exec rubocop after changes
- Rails: run bundle exec rails test or bundle exec rspec, not the full suite unless asked

# Git
- Commit messages: imperative mood, max 72 chars, e.g. "Add rate limiter to auth endpoint"
- Never commit directly to main or master
- Branch naming: <type>/<short-description>, e.g. feat/oauth-login, fix/token-refresh

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