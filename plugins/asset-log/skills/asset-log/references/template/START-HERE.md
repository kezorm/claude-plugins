# Start here

A record of **<<ASSET_NAME>>** — the documents, the history, and what needs
doing. Markdown files, a handful of small scripts, and a few habits.

No app, no database, no AI required. An assistant makes it faster; nothing here
depends on one.

## There is no prescribed folder structure

Deliberately. A vehicle, a house and a rack of servers need different things.
**Folders get made when documents arrive that need them** — not guessed at on
day one and left empty. Start with this README and an inbox; structure follows
content.

## The one habit that makes it work

**When something new arrives, update three things in one sitting:**

1. **The document** — filed, original unchanged
2. **Whatever log or write-up it belongs to**
3. **`README.md`** — the status and open items

The third is the one people skip, and skipping it is how a folder of documents
becomes a folder nobody reads.

## Commands

| You want to | Run |
|---|---|
| See what's waiting to be filed | `bin/inbox-status` |
| Make PDFs searchable | `bin/extract-text` |
| Make saved email searchable | `bin/eml-text` |
| Check nothing's broken | `bin/check-links` |
| Save a web page into the record | `bin/archive-page <url>` |
| Verify an archived page is complete | `bin/archive-check` |
| Read the archive back in a browser | `bin/archive-browse` |

`extract-text` needs `pdftotext` — `brew install poppler` on macOS,
`apt install poppler-utils` on Linux. `archive-page` needs `wget`. The rest are
plain Python 3.

They're short scripts, not a framework. Delete any you don't use.

## Then read CLAUDE.md once

It holds the working rules — document roles, evidence standards, how to handle
sources that disagree. It's what makes separate records feel like siblings even
when their folders look nothing alike.
