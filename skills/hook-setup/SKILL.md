---
name: hook-setup
description: Sets up Claude Code hooks in settings.json and documents them in CLAUDE.md so future agents don't redundantly re-run operations already handled automatically. Use this skill whenever the user wants to run tests, linting, formatting, or builds automatically; says "run X automatically", "don't run X manually", "add a Stop hook", "hook up lint", "automate X on every task", or "set up a PreToolUse/PostToolUse/Stop hook". Always use this skill for any "automate a command via hooks" request, even if the user doesn't say the word "hook" explicitly.
---

# Hook Setup

You are helping the user wire up a Claude Code hook and document it so every future agent in this project knows not to re-run the operation by hand.

Two things must happen before you're done:
1. The hook is written into the correct `settings.json`.
2. `CLAUDE.md` has a clear note telling agents the operation is automated.

---

## Step 1 — Read the project context

Run this block to understand the stack and what commands are likely available:

```bash
echo "=== Stack ===" && ls package.json pyproject.toml Cargo.toml go.mod Makefile 2>/dev/null
echo "=== Scripts ===" && cat package.json 2>/dev/null | python3 -c "import sys,json; d=json.load(sys.stdin); [print(k,'->', v) for k,v in d.get('scripts',{}).items()]" 2>/dev/null
echo "=== CLAUDE.md ===" && test -f CLAUDE.md && echo "exists" || echo "absent"
echo "=== Project settings ===" && test -f .claude/settings.json && cat .claude/settings.json || echo "absent"
echo "=== Global hooks ===" && python3 -c "import json; d=json.load(open('$HOME/.claude/settings.json')); print(json.dumps(d.get('hooks',{}), indent=2))" 2>/dev/null || echo "none"
```

Use this to propose sensible defaults in the next step so the user doesn't have to spell out obvious things.

---

## Step 2 — Understand what the user wants

If the user's request is already specific enough (command + trigger), skip to Step 3. Otherwise ask the minimum needed to proceed — don't ask for things you can infer from the stack.

Key questions:
- **What command(s) should run?** (e.g. `npm test && npm run lint`, `pytest`, `cargo check`)
- **When should it trigger?** (see the event guide below)
- **Scope?** Global (`~/.claude/settings.json`) applies to all projects. Project (`.claude/settings.json`) applies only here. Default to **project scope** unless the user says otherwise.

### Event guide

| Goal | Hook event |
|------|-----------|
| Run tests/lint after every completed task | `Stop` |
| Run formatter every time a file is edited | `PostToolUse` on `Write\|Edit` |
| Block a dangerous bash command | `PreToolUse` on `Bash` |
| Inject context when a session starts | `SessionStart` |
| Run build to catch compile errors before stopping | `Stop` |

When in doubt, **Stop** is the right default for "run X automatically after each task."

---

## Step 3 — Write the hook

### Read the target settings.json first

Always read the existing file before writing — never overwrite it blindly.

- **Project:** `.claude/settings.json` (create `.claude/` dir if needed)
- **Global:** `~/.claude/settings.json`

### Hook JSON structure

For `settings.json` (not a plugin — no `"hooks"` wrapper):

```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "*",
        "hooks": [
          {
            "type": "command",
            "command": "npm test && npm run lint",
            "timeout": 60
          }
        ]
      }
    ]
  }
}
```

**Common patterns:**

Stop hook (run after every task):
```json
"Stop": [{ "matcher": "*", "hooks": [{ "type": "command", "command": "<cmd>", "timeout": 60 }] }]
```

PostToolUse hook (run after file edits):
```json
"PostToolUse": [{ "matcher": "Write|Edit", "hooks": [{ "type": "command", "command": "<cmd>", "timeout": 30 }] }]
```

PreToolUse hook (block/warn before a tool runs):
```json
"PreToolUse": [{ "matcher": "Bash", "hooks": [{ "type": "command", "command": "<script>", "timeout": 10 }] }]
```

### Merging hooks

Merge new hooks into the existing JSON — preserve everything else. Use Python to read, update, and write:

```python
import json, os

path = ".claude/settings.json"
os.makedirs(".claude", exist_ok=True)

try:
    with open(path) as f:
        cfg = json.load(f)
except FileNotFoundError:
    cfg = {}

cfg.setdefault("hooks", {})
cfg["hooks"].setdefault("Stop", [])

# Add the new hook entry (check for duplicates first)
new_entry = {"matcher": "*", "hooks": [{"type": "command", "command": "npm test", "timeout": 60}]}
cfg["hooks"]["Stop"].append(new_entry)

with open(path, "w") as f:
    json.dump(cfg, f, indent=2)
print("Written to", path)
```

Adapt the event name, command, matcher, and timeout to what the user actually wants.

---

## Step 4 — Update CLAUDE.md

The note you write here is what prevents every future agent from re-running the operation manually. Write it so the instruction is unambiguous.

**Format:**

If `CLAUDE.md` has an `## Automated Hooks` section, append to it. If not, add the section at the top (after any existing title/intro).

```markdown
## Automated Hooks

<description of what runs automatically and via which hook, plus the explicit "do not run X manually" instruction>
```

**Examples of good entries:**

- `Tests and linting run automatically via a Stop hook. Do not run \`npm test\` or \`npm run lint\` manually unless explicitly asked.`
- `Code is formatted automatically via a PostToolUse hook after every file edit. Do not run \`prettier\` or \`black\` manually.`
- `The build runs automatically on Stop to catch compile errors. Do not run \`cargo build\` or \`npm run build\` manually.`

The wording should match exactly what was hooked. Be specific about the command names so agents know what's covered.

---

## Step 5 — Confirm with the user

After writing both files, tell the user:

1. What hook was created (event, command, scope).
2. What was added to CLAUDE.md.
3. **"Restart Claude Code for the hook to take effect."** (Hooks load at session start — changes don't apply to the current session.)

---

## Quick example

User says: *"Run tests and lint automatically after every task."*

Stack detected: Node.js with `npm test` and `npm run lint` scripts.

Hook written to `.claude/settings.json`:
```json
{
  "hooks": {
    "Stop": [
      {
        "matcher": "*",
        "hooks": [{ "type": "command", "command": "npm test && npm run lint", "timeout": 60 }]
      }
    ]
  }
}
```

CLAUDE.md entry added:
```
## Automated Hooks

Tests and linting run automatically via a Stop hook. Do not run `npm test` or `npm run lint` manually unless explicitly asked.
```
