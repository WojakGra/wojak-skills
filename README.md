# wojak-skills

Agent skills for Claude Code: reusable engineering and productivity workflows, packaged as an installable plugin.

The set is curated rather than written from scratch. Most skills are adapted from three MIT-licensed upstream projects ([superpowers](https://github.com/obra/superpowers), [mattpocock/skills](https://github.com/mattpocock/skills), [ponytail](https://github.com/DietrichGebert/ponytail)); see [NOTICE.md](NOTICE.md) for attribution and the exact adaptations. Skills that duplicated Claude Code's built-in commands (`/code-review`, `/simplify`, `/security-review`) or depended on someone else's issue tracker were left out.

## Install

This repository is private, which rules nothing out: Claude Code shells out to `git` for remote marketplaces, so any machine whose git can already read the repo can install it.

**From a local clone (no credentials needed):**

```
/plugin marketplace add /path/to/wojak-skills
/plugin install wojak-skills@wojak-skills
```

The marketplace is registered as a `Directory` source and reads the working tree live, so `git pull` is all it takes to pick up changes.

**From GitHub (needs git credentials for a private repo):**

```
/plugin marketplace add WojakGra/wojak-skills
/plugin install wojak-skills@wojak-skills
```

This clones over HTTPS using whatever git credential helper is configured (Git Credential Manager, or `gh auth login`). On a machine with no credentials for the repo, use a local clone instead, or make the repo public. Run `claude plugin marketplace update wojak-skills` to pull later changes.

**Without the plugin system**, clone the repo and symlink the skills into `~/.claude/skills`:

```sh
sh scripts/link-skills.sh
```

## Skills

### Engineering

| Skill | What it is for |
| --- | --- |
| [codebase-design](skills/engineering/codebase-design/SKILL.md) | Deep modules, interfaces, and seams: the vocabulary for deciding where a boundary belongs. |
| [systematic-debugging](skills/engineering/systematic-debugging/SKILL.md) | Phase-based root-cause debugging instead of guess-and-patch. |
| [test-driven-development](skills/engineering/test-driven-development/SKILL.md) | The red-green-refactor loop, and what makes a test worth keeping. |
| [writing-plans](skills/engineering/writing-plans/SKILL.md) | Turn an approved design into a plan another session can execute task by task. |
| [executing-plans](skills/engineering/executing-plans/SKILL.md) | Work through a written plan with review checkpoints. |
| [subagent-driven-development](skills/engineering/subagent-driven-development/SKILL.md) | A fresh subagent per plan task, with two-stage review between tasks. |
| [dispatching-parallel-agents](skills/engineering/dispatching-parallel-agents/SKILL.md) | Fan independent work out to subagents with purpose-built context. |
| [requesting-code-review](skills/engineering/requesting-code-review/SKILL.md) | Dispatch a reviewer subagent before problems cascade. |
| [receiving-code-review](skills/engineering/receiving-code-review/SKILL.md) | Evaluate feedback technically instead of agreeing on reflex. |
| [verification-before-completion](skills/engineering/verification-before-completion/SKILL.md) | Prove it works before claiming it is done. |
| [using-git-worktrees](skills/engineering/using-git-worktrees/SKILL.md) | Isolated workspaces so parallel work does not collide. |
| [finishing-a-development-branch](skills/engineering/finishing-a-development-branch/SKILL.md) | Verify, then decide how the branch gets integrated and cleaned up. |
| [ponytail](skills/engineering/ponytail/SKILL.md) | Lazy senior dev mode: the shortest solution that works, YAGNI, stdlib first. |
| [ponytail-review](skills/engineering/ponytail-review/SKILL.md) | Review a diff for over-engineering and rank what to cut. |

### Productivity

| Skill | What it is for |
| --- | --- |
| [brainstorming](skills/productivity/brainstorming/SKILL.md) | Turn an idea into a design and a spec before any implementation. |
| [grilling](skills/productivity/grilling/SKILL.md) | Interview round by round until every branch of the design tree is settled. |
| [handoff](skills/productivity/handoff/SKILL.md) | Compact the session into a handoff document for the next agent. |
| [writing-for-agents](skills/productivity/writing-for-agents/SKILL.md) | Write instructions and docs that agents actually follow. |

### Meta

| Skill | What it is for |
| --- | --- |
| [writing-skills](skills/meta/writing-skills/SKILL.md) | Create, split, and verify skills in this repo. |

## Layout

```
.claude-plugin/
  plugin.json        # the plugin, with an explicit list of shipped skills
  marketplace.json   # makes this repo its own single-plugin marketplace
skills/
  engineering/       # promoted: code work
  productivity/      # promoted: non-code workflow
  meta/              # promoted: skills about skills
  in-progress/       # public but unfinished, not shipped
  deprecated/        # kept for reference, not shipped
scripts/             # validation and local linking
tests/               # pressure scenarios used to verify skills
```

Only the promoted buckets ship. A skill in `engineering/`, `productivity/`, or `meta/` must appear in both `plugin.json` and this README; a skill in `in-progress/` or `deprecated/` must appear in neither. `scripts/validate-skills.sh` enforces this.

## Adding a skill

Read [skills/meta/writing-skills/SKILL.md](skills/meta/writing-skills/SKILL.md), start from its [template.md](skills/meta/writing-skills/template.md), then:

```sh
sh scripts/validate-skills.sh
claude plugin validate . --strict
```

## License

MIT, see [LICENSE](LICENSE) and [NOTICE.md](NOTICE.md).
