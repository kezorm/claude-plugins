# Journal

Keep an append-only engineering journal (devlog) with a SessionEnd hook that reminds you to record what happened. Promote significant decisions to ADRs (Architecture Decision Records) for durability.

## Install

### Local installation (for development or testing)

```bash
/plugin marketplace add file:///Users/greg/Projects/claude/kezorm
/plugin install journal@kezorm
```

Or from another project in the same parent directory:
```bash
/plugin marketplace add ../kezorm
/plugin install journal@kezorm
```

### Community marketplace (once approved)

Once approved, set up the community marketplace (one time):
```bash
/plugin marketplace add anthropics/claude-plugins-community
```

Then install:
```bash
/plugin install journal@claude-community
```

(Submission pending review.)

---

Then use `/journal` to write an entry, or ask Claude to "write an ADR" to record a decision.

## What it does

**Journal entries** — a reverse-chronological narrative in `JOURNAL.md` that captures:
- What you did and why
- What failed and why it failed (the highest-value content)
- What you verified and how (with citations, not hand-waving)
- What's still open or uncertain

**ADRs** — Architecture Decision Records in `docs/adr/` that hold decisions worth keeping:
- Constraints that bind future work
- Rejected alternatives with reasons
- Consequences of the choice
- When to revisit

**SessionEnd hook** — automatically reminds you if code changed but the journal didn't. The reminder is advisory only; it never writes entries itself, because an auto-generated entry is worse than silence.

## Why split journal and ADRs?

A journal is unsearchable by intent. Six months on, nobody can find "why are we using X" in 4,000 lines of chronology. But they can skim a directory of titled decisions and read only what's relevant.

## How to use

### Catching up on a project

When starting work in a repo that has a journal:
1. Read the **newest entries first** (the file is reverse-chronological)
2. Skim `docs/adr/` by title; open only the decisions relevant to what you're about to touch

### Writing a journal entry

The skill guides you through it. Use `/journal` or ask Claude to "write a journal entry" — it will:
- Find the journal at `JOURNAL.md` or `docs/JOURNAL.md` (or create one)
- Add your entry at the top with today's date
- Prompt for the key sections: what you did, why, what failed, what you verified, what's still open

**Write for a competent stranger** — often a future session with no context. Record:
- Failures and dead ends (this saves the most time)
- What you verified and how (cite the docs, datasheet, or command)
- Surprises — anywhere reality differed from the obvious assumption
- Open questions or risks

### Recording a decision as an ADR

When you've made a decision that:
- Constrains future work (a platform, dependency, or interface choice)
- Rejected credible alternatives (with reasons that would be re-litigated otherwise)
- Would make someone ask "why on earth is it like this" months later
- Would be expensive to reverse

Use `/journal` and choose "write an ADR", or ask Claude to "record an ADR". The skill will:
- Create `docs/adr/NNNN-kebab-case-title.md`
- Guide you through context, decision, alternatives rejected, and consequences
- Help you check for common ADR mistakes (generic context, strawman alternatives, all-upside consequences)

**Reference ADRs from journal entries** as `ADR-NNNN`, and cite them in code comments where the decision is non-obvious.

## The hook stays quiet

The SessionEnd hook only warns if:
1. You're in a git repo that already has a `JOURNAL.md` (so installing this plugin doesn't nag new repos)
2. Code changed but the journal didn't

It always exits successfully (never blocks) and respects the 1.5s budget for SessionEnd hooks.

## Files

- `skills/journal/SKILL.md` — the journal/ADR workflow
- `skills/journal/templates/` — templates for journal entries and ADRs
- `hooks/journal-reminder.sh` — the SessionEnd hook
- `hooks/hooks.json` — hook registration

## License

MIT. See [LICENSE](../../LICENSE) in the root of this repository.
