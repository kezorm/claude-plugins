# Inbox — drop documents here

Anything related to <<ASSET_NAME>>. No naming convention, no subfolder, no
decisions. Photos of receipts, PDFs, emailed invoices, screenshots, manuals.

Then run `bin/inbox-status`, or ask an assistant to "check the inbox."

Filing puts each document where its **content** says it belongs — making the
folder if one doesn't exist yet. There's no fixed destination table here because
a vehicle and a house need different homes for different things. See
[`../CLAUDE.md`](../CLAUDE.md).

Originals are preserved: renamed and moved, never rewritten or recompressed.

## Contents aren't in version control

Everything here except this README is gitignored, deliberately.

Unfiled documents are transient — once filed properly they're committed there,
and tracking them here too would put two copies in history. More importantly,
some of what lands here carries signatures or account details, and **anything
committed to git persists permanently; deleting the file later doesn't remove it
from past commits.**

Untracked is the reversible default. A document can always be committed on
purpose after review; it can't easily be un-committed.
