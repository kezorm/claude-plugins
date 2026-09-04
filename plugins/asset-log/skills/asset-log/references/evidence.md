# Evidence Discipline

An asset record is something people spend money against. A confident wrong
number costs a return trip, an unnecessary repair, or a missed real problem.
These habits are what make the record worth trusting.

## Confidence tagging

Mark every specification with where it came from:

- **`[confirmed]`** — from the item itself, its data plates, or its official
  documentation
- **`[verify]`** — the standard value for this category, not checked against
  this specific item

```markdown
| Item | Value | Source |
|---|---|---|
| Oil capacity | 5.6 L / 5.9 US qt | **[confirmed]** — owner's manual p. 630 |
| Battery type | AGM, group H7 or H8 | **[confirmed]** — manual p. 591 |
| Brake fluid spec | DOT 4 low-viscosity | **[verify]** |
```

Keep a "to fill in" list of open `[verify]` items. Closing them is real work
that pays off every time someone orders a part.

The failure this prevents: stating that a part number, capacity or interval *is*
the value because it's typical for the model line. Manufacturers make running
changes. A specific item's own documentation is the authority.

## Record the prediction, and its limits

When a document gives a value the item itself has not confirmed, write down
**what the item should show**, as a specific checkable value — *"the plate
behind the bumper should read `41531`"*. That costs a sentence and turns a
passive `[verify]` into something that can be **broken**: if it later holds, the
agreement is corroboration; if it fails, it fails loudly.

**The inverse is the commoner error.** Recording what a pending document *will*
settle, as a certainty, is how an open question gets closed on paper by a
document that never answered it. Write what it will **not** settle too, and when
it arrives, go back to the places that were waiting on it.

## Absence of a record is not evidence of absence

Write **"no record of X since \<date\>"** — never "X was skipped," "X was
missed," or "X was never done."

Gaps have two explanations: it didn't happen, or it happened and wasn't
reported. Nothing in the gap distinguishes them. Not every job is done by a
professional, and not everything a professional does gets reported to a history
database.

The honest framing reaches the same action and survives scrutiny:

> We don't know whether this was done. It degrades invisibly and can't be
> assessed by eye. If it was done recently, redoing it costs little. If it
> wasn't, it's years overdue. So do it, and start the clock from a date we
> actually own.

The same reasoning applies to thin datasets. A government complaint database
showing zero reports for a low-volume item is weak evidence of absence, not
proof of a clean record.

Column headers matter too: label it **"Last documented"**, not "Last done." Use
**"no record"**, not "never."

## A reading off a photograph is a proposal, not an observation

Photographs are how most of a record gets captured, and they are the easiest
place to be confidently wrong. This applies to **more than numbers**: which part
you are looking at, what condition it is in, which of two variants it is, and
whether a component is in the frame at all.

**The rule:** an image is evidence to be checked against the thing itself, never
a source to be quoted. Crop it, put it in front of the owner, and ask.

**Processing an image does not upgrade it.** Contrast, sharpening and gradient
subtraction amplify corrosion and damage identically to the marks you want, and
at useful strength render strokes that are not there. An enhanced crop is a
*different proposal*, not a better source; commit the honest view beside it.

**Keep the reader distinct from the reading.** `[confirmed — owner]` and
`[confirmed]` are different claims. Whether a human looked at the object or an
assistant looked at a picture of it must stay visible, because only one of them
can be re-checked cheaply later.

### The tag covers the value, not the field

A reading is two claims — **what the characters are**, and **which field they
belong to**. The tag only ever addresses the first.

Field labels are printed, etched or cast; the values are struck. The labels
corrode away first, so the field gets assigned by position — and that inference
silently inherits the tag the digits earned. A number read correctly by the
owner and filed `[confirmed — owner]` can still be under the wrong heading.

**Say when a field was inferred**, and when a document later supplies the same
values, **check the assignments, not just the digits.**

### Asserting absence is the dangerous direction

This is the same logical error as *absence of a record is not evidence of
absence*, in a different medium:

> **"I cannot see it in this photograph" is not "it is not there."**

Reporting a part as missing is worse than misidentifying one. It sends the owner
hunting for something that was never lost, and it writes a false gap into a
record that is supposed to be the reliable account.

**Say what the frames do and do not show**, and let the item settle the rest.

### A `[verify]` tag does not rescue a wrong reading

Tagging a guess and publishing it anyway feels like diligence and is not. On a
value nobody will ever independently re-derive, `[verify]` is **a wrong claim
with a disclaimer attached** — and it propagates into digests, commit messages
and summaries exactly as fast as a confirmed one.

Ask instead. The cost of asking is one message; the cost of a wrong identifier
in a permanent record is every decision made against it afterwards.

## When sources conflict

Record the conflict and name the authoritative source. Don't silently pick.

| Source | Says |
|---|---|
| Vehicle history report | "No open recalls reported" |
| Diagnostic scan | 1 open safety recall |
| Government database | Campaign 18V800000 applies |

Then state which governs and why — here, the government VIN lookup, because the
history report's recall data is secondhand and frequently stale.

Someone reading later needs to know the disagreement existed. If you resolve it
silently and your pick was wrong, nothing in the record reveals the error.

## Correct silently; annotate only what was relied on

**The test is not "was this wrong?" It is "did anyone rely on it?"**

Most corrections are a draft being tidied — a misread label, a number
transcribed wrong, a conclusion that lasted an hour before better information
arrived. **Fix it and leave no trace in the prose.** The old text is in the
commit history, dated, with a message saying what changed. A note disowning an
earlier version costs every future reader attention and teaches them the wrong
fact on the way to the right one.

Annotate in place in exactly two cases.

**When someone acted on it** — money spent, work skipped, a part ordered, an
inspection not done. The fact that it was believed is then part of the item's
history, and goes in the **log** as a dated entry rather than inside a reference
document:

> **2026-08-27.** The 80,000-mile service was skipped at the August visit
> because this record said it had been done. That was unsupported. What is known
> is that no record exists after 41,424 mi.

**When the document is a dated analysis** — a snapshot of what was believed at a
moment. Never rewrite one: new information that *adds* to it goes in as its own
dated note, and when one is overtaken rather than extended, write a new analysis
and mark the old **Superseded**, with a pointer forward.

A record earns trust by being accurate, not by displaying its scars.

## Separate urgency from importance

Most findings are neither emergencies nor trivia. Say which:

- **Act** — a real finding worth diagnosis or a scheduled fix
- **Watch** — unconfirmed, but would matter if it recurs
- **Minor** — real, but only affects convenience
- **Noise** — attributable to something already explained

Inflating a finding spends credibility you need when something genuinely is
urgent. When a deadline is real, be specific about *why* — "the calendar limit
arrives in 17 months and usage will never trigger it" lands harder than "this is
overdue" and is easier to act on.

## Flag your own weakest claim

Every research pass produces one conclusion resting on thinner evidence than the
rest. Name it. "This is the weakest item here — the reading is inference from
the code text, not a verified source. Have it looked up rather than acted on."

This costs nothing and is the difference between a record someone trusts and one
they have to re-verify entirely.
