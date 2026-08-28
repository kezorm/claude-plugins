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

## Absence of a record is not evidence of absence

Write **"no record of X since \<date\>"** — never "X was skipped," "X was
missed," or "X was never done."

Gaps have two explanations: it didn't happen, or it happened and wasn't
reported. Nothing in the gap distinguishes them. Not every job is done by a
professional, and not everything a professional does gets reported to a history
database.

This mistake is tempting precisely because it usually doesn't change the
recommendation — which is also why it's pointless. The honest framing gets to
the same action and survives scrutiny:

> We don't know whether this was done. It degrades invisibly and can't be
> assessed by eye. If it was done recently, redoing it costs little. If it
> wasn't, it's years overdue. So do it, and start the clock from a date we
> actually own.

The same reasoning applies to thin datasets. A government complaint database
showing zero reports for a low-volume item is weak evidence of absence, not
proof of a clean record.

Column headers matter too: label it **"Last documented"**, not "Last done." Use
**"no record"**, not "never."

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

## Annotate history, never rewrite it

When new information changes a past conclusion, add a dated note inside the
original document:

> **Added 2026-08-27.** The service history filed after this analysis was
> written shows no battery replacement in 14 records spanning 2018–2026. That
> supports the low-voltage hypothesis above.

And when a past conclusion turns out to be *wrong*, withdraw it in place rather
than deleting it:

> **Corrected 2026-08-27.** An earlier version stated the 80,000-mile service
> "was skipped." That was unsupported and has been withdrawn. What is known is
> that no record exists after 41,424 mi.

Preserving the correction is more valuable than a clean-looking document. It
tells a reader the record is maintained by someone who checks.

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
