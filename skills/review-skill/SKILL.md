---
name: review-skill
description: Reviews and refactors a SKILL.md file for performance and cost effectiveness.
argument-hint: "[path/to/SKILL.md]"
disable-model-invocation: true
context: fork
model: haiku
allowed-tools: Read Write
---

# Review Skill

## Task

Review and refactor the SKILL.md at `$ARGUMENTS` for performance and cost effectiveness.
If no path given, look for SKILL.md files in `.claude/skills/` and `~/.claude/skills/`.

## Rules

**Description**
- One sentence, front-loaded with the key use case
- Enough signal for correct auto-invocation — vague causes missed or over-triggering
- If `disable-model-invocation: true`, description can be minimal (never loaded into context)
- If auto-invoked, `description` + `when_to_use` combined under 1,536 characters

**Focus**
- One thing well — flag multi-topic skills for splitting
- Generic session-wide content belongs in CLAUDE.md, not a skill
- Zero-exception rules belong in hooks, not skill bodies

**Body**
- Under 500 lines
- Remove anything Claude already knows
- Move large reference material (JSON schemas, templates, format examples, lookup tables, worked examples) to supporting files with relative links; add `Read` to `allowed-tools`
- No redundant steps
- Convert checklists to rules or remove them

**Frontmatter**
- `disable-model-invocation: true` for side-effects or manual-only skills
- `context: fork` when reading many files or producing verbose output
- `model: haiku` or `effort: low` for mechanical skills
- `allowed-tools`: minimal — only what the skill needs

## Output

1. Rewritten SKILL.md
2. Changes made and rules cited
3. Flag for human judgment: content to move to supporting files, rules better as hooks, skills to split
