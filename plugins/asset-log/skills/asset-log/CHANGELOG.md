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
