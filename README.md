# wojak-skills

Agent skills for Codex and Claude Code: reusable engineering and productivity workflows, packaged as an installable plugin.

The set is curated rather than written from scratch. Most skills are adapted from four MIT-licensed upstream projects ([superpowers](https://github.com/obra/superpowers), [mattpocock/skills](https://github.com/mattpocock/skills), [ponytail](https://github.com/DietrichGebert/ponytail), [pstack](https://github.com/cursor/plugins/tree/main/pstack)); see [NOTICE.md](NOTICE.md) for attribution and the exact adaptations. Skills that duplicated Claude Code's built-in commands (`/code-review`, `/simplify`, `/security-review`) or depended on someone else's issue tracker were left out.

## Install

### Codex

Codex reads this repository as both a plugin and a plugin marketplace. The marketplace catalog is at `.agents/plugins/marketplace.json`, the Codex manifest is at `.codex-plugin/plugin.json`, and the shared skills are under `skills/`.

**From a local clone:**

```sh
codex plugin marketplace add /absolute/path/to/wojak-skills
codex plugin add wojak-skills@wojak-skills
```

The marketplace source stays attached to the local clone. After pulling an update, reinstall the plugin and start a new Codex thread so Codex discovers the refreshed skills:

```sh
codex plugin add wojak-skills@wojak-skills
```

**From GitHub:**

```sh
codex plugin marketplace add WojakGra/wojak-skills
codex plugin add wojak-skills@wojak-skills
```

The repository is private, so Git must already have access to it. Configure a credential helper or run `gh auth login`; otherwise use a local clone. Refresh the Git marketplace with:

```sh
codex plugin marketplace upgrade wojak-skills
codex plugin add wojak-skills@wojak-skills
```

The second command reinstalls the plugin from the refreshed snapshot. Start a new thread afterward so Codex discovers the updated skills.

### Claude Code

This repository is private, which rules nothing out: Claude Code shells out to `git` for remote marketplaces, so any machine whose git can already read the repo can install it.

**From a local clone (no credentials needed):**

```sh
claude plugin marketplace add /path/to/wojak-skills
claude plugin install wojak-skills@wojak-skills
```

The marketplace is registered as a `Directory` source and reads the working tree live, so `git pull` is all it takes to pick up changes.

**From GitHub (needs git credentials for a private repo):**

```sh
claude plugin marketplace add WojakGra/wojak-skills
claude plugin install wojak-skills@wojak-skills
```

This clones over HTTPS using whatever git credential helper is configured (Git Credential Manager, or `gh auth login`). On a machine with no credentials for the repo, use a local clone instead, or make the repo public. Run `claude plugin marketplace update wojak-skills` to pull later changes.

**Without the Claude Code plugin system**, clone the repo and symlink the skills into `~/.claude/skills`:

```sh
sh scripts/link-skills.sh
```

### Cross-platform structure

Both plugins load the same `SKILL.md` files from the flat `skills/` directory; there is no generated copy. A skill may additionally contain `agents/openai.yaml` for Codex-only presentation or invocation policy. Claude Code ignores that companion file and continues to load the shared skill normally.

## Skills

### Engineering

| Skill                                                                                        | What it is for                                                                             |
| -------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------ |
| [codebase-design](skills/codebase-design/SKILL.md)                               | Deep modules, interfaces, and seams: the vocabulary for deciding where a boundary belongs. |
| [systematic-debugging](skills/systematic-debugging/SKILL.md)                     | Phase-based root-cause debugging instead of guess-and-patch.                               |
| [test-driven-development](skills/test-driven-development/SKILL.md)               | The red-green-refactor loop, and what makes a test worth keeping.                          |
| [writing-plans](skills/writing-plans/SKILL.md)                                   | Turn an approved design into a plan another session can execute task by task.              |
| [executing-plans](skills/executing-plans/SKILL.md)                               | Work through a written plan with review checkpoints.                                       |
| [subagent-driven-development](skills/subagent-driven-development/SKILL.md)       | A fresh subagent per plan task, with two-stage review between tasks.                       |
| [dispatching-parallel-agents](skills/dispatching-parallel-agents/SKILL.md)       | Fan independent work out to subagents with purpose-built context.                          |
| [requesting-code-review](skills/requesting-code-review/SKILL.md)                 | Dispatch a reviewer subagent before problems cascade.                                      |
| [receiving-code-review](skills/receiving-code-review/SKILL.md)                   | Evaluate feedback technically instead of agreeing on reflex.                               |
| [verification-before-completion](skills/verification-before-completion/SKILL.md) | Prove it works before claiming it is done.                                                 |
| [using-git-worktrees](skills/using-git-worktrees/SKILL.md)                       | Isolated workspaces so parallel work does not collide.                                     |
| [finishing-a-development-branch](skills/finishing-a-development-branch/SKILL.md) | Verify, then decide how the branch gets integrated and cleaned up.                         |
| [ponytail](skills/ponytail/SKILL.md)                                             | Lazy senior dev mode: the shortest solution that works, YAGNI, stdlib first.               |
| [ponytail-review](skills/ponytail-review/SKILL.md)                               | Review a diff for over-engineering and rank what to cut.                                   |
| [blast-radius](skills/blast-radius/SKILL.md)                                     | Find what a change breaks outside its diff, and prove the safety claim by running code.    |
| [create-verification-skill](skills/create-verification-skill/SKILL.md)           | Generate a project-local skill that drives the real app and captures evidence.             |
| [maintain-verification-skill](skills/maintain-verification-skill/SKILL.md)       | Keep that verification skill and its feature map honest as the app moves.                  |
| [typescript-best-practices](skills/typescript-best-practices/SKILL.md)           | The TypeScript rules that keep illegal states unrepresentable.                             |

### Productivity

| Skill                                                                 | What it is for                                                                |
| --------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| [brainstorming](skills/brainstorming/SKILL.md)           | Turn an idea into a design and a spec before any implementation.              |
| [grilling](skills/grilling/SKILL.md)                     | Interview round by round until every branch of the design tree is settled.    |
| [handoff](skills/handoff/SKILL.md)                       | Compact the session into a handoff document for the next agent.               |
| [unslop](skills/unslop/SKILL.md)                         | Strip AI tells out of writing and put a voice back in.                        |
| [writing-for-agents](skills/writing-for-agents/SKILL.md) | Write instructions and docs that agents actually follow.                      |
| [technical-writing](skills/technical-writing/SKILL.md)   | Diataxis structure, Google style sentences, plain instruction rules for docs. |
| [show-me-your-work](skills/show-me-your-work/SKILL.md)   | Keep a reviewable TSV decision trail for long or unattended runs.             |
| [bro](skills/bro/SKILL.md)                               | Restate the last message in plain human language, no jargon.                  |

### Principles

Twenty-one short principle skills from pstack, each one rule with its rationale. Type a principle's name to pull it into a session deliberately, for example when you want a review held to it.

| Principle                                                                                                                 | Rule                                                                                                                                                                                   |
| ------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [boundary-discipline](skills/principle-boundary-discipline/SKILL.md)                                           | Concentrate guards at system boundaries (CLI, config, network, external APIs); trust internal types and keep business logic in pure functions.                                         |
| [build-the-lever](skills/principle-build-the-lever/SKILL.md)                                                   | Build the tool that does it or proves it (codemod, script, generator, or a skill your subagents follow) instead of working by hand. The tool is the artifact a reviewer can rerun.     |
| [encode-lessons-in-structure](skills/principle-encode-lessons-in-structure/SKILL.md)                           | Encode the rule as a lint, metadata flag, runtime check, or script instead of more text.                                                                                               |
| [exhaust-the-design-space](skills/principle-exhaust-the-design-space/SKILL.md)                                 | Build 2-3 competing prototypes and compare side by side before committing.                                                                                                             |
| [experience-first](skills/principle-experience-first/SKILL.md)                                                 | Choose user delight over implementation convenience; ship fewer polished features over more rough ones.                                                                                |
| [fix-root-causes](skills/principle-fix-root-causes/SKILL.md)                                                   | Trace each symptom to its root cause and fix it there; reproduce first, ask why until you reach it, resist nil-check guards that silence crashes.                                      |
| [foundational-thinking](skills/principle-foundational-thinking/SKILL.md)                                       | Get the data structures right so downstream code becomes obvious.                                                                                                                      |
| [guard-the-context-window](skills/principle-guard-the-context-window/SKILL.md)                                 | Route bulk to subagents; keep summaries in the main thread, not raw payloads.                                                                                                          |
| [laziness-protocol](skills/principle-laziness-protocol/SKILL.md)                                               | Bias toward deletion and the smallest change that solves the problem.                                                                                                                  |
| [make-operations-idempotent](skills/principle-make-operations-idempotent/SKILL.md)                             | Converge to the same end state regardless of partial prior runs.                                                                                                                       |
| [migrate-callers-then-delete-legacy-apis](skills/principle-migrate-callers-then-delete-legacy-apis/SKILL.md)   | Migrate callers and delete the old API in the same wave instead of preserving compatibility layers.                                                                                    |
| [minimize-reader-load](skills/principle-minimize-reader-load/SKILL.md)                                         | Count layers between question and answer, and hidden state in the reader's head; collapse one-caller wrappers and shrink mutable scope.                                                |
| [model-the-domain](skills/principle-model-the-domain/SKILL.md)                                                 | Encode the domain in a structure instead of scattered conditionals.                                                                                                                    |
| [never-block-on-the-human](skills/principle-never-block-on-the-human/SKILL.md)                                 | Proceed, present the result, let the human course-correct after the fact; reserve confirmation for irreversible actions.                                                               |
| [outcome-oriented-execution](skills/principle-outcome-oriented-execution/SKILL.md)                             | Converge on the target architecture; don't preserve smooth intermediate states with throwaway compatibility code.                                                                      |
| [prove-it-works](skills/principle-prove-it-works/SKILL.md)                                                     | Verify against the real artifact (run the feature, read the actual value, inspect the diff), not a proxy, self-report, or 'it compiles.'                                               |
| [redesign-from-first-principles](skills/principle-redesign-from-first-principles/SKILL.md)                     | Redesign as if the requirement had been a foundational assumption from day one, instead of bolting it on.                                                                              |
| [separate-before-serializing-shared-state](skills/principle-separate-before-serializing-shared-state/SKILL.md) | Eliminate the sharing first; serialize structurally only when one shared writer is a real invariant.                                                                                   |
| [sequence-verifiable-units](skills/principle-sequence-verifiable-units/SKILL.md)                               | Break work into small units that each end in a verifiable state, check each before the next, and order delivery so the sequence proves itself to a reviewer.                           |
| [subtract-before-you-add](skills/principle-subtract-before-you-add/SKILL.md)                                   | Remove dead weight, redundant validators, and stub references first, then build on the simpler base.                                                                                   |
| [type-system-discipline](skills/principle-type-system-discipline/SKILL.md)                                     | Make illegal states unrepresentable, brand semantic primitives, parse external data at boundaries, refuse to lie to the compiler, exhaust variants, derive from authoritative schemas. |

### Meta

| Skill                                                 | What it is for                                 |
| ----------------------------------------------------- | ---------------------------------------------- |
| [writing-skills](skills/writing-skills/SKILL.md) | Create, split, and verify skills in this repo. |

## Layout

```
.claude-plugin/
  plugin.json        # the plugin, with an explicit list of shipped skills
  marketplace.json   # makes this repo its own single-plugin marketplace
.codex-plugin/
  plugin.json        # Codex plugin metadata and presentation details
.agents/plugins/
  marketplace.json   # makes this repo a Codex marketplace
skills/
  <skill-name>/      # one shared, flat skill tree used by both agents
unpromoted/
  in-progress/       # public but unfinished, not shipped
  deprecated/        # kept for reference, not shipped
scripts/             # validation and local linking
tests/               # pressure scenarios used to verify skills
```

Every directory directly under `skills/` ships in both plugins. Categories such as Engineering and Productivity live in this README rather than in the filesystem. Unfinished or retired skills belong under `unpromoted/` and do not ship. `scripts/validate-skills.sh` enforces these rules.

## Adding a skill

Read [skills/writing-skills/SKILL.md](skills/writing-skills/SKILL.md), start from its [template.md](skills/writing-skills/template.md), then:

```sh
sh scripts/validate-skills.sh
claude plugin validate . --strict
```

## License

MIT, see [LICENSE](LICENSE) and [NOTICE.md](NOTICE.md).
