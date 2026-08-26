#!/bin/sh
# SessionEnd hook: remind the user if code changed but the journal didn't.
#
# Reminder only. Never blocks, never writes to the journal itself — an auto-generated
# entry is worse than no entry, because it looks like a real one.
#
# Contract: stderr is shown to the user on SessionEnd; stdout is ignored. Always exit 0.
# SessionEnd hooks share a ~1.5 s budget, so this must stay cheap.
#
# Installed from ~/.claude/settings.json, which points at this file by absolute path so the
# hook applies in every repo. As a plugin, use "${CLAUDE_PLUGIN_ROOT}" instead — a relative
# path is resolved against the session cwd, not the skill, and silently never fires.

set -u

# Only meaningful inside a git work tree.
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0

root=$(git rev-parse --show-toplevel 2>/dev/null) || exit 0
cd "$root" 2>/dev/null || exit 0

# Locate the journal the same way the skill does.
journal=""
for candidate in JOURNAL.md docs/JOURNAL.md; do
	if [ -f "$candidate" ]; then
		journal="$candidate"
		break
	fi
done
[ -n "$journal" ] || exit 0

# Uncommitted changes, excluding the journal itself. Match the path as a fixed
# string anchored to the porcelain path field (chars 4+), so a name that merely
# contains the journal path -- JOURNAL.md.bak, notes/JOURNAL.md -- still counts.
changed=$(git status --porcelain -- . 2>/dev/null | awk -v j="$journal" 'substr($0, 4) != j')
[ -n "$changed" ] || exit 0

# Did the journal change too? Covers staged, unstaged, and untracked.
if git status --porcelain -- "$journal" 2>/dev/null | grep -q .; then
	exit 0
fi

# Count before truncating, so the number reported is the real one.
count=$(printf '%s\n' "$changed" | grep -c .)
printf '\n  journal: %s file(s) changed but %s was not updated.\n' "$count" "$journal" >&2
printf '  Run /journal next session, or before committing, to record what happened and why.\n\n' >&2

exit 0
