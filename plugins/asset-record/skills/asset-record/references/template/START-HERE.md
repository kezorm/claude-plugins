# Start here

A record of **<<ASSET_NAME>>** — the documents, the history, and what needs
doing. Markdown files, three small scripts, and a handful of habits.

No app, no database, no AI required. An assistant makes it faster; nothing here
depends on one.

## There is no prescribed folder structure

Deliberately. A vehicle needs different things than a house needs than a camera
kit needs. **Folders get made when documents actually arrive that need them** —
not guessed at on day one and left empty.

Start with this README and an inbox. Structure follows content.

## The one habit that makes it work

**When something new arrives, update three things in one sitting:**

1. **The document** — filed, original unchanged
2. **Whatever log or write-up it belongs to**
3. **`README.md`** — the status and open items

The third is the one people skip, and skipping it is exactly how a folder of
documents becomes a folder nobody reads.

## Commands

| You want to | Run |
|---|---|
| See what's waiting to be filed | `bin/inbox-status` |
| Make PDFs searchable | `bin/extract-text` |
| Check nothing's broken | `bin/check-links` |

`extract-text` needs `pdftotext` — `brew install poppler` on macOS,
`apt install poppler-utils` on Linux. The other two are plain Python 3.

They're three short scripts, not a framework. Delete any you don't use.

## Then read CLAUDE.md once

It holds the working rules — document roles, evidence standards, how to handle
sources that disagree. It's the file that makes separate records feel like
siblings even when their folders look nothing alike.
