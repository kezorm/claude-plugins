# Changelog — asset-log method

The version here matches the stamp at the top of `references/template/.claude/method.md`,
which is copied verbatim into every record created from this skill.

`.claude/method.md` is **byte-identical in every record** — it contains no
placeholders and is never substituted. So the quickest check of whether a record
is current is a checksum:

```sh
md5sum <record>/.claude/method.md references/template/.claude/method.md
```

**To bring an established record up to date:** read the version heading in its
`.claude/method.md`, read the entries below that are newer, overwrite the file
from the current skill, then review that record's `CLAUDE.md` for anything the
update now duplicates or contradicts.

Entries describe changes to the *method* — the conventions a record inherits.
Skill-only changes (how the setup conversation runs, research guidance) are not
listed, because they don't propagate into records.

---

## v1.7.0

> **`method.md` moves to v1.7.0**, so established records are now out of date.
> Overwrite `.claude/method.md` from this skill and review the record's
> `CLAUDE.md`.

**The credential audit was in the wrong place, and it was the only place.**

Until now the method's only guidance on sensitive material sat under *Before
sharing* — audit the owner's information, third-party copyright, and anything
about other people, before anyone makes the record public. That is the right
advice for prices and addresses. **It is the wrong time for credentials.**

Git history is permanent. A card number committed on a Tuesday is in every
clone that ever existed, and switching a repository to private later recalls it
no better than switching it to public was reversible. By the time a sharing
audit runs, the damage is already distributed. The audit has to run **before
the commit**.

Two documents in one vehicle record made the point. The first was an email in
which the owner had sent a supplier a full card number, expiry and CVV in
cleartext; it was caught, and the fix — commit a redacted transcript, keep the
original outside the repository, say in the transcript where it lives — had to
be invented locally, because the method offered nothing.

The second was worse, because the local rule that the first produced **ran clean
over it.** A supplier's invoice printed their own sort code, eight-digit account
number and IBAN in the payment footer. The check that had been written after the
first incident was a card-number pattern: sixteen digits in groups of four. A
sort code is six digits, an account number eight, and an IBAN's groups are not
4-4-4-4, so it matched none of the three and reported the file safe.

Hence the rule's second half, which is the part that generalises: **match the
labels, not the number shapes.** Anything that looks like a payment instruction
gets read, not pattern-matched.

Scope note: the specific expression — which patterns, which currencies, which
banking conventions — stays in a record's own `CLAUDE.md`. What propagates is
the timing and the principle.

**Also in this release: the method version is no longer restated in
`CLAUDE.md`.** Both the template and a live record carried a second copy of the
version number in prose, and **both were still saying v1.5.0 after the v1.6.0
bump** — the update replaced `method.md` and missed the restatement, in two
places independently. The stamp at the top of `method.md` is the single source
of truth, and the checksum is the real test. `CLAUDE.md` now points at it
instead of repeating it.

## v1.6.0

> **`method.md` moves to v1.6.0**, so established records are now out of date.
> Overwrite `.claude/method.md` from this skill and review the record's
> `CLAUDE.md`.

**A reading has two parts, and the confidence tag only covers one.** The value,
and the field it belongs to. Data plates lose their printed field labels long
before they lose their struck digits, so the field gets assigned by position —
and that inference then inherits the tag the digits earned.

In one vehicle record a number was read off a plate by the owner, correctly, and
filed `[confirmed — owner]` as the body number. It was the gearbox number. It
stood for a week, propagated into three documents, invented an identifier the
record described as "permanently lost", and blocked an action item that depended
on the number it had supposedly lost. Nothing in the confidence scheme could
catch it: the scheme was answering a question that was not in doubt.

The rule is to **say when a field was inferred**, and when a document later
supplies the same values, to **check the assignments, not just the digits.**

**Write down what a pending document is expected to settle — and what it will
not.** Two rules in one, from opposite failures in the same session.

A predicted value is falsifiable and worth having: *"the body plate should read
41531"* was written before the plate was photographed, and when it was read it
agreed. That agreement is corroboration; a mismatch would have been loud.

