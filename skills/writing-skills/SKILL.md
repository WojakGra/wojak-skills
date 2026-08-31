---
name: writing-skills
description: Use when creating a new skill, editing an existing one, splitting a skill that grew too big, or checking a skill before it ships. Covers frontmatter rules, description writing, progressive disclosure, and how to verify a skill actually changes agent behavior.
---

# Writing Skills

## Overview

A skill is a reference guide for a proven technique, pattern, or workflow, written for the agent that will read it later. It is not a narrative of how you solved something once.

**Core principle:** a skill earns its place only if an agent behaves measurably better with it than without it. If you never watched an agent fail without the skill, you do not know what the skill has to teach.

## When to create a skill

Create one when all of these hold:

- The technique was not obvious to you the first time.
- You would reach for it again across different projects.
- It encodes judgment, not a mechanical rule.

Do not create one for:

- A one-off fix.
- Standard practice already covered by the model's training.
- Project-specific conventions. Those belong in that project's `CLAUDE.md`.
- Anything a linter, formatter, or hook can enforce. Automate it instead.

## Anatomy

```
skills/<skill-name>/
  SKILL.md            # required, the entry point
  reference.md        # optional, heavy detail loaded on demand
  script.sh           # optional, a tool the skill tells the agent to run
```

`<skill-name>` is kebab-case, and the directory name must equal the `name` in the frontmatter.

## Frontmatter

Two required fields, `name` and `description`. Keep the whole block under 1024 characters.

```yaml
---
name: skill-name
description: Use when <triggering conditions and symptoms>.
---
```

This repository targets both Claude Code and Codex from one shared `SKILL.md`. Do not add Claude Code's `disable-model-invocation: true`: Codex plugin validation rejects that value. To make a skill explicit-only in Codex, add `agents/openai.yaml` with `policy.allow_implicit_invocation: false`. There is no shared metadata switch that makes the same file explicit-only in both hosts; preserving that exact behavior would require platform-specific copies, which this repository deliberately avoids.

## Writing the description

The description is the only text the agent sees when deciding whether to load your skill. It has one job: answer "should I read this right now?"

- **Describe when to use it, not what it does.** A description that summarizes the workflow gives the agent a shortcut, and it will follow the summary instead of opening the file. That is the single most common way a skill silently stops working.
- Start with `Use when ...` and list concrete symptoms, situations, and the phrases a user actually types.
- Third person, no "I" or "you".
- Under 500 characters where possible.

```yaml
# bad: summarizes the process, so the agent skips the body
description: Reviews the diff, then checks tests, then writes a summary comment.

# good: pure triggers
description: Use when finishing a feature branch, before opening a PR, or when the user asks for a review of uncommitted work.
```

## Progressive disclosure

`SKILL.md` is loaded in full once triggered, so it competes for context with the actual task. Keep it under roughly 200 lines.

- **Inline:** the core principle, the decision points, code patterns under ~50 lines, common mistakes.
- **Split into a sibling file:** heavy reference (100+ lines), long API tables, templates, anything needed only in one branch of the workflow. Link it and say when to read it: `For the full flag list, read [reference.md](reference.md).`
- **Split into a script:** anything deterministic. A script the agent runs beats fifteen lines telling it what to type.

## Writing style for agents

- Imperative and specific. "Run `git diff --stat` first" beats "it may be helpful to look at the diff".
- Say what NOT to do, and why, where a plausible wrong path exists. Rationalizations you observed in testing are the best content a skill can carry.
- One concrete before/after example is worth three paragraphs of principle.
- No hedging, no filler headings, no restating the description.

## Calling another skill

Express a dependency as an explicit instruction to call the Skill tool by name:

> Call the Skill tool with "systematic-debugging" before proposing a fix.

Do not cross-link into another skill's files with `../other-skill/reference.md`, and do not drop a bare `/name` and hope it reads as a command. When a step depends on a skill that is explicit-only in the current host, instruct the human instead: "tell the user to run `/setup-x`".

## Verify it works

Documentation you never tested is a guess. The loop mirrors TDD:

1. **Baseline (red).** Give a fresh subagent a task the skill would cover, without the skill. Record exactly what it does wrong and the reasoning it used to justify it.
2. **Write the skill (green).** Address those specific failures, in their own vocabulary.
3. **Re-run.** Same task, same wording, skill available. It should now comply.
4. **Refactor.** Find the next loophole (an agent obeying the letter but not the intent), close it, re-run.

Keep the scenarios you used in `tests/<skill-name>.md` so the next edit can be re-verified.

## Adding a skill to this repo

1. Choose the README category: Engineering, Productivity, Principles, or Meta.
2. Create `skills/<name>/SKILL.md` from [template.md](template.md).
3. Add `"./skills/<name>"` to the `skills` array in `.claude-plugin/plugin.json` and a row under the chosen category in the top-level `README.md`. Unfinished or retired skills belong under `unpromoted/` and must appear in neither.
4. Run `bash scripts/validate-skills.sh`.
5. Run `bash scripts/link-skills.sh` to symlink it into `~/.claude/skills` for local use.

## Checklist before shipping

- [ ] Directory name equals frontmatter `name`, kebab-case.
- [ ] Description states triggers only, and never the workflow.
- [ ] `SKILL.md` under ~200 lines; heavy detail moved to sibling files.
- [ ] Every claim is actionable; nothing is a story about one past session.
- [ ] Baseline run showed the failure the skill fixes.
- [ ] Manifest, README, and validator all pass.
