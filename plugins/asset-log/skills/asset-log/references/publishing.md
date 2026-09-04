# Before Sharing or Publishing

Audit before anyone makes a record public, hands it to a third party, or pushes
it somewhere new.

## Going public is one-way

Clones, forks, platform event feeds and third-party mirrors hold a public
repository permanently. **Switching it back to private recalls none of that.**

- **Private-first is the reversible order.** Public-first is not.
- **"Share it with a few people" is collaborator access, not publication.** Most
  platforms allow unlimited collaborators on private repositories. Publish only
  when the audience is genuinely the public.

## What to audit for

- **The owner's own information** — purchase prices, financing, identifiers,
  signatures, addresses, anything that names them. Search the whole tree: a
  price quoted in a summary is as exposed as the invoice it came from. **Check
  commit metadata too** — author name and email are embedded in every commit.
- **Third-party copyrighted material they would be republishing.** This is the
  one people miss. History reports, manufacturer manuals, vendor datasheets and
  dealer listings are someone else's copyright, and some carry explicit
  redistribution prohibitions in their own footers. Holding a copy privately is
  ordinary use; republishing is a different act. **Read the terms.**
- **Anything about other people** — prior owners, tenants, contractors,
  neighbours. The owner consented to their own exposure; nobody else did.

**Credentials are not on this list.** A card number or a set of bank details
should never have reached a commit, and history is permanent — that audit
belongs at filing time. If one surfaces here, the repository needs its history
rewritten, which is a much larger conversation than redacting a price. See
*Credentials* in the method.

## What to say

**Give a plain inventory rather than a warning, and let them decide.**

> Here's what's in there that shouldn't be public: the purchase price in two
> files, the vendor's quote with the account number in its footer, the serial
> numbers in ~15 files, and 119 MB of manufacturer documentation. Going public
> is one-way — visibility can be flipped back, clones can't be recalled.

Then offer the options, including the one they may not have considered: a
**separate public repository with fresh history**, carrying the method — the
structure, the working rules, the scripts, the generic findings — and none of
the actual documents. That is usually what's interesting to share anyway, and
it carries no exposure.

## Record the decision

**Write the policy into the repository, not just the conversation.** A future
session or owner needs to know this is private on purpose rather than by
accident.

```markdown
## Sharing and privacy

**This repository is private and should stay that way in its current form.**

| What | Where |
|---|---|
| Purchase price | `purchase/README.md` |
| Vendor quote — terms prohibit redistribution | `purchase/quotes/` |
| Serial numbers | ~15 files |
| Manufacturer manuals (25 MB) | `reference/manuals/` |
```

## Self-containment

Worth checking at the same time: **nothing important should live only in an
assistant's memory, a subscription-tied store, or one machine.**

- **Audit it directly** — take each substantive fact from any external memory
  and confirm it also exists in the repository. Write in anything that doesn't.
- **State the guarantee in the working-rules file** so future sessions maintain
  it: if it matters, it goes in a file here, because a reader with nothing but a
  clone and a text editor has to be able to pick this up completely.
