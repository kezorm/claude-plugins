# Working rules — <<ASSET_NAME>>

The shared method for records like this one is imported below and applies in
full. This file holds only what is specific to **this <<ASSET_KIND>> and this
repository**, and only as **rules** — this file is read at the start of every
session, so every line costs on every task. The evidence behind a rule belongs
in the document that owns the subject, not here.

@.claude/method.md

> `.claude/method.md` is a verbatim copy of the asset-log skill's template,
> currently **v1.5.0**. Don't edit it — record-specific rules go here instead.
> To bring it up to date, replace that file wholesale from the current skill and
> review this one for conflicts.

---

## Orientation

*(Read this file, then `README.md`. Then: which document should someone open
first for this particular thing? Once a manual or spec sheet is archived and
text-extracted, say so here and tell people to grep it before searching online —
it is authoritative for this item and faster than anything on the web.)*

## Evidence rules

*(What this record has learned the hard way, **stated as rules, one or two lines
each** — a source that proved unreliable, a number that was wrong the first
time, a check that has to happen every time. Put the incident, the dates and the
evidence in the document that owns the subject and link to it. A rules file full
of war stories stops being read.)*

## Record-specific conventions

*(What this thing measures itself in — miles, hours, years, cycles — and how
readings are written. Which limits bind first. Anything the general method
leaves open that this record has settled.)*

## Filing routing

| What arrives | Where it goes |
|---|---|
| | |

*(Fill in as folders appear. Don't pre-create them — see the method on why an
empty guessed-at tree is worse than none.)*

## Repository facts

| | |
|---|---|
| Remote | |
| Branch | |
| Visibility | |

## Environment notes that are not obvious

*(Tools that turn out to be missing, permissions that must be requested,
anything that wasted someone half an hour once. Check with `command -v` rather
than assuming.)*

## Working with this owner

*(Corrections they have made, how they prefer conclusions framed, whether they
state facts conversationally rather than filing documents.)*

## Committing

Commit messages state the finding, not the file move:

```
<what was learned, in one line>

<why it matters, what changed as a result>
```
