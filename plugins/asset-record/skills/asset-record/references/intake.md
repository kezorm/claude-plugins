# The Intake Loop

What to do when documents arrive. Read this when filing anything into a record.

## Order of operations

1. **Inventory** — `scripts/inbox-status`. Know what arrived before touching it.
2. **Read every file.** Not the filename — the contents.
3. **Deduplicate** against what's already filed, by checksum.
4. **Route** to its home.
5. **Rename** to something a human can read.
6. **Extract text** beside every PDF.
7. **Transcribe** anything that's only legible as an image.
8. **Write or update the digest** for that subject.
9. **Update the top-level status** — the step people skip.
10. **Verify links** — `scripts/check-links`.
11. **Commit** with a message stating the finding.

## Reading before filing

The filename is the sender's guess about what a file is. It is frequently wrong
and occasionally the opposite of the truth. Three photos named `IMG_0854`,
`IMG_0858`, `IMG_0859` turned out to be a refrigerant label, a federal
certification plate, and a tire placard — carrying pressures, weights, a paint
code and a previous owner's handwritten service note.

For images, stage them somewhere you can actually view them. For PDFs, extract
text and read it. For spreadsheets, open them. Filing blind produces a tidy
folder full of mysteries.

## Deduplication

Owners re-send things, and download scripts overlap with manual downloads.
Checksum before filing:

```sh
md5sum inbox/*.pdf
md5sum already-filed/*.pdf
```

Byte-identical means discard the new copy, not file it twice. Say which ones were
duplicates — it confirms an earlier step worked rather than looking like files
went missing.

## Routing by type

| What it is | Where it goes | What else updates |
|---|---|---|
| Acquisition paperwork | `purchase/` | identity doc, top-level status |
| Inspection / scan / assessment | `reports/YYYY-MM-DD/` | new analysis, comparison against the baseline, status |
| Invoice or receipt for work done | `service/YYYY-MM-DD-<what>/` | service log, close the matching open item |
| Manual, spec sheet, parts data | `reference/` | the relevant reference doc |
| Notice, recall, campaign | `reference/` | status if it needs action |
| Photos of labels or data plates | `reference/labels/` | transcribe into markdown |
| Anything unclear | leave in the inbox | ask |

## Preserving originals

Rename and move; never rewrite, recompress or "clean up" a source document. The
original is evidence. If it needs to be smaller, keep the transformation
lossless with respect to content and say exactly what was removed — for example,
stripping embedded UI images from a saved web page while verifying the extracted
text is byte-identical before and after.

When renaming in bulk, write a provenance file mapping new names to originals so
nothing becomes untraceable.

## Extracted tables are the weak point

`pdftotext -layout` reconstructs columns from character positions on the page.
It is fast, universally available, and good enough for prose. **It is not
reliable on tables**, and asset records are full of them — service schedules,
spec charts, pressure tables, parts lists. These are exactly the documents where
a wrong number costs real money.

Three failures from a single real record, all silent:

- **A service-interval chart.** The table marked each item's due points with `X`
  under mileage columns. The first extraction put the timing belt at 140k instead
  of 150k, brake hoses at 70/140 instead of 40/80/120, and transmission fluid at
  50/100/150 shifted to 40/90/140. Cause: the table spanned pages whose
  indentation differed, and every row had been anchored to the first page's
  header. **Wrong service intervals for a safety-critical item, and nothing about
  the output looked broken.**
- **A two-column manual page.** The columns interleaved on extraction, producing
  a paragraph that named two different oil grades in adjacent lines. Unresolvable
  from the text; the answer required opening the PDF.
- **A diagnostic report.** Fault descriptions that happened to start at column 0
  were indistinguishable from section headers, so codes were filed under the
  wrong modules until the header detection was constrained.

### What to actually do

**Verify one row you can check independently.** This is free and catches most of
it. In the chart above, the error surfaced because a related item in the same
footnote read 150k while the extraction said 140k — two numbers that had to
agree, and didn't. Pick a value you can confirm from another source and confirm
it before trusting the rest.

**When a table spans pages, anchor each row to its own page's header** rather
than to the first one. Page indentation shifts more often than you'd expect.

**When the tables *are* the content, use a structure-aware extractor.**
[Docling](https://github.com/docling-project/docling) (IBM, MIT-licensed) runs a
layout model plus a dedicated table-structure model and emits markdown with the
tables intact:

```sh
uvx docling --to md service-schedule.pdf
```

No install needed via `uvx`; the first run downloads models, so it's slow once
then fast. It is not a requirement of this workflow — `pdftotext` remains the
default because it's instant and always present. Reach for docling when a
document's value is in its tables, or when a spot-check fails.

`bin/extract-text` flags files whose layout looks tabular so you know which ones
deserve the scrutiny.

## Transcribing images

A photograph of a data plate is not data until the numbers are text. Put the
image in the record, then transcribe it into a table beneath the link:

```markdown
## [Tire and Loading Placard](tire-placard.jpg)

| Position | Size | Cold pressure |
|---|---|---|
| Front | 255/35R20 | 39 psi (270 kPa) |
| Spare | T125/80R18 | 60 psi (420 kPa) |
```

Now it's greppable, quotable, and usable by someone who can't open images.

## Capture more than seems useful

When writing up a document, the temptation is to record what matters *now* and
skip the rest. Resist it. The filing pass is the only moment someone has the
document open and is paying attention — anything not captured then is
effectively lost, because nobody re-reads a filed PDF looking for facts they
didn't know they'd want.

Transcribe data plates completely. Record the full line-items on an invoice, not
just the one that prompted a finding. Note the vendor, the town, the technician's
remarks, the serial numbers, the dates stamped on parts. Capture what a previous
owner claimed *and* whether anything corroborates it.

None of that is actionable. All of it is what someone needs in ten years, and
none of it costs more than a few lines to keep.

## Owner statements are filings too

People rarely file a document that says "I changed the oil." They mention it.
Treat "I replaced the cabin filter last week, Mann CUK 34 003" exactly like a
received document: log it with part numbers and a date, propagate it, close the
matching open item.

If they give a date but no usage reading, either ask or record it as an explicit
estimate — `~12,400` with one line nearby saying what bounds it. An accepted
estimate is fine; an estimate silently presented as a reading is not.

## Commit messages

State what was learned. A message that only says what moved is a wasted chance
to make the history searchable.

Bad: `Add scan report and update files`

Good:
```
Add August scan; brake fluid overdue since 2022

Service history shows last flush at 41,424 mi (2020-09-15), ~55,400 mi and
six years ago against a 3-year interval. Raised to action item 3, ahead of
the ABS diagnosis it may be contributing to.
```
