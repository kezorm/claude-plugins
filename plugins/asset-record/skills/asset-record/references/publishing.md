# Before Sharing or Publishing

A record accumulates things that shouldn't leave the owner's control. Audit
before anyone makes it public, hands it to a third party, or pushes it somewhere
new.

## Going public is one-way

Once a repository is public, clones, forks, platform event feeds and third-party
mirrors hold it permanently. **Switching it back to private recalls none of
that.** Private-first is the reversible order; public-first is not.

If the goal is "share it with a few people," that's collaborator access, not
publication. Most platforms allow unlimited collaborators on private
repositories. Reach for publication only when the audience is genuinely the
public.

## What to audit for

**The owner's own information.** Purchase prices, financing details,
identifiers, signatures, addresses, anything that names them. Search the whole
tree, not just the obvious folder — a price quoted in a summary is as exposed as
the invoice it came from. Check the commit metadata too: author name and email
are embedded in every commit and are visible forever.

**Third-party copyrighted material they'd be republishing.** This is the one
people miss. History reports, manufacturer manuals, dealer listings and product
sheets are all someone else's copyright, and some carry explicit redistribution
prohibitions in their own footers. Holding a copy privately is ordinary use;
republishing it is a different act. Read the terms before assuming.

**Anything about other people.** Prior owners, tenants, contractors, neighbors.
The owner consented to their own exposure; nobody else did.

## What to say

Give a plain inventory rather than a warning, and let them decide:

> Here's what's in there that shouldn't be public: the purchase price in two
> files, the full history report (whose own terms prohibit redistribution), the
> identifier in ~15 files, and 119 MB of manufacturer and dealer copyrighted
> material. Going public is one-way — visibility can be flipped back but clones
> can't be recalled.

Then offer the options, including the one they may not have considered: a
**separate public repository with fresh history**, carrying the method — the
structure, the working rules, the scripts, the generic findings — and none of
the actual documents. That is usually what's interesting to share anyway, and it
carries no exposure at all.

## Record the decision

Write the policy into the repository, not just the conversation. A future
session or a future owner needs to know that "this is private on purpose"
rather than by accident:

```markdown
## Sharing and privacy

**This repository is private and should stay that way in its current form.**

| What | Where |
|---|---|
| Purchase price | `purchase/README.md` |
| History report — terms prohibit redistribution | `purchase/history/` |
| Identifier | ~15 files |
| Manufacturer manuals (25 MB) | `reference/manuals/` |
```

## Self-containment

Related, and worth checking at the same time: **nothing important should live
only in an assistant's memory, a subscription-tied store, or one machine.**

Audit it directly — take each substantive fact from any external memory and
confirm it also exists in the repository. Anything that doesn't, write in. Then
state the guarantee in the working-rules file so future sessions maintain it:
if it matters, it goes in a file here, because a reader with nothing but a clone
and a text editor has to be able to pick this up completely.
