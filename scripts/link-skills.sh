#!/usr/bin/env sh
# Symlinks every promoted skill into ~/.claude/skills so they are available
# outside the plugin install. Re-run after adding or renaming a skill.
set -eu

repo="$(cd "$(dirname "$0")/.." && pwd)"
dest="${HOME}/.claude/skills"
mkdir -p "$dest"

buckets="$(find "$repo/skills" -mindepth 1 -maxdepth 1 -type d ! -name in-progress ! -name deprecated)"

for skill_md in $(find $buckets -name SKILL.md | sort); do
  src="$(dirname "$skill_md")"
  name="$(basename "$src")"
  target="$dest/$name"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    echo "skip $name: $target exists and is not a symlink" >&2
    continue
  fi
  ln -sfn "$src" "$target"
  echo "linked $name -> $src"
done
