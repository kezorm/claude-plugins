# Archiving a web page into a record

The usual case is **one page at a time**: something authoritative turns up while
answering a question, and it should still be answerable in ten years without a
network connection. The job is *fetch it, prove it is complete, prove it is
readable, write down what it says.*

**The failure mode is not "the fetch errored."** It is a page that sits on disk
at a plausible size and is quietly missing its images, its later pages, or its
text.

Tools: `bin/archive-page` (fetch and repair), `bin/archive-check` (verify),
`bin/archive-browse` (read it back).

---

## 1. Ask what you are actually archiving — before fetching

A linked page is often one part of something larger, and nothing on it says so:
page 1 of a 22-page thread, one article of an eight-part series, one post of a
run that shares a subject. This is the cheapest and highest-value check here,
and it changes the command you run.

- **Look for pagination, "next / previous / part II" links, and an index or
  category page on the same site.** Then fetch the set.
- **Do not check for pagination by looking for one spelling of it.** Testing for
  `Page N of M` and `index2.html` misses a forum that paginates as `/page2/`.
  **Enumerate the anchors whose text is a bare number, `next` or `last`, and see
  where they point** — that catches every scheme without knowing the software.
- **Search a site by content, not by the word you expect in the title.** A
  repair write-up often never names the thing it is about. On a personal blog
  the subject is usually implied by *date*: a contiguous run of posts is one
  project. Find the run's boundaries and take the run.
- **Ask what the page links *out* to.** The value is often in the replies — a
  part number, a supplier.

**Run this check backwards over what you already hold, too.** Walk every
archived page, pull the anchors matching `next`, `last`, `part N`, `continued`
or a bare page number, resolve each href to where wget would have written it,
and list the ones with no local file. **Resolve absolute URLs properly** — map
`http://host/a/b` to `<base>/host/a/b`, plus the `.html` and `/index.html`
variants — or the sweep reports pages you already have and you learn to ignore
it.

---

## 2. Fetch with a tool that already solves this

Use `wget`. Page requisites, link rewriting, retries and rate limiting are all
easy to get subtly wrong by hand.

```sh
wget --adjust-extension --convert-links --span-hosts --page-requisites \
     --restrict-file-names=windows --no-parent \
     --header='Accept-Encoding: identity' \
     -e robots=off --wait=0.4 --random-wait --tries=3 --timeout=30 \
     -P <dest> <url>
```

**Reject what is never content; keep what is:**

| Reject | Keep |
|---|---|
| `*.js` — scripts, trackers, ad bundles | **CSS** — without it the page is unreadable |
| Webfonts: `*.woff *.woff2 *.ttf *.otf *.eot`, icon-font SVGs | **Images** — usually the whole point |
| `*avatar* *smilie* *banner* *advert*` | |
| Analytics and ad hosts by domain | |

- **Don't skip the font extensions.** A single `.otf` can be larger than every
  photograph on the page.
- **Fonts also ship as ordinarily-named SVG** — `InterRegular.svg`,
  `BentonSans-Bold.svg`. Extension-based rejection cannot catch these; **check
  what landed in a `fonts/` directory.**
- **Always write a `.txt` beside the saved page.** An archive that cannot be
  grepped does not get read.

---

## 3. Twelve traps, each of which produces a file that looks fine

`bin/archive-check` reports all of these and exits non-zero when a page is
genuinely unreadable. Run it after any archiving session.

**Servers that gzip regardless of what you ask.** wget writes `page.html.gz` —
still compressed, not parsed as HTML, so **none of the page's images are ever
fetched**, and any text extraction is binary garbage at a plausible size.
*Fix:* decompress, drop the `.gz`, re-fetch requisites.

