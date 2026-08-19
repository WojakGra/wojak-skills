# Working in this repo

This is a Claude Code plugin that ships agent skills. Nothing here is application code.

## Structure

Skills live at `skills/<bucket>/<skill-name>/SKILL.md`. The directory name must equal the `name` in the frontmatter, and names are unique across all buckets (Claude Code loads them into one flat namespace).

Buckets:

- `engineering/` - code work. Promoted.
- `productivity/` - non-code workflow. Promoted.
- `meta/` - skills about writing skills. Promoted.
- `in-progress/` - public but unfinished. Not shipped.
- `deprecated/` - kept for reference. Not shipped.

Every promoted skill must appear in the `skills` array of `.claude-plugin/plugin.json` **and** in the skill tables in `README.md`. Unpromoted skills must appear in neither. Run `sh scripts/validate-skills.sh` after any change; it checks frontmatter, name/directory agreement, kebab-case, the 1024-char frontmatter limit, duplicate names, manifest sync, and README coverage. `claude plugin validate . --strict` checks the manifests themselves.

## Writing or editing a skill

Follow `skills/meta/writing-skills/SKILL.md`. The two rules that break skills most often:

- The `description` states **triggering conditions only**. A description that summarizes the workflow gives the agent a shortcut and it stops reading the body.
- Keep `SKILL.md` under roughly 200 lines. Heavy reference material goes in a sibling file the skill links, and deterministic steps go in a script.

Express a dependency on another skill as an instruction to call the Skill tool by name, not as a `../other-skill/file.md` link.

## Vendored skills

Most skills are adapted from upstream MIT projects and carry an attribution footer at the bottom of `SKILL.md`. `NOTICE.md` records the sources and the adaptations. When editing one:

- Keep the footer.
- Keep upstream references resolvable: cross-skill references use plain local skill names, never the `superpowers:` namespace they came with.
- Artifact paths are de-branded (`docs/plans/`, `docs/specs/`, `.agent-work/`). Do not reintroduce upstream paths.

When pulling a fix from upstream, note it in `NOTICE.md` under the adaptations list if it changes behavior.

## Local use

`sh scripts/link-skills.sh` symlinks every promoted skill into `~/.claude/skills`, so a `git pull` keeps the installed copies current.
