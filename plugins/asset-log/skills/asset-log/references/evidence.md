# Evidence Discipline

People spend money against a record's conclusions. A confident wrong number
costs a return trip, an unnecessary repair, or a missed real problem.

## Confidence tagging

Mark every specification with where it came from.

- **`[confirmed]`** — from the item itself, its data plates, or its official
  documentation
- **`[verify]`** — the standard value for this category, not checked against
  this specific item

```markdown
| Item | Value | Source |
|---|---|---|
| Max RAM | 128 GB ECC UDIMM | **[confirmed]** — board manual §2.3 |
| Drive bays | 8 × 3.5" SATA/SAS | **[confirmed]** — chassis nameplate |
| PSU | 2 × 750 W, 80+ Platinum | **[verify]** |
```

- **Never state a part number, capacity or interval as fact because it is
  typical for the model line.** Manufacturers make running changes; the item's
  own documentation is the authority.
- **Keep a "to fill in" list of open `[verify]` items.** Closing them pays off
  every time someone orders a part.

## Record the prediction, and its limits

- **When a document gives a value the item has not confirmed, write down what
  the item should show**, as a specific checkable value — *"the label inside the
  side panel should read `SMT1500RM2U`"*. That turns a passive `[verify]` into
  something that can be **broken**: if it holds, it corroborates; if it fails,
  it fails loudly.
- **Write down what a pending document will *not* settle.** Recording what it
  *will* settle, as a certainty, is how an open question gets closed on paper by
  a document that never answered it. When it arrives, go back to the places that
  were waiting on it.

## Absence is not evidence of absence

The same error appears in two media.

**In records:** write **"no record of X since \<date\>"** — never "X was
skipped," "X was missed," or "X was never done." Gaps have two explanations —
it didn't happen, or it happened and wasn't reported — and nothing in the gap
distinguishes them. Not every job is done by a professional, and not everything
a professional does gets reported.

**In photographs:** *"I cannot see it in this photograph"* is not *"it is not
there."* Reporting a part as missing is worse than misidentifying one — it
sends the owner hunting for something that was never lost and writes a false
gap into the record. **Say what the frames do and do not show.**

Also:

- **Thin datasets are the same shape.** Zero complaints on a low-volume item is
  weak evidence of absence, not proof of a clean record.
- **Column headers matter.** Label it **"Last documented"**, not "Last done."
  Use **"no record"**, not "never."

The honest framing usually reaches the same action and survives scrutiny:

> We don't know whether this was done. It degrades invisibly and can't be
> assessed by eye. If it was done recently, redoing it costs little. If it
> wasn't, it's years overdue. So do it, and start the clock from a date we
> actually own.

## A reading off a photograph is a proposal, not an observation

- **An image is evidence to be checked against the thing itself, never a source
  to be quoted.** Crop it, put it in front of the owner, and ask. This covers
  more than numbers: which part you are looking at, its condition, which of two
  variants it is, whether it is in the frame at all.
- **Processing an image does not upgrade it.** Contrast, sharpening and gradient
  subtraction amplify damage identically to the marks you want, and at useful
  strength render strokes that are not there. An enhanced crop is a *different
  proposal*; commit the honest view beside it.
- **Keep the reader distinct from the reading.** `[confirmed — owner]` and
  `[confirmed]` are different claims — only one of them can be re-checked
  cheaply later.

### The tag covers the value, not the field

A reading is two claims — **what the characters are**, and **which field they
belong to**. The tag only addresses the first.

Field labels are printed, etched or cast; the values are struck. Labels corrode
away first, so the field gets assigned by position — and that inference silently
inherits the tag the digits earned.

- **Say when a field was inferred.**
- **When a document later supplies the same values, check the assignments, not
  just the digits.**

### A `[verify]` tag does not rescue a wrong reading

On a value nobody will ever independently re-derive, `[verify]` is **a wrong
claim with a disclaimer attached**, and it propagates into digests, commit
messages and summaries as fast as a confirmed one. **Ask instead.** One message
against every decision made afterwards.

## When sources conflict

**Record the conflict and name the authoritative source.** Don't silently pick.

| Source | Says |
|---|---|
| Seller's disclosure | Roof replaced 2016 |
| County permit record | No roofing permit on file |
| Inspection report | Two layers of shingle, oldest ~2004 |

Then state which governs and why — here the permit record and the physical
inspection, because a disclosure is the seller's recollection.

If you resolve a conflict silently and your pick was wrong, nothing in the
record reveals the error.

## Correct silently; annotate only what was relied on

**The test is not "was this wrong?" It is "did anyone rely on it?"**

**Nobody did** — fix it and leave no trace in the prose. The old text is in the
commit history, dated. A note disowning an earlier version costs every future
reader attention and teaches them the wrong fact on the way to the right one.

Annotate in place in exactly two cases.

**When someone acted on it** — money spent, work skipped, a part ordered. It
goes in the **log** as a dated entry, not inside a reference document:

> **2026-08-27.** The annual service was skipped at the August visit because
> this record said it had been done. That was unsupported. What is known is that
> no record exists after 2020-09-15.

**When the document is a dated analysis** — a snapshot of what was believed at a
moment. Never rewrite one. Additions go in as their own dated note; when one is
overtaken rather than extended, write a new analysis and mark the old
**Superseded**, with a pointer forward.

**A record earns trust by being accurate, not by displaying its scars.**

## Separate urgency from importance

Most findings are neither emergencies nor trivia. Say which:

- **Act** — worth diagnosis or a scheduled fix
- **Watch** — unconfirmed, but would matter if it recurs
- **Minor** — real, but only affects convenience
- **Noise** — attributable to something already explained

**When a deadline is real, be specific about why.** *"The calendar limit arrives
in 17 months and usage will never trigger it"* lands harder than "this is
overdue" and is easier to act on.

## Flag your own weakest claim

Every research pass produces one conclusion resting on thinner evidence than the
rest. **Name it.**

> This is the weakest item here — the reading is inference from the code text,
> not a verified source. Have it looked up rather than acted on.
