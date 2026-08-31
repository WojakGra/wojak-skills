# Notice

This repository vendors and adapts skills from three MIT-licensed upstream projects. Their copyright notices are reproduced below, as MIT requires. Every adapted `SKILL.md` also carries a one-line attribution footer naming its source.

## superpowers

<https://github.com/obra/superpowers> - Copyright (c) 2025 Jesse Vincent, MIT.

Vendored: `systematic-debugging`, `test-driven-development`, `writing-plans`, `executing-plans`, `subagent-driven-development`, `dispatching-parallel-agents`, `requesting-code-review`, `receiving-code-review`, `verification-before-completion`, `using-git-worktrees`, `finishing-a-development-branch`, `brainstorming`, plus `anthropic-best-practices.md` and `testing-skills-with-subagents.md` under `skills/writing-skills/`.

## mattpocock/skills

<https://github.com/mattpocock/skills> - Copyright (c) 2026 Matt Pocock, MIT.

Vendored: `codebase-design`, `grilling`, `writing-for-agents`, `handoff`.

## ponytail

<https://github.com/DietrichGebert/ponytail> - Copyright (c) 2026 DietrichGebert, MIT.

Vendored: `ponytail`, `ponytail-review`.

## cursor/plugins (pstack)

<https://github.com/cursor/plugins/tree/main/pstack> - Copyright (c) 2026 Lauren Tan, MIT.

Vendored: `unslop`, `blast-radius`, `create-verification-skill`, `maintain-verification-skill`, `typescript-best-practices`, `technical-writing`, `show-me-your-work`, `bro`, and the twenty-one `principle-*` skills under `skills/`.

## Adaptations applied

- Cross-skill references in the `superpowers:<name>` namespace were rewritten to plain skill names, so they resolve inside this plugin.
- Artifact paths were de-branded: `docs/superpowers/plans/` to `docs/plans/`, `docs/superpowers/specs/` to `docs/specs/`, `.superpowers/` to `.agent-work/`.
- Codex-specific `agents/openai.yaml` metadata was removed; this plugin targets Claude Code.
- pstack skills that hard-code Cursor's model panel (`~/.cursor/rules/pstack-models.mdc`) or its cloud subagent parameters were left behind, not rewritten: `poteto-mode`, `setup-pstack`, `architect`, `arena`, `swarm`, `interrogate`, `how`, `why`, `reflect`, `recall`, `automate-me`, `figure-it-out`, `teach`, `no-comments`.
- In the skills that were taken, `.cursor/skills/` became `.claude/skills/`, and `show-me-your-work` had its transcript path and cross-model review step rewritten for Claude Code.
- Pressure-test material shipped alongside `systematic-debugging` was moved to `tests/`, out of the loaded skill payload.
