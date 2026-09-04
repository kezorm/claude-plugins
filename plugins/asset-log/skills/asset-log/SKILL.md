---
name: asset-log
description: Set up and maintain a durable, self-contained record for something the user owns — a vehicle, house, boat, rental property, tools, or equipment — from scattered documents, photos, receipts, inspection reports and manuals. Reach for this above all when a record is being started from nothing — someone just bought or inherited something, has a folder or pile of paperwork about it, and wants to stop losing track. Also use it when filing new documents into a record that has no working rules of its own, when an inspection or scan report needs interpreting, or when someone says they want to keep track of or stay on top of something they own — even if they never say repository, archive, or documentation. The first setup is where this matters most; a record that already carries its own rules mostly runs itself.
---

# Asset Record

Someone owns a thing — a car, a house, a boat, a rental unit, a shop full of
tools — and the documents about it are scattered across email, downloads,
glove boxes and filing cabinets. This skill turns that into a record that stays
current, tells them what needs attention, and survives being handed to a
mechanic, a contractor, a buyer, or a future version of themselves.

The hard part is not filing. It's that records rot: a document gets saved, the
conclusion it implies never reaches the summary anyone actually reads, and six
months later the folder is full and useless. Everything below is aimed at that.

## See it in action

[vehicle-silverado-example](https://github.com/kezorm/vehicle-silverado-example) is a real asset log for a vehicle — shows the structure, conventions, and what a mature record looks like.

## Where this skill actually pays — read this first

**Setting a record up well is worth far more than maintaining one.** That isn't a
slogan; it's the measured result. Tested against the same work done without this
skill, cold starts diverged sharply and ongoing intake into an established record
didn't diverge at all.

The reason is simple once seen: **a well-made record carries its own
instructions.** Its `CLAUDE.md` states the rules, its README models the shape,
its existing entries demonstrate the conventions. Anyone — or anything — working
in it afterward reads that and continues it. The structure does the teaching.

Two consequences for how to use this skill:

**Spend the effort at initialization.** The `CLAUDE.md` written into a new record
is the highest-value artifact produced here, because it is what keeps the record
honest for years without this skill present. Write it properly; don't stub it.

**Get out of the way when the record already has rules.** If a record already
carries a `CLAUDE.md` or equivalent working-rules file, **follow that and stop
consulting this skill.** The record's own rules are more specific and take
precedence. Duplicating the effort measurably costs more and produces nothing
better. Bring this skill back only when the rules themselves need changing.

**Updating an established record's method.** Its `.claude/method.md` is a
byte-identical copy of [references/template/.claude/method.md](references/template/.claude/method.md),
carrying a version heading. To bring it current: `md5sum` both to see whether it
is stale, read [CHANGELOG.md](CHANGELOG.md) for what changed since its version,
overwrite the file, then review that record's `CLAUDE.md` for anything the
update now duplicates or contradicts. Never hand-edit `method.md` — a modified
copy stops being replaceable, which is the only reason the split exists.

## A record has two jobs, and they run on different clocks

**Telling you what needs attention now.** Ranked open items, what's overdue,
what's coming. This is what an owner asks for on day one, and it's what makes a
new record feel worth having.

**Answering questions later.** What oil does this take. When was the water heater
replaced. What did the previous owner say about the roof. What's the paint code.
Who did the work in 2027 and what exactly did they do.

The first is episodic — it matters intensely for a week and then the item is
closed. The second is cumulative, and it is usually why the record still exists
in ten years. **Don't let the triage view crowd out the archive.**

This has a concrete consequence for what gets written down. The instinct when
filing is to ask "so what — does this change anything?" and drop what doesn't.
**That test is wrong for archival facts.** A paint code changes nothing today
and is exactly what someone wants in 2035 with a scratched fender. A serial
number, a vendor's name, a dimension, the full text of a data plate, what a
previous owner claimed and whether it was ever verified — none of it is
actionable, and all of it is the reason to keep a record at all.

**So capture completely and triage separately.** Transcribe the whole plate, not
the two fields that matter this week. Record the full service detail, not just
the finding that prompted a note. The README holds what's urgent; everything
else holds what's true.

**Write for a reader who arrives in ten years knowing nothing** — quite possibly
the owner, who will have forgotten. Spell out the abbreviation. Say why a
decision was made, not just what was decided. Name the vendor and the town. What
is obvious today is the exact thing that won't be.

## The one rule that matters

**When new information arrives, propagate it to every layer it touches — in the
same sitting, before reporting done.**

Three layers, every time:

1. **The artifact** — the original file, preserved byte-intact, in a dated home,
   with an extracted text version alongside if it's a PDF
2. **The specific document** — the digest or log covering that subject
3. **The top-level status** — current state, open items, what's coming up

The third is mandatory and the one people forget. Filing without propagating is
exactly how a folder becomes a junk drawer. If new information genuinely changes
nothing at the top level, say so explicitly rather than skipping it silently.

## Document roles — keep these distinct

| File | Role | Rewritable? |
|---|---|---|
| Top-level `README.md` | The **only** document describing *current* state | **Yes — always rewrite to stay true** |
| Identity doc | What the thing is, ownership, warranty | Yes, as facts change |
| Reference docs | Specs, parts, part numbers — living reference | Yes |
| Logs | Append-only record of what was done | Append; don't rewrite history |
| Dated analyses | What was believed **at that time** | **No — annotate, never rewrite** |

When later information changes a past conclusion, add a dated note inside the
original rather than editing it:

> **Added 2026-08-27.** The service history shows this was last done at
> 41,424 mi in 2020 — six years before this analysis was written.

This preserves the reasoning trail. Someone reading a two-year-old inspection
should see both what was concluded then and what was learned since. Silently
editing history destroys the thing that makes a record trustworthy.

## Setting up a new record — the main event

Ask before scaffolding — these change the shape of everything:

- Version controlled, or plain folders? (Git is usually right: it timestamps
  every change and makes "what did we know when" answerable. It also needs
  delete permission on the folder to manage `.git/index.lock` — request it
  up front if the environment restricts deletes.)
- What formats will arrive? Photos, PDFs, spreadsheets, email?
- What matters to track beyond the obvious — costs, warranty dates, usage hours?

Then create only this:

```
.
├── _inbox/            drop zone; contents gitignored until triaged
├── README.md          current status, open items, what's coming
├── CLAUDE.md          THIS record's specifics; imports the method below
├── .claude/method.md  the shared method, verbatim, versioned
└── bin/               the three scripts
```

**Two files, deliberately.** `CLAUDE.md` opens with `@.claude/method.md` — an
import, not a link. Imports are expanded into context at launch; a plain
markdown link is only read at the model's discretion. Both files live in the
record, so it stays self-contained.

The split exists so the method stays **replaceable**. Keep `.claude/method.md`
verbatim from [references/template/](references/template/) and never edit it —
everything specific to this thing goes in `CLAUDE.md`. Updating an established
record then becomes "replace one file, review the other for conflicts" rather
than reconciling hundreds of lines of prose. That is also why it carries a
version stamp.

**Do not scaffold a folder tree.** It's tempting to create `purchase/`,
`service/`, `reports/`, `reference/` up front — resist it. A vehicle, a house
and a camera kit need genuinely different homes for different things, and empty
folders guessed at on day one are worse than none: they invite filing documents
where they don't belong because a slot exists. **Make a folder when a document
arrives that needs one.**

What makes separate records feel like siblings is not their directories — it's
the imported method and a README that works the same way. So **write the working rules
into the record itself.** A record depending on an assistant's memory or one
machine isn't durable; anyone with a clone and a text editor should be able to
pick it up completely.

A ready-made starting point lives in
[references/template/](references/template/) — copy it in and fill the
placeholders rather than composing these files from scratch each time.

### Don't ship a thin CLAUDE.md

This is the part worth being fussy about. Every session after this one — with or
without this skill, with or without any assistant — inherits its judgment from
that file. A stub gets you a folder that drifts back into a junk drawer within a
year.

The template's version is a working baseline. Add to it what's specific to *this*
thing: the intervals that bind on the calendar rather than usage, the sources
that turned out to be unreliable, the conventions this record adopted and why.
Those are the notes a stranger — or a forgetful owner — needs to keep it honest.

### Setup includes the first intake

Don't scaffold and hand back an empty shell. The documents that prompted this
are the first test of whether the structure works.

Read them, file them, and **write up what they actually say** — both halves.
Capture the durable facts they contain, generously and whether or not anything
follows from them, because that is the record's long job. And surface anything
that needs attention, because that is what makes it obviously worth keeping on
day one. An empty template has to be believed on faith; a record that already
holds real content doesn't.

### The inbox pattern

Give them one place to drop things with no naming convention and no decisions
required. `scripts/inbox-status` inventories what's waiting. Gitignore the
contents but track the folder's README — unfiled documents are transient, and
some will be sensitive before anyone has looked at them.

## What this needs, and what to do without it

| Needs | Used for | Without it |
|---|---|---|
| A filesystem and shell | Everything | On a surface with no filesystem (claude.ai chat), this skill mostly can't run. Say so plainly and offer what *is* possible: read the documents the user pastes or uploads, produce the analysis and a README they can save themselves. |
| `pdftotext` (poppler) | Text beside every PDF | Highest-value habit, so don't skip silently. Offer the install (`brew install poppler` / `apt install poppler-utils`); if refused or unavailable, read PDFs directly and transcribe key figures into markdown by hand so the numbers are still searchable. |
| `docling` *(optional)* | Reliable table extraction | Not required. `uvx docling --to md <pdf>` needs no install but downloads models on first run. Worth it when a document's meaning is in its tables; overkill otherwise. |
| `wget` | `bin/archive-page` — fetching a web page with its images | Only needed when archiving from the web. `brew install wget` / `apt install wget`. Without it, `curl` the HTML alone and say plainly that the page's images were not kept — a partial archive that claims to be whole is worse than none. |
| `git` | History, and answering "what did we know when" | Plain dated folders work. Say the tradeoff once — no history, no diffs — and move on. Don't insist. |
| Delete permission on the folder | `git` needs to unlink `.git/index.lock` | If git operations fail with "Operation not permitted", request delete access for the record folder before continuing. |
| Subagents | The research phase | Do the research inline, sequentially. Slower, same output. |

Check with `command -v` rather than assuming. Degrade quietly and mention it
once — a user who can't install poppler doesn't need it raised three times.

## The intake loop

This runs during setup, and every time documents arrive afterward. Full detail —
routing, deduplication, table pitfalls, commit messages — is in
[references/intake.md](references/intake.md). Read it when filing; the essentials
are here.

*(If the record already has its own working-rules file, follow that instead. See
above.)*

**Read every file before filing it.** Never route on filename alone — the
filename is a guess, the contents are the fact. Photos labeled `IMG_0854` turned
out to be data plates carrying tire pressures and part numbers. Stage images
where you can actually look at them.

**Extract text beside every PDF.** `pdftotext -layout in.pdf out.txt`, kept next
to the original. This is the highest-leverage habit in the whole skill: it makes
the corpus greppable, and an archived manual then beats the internet for
questions about that specific thing. `scripts/extract-text` batches it.

**A scan with no text layer produces no `.txt`, and the run reports success.**
`extract-text` skips what it cannot extract, so `extracted=0 … failed=0` is
indistinguishable from "nothing to do" — check that a `.txt` actually appeared.
When a PDF is a pure image (`pdfimages -list` shows images and `pdftotext`
returns nothing), **type the document out by hand**, save it as the `.txt`
beside the original, and mark at the top that it is a transcription rather than
an extraction. Identity documents and certificates arrive this way constantly,
and an un-greppable one is invisible to every later search.

**Saved email needs the same treatment, and a `.eml` will not grep.** The part
that matters — the vendor's order table — is usually quoted-printable HTML, so
`grep` finds nothing and a human reads nothing. `scripts/eml-text` writes a
`.txt` beside each `.eml` keeping **both** the plain-text and HTML parts:
retailers routinely put the full item description only in the HTML and leave
the plain-text part as bare part numbers.

**But treat extracted tables as suspect.** pdftotext rebuilds columns from
character positions and gets tables wrong silently — in one real record it
misread a service-interval chart and produced the wrong timing-belt interval for
an interference engine. Asset records are full of exactly these documents.
Verify one row you can confirm independently before relying on the numbers, and
when a document's value *is* its tables, re-extract with a structure-aware tool
(`uvx docling --to md file.pdf`). `scripts/extract-text` flags tabular-looking
files so you know which ones need it.
[references/intake.md](references/intake.md) has the failure modes.

**Transcribe photographed labels into markdown.** A photo of a data plate is
useless until the numbers are searchable text. Type them out in a table under
the image link.

**Rename to something a human can read.** `carfax-report-2026-07-06.pdf`, not
`Report_104_S639234483889667912.pdf`. When renaming in bulk, keep a provenance
file mapping new names to originals.

**Editing an existing document is where a pass fails silently.** A
find-and-replace that matches nothing reports success, so assert the anchor
matched before trusting it and check `git status` afterwards. Verify a bulk edit
by re-deriving the result from the source, never by the loop finishing — a
partly-failed bulk edit looks exactly like one that worked.

**Then write the digest, then update the top-level status.** Then verify links
resolve (`scripts/check-links`), then commit with a message stating what was
*learned*, not what was moved:

> `check-links` validates the `#fragment` as well as the path, and three of its
> behaviours look like bugs and are not — a heading in a fenced code block is
> not an anchor, an emoji is dropped from the slug while its invisible variation
> selector is kept, and **a heading inside a blockquote is not indexed** though
> GitHub renders it as linkable, so link to the enclosing section instead. Its
> docstring explains all three; read it before "fixing" a report.

```
Add August scan; brake fluid overdue since 2022

Service history shows last flush at 41,424 mi (2020-09-15), ~55,400 mi
and six years ago. Raised to action item 3, ahead of ABS diagnosis.
```

**Check the archived primary sources before researching online.** Once a manual
is archived and text-extracted, grep it first. It is authoritative, faster, and
free of the guesswork that aggregator sites introduce.

## Evidence discipline

This is what separates a useful record from a confident-sounding one. Full
detail in [references/evidence.md](references/evidence.md).

**Mark confidence explicitly.** Tag facts `[confirmed]` when they come from the
thing itself or its official documentation, `[verify]` when they're the standard
value for the category but unchecked for this specific item. Never state a part
number, capacity or interval as fact because it's typical — say where it came
from. Owners act on these; a wrong part number costs them a return trip.

**Absence of a record is not evidence of absence.** Write "no record of X since
\<date\>" — never "X was skipped" or "X was never done." Not everything is done
by a professional, and not everything a professional does gets reported. This
mistake is easy and tempting because it almost never changes the recommendation.
When something is cheap, degrades invisibly, and can't be assessed by eye, the
honest framing reaches the same action: *we don't know, redoing it costs little,
skipping it may cost a lot — so do it and start the clock from a date we own.*

**When sources conflict, say so and name the authoritative one.** Don't
silently pick. Recording that a history report and a government database
disagree is more useful than either answer alone.

**Separate urgency from importance.** Most findings are not emergencies.
Inflating them burns the credibility you need when something genuinely is one.

## Researching the gaps

Records answer what happened. Owners also need what they *don't* know — the
maintenance item that isn't on the standard schedule, the recall nobody
mentioned, where authoritative data actually lives.

Run distinct questions as parallel subagents rather than one sweeping search;
they cover more ground and their sources can be cross-checked. Useful axes:

- **Official channels** — manufacturer manuals, technical portals, what they
  cost, what a private owner can actually buy
- **Government and regulatory** — recalls, complaints, inspections, permits.
  Often free APIs; note that thin data on a low-volume item is weak evidence of
  absence, not proof of a clean record
- **Known issues for this class of thing** at its current age or usage
- **Where the community documents things** — forums, specialist vendors with
  real technical writing

Demand that findings come back marked by confidence and with sources, and
propagate them like any other intake.

## Archiving what you find on the web

Research turns up a page that answers a question about this thing. **Bookmarking
it is not keeping it.** Measured on one record: of 48 links kept six years
earlier, **~40% had rotted** — 8 survived only in the Wayback Machine and 5 were
gone from both. A record that needs a working internet connection to answer a
question is not a durable record.

So `curl` it in, `bin/extract-text` beside it, and cite the local path; keep the
URL as provenance. Then grep the local copy before searching the web again.

Three things to know before the first fetch:

- **Ask what you are actually archiving.** Repeatedly, a linked page is one part
  of something larger and nothing on it says so: a 22-page thread saved as page
  1, one article of an eight-part series, two bookmarks that were an 86-page
  site. Look for pagination, "next / part II" links, and an index on the same
  site — *then* fetch the set. This is the cheapest and highest-value check
  there is.
- **The failure mode is not "the fetch errored."** It is a page that sits on
  disk at a plausible size, extracts cleanly, and is quietly missing its
  images, its later pages, or — four separate ways — its ability to render at
  all. Run `bin/archive-check` afterwards.
- **A live page beats a snapshot.** Reach for the Wayback when a page is gone,
  not when it is merely awkward to fetch.

Full method, twelve traps and how each was found:
[references/archiving-web-content.md](references/archiving-web-content.md).
Tools: `bin/archive-page` fetches and repairs, `bin/archive-check` verifies,
`bin/archive-browse` serves the archive so a human can read it back.

## Before sharing or publishing

A record accumulates things that shouldn't be public. Audit before anyone makes
a repository public or sends it on — see
[references/publishing.md](references/publishing.md).

The short version: **going public is one-way.** Clones, forks and mirrors aren't
recalled by flipping visibility back. Check for the owner's financial details,
identifiers, third-party copyrighted material they'd be republishing, and
anything about other people. Private-first with collaborators added is almost
always the right order, and a public version — if wanted — is a *separate*
repository with fresh history carrying the method and none of the documents.
