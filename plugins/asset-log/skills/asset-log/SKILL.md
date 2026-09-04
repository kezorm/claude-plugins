---
name: asset-log
description: Set up and maintain a durable, self-contained record for something the user owns — a vehicle, house, boat, rental property, tools, or equipment — from scattered documents, photos, receipts, inspection reports and manuals. Reach for this above all when a record is being started from nothing — someone just bought or inherited something, has a folder or pile of paperwork about it, and wants to stop losing track. Also use it when filing new documents into a record that has no working rules of its own, when an inspection or scan report needs interpreting, or when someone says they want to keep track of or stay on top of something they own — even if they never say repository, archive, or documentation. The first setup is where this matters most; a record that already carries its own rules mostly runs itself.
---

# Asset Record

Turn the documents scattered around something someone owns — a vehicle, a
house, a boat, a rental unit, a homelab, a shop full of tools — into a record
that stays current, says what needs attention, and survives being handed to a
contractor, a buyer, or a future owner.

**See it in action:**
[vehicle-silverado-example](https://github.com/kezorm/vehicle-silverado-example)
— a mature record, showing the structure and conventions.

## Which mode you are in

**The record already has a `CLAUDE.md` or equivalent working-rules file** —
follow that and stop consulting this skill. Its rules are more specific and take
precedence. Return only when the rules themselves need changing.

**Its `.claude/method.md` is stale** — `md5sum` it against
[references/template/.claude/method.md](references/template/.claude/method.md),
read [CHANGELOG.md](CHANGELOG.md) from its version heading forward, overwrite
the file, then review that record's `CLAUDE.md` for anything the update now
duplicates or contradicts. Never hand-edit `method.md`.

**No record yet, or a record with no rules of its own** — the rest of this file.
Setup is where the effort pays.

## The rules a record runs on

The full set is
[references/template/.claude/method.md](references/template/.claude/method.md),
which ships verbatim into every record. **Read it when filing into a record that
has none.** The three that carry the most weight:

1. **Propagate to every layer in the same sitting** — the artifact, the write-up
   covering that subject, and the top-level `README.md`. The third is the one
   people skip, and skipping it is how a folder becomes a junk drawer. If
   nothing changes at the top, say so rather than skipping silently.
2. **Capture completely; triage separately.** *"Does this change anything?"* is
   the wrong test for an archival fact. A paint code, a serial number, a
   firmware version and a vendor's name change nothing today and are the reason
   the record exists in ten years.
3. **Mark confidence.** `[confirmed]` from the thing itself or its official
   documentation; `[verify]` for a value that is typical but unchecked.

## Setting up a new record

Ask first — these change the shape of everything:

- Version controlled, or plain folders? Git is usually right. It needs delete
  permission on the folder to manage `.git/index.lock`; request that up front if
  the environment restricts deletes.
- What formats will arrive — photos, PDFs, spreadsheets, email?
- What matters to track beyond the obvious — costs, warranty dates, usage hours,
  power draw?

Then create only this, copied from
[references/template/](references/template/) with the placeholders filled:

```
.
├── _inbox/            drop zone; contents gitignored until triaged
├── README.md          current status, open items, what's coming
├── CLAUDE.md          THIS record's specifics; imports the method below
├── .claude/method.md  the shared method, verbatim, versioned
└── bin/               the scripts
```

- **`CLAUDE.md` opens with `@.claude/method.md`** — an import, not a link.
  Imports expand into context at launch; a markdown link is read at the model's
  discretion. Both files live in the record, so it stays self-contained.
- **Keep `.claude/method.md` verbatim and never edit it.** Everything specific
  to this thing goes in `CLAUDE.md`. That split is what makes an update "replace
  one file, review the other."
- **Do not scaffold a folder tree.** Make a folder when a document arrives that
  needs one. A vehicle, a house and a rack of servers need different homes for
  different things, and an empty guessed-at folder invites documents into the
  wrong one.
- **Do not ship a thin `CLAUDE.md`.** Every later session inherits its judgment
  from that file, with or without this skill. Add what is specific to this
  thing: which intervals bind on the calendar rather than on usage, which
  sources proved unreliable, what conventions this record settled and why.
- **Setup includes the first intake.** File the documents that prompted it,
  write up what they say, and surface what needs attention. Don't hand back an
  empty shell.
- **Write the working rules into the record.** A record that depends on an
  assistant's memory or one machine is not durable.
- **The inbox takes anything, with no naming convention and no decisions.**
  `bin/inbox-status` inventories it. Gitignore the contents, track its README.

## What this needs, and what to do without it

Check with `command -v` rather than assuming. Degrade quietly and say so once.

| Needs | Used for | Without it |
|---|---|---|
| A filesystem and shell | Everything | On a surface with no filesystem (claude.ai chat) this skill mostly cannot run. Say so, and offer what is possible: read what the user pastes, produce the analysis and a README they save themselves. |
| `pdftotext` (poppler) | Text beside every PDF | Offer the install (`brew install poppler` / `apt install poppler-utils`). If refused, read PDFs directly and transcribe key figures by hand so the numbers stay searchable. |
| `docling` *(optional)* | Reliable table extraction | Not required. `uvx docling --to md <pdf>` needs no install but downloads models on first run. Worth it when a document's meaning is in its tables. |
| `wget` | `bin/archive-page` | Only for archiving from the web. Without it, `curl` the HTML alone and say plainly that the page's images were not kept. |
| `git` | History, and "what did we know when" | Plain dated folders work. State the tradeoff once and move on. |
| Delete permission on the folder | `git` unlinking `.git/index.lock` | If git fails with "Operation not permitted", request delete access before continuing. |
| Subagents | The research phase | Do the research inline, sequentially. Slower, same output. |

## Intake

Full detail — routing, deduplication, table pitfalls, commit messages — is in
[references/intake.md](references/intake.md). Read it when filing.

- **Read every file before filing it.** The filename is a guess; the contents
  are the fact. Stage images where you can actually look at them.
- **Deduplicate by checksum.** Owners re-send things.
- **Rename so a human can read it** — `roof-inspection-2026-07-06.pdf`, not
  `Report_104_S639234483889667912.pdf`. Renaming in bulk, keep a provenance file
  mapping new names to originals.
- **Extract text beside every PDF** — `pdftotext -layout in.pdf out.txt`,
  batched by `bin/extract-text`. This is the highest-leverage habit here: an
  archived manual then beats the internet for questions about this specific
  thing.
- **A scan with no text layer produces no `.txt` and still reports success.**
  `extracted=0 … failed=0` is indistinguishable from "nothing to do", so check
  that a `.txt` appeared. When a PDF is pure image, **type it out by hand**,
  save it as the `.txt`, and mark at the top that it is a transcription.
- **Run `bin/eml-text` beside every `.eml`.** A `.eml` will not grep; the part
  that matters is usually quoted-printable HTML. Keep both the plain-text and
  HTML parts — vendors routinely put full item descriptions only in the HTML.
- **Treat extracted tables as suspect.** `pdftotext` rebuilds columns from
  character positions and gets tables wrong silently. Verify one row you can
  confirm independently; when a document's value *is* its tables, re-extract
  with `uvx docling --to md file.pdf`. `bin/extract-text` flags tabular-looking
  files.
- **Transcribe photographed labels into markdown.** A photo of a data plate is
  not data until the numbers are text.
- **Assert that an edit's anchor matched.** A find-and-replace that matches
  nothing reports success. Check `git status` afterwards, and verify a bulk edit
  by re-deriving the result from the source, never by the loop finishing.
- **Then the digest, then `README.md`, then `bin/check-links`, then commit.**
  Read `check-links`'s docstring before treating its report as a bug — three of
  its behaviours look like bugs and are not.
- **Commit messages state what was learned, not what moved.**

```
Add UPS self-test log; battery pack past service life

Self-test on 2026-08-14 held 4 minutes against 22 minutes when new, and the
pack date code reads 2019. Raised to item 1 — the NAS runs off this UPS.
```

- **Grep the archived primary sources before researching online.** They are
  authoritative, faster, and free of aggregator guesswork.

## Evidence

Full detail in [references/evidence.md](references/evidence.md).

- **Never state a part number, capacity or interval as fact because it is
  typical.** Say where it came from. Owners spend money against these.
- **Absence of a record is not evidence of absence.** Write *"no record of X
  since \<date\>"* — never "was skipped" or "was never done". Same caution for
  thin data: zero reports on an uncommon item is weak evidence, not a clean
  record.
- **Anything read off a photograph is a proposal, not an observation** — and
  *"I can't see it"* is not *"it isn't there."*
- **When sources conflict, record the conflict and name which one governs.**
  Don't silently pick.
- **Separate urgency from importance.** Inflating a finding spends the
  credibility you need when something genuinely is urgent.
- **Flag your own weakest claim.** Every research pass has one.

## Researching the gaps

Records answer what happened; owners also need what they don't know. Run
distinct questions as parallel subagents rather than one sweeping search, and
require that findings come back marked by confidence and with sources.
Propagate them like any other intake. Useful axes:

- **Official channels** — manufacturer manuals, technical portals, what they
  cost and what a private owner can actually buy
- **Government and regulatory** — recalls, complaints, inspections, permits
- **Known issues for this class of thing** at its age, usage or firmware level
- **Where the community documents it** — forums, specialist vendors, project
  wikis

## Archiving what you find on the web

**Bookmarking is not keeping.** Measured on one record, ~40% of six-year-old
links had rotted. `curl` or `bin/archive-page` it in, extract text beside it,
cite the local path and keep the URL as provenance. Full method and the traps
that produce a plausible-looking broken archive:
[references/archiving-web-content.md](references/archiving-web-content.md).

- **Ask what you are actually archiving, before fetching.** A linked page is
  often one part of something larger — page 1 of a thread, one article of a
  series. Look for pagination and an index, then fetch the set.
- **The failure mode is not a fetch error.** It is a page on disk at a plausible
  size, quietly missing its images, its later pages, or its ability to render.
  Run `bin/archive-check` afterwards.
- **A live page beats a snapshot.** Reach for the Wayback Machine when a page is
  gone, not when it is awkward to fetch.

Tools: `bin/archive-page` fetches and repairs, `bin/archive-check` verifies,
`bin/archive-browse` serves the archive to read back.

## Before sharing or publishing

See [references/publishing.md](references/publishing.md).

- **Going public is one-way.** Clones, forks and mirrors are not recalled by
  flipping visibility back. Private-first with collaborators added is the
  reversible order.
- **Audit for** the owner's financial details and identifiers, third-party
  copyrighted material they would be republishing, and anything about other
  people. Commit metadata carries a name and email too.
- **Credentials are audited at filing time, not here** — history is permanent by
  the time anyone considers sharing.
- **A public version is a separate repository with fresh history**, carrying the
  method and none of the documents.
