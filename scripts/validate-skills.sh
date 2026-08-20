#!/usr/bin/env sh
# Validates every skill in the repo and checks the plugin manifest is in sync.
# POSIX sh: runs in Git Bash on Windows and on CI.
set -eu

repo="$(cd "$(dirname "$0")/.." && pwd)"
cd "$repo"

fail=0
err() { echo "ERROR: $*" >&2; fail=1; }
warn() { echo "warn:  $*" >&2; }

promoted="$(find skills -mindepth 1 -maxdepth 1 -type d ! -name in-progress ! -name deprecated | sort | tr "
" " ")"
unpromoted="skills/in-progress skills/deprecated"

# --- per-skill checks -------------------------------------------------------
for skill_md in $(find skills -name SKILL.md | sort); do
  dir="$(dirname "$skill_md")"
  dirname="$(basename "$dir")"

  # frontmatter must be the first thing in the file
  [ "$(head -n 1 "$skill_md")" = "---" ] || err "$skill_md: does not start with YAML frontmatter"

  fm="$(awk 'NR==1 && $0=="---" {inside=1; next} inside && $0=="---" {exit} inside {print}' "$skill_md")"
  [ -n "$fm" ] || { err "$skill_md: empty frontmatter"; continue; }

  name="$(printf '%s\n' "$fm" | sed -n 's/^name: *//p' | head -n 1)"
  [ -n "$name" ] || err "$skill_md: missing 'name'"
  printf '%s\n' "$fm" | grep -q '^description:' || err "$skill_md: missing 'description'"

  [ "$name" = "$dirname" ] || err "$skill_md: name '$name' does not match directory '$dirname'"
  printf '%s' "$name" | grep -qE '^[a-z0-9]+(-[a-z0-9]+)*$' || err "$skill_md: name '$name' is not kebab-case"

  chars="$(printf '%s' "$fm" | wc -c | tr -d ' ')"
  [ "$chars" -le 1024 ] || err "$skill_md: frontmatter is $chars chars, limit is 1024"

  lines="$(wc -l < "$skill_md" | tr -d ' ')"
  [ "$lines" -le 320 ] || warn "$skill_md: $lines lines, consider splitting detail into sibling files"
done

# --- duplicate names --------------------------------------------------------
dupes="$(find skills -name SKILL.md | sed 's|/SKILL.md||' | xargs -n1 basename | sort | uniq -d)"
[ -z "$dupes" ] || err "duplicate skill names: $(echo "$dupes" | tr '\n' ' ')"

# --- manifest sync ----------------------------------------------------------
manifest="$(sed -n '/"skills": \[/,/\]/p' .claude-plugin/plugin.json | sed -n 's|.*"\./\(skills/[^"]*\)".*|\1|p' | sort)"
ondisk="$(find $promoted -name SKILL.md 2>/dev/null | sed 's|/SKILL.md||' | sort)"

for s in $ondisk; do
  printf '%s\n' "$manifest" | grep -qx "$s" || err "$s is in a promoted bucket but missing from plugin.json"
done
for s in $manifest; do
  [ -f "$s/SKILL.md" ] || err "plugin.json lists $s, which has no SKILL.md"
  case " $s " in
    *" skills/in-progress/"*|*" skills/deprecated/"*) err "$s is unpromoted and must not ship in plugin.json" ;;
  esac
done
for bucket in $unpromoted; do
  [ -d "$bucket" ] || continue
  for skill_md in $(find "$bucket" -name SKILL.md 2>/dev/null); do
    dir="$(dirname "$skill_md")"
    printf '%s\n' "$manifest" | grep -qx "$dir" && err "$dir is unpromoted but listed in plugin.json"
  done
done

# --- README coverage --------------------------------------------------------
for s in $ondisk; do
  grep -q "$s" README.md || err "$(basename "$s") is not listed in README.md"
done

if [ "$fail" -eq 0 ]; then
  echo "OK: $(printf '%s\n' "$ondisk" | wc -l | tr -d ' ') promoted skills validated"
fi
exit "$fail"