**Never feed a page's own links back to the fetcher.** `wget -i <local.html>
--force-html` treats every link as a *download target*, not a requisite, and
pulls in the whole open web. If requisites need re-fetching, extract only
`<img>`/`<link>` sources and fetch those.

**"Unresolved references" needs a baseline, not a count.** Sites lazy-load
through query-string URLs that never survive being written to disk, so a clean
fetch can start with hundreds unresolved. **Take the resolved/unresolved count
on the clean fetch first**, then compare — otherwise the site's own behaviour
looks like damage you caused, or real damage looks normal.

**Text extractors that discard `<noscript>`.** Stripping `<script>` is right;
stripping `<noscript>` alongside it is wrong. Crawler-conscious JavaScript sites
render their entire server-side content inside a single `<noscript>` block. Drop
it and a 396 KB forum thread extracts to 24 words — archived, correctly sized,
complete on disk, and not greppable. **Unwrap `<noscript>`; don't drop it.**

**Crawler-only content inside `<noscript>`, in the HTML too.** With JavaScript
rejected the app never boots, and a browser hides `<noscript>` content by
definition — so the page is **blank by construction**. It needs two separate
fixes: unwrap when extracting text, *and* unwrap the tags in the saved file.
Fixing only the first makes the archive greppable and still unreadable.
**Unwrap selectively** — more than ~100 words in the block, and more inside than
outside — so an ordinary "please enable JavaScript" notice is left alone. Leave
a marker comment where the tags were.

**Overlays the site's own JavaScript would have removed.** A modern app-shell
site uses JS to take down its own loading screen: a `position:absolute`,
viewport-sized, high-`z-index` splash plus `html{overflow-y:hidden !important}`.
With no JS it stays up permanently over a page that is intact underneath. **Text
extraction is clean, file size is right, images are all there, and the page is
blank** — no mechanical check catches it. *Fix:* append a marked stylesheet
rather than editing the page's markup (`#splash{display:none!important}`,
`html,body{overflow-y:auto!important}`), so the served bytes are all still there
and the change is one greppable block. **Match strictly** — require a named
splash, or an element sized in viewport units *and* stacked above the page.
Matching any class containing "preloader" rewrites pages that needed nothing.

**Never round-trip an archived page through text I/O.** Reading with
`encoding='utf-8', errors='replace'` and writing back rewrites CRLF to LF and
turns every invalid byte into U+FFFD. The archive is supposed to hold what the
server sent, byte for byte. **Read and write bytes**; decode a copy for matching
if you must, never write the decoded string back.

**Line endings.** If `core.autocrlf` is set, git rewrites CRLF to LF in anything
it thinks is text, and a checksum against the origin stops matching. **Mark
archive paths `-text` in `.gitattributes`.**

**Lazy-loaded images have no `src` to load.** The URL sits in `data-src`
(or `data-original`, `data-lazy-src`, `data-url`), or `src` is a 1×1
transparent GIF, and no archived script ever copies it across. **The page has
its text, the photographs are on disk, every file serves 200 — and it shows no
pictures.** Subresource checking cannot catch this; nothing is missing.
*Fix:* write the lazy URL into `src`, with two cautions —
- **Only promote a target you actually hold**, and skip remote URLs. Promoting
  blind turns invisible placeholders into broken-image icons, which is worse.
- **`\bsrc=` also matches `data-src=`** — `-` is a non-word character. Use
  `(?<![-\w])src`.

**`--convert-links` does not always finish.** It skips a requisite that was
already on disk from an earlier run, leaving the link as the server wrote it —
so a stylesheet sitting in the same folder never loads, because `/assets/x.css`
resolves against the *repository* root. *Fix:* rewrite to a relative path, but
only where the file exists, and **keep the `#fragment`** — flattening
`.../thread/#post1265135` to `index.html` destroys every permalink in a thread.
**Prefer re-fetching cleanly**; a fresh fetch lets wget convert the links itself
and needs a fraction of the repairs.

**An interrupted run leaves pages the next run will not repair.** `archive-page`
post-processes the files *that run created*. Stop a run part-way and the `.html`
is on disk; run it again and those files are no longer new, so every repair
silently skips them. **The tell is a page count of zero beside a healthy file
count** — `53 file(s), 0 page(s), 22 image(s)` looks like success and means the
archive cannot be grepped. The tool now sweeps for pages with no `.txt` beside
them. Two details if this is ever reimplemented:
- **"Nothing new downloaded" must not short-circuit the sweep** — that is
  exactly when a page left behind needs repairing.
- **Staleness is absence of a `.txt`, not an mtime comparison.**
  `--convert-links` rewrites every page at the end of a run, so the `.html` is
  always newer.

**A page fetched by hand is HTML and nothing else.** Saved from a browser or
pulled by a script, it comes back with no stylesheets and no images — page
requisites are precisely what `wget` was doing for you. It reads perfectly as
text and renders as an unstyled wall of broken-image icons. **After any hand
fetch, go back for what the page references**: extract its `<link
rel=stylesheet>` and `<img>` sources, fetch those, rewrite the references. A bot
check usually guards only HTML, so the assets fetch with a plain request.

---

## 4. When the page is gone or blocked

| Situation | What works |
|---|---|
| 404 | Wayback Machine — use the **CDX API** to list *all* snapshots, not the "closest" one |
| Cloudflare / bot check (HTTP 202, 403) | Wayback if a snapshot exists; otherwise only a real browser |
| Login wall, or a social-media album | **Generally unarchivable.** Say so plainly rather than leaving a link |

- **Not all snapshots are equal.** Pick by content length — redirect stubs run a
  few hundred bytes and look like successful captures.
