---
name: journal
description: Keep an engineering journal (devlog) and promote durable decisions to ADRs. Use when the user says "journal", "devlog", "worklog", "log what we did", "write up this session", "record this decision", "write an ADR", or when a working session is wrapping up and its findings would otherwise be lost. Also use when starting work in an unfamiliar repo to catch up on recent history.
---

# Journal

Two artifacts, two jobs:

- **`JOURNAL.md`** — append-only chronological narrative. What happened, why, what failed.
- **`docs/adr/NNNN-*.md`** — one durable decision per file, addressable and citable.

The split exists because a journal is unsearchable by intent. Six months on, nobody can find
"why are we using X" in 4,000 lines of chronology, but they can read a directory of decisions.

## Catching up (read mode)

When starting work in a repo that has a journal, read the **newest entries first** — the file
is reverse-chronological, so the top is current. Read `docs/adr/` index-style (titles alone
are often enough) and open only the ADRs relevant to what you're about to touch.

## Writing an entry

1. Locate the journal: `JOURNAL.md` at the repo root, else `docs/JOURNAL.md`. If none exists,
   create it at the root with the header from `templates/journal-header.md`.
2. Get today's real date — `date +%Y-%m-%d`. **Never guess the date**, and never reuse a date
   from earlier in the conversation without checking.
3. Insert the new entry **at the top**, directly under the file header, using
   `templates/entry.md`. Newest-first keeps the useful part cheap to read.
4. If the day already has an entry and you're continuing the same thread of work, extend it
   rather than adding a second same-day entry.

### What makes an entry worth writing

Write for a competent stranger — often a future session with none of your context.

- **Record failures and dead ends.** This is the highest-value content and the most commonly
  omitted. "Tried X, it doesn't work because Y" saves someone the same day of work. An entry
  with no failures in it is usually an entry that's hiding something.
- **Record what you verified and how.** Cite the datasheet table, doc page, or command output
  you relied on. "Checked the vendor docs" is worthless; "supported-features table lists no
  PWM driver" is durable.
- **Convert relative dates to absolute.** "Next week" is meaningless in an archive.
- **Note surprises.** Anywhere reality differed from the obvious assumption is exactly where
  the next person will trip.
- **Keep it proportional.** A one-line fix gets a one-line entry. Don't pad.
- **Never** paste secrets, tokens, keys, or credentials into the journal.

Do not narrate the conversation ("the user asked me to…"). Record the *work*: decisions,
findings, changes, and what's still open. Where memory is thin, say so — a gap is more useful
than a smoothed-over guess.

## Promoting a decision to an ADR

Write an ADR when **any** of these hold:

- it constrains future work (a platform, protocol, dependency, or interface choice);
- you rejected credible alternatives, and the reasons would be re-litigated otherwise;
- someone reasonable would look at the result later and ask "why on earth is it like this";
- reversing it would be expensive.

Skip the ADR for: routine implementation detail, anything easily reversed, and style choices
that belong in the project's instructions file instead.

Procedure:

1. Find where ADRs already live before creating anything: `docs/adr/`, `doc/adr/`,
   `docs/decisions/`, `docs/architecture/decisions/`, or the path named in a `.adr-dir` file
   (adr-tools). If some exist, read one or two and follow their format — a repo's house style
   beats this skill's template. Otherwise create `docs/adr/`.
2. Next free number, zero-padded to four digits. Filename `NNNN-kebab-case-title.md`, from
   `templates/adr.md`.
3. State the alternatives you rejected **and why** — an ADR without rejected alternatives is
   just a note.
4. Reference it from the journal entry as `ADR-NNNN`, and cite it in code comments where the
   decision is non-obvious from the code — the comment carries the citation, not the reasoning.

### Checks before you save it

- **Context that fits any project isn't context.** If another project's constraints could be
  swapped in and the section still read fine, rewrite it with what actually bound this
  decision — part availability, the deadline, the one person who knows the toolchain.
- **One strawman beside the winner is not a comparison.** Two credible alternatives minimum.
  If there was genuinely only one, record that as the finding — "evaluated X, nobody here has
  run it in production" is a real reason.
- **All-upside consequences mean you stopped early.** Every decision buys something with
  something. If nothing got worse, this probably wasn't a decision worth an ADR.
- **Write what you remember, not a tidier version.** Recording a decision months late is fine;
  say where you're unsure. A clean story you half-invented is worse than a gap, because it
  reads as reliable.
- **One page.** Longer means the design belongs elsewhere and only the decision belongs here.

An accepted ADR is not edited to change its decision. Write a new one and mark the old one
`Status: Superseded by ADR-NNNN`.

## Bundled files

| File | Use |
|---|---|
| `templates/journal-header.md` | header when creating a new journal |
| `templates/entry.md` | one journal entry (v1.0.0) |
| `templates/adr.md` | one ADR (v1.0.0) |
| `CHANGELOG.md` | template changes between versions |
| `journal-reminder.sh` | SessionEnd hook: warns when code changed but the journal didn't |

## Template versioning

Entry and ADR templates carry version comments. When this skill updates a template structure, a new version appears in `CHANGELOG.md`. If your entries are using an older version, you can update by replacing the template portion with the current version. Most changes are backward-compatible; significant restructuring will be noted in the changelog.
