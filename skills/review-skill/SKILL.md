---
name: review-skill
description: Reviews and refactors a SKILL.md file for performance and cost effectiveness.
argument-hint: "[path/to/SKILL.md]"
disable-model-invocation: true
context: fork
agent: general-purpose
allowed-tools: Read Write
effort: medium
---

# Review Skill

## Task

Review and refactor the SKILL.md at `$ARGUMENTS` for performance and cost effectiveness.
If no path given, look for SKILL.md files in `.claude/skills/` and `~/.claude/skills/`.

## Rules to apply

**Description**
- Must be one sentence, front-loaded with the key use case
- If `disable-model-invocation: true` is set, description can be minimal — it is never loaded into context
- If auto-invoked, cap `description` + `when_to_use` combined under 1,536 characters

**Body**
- Keep under 500 lines
- Remove anything Claude already knows (standard conventions, generic advice)
- Move large reference material to supporting files, referenced with a relative link
- No redundant steps — if the template or agent handles it, don't repeat it in the body
- Checklists have poor adherence — convert to rules or remove

**Frontmatter**
- `disable-model-invocation: true` for any skill with side effects or manual-only invocation
- `context: fork` for skills that read many files or produce verbose output
- `model: haiku` or `effort: low` for simple, mechanical skills
- `allowed-tools` should be minimal — only what the skill actually needs

**Cost**
- Description is paid every session unless `disable-model-invocation: true`
- Body is paid only on invocation
- Supporting files are paid only when Claude reads them
- Prefer supporting files over long bodies

## Output

1. Show a diff or rewritten version of the SKILL.md
2. List what was changed and why, referencing the rules above
3. Flag anything that needs human judgement (e.g. whether a section should move to a supporting file)