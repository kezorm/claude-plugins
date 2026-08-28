# Changelog — asset-record method

The version here matches the stamp at the top of `references/template/.claude/method.md`,
which is copied verbatim into every record created from this skill.

**To bring an established record up to date:** read the stamp in its
`.claude/method.md`, apply the entries below that are newer than it, replace the
file wholesale, then review that record's `CLAUDE.md` for anything the update
now duplicates or contradicts. Bump the stamp.

Entries describe changes to the *method* — the conventions a record inherits.
Skill-only changes (how the setup conversation runs, research guidance) are not
listed, because they don't propagate into records.

---

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

## v1.0.0

Initial method. Three-layer propagation (artifact → digest → top-level status);
document roles with dated analyses annotated rather than rewritten; read every
file before filing it; text extraction beside every PDF; transcribe photographed
labels; confidence tagging with `[confirmed]` / `[verify]`; absence of a record
is not evidence of absence; name which source governs a conflict; structure
emerges rather than being scaffolded; self-containment; the pre-sharing audit.