The inverse is the commoner error. Two documents in the same record stated that
an ordered factory certificate "would close" a nine-year gap in the item's
history. It arrived and did not — it named the distributor and recorded no
dealer and no registration. A forecast had been written as a certainty, and an
open question came close to being closed on paper by a document that never
answered it.

**A filing pass fails silently at the edit.** A find-and-replace that matches
nothing reports success. Assert the anchor matched, then check `git status`;
verify a bulk edit by re-deriving the result from the source, never by the loop
finishing. This fired during the session that prompted this release — an edit
whose anchor wrapped across a line break differently than assumed — and it was
caught only because the match count was being asserted.

**Also in this release, not part of the method:**

- **A scan with no text layer produces no `.txt`, and the run reports success.**
  `extract-text` skips what it cannot extract, so `extracted=0 … failed=0` reads
  as "nothing to do". Check that a `.txt` appeared; when a PDF is a pure image,
  type it out by hand and mark the file as a transcription rather than an
  extraction. Identity documents and certificates arrive this way constantly.
- **Processing an image does not upgrade it.** Contrast, sharpening and gradient
  subtraction amplify corrosion, casting texture and paint damage identically to
  the marks you want, and at useful strength render strokes that are not there.
  An enhanced crop is a *different proposal*, not a better source. Added to
  `references/evidence.md`.
- **`check-links` documents its third surprising behaviour.** A heading inside a
  blockquote is **not** indexed — the pattern requires the line to start with
  `#` — while GitHub renders it as linkable, so a link to one is reported broken
  here and works there. Records use blockquote headings heavily for dated
  corrections, so this comes up. The emoji/variation-selector and fenced-code
  behaviours were already documented; this one was not. **Documented, not
  changed** — see the open question below.

**Open question, deliberately not decided here.** Should `check-links` index
blockquote headings instead of reporting them broken? It is arguably a false
positive, and false positives train you to ignore a validator. Against that,
loosening a validator's semantics across every record risks accepting links that
do not resolve. Left as documentation until that is decided.

---

## v1.5.0

> **`method.md` moves to v1.5.0**, so established records are now out of date.
> Overwrite `.claude/method.md` from this skill and review the record's
> `CLAUDE.md`.

**`method.md` is now rules, not explanations — 276 lines to 193, 2,093 words to
1,386.** Every rule survived; what went was the prose justifying each one. The
file is imported at the start of every session in every record, so its length is
a cost paid on every task, and it had accumulated illustrations, worked examples
and "why this error is tempting" paragraphs around rules that stand on their
own. Where a rule is meaningless without its reason, one clause of reason
stayed.

**The template `CLAUDE.md` was causing the same growth and is fixed.** Its
guidance invited war stories — *"these are worth more than the rules they
illustrate"* — and one record's rules file reached 671 lines under it. It now
asks for the rule in one or two lines with the incident and evidence in the
document that owns the subject, and says plainly that a rules file full of war
stories stops being read.

**Purchase paperwork is ranked by how close it is to the money.** Filing an
order's email trail had no guidance beyond "read it before filing it", and two
records lost the same fact twice: a line item that was ordered, invoiced in the
confirmation, and never supplied.

The new **Purchase paperwork: the money is the fact** section in `Filing` ranks
the documents — payment record, invoice, confirmation-with-per-item-status,
plain confirmation, dispatch notice — and says to keep the top of the stack.

Three rules come with it:

- **A confirmation is not an invoice.** Nothing amends it after the order is
  placed, so a cancellation leaves it reading as though the part arrived.
- **The vendor's own corrected total is not the payment either.** A retailer
  that cancels a line will recompute its own document and still get it wrong —
  one dropped the cancelled item from the subtotal while keeping the original
  tax, overstating the cost by $3.78. Only the refund receipt was right.
- **Record the vendor's stated reason for a cancellation.** *"Part is no longer
  available"* is a fact about the world, not about the order.

**Also in this release, not part of the method:**

- **`bin/eml-text`** joins the shared scripts — converts `.eml` to greppable
  text, keeping both the plain-text and HTML parts, because retailers routinely
  put the item description only in the HTML.
