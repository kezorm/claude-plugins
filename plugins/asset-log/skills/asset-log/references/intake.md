# The Intake Loop

What to do when documents arrive.

## Order of operations

1. **Inventory** — `bin/inbox-status`
2. **Read every file** — the contents, not the filename
3. **Deduplicate** against what is already filed, by checksum
4. **Route** to its home, making the folder if one does not exist
5. **Rename** to something a human can read
6. **Extract text** — `bin/extract-text` beside every PDF, `bin/eml-text`
   beside every `.eml`
7. **Transcribe** anything only legible as an image
8. **Write or update the digest** for that subject
9. **Update `README.md`** — the step people skip
10. **Verify links** — `bin/check-links`
11. **Commit** with a message stating the finding

## Reading before filing

**The filename is the sender's guess and is frequently wrong.** Three photos
named `IMG_0854`, `IMG_0858`, `IMG_0859` turned out to be equipment nameplates
carrying model numbers, service ratings and a previous owner's handwritten note.

- Stage images somewhere you can view them
- Extract PDFs and read the text
- Open spreadsheets

## Deduplication

Checksum before filing — owners re-send things, and download scripts overlap
with manual downloads.

```sh
md5sum inbox/*.pdf already-filed/*.pdf
```

Byte-identical means discard the new copy. **Say which ones were duplicates**,
so it reads as an earlier step confirmed rather than files gone missing.

## Routing by type

| What it is | Where it goes | What else updates |
|---|---|---|
| Acquisition paperwork | `purchase/` | identity doc, `README.md` |
| Inspection / survey / scan | `reports/YYYY-MM-DD/` | new analysis, comparison against the baseline, `README.md` |
| Invoice or receipt for work done | `service/YYYY-MM-DD-<what>/` | the log, and close the matching open item |
| Manual, spec sheet, parts data | `reference/` | the relevant reference doc |
| Notice, recall, campaign, advisory | `reference/` | `README.md` if it needs action |
| Photos of labels or data plates | `reference/labels/` | transcribe into markdown |
| Anything unclear | leave in the inbox | ask |

## Preserving originals

- **Rename and move; never rewrite, recompress or "clean up" a source
  document.** The original is evidence.
- If it must be smaller, keep the transformation lossless with respect to
  content and **say exactly what was removed**.
- **Renaming in bulk, write a provenance file** mapping new names to originals.

## Extracted tables are the weak point

`pdftotext -layout` reconstructs columns from character positions. Good enough
for prose; **not reliable on tables** — and records are full of them: service
schedules, spec charts, capacity tables, parts lists, rack inventories. These
are exactly the documents where a wrong number costs money.

**The failures are silent.** A service-interval chart marked with `X` under
mileage columns extracted with the timing belt at 140k instead of 150k and
brake hoses at 70/140 instead of 40/80/120, because the table spanned pages
whose indentation differed and every row was anchored to the first page's
header. Nothing about the output looked broken. Two-column manual pages
interleave into paragraphs naming two different values in adjacent lines.
Report text starting at column 0 is indistinguishable from a section heading.

### The rules

- **Verify one row you can check independently** before trusting the rest. This
  is free and catches most of it.
- **When a table spans pages, anchor each row to its own page's header.**
- **When the tables *are* the content, use a structure-aware extractor** —
  [Docling](https://github.com/docling-project/docling) runs a layout model plus
  a table-structure model and emits markdown with tables intact:

  ```sh
  uvx docling --to md service-schedule.pdf
  ```

  No install needed via `uvx`; the first run downloads models. `pdftotext`
  stays the default because it is instant and always present.
- **`bin/extract-text` flags files whose layout looks tabular.** Give those the
  scrutiny.

## Read every figure back out of its source

Extraction is one place figures go wrong; **writing them up is the other.**
When a document gathers numbers from several sources, grep each one back out of
the file it came from **before the commit, not after** — a reader years later
cannot tell which figures were checked.

```sh
chk () { grep -qi "$1" "$2" && echo "OK   $3" || echo "FAIL $3"; }
chk "1500VA"    manuals/ups-manual.txt        "UPS VA rating"
chk "12.7 kWh"  reports/2026-03-energy.txt    "monthly draw"
chk "RJ45 x24"  reference/switch-datasheet.txt "port count"
```

It catches three failures that look identical in a finished document: **the
value that drifted while being retyped**, **the quote paraphrased into
something the source does not say**, and **the figure attributed to the wrong
document.**

## Transcribing images

**A photograph of a data plate is not data until the numbers are text.** Put
the image in the record, then transcribe it into a table beneath the link:

```markdown
## [Nameplate — rack UPS](ups-nameplate.jpg)

| Field | Value |
|---|---|
| Model | SMT1500RM2U |
| Serial | 3S1812X09876 |
| Input | 120 V, 12 A, 60 Hz |
| Output | 1500 VA / 1000 W |
| Battery | RBC133, date code 2019-11 |
```

Now it is greppable, quotable, and usable by someone who cannot open images.

> **Transcribing is not confirming.** What you wrote down is *your reading of a
> photograph*, and it belongs to the owner to check before it becomes a fact —
> identifiers especially, since a wrong one misroutes every future lookup. See
> [a reading off a photograph is a proposal](evidence.md#a-reading-off-a-photograph-is-a-proposal-not-an-observation).

## Capture more than seems useful

**The filing pass is the only moment someone has the document open.** Anything
not captured then is effectively lost — nobody re-reads a filed PDF looking for
facts they didn't know they'd want.

Transcribe data plates completely. Record every line item on an invoice, not
just the one that prompted a finding. Note the vendor, the town, the
technician's remarks, serial numbers, dates stamped on parts. Capture what a
previous owner claimed *and* whether anything corroborates it.

## Spoken statements are filings too

People rarely file a document saying what they did — they mention it. **Treat
*"I swapped the failing drive last week, WD181KFGX, serial 2CGxxxxx"* exactly
like a received document:** log it with part numbers and a date, propagate it,
close the matching open item.

**If they give a date but no usage reading, ask or record an explicit
estimate** — `~12,400` with one line nearby saying what bounds it. An accepted
estimate is fine; an estimate presented as a reading is not.

## Commit messages

**State what was learned.** A message that only says what moved wastes the
chance to make the history searchable.

Bad: `Add scan report and update files`

Good:
```
Add August scan; brake fluid overdue since 2022

Service history shows the last flush at 41,424 mi (2020-09-15), ~55,400 mi and
six years ago against a 3-year interval. Raised to action item 3, ahead of the
ABS diagnosis it may be contributing to.
```
