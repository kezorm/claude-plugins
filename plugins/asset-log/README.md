# asset-log

Sets up and maintains a durable record for something you own — a vehicle, a
house, a boat, a rental unit, equipment — out of the scattered documents,
photos, receipts, inspection reports and manuals that accumulate around it.

The output is plain markdown in a git repository. No app, no database, no schema
to migrate when you discover you need a field nobody anticipated. It stays
readable by a person with a text editor in twenty years, which is longer than
most software lasts.

**See it in action:** [vehicle-silverado-example](https://github.com/kezorm/vehicle-silverado-example) — a real asset log for a vehicle.

## Install

```bash
/plugin marketplace add kezorm/claude-plugins
/plugin install asset-log@kezorm
```

Then use `/asset-log` to set up a new log or file documents into an existing one.

## What it's actually for

Records rot in a specific way: documents accumulate, the conclusion each one
implies never reaches the summary anyone reads, and a year later the folder is
full and useless.

It also holds two jobs apart, because one tends to eat the other:

- **What needs attention now** — episodic. An overdue item matters intensely
  until it's done, then closes forever.
- **What you'll want to know later** — cumulative. What oil it takes, when the
  pump was replaced, what the paint code is, who did the work in 2027. This is
  usually why the record still exists in 2040.

The instinct when filing is to ask *"so what — does this change anything?"* and
drop what doesn't. That test is wrong for the second job, and the skill says so.

## Where it helps, and where it doesn't

Tested against the same work done without it, four scenarios, twice each.

| Scenario | Starting point | With | Without |
|---|---|---|---|
| Boat paperwork, no structure | cold start | 9/9 | 6/9 |
| Generator docs, vague request | cold start | 6/6 | 5/6 |
| Filing into an HVAC record | existing record | 8/8 | 8/8 |
| Answering a septic question | existing record | 7/7 | 7/7 |

**Both cold starts separated. Both established records tied.** A well-made record
carries its own instructions, so once the structure and conventions exist a
capable model reads them and continues them unaided. The scarce act is authoring
the context, not maintaining it.

The skill is written accordingly — weighted toward setup, and it explicitly tells
a session to **stop consulting it** once a record carries its own working rules,
because duplicating that effort costs more and produces nothing better.

## The difference the score didn't capture

In the boat scenario both runs read identical documents. One ranked a
$1,200–2,500 timing belt job as the highest-priority item, *"~5 YEARS OVERDUE"*,
purely because no record of it existed. The other ranked it fifth, called it
*"the single biggest unknown here,"* and wrote: **"Don't authorise belt work on
the strength of my file."**

Same evidence, opposite recommendation. The first had even written the caveat —
*"no record"* — and then reasoned *"treat undocumented as not done"* anyway.
Avoiding the phrase is not the same as avoiding the reasoning, and that is mostly
what this skill is about.

## What's in it

| Path | What |
|---|---|
| `SKILL.md` | The method |
| `references/intake.md` | Filing, deduplication, and why extracted PDF tables are the weak point |
| `references/evidence.md` | Confidence tagging, absence of a record vs absence of the event, conflicting sources |
| `references/publishing.md` | What to audit before a record is shared |
| `references/template/` | Starting point copied into new records |
| `scripts/` | `inbox-status`, `extract-text`, `check-links` — three short scripts, not a framework |

## Requirements

Needs a filesystem and a shell. `pdftotext` (poppler) for text extraction and
`git` for history are both strongly recommended; the skill degrades explicitly
without either rather than failing quietly. Optionally uses
[docling](https://github.com/docling-project/docling) via `uvx` where a
document's meaning lives in its tables.