- **`bin/archive-page` bug fix.** Every post-processing step keyed off the files
  that run created, so a page left behind by an interrupted fetch got no `.txt`,
  no lazy-image promotion and no `<noscript>` unwrap — and the run reported
  `0 page(s)` beside a healthy file count while looking like a success. It now
  sweeps the destination for pages with no `.txt` and repairs them. Written up
  as the twelfth trap in `references/archiving-web-content.md`.

---

## v1.4.0

> **`method.md` moves to v1.4.0**, so established records are now out of date.
> Overwrite `.claude/method.md` from this skill and review the record's
> `CLAUDE.md`.

**Corrections are governed by reliance, not by wrongness.** The old rule said a
wrong conclusion should be "withdrawn in place rather than deleted," on the
grounds that preserving the correction "tells a reader the record is maintained
by someone who checks." In practice that rule fired on everything, including
ordinary drafting — a misread label, a number transcribed wrong, a conclusion
that lasted an hour. The result was documents carrying a running commentary on
their own past mistakes, which is harder to read and teaches the reader the
wrong fact on the way to the right one.

The rule now turns on one question: **did anyone rely on it?**

- **Nobody acted on it** — correct it silently. The old text is in the commit
  history, dated, with a message saying what changed. Filing step 11 already
  requires that message.
- **Someone acted on it** — money spent, work skipped, a part ordered, an
  inspection not done — the fact that it was believed is part of the item's
  history and goes in the **log** as a dated entry, not as an annotation inside
  a reference document.
- **Dated analyses** are unchanged in spirit and sharper in practice: never
  rewrite them. Additions go in as dated notes; when one is overtaken rather
  than extended, write a new one and mark the old **Superseded**.

Rationale: a record earns trust by being accurate, not by displaying its scars.
The history mechanism a record already has — git, with commit messages that say
what was learned — is better at preserving supersession than inline prose, and
costs the reader nothing.

*Prompted by a working session on a vehicle record where a live diagnostic
document accumulated four correction blocks in a day, none of which any decision
had depended on.*

---

## v1.3.0

> **`method.md` moves to v1.3.0**, so established records are now out of date.
> Overwrite `.claude/method.md` from this skill and review the record's
> `CLAUDE.md` for rules this now duplicates — several records grew a private
> version of the photograph rule below, and the record-specific copy should be
> trimmed to whatever is genuinely local to that item.

- **Anything read off a photograph is a proposal, not an observation.** The
  method already said a photographed label isn't data until transcribed; it did
  not say that the transcription is itself a claim needing confirmation. This
  broadens it past numbers to **part identification, condition, variant, and
  presence**, and asks that `[confirmed — owner]` stay visibly distinct from an
  assistant's reading.
- **"I cannot see it in this photograph" is not "it is not there."** The
  dangerous direction, and the same logical error the method already names for
  records. Reporting a part as missing sends the owner hunting for something
  never lost and writes a false gap into the record.
- **A `[verify]` tag does not rescue a wrong reading.** On a value nobody will
  independently re-derive, it is a wrong claim with a disclaimer, and it
  propagates into digests and commit messages just as fast as a confirmed one.
  Ask instead.
- **Verify figures against their source before publishing them.** The method
  covered *extraction* going wrong; this covers *write-up* going wrong. Grep
  each figure back out of the file it came from before committing — it catches
  values that drift in transcription, quotes paraphrased past what the source
  says, and figures attributed to the wrong document. Worked example and a
  one-line shell helper in `references/intake.md`.

Fuller treatment of the photograph rule, with a two-row worked example of the
same component misread twice in two days, is in `references/evidence.md`.

## v1.1.0

- **Two jobs, two clocks.** Added the distinction between the triage view
  (episodic — an overdue item closes forever) and the archive (cumulative, and
  usually why the record still exists in ten years). The method had been leaning
  on the first at the expense of the second.
- **"So what, does this change anything?" is the wrong test for archival facts.**
  Capture completely, triage separately. A paint code changes nothing today and
  is exactly what's wanted years from now.