- **A redirect to the front page is a migration's fallback, not a tombstone.**
  **Try the platform's own convention first**: Shopify puts articles under
  `/blogs/`, WordPress under `/YYYY/MM/DD/`, Discourse under `/t/<slug>/<id>`.
  Failing that, search the site for the headline. **The live page is always
  better than a snapshot** — fuller text, images the crawler never reached, and
  nothing to un-rewrite.
- **A dead hostname is not a dead domain.** `www.example.com` can fail on DNS
  while `example.com` answers 200. **Before concluding a site is dead: test the
  apex, follow redirects, and read the CDX listing for the whole domain** — it
  will usually show the site's newer URL scheme.
- **A site can survive while the *content* does not.** "Use the Wayback because
  the site is gone" and "because this page is gone" are different findings. Say
  which.
- **A 404 on the URL the page names is not proof the picture is gone.** A CMS
  migration can move images to a CDN the archive never crawled while older
  copies stay indexed under the original domain. **List what the archive holds
  for the whole domain before concluding anything is lost**, and when images are
  recovered that way, **rewrite the pages' `<img>` sources onto them** — or the
  files sit beside pages still pointing at the dead host.
- **When something cannot be archived, write down that it cannot**, and why, or
  a future reader repeats the search.

---

## 5. Size: measure, never estimate

- **A sample of the largest files does not predict the set.** Sampling the
  biggest PNGs predicted 19% of original size; across all 1,707 images the real
  figure was 53%. Quote a measured number or say it is an estimate.
- **Re-encoding can make files bigger.** A set of already-efficient JPEGs went
  from 31.5 MB to 45.7 MB, and lost a generation of quality. **Test on a sample
  and compare before applying.**
- **CMS duplicates are usually the real weight.** WordPress generates
  `-150x150`, `-768x512` copies of every upload. Keep the largest of each and
  rewrite references.
- **A CMS publishes feeds, and wget saves them as pages.** Each lands as
  `feed/index.html` containing `<?xml … <rss>`: a browser renders a mess, and
  `<content:encoded>` repeats a post archived beside it. **Detect by the first
  bytes, not the extension**, and keep them out of any index a human reads — a
  word-count filter will not do it.
- **A CMS also duplicates pages.** WordPress serves every post again at
  `?replytocom=N` and `?p=NNNN`, and wget saves a byte-identical copy of each.
  An index then lists the same title nine times and splits the post's
  photographs between the copies. **Deduplicate by hashing the text, show the
  alias-free URL, and say how many copies it stands for** — rather than deleting
  files already committed, where deletion reclaims nothing.
- **When rewriting references, map from the exact strings in the HTML**, not
  from bare filenames — escaping, query strings and `srcset` entries all differ
  from what is on disk. Then verify against the §3 baseline.
- **Re-encoding someone else's mirror is legitimate; re-encoding the owner's own
  originals is not.** A third-party page is already lossy and still online. The
  owner's photographs are the primary record and are never converted.

---

## 6. Reading it back

- **Plain-looking is often correct.** Many older technical sites have no
  stylesheet at all. Don't chase a rendering problem that isn't one.
- **Serve the archive over `http://` rather than opening files directly.** A
  `file://` page cannot reliably load subresources from sibling directories.

  ```sh
  python3 -m http.server 8765 --bind 127.0.0.1
  ```

  **Bind loopback explicitly** — the default binds every interface, which puts a
  private record on the local network. `bin/archive-browse` wraps this and adds
  an index. It is a *reading* tool: it cannot repair a page that was incomplete
  when captured, and it is not search. Search is `grep` over the `.txt` files.
- **URL-escape generated links; HTML-escaping is not the same thing.**
  `--restrict-file-names` writes a Wayback capture to a path holding a literal
  percent sign — `.../20240915160007/https%3A/example.com/page.html`. Unescaped
  in an `href`, the server decodes it back to `https:/` and every
  Wayback-captured page 404s from the index while the files sit correctly on
  disk. `html.escape()` does not help; the path needs `quote()`. **Verify by
  requesting every link the index emits and checking the status code**, not by
  opening one.
- **Check generated markup mechanically, not by eye.** An `<a>` nested inside an
  `<a>` makes browsers silently close the outer one, and the layout collapses in
  a way that looks like a styling problem. One regex over the output catches it.
- **Beware tooling that lies about binary-ish files.** `grep` on a file with
  very long lines or non-UTF-8 bytes may silently print nothing rather than
  matching. Verify with something that decodes explicitly.

---

## 7. What to write down

Filing the page is not the task; **recording what it says is the task.**

- What the source is, **who wrote it**, and when it was retrieved
- Whether it is complete, and **what is missing that cannot be recovered**
- Which page of a series is the one worth reading
- **Why it was kept** — and if something was deliberately *not* kept, why not
- The local path, cited in preference to the URL. The URL is provenance