- **Write for a reader arriving in ten years knowing nothing** — quite possibly
  the owner, having forgotten.
- **Flag your own weakest claim.** Every research pass produces one conclusion
  resting on thinner evidence; name it.
- **Watch which limit binds.** Where something carries both a usage interval and
  a calendar limit, work out which arrives first. On lightly used things the
  calendar usually wins and nothing warns you.
- **Extracted tables are unreliable.** `pdftotext` rebuilds columns from
  character positions and gets tables wrong silently. Verify one
  independently-checkable row; anchor rows to their own page's header when a
  table spans pages; reach for `uvx docling --to md` when the tables *are* the
  content.
- **Two-file structure.** The method moved to `.claude/method.md`, imported by
  `CLAUDE.md` with `@` so it loads deterministically. Record-specific rules stay
  in `CLAUDE.md`. This is what makes the method replaceable rather than
  something to reconcile by hand.
- **No placeholders in the method.** It carries no `<<ASSET_NAME>>` and is never
  substituted at setup, so it stays byte-identical across every record — which
  is what makes `cp` a safe update and `md5sum` a valid currency check. The
  version is a visible heading rather than an HTML comment, since comments are
  stripped before reaching context and a session could not otherwise see which
  version a record is on.

## v1.0.0

Initial method. Three-layer propagation (artifact → digest → top-level status);
document roles with dated analyses annotated rather than rewritten; read every
file before filing it; text extraction beside every PDF; transcribe photographed
labels; confidence tagging with `[confirmed]` / `[verify]`; absence of a record
is not evidence of absence; name which source governs a conflict; structure
emerges rather than being scaffolded; self-containment; the pre-sharing audit.

## v1.2.0

> **`method.md` stays at v1.1.0** — it is deliberately unchanged, so an
> established record is still current and `md5sum` still answers "am I on the
> latest method?" correctly. This release adds a reference and four scripts
> around it. (`plugin.json` was on 1.0.0 and had drifted; it is now 1.2.0.)

**Archiving from the web, and the tools to do it.** Research constantly turns up
a page that answers a question, and a bookmark is not a copy: measured on one
record, **~40% of six-year-old links had rotted** — some recoverable only from
the Wayback Machine, some gone entirely.

New reference: `references/archiving-web-content.md` — the full method, written
from ~250 pages archived into a working record and eleven distinct ways of
getting it wrong. Deliberately a *reference*, not part of `method.md`: it is
loaded only when a session actually archives something, so records about houses
and camera kits pay nothing for it.

Four scripts, in `scripts/` and `references/template/bin/`:

- **`archive-page`** — wraps `wget`, rejects trackers and webfonts, writes a
  `.txt` beside every page, and repairs four faults at fetch time that each
  produce a page which looks archived and will not render: content served only
  inside `<noscript>`, a loading overlay the site's own JavaScript would have
  removed, lazy-loaded `<img>` tags carrying no `src`, and gzipped HTML wget
  cannot parse.
- **`archive-check`** — verifies that saved pages *render*, not merely exist.
  Exits non-zero when a page is genuinely unreadable. This exists because four
  such faults were found by a human opening pages that had passed every other
  check.
- **`archive-browse`** — serves the record over `http://` with an index, because
  a `file://` page cannot reliably load its own images. Groups by source site,
  collapses byte-identical CMS aliases (one WordPress post was stored **nine**
  times), hides RSS feeds saved as `.html`, and shows each page's size
  *including the images it pulls*.
- **`check-links`** — now validates the `#fragment` as well as the path. On one
  record that found five dead cross-references pointing at reworded headings,
  which nothing else surfaces: the file exists and the link looks fine.

`method.md` is unchanged, so established records need no migration — copy the
new scripts into `bin/` and add a line to `CLAUDE.md` if the record archives
web pages.

**Two rules worth stating outside the reference**, because they cost real data
here: **never round-trip an archived page through text I/O** — reading it as
UTF-8 and writing it back rewrites CRLF and turns invalid bytes into U+FFFD,
which silently stripped 5,787 bytes from a committed page — and **triage before
the first commit**, because afterwards deleting reclaims nothing.
