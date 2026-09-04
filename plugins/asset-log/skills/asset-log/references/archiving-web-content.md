# Archiving a web page into a record

> **Written from failure, not theory.** Every rule here cost something: it
> comes from archiving ~250 pages into a working record and getting it wrong in
> twelve distinct ways first. Nothing in it is specific to any one record.
>
> The companion tools are `bin/archive-page` (fetch and repair),
> `bin/archive-check` (verify) and `bin/archive-browse` (read it back).

The usual case is **one page at a time**: something authoritative turns up
while answering a question, and it should still be answerable in ten years
without a network connection. The whole job is *fetch it, prove it is
complete, prove it is readable, write down what it says.*

**The failure mode is not "the fetch errored."** It is a page that looks
archived, sits on disk at a plausible size, and is quietly missing its images,
its later pages, or its text.

---

## 1. Ask what you are actually archiving

**Ask this before fetching, not after.** It is the highest-value check in
this document and the cheapest, and it changes the command you run: the whole
series in one invocation, rather than discovering page 2 exists a week later.

Repeatedly, what was linked turned out to be one part of something larger, and
nothing on the page announced it:

- A forum thread that was **22 pages**, saved as page 1
- Another that was **3 pages**, saved as page 1
- A technical article that was **one page of an eight-part series**, where the
  most useful page was one nobody had linked to
- A single article whose site carried **an index of eight more** by the same
  author on the same subject

So look, before you fetch, for: pagination (`page-2`, `/page2/`,
`index2.html`, "Page 1 of N"), "next/previous/part II" links, and an article
index or category page on the same site. Then fetch the set.

**Do not check for pagination by looking for one spelling of it.** A check for
`Page N of M` text and `index2.html` URLs found nothing on a jaguarforums
thread and the page was archived as complete. It was **page 1 of 7** — that
forum paginates as `/page2/`, `/page3/`. 20 posts were kept and 105 thrown
away, and the archive looked finished. Enumerate the anchors whose text is a
bare number, `next` or `last`, and see where they point; that catches every
scheme without needing to know the software.

**Search a site by content, not by the word you expect in the title.** A blog
searched for "jaguar" gave ten posts and missed nine more about the very car
being researched — "Exhaust Manifold Helicoil Repair" is about an XJ6 and does
not say so in its title. On a personal blog the subject is usually implied by
*date*: a contiguous run of posts is one project. Find the run's boundaries and
take the run.

### Run §1 backwards over what you already hold

The check above is cheap before fetching and still cheap afterwards, so do it
both times. Walk every archived page, pull the anchors whose text matches
`next`, `last`, `part N`, `continued` or a bare page number, resolve each href
to where wget would have written it, and list the ones with no local file.

That sweep, run over one session's work, found a 7-page thread saved as 1 page
and a nine-post blog run saved as two posts. **Resolve absolute URLs properly**
— map `http://host/a/b` to `<base>/host/a/b`, plus the `.html` and
`/index.html` variants — or the sweep reports pages you already have and you
learn to ignore it, which is worse than not running it.

**Also ask what the page links *out* to.** A dead-looking want-ad thread turned
out to name both an off-the-shelf part number and a supplier — the value was in
the replies, not the first post.

---

## 2. Fetch with a tool that already solves this

Use `wget` rather than a hand-rolled crawler. Page requisites, link rewriting
so the copy opens offline, retries and rate limiting are all easy to get
subtly wrong.

```sh
wget --adjust-extension --convert-links --span-hosts --page-requisites \
     --restrict-file-names=windows --no-parent \
     --header='Accept-Encoding: identity' \
     -e robots=off --wait=0.4 --random-wait --tries=3 --timeout=30 \
     -P <dest> <url>
```

**Reject what is never content**, and keep what is:

| Reject | Keep |
|---|---|
| `*.js` — scripts, trackers, ad bundles | **CSS** — without it the page is unreadable |
| Webfonts: `*.woff *.woff2 *.ttf *.otf *.eot`, icon-font SVGs | **Images** — usually the whole point |
| `*avatar* *smilie* *banner* *advert*` | |
| Analytics/ad hosts by domain | |

Measured on one forum thread: **3.3 MB → 0.6 MB with nothing of value lost.**
Almost all of it was ad trackers and webfonts. Don't skip the font extensions —
a single stray `.otf` was **4.1 MB**, larger than any photograph on the page.

**Fonts also ship as ordinarily-named SVG.** A reject list naming
`*fontawesome*.svg` misses `InterRegular.svg`, `InterMedium.svg`,
`BentonSans-Bold.svg`. On one article those five files were **3.8 MB — larger
than any real image on the page**, which had only one. Extension-based
rejection cannot catch these; check what landed in a `fonts/` directory.

**Always write a `.txt` beside the saved page.** An archive that cannot be
grepped does not get read, and the text is what survives when the layout
doesn't.

---

## 3. Twelve traps, each of which produces a file that looks fine

> **These are checked by `bin/archive-check`.** Run it after any archiving
> session; it reports every fault below and exits non-zero when a page is
> genuinely unreadable. What follows is *why* each one exists and how it was
> found — knowledge the script cannot carry. Read it when a check fires and
> you need to decide whether it matters.

### Servers that gzip regardless of what you ask

Some servers answer every request with `Content-Encoding: gzip`, even against
`Accept-Encoding: identity`. wget then writes `page.html.gz` — **still
compressed, and not parsed as HTML, so none of the page's images are ever
fetched.** Any text extraction made from it is binary garbage that still has a
plausible file size.

**Fix:** decompress, drop the `.gz`, re-fetch requisites.

### Never feed a page's own links back to the fetcher

`wget -i <local.html> --force-html` treats **every link as a download target**,
not as a requisite. Doing this once pulled **189 MB** of YouTube pages,
social media and unrelated storefronts into a reference folder. If requisites
need re-fetching, extract only `<img>`/`<link>` sources and fetch those.

### "Unresolved references" needs a baseline, not a count

Counting broken image references *after* an edit tells you nothing on its own.
One page saved 41 MB of images and **515 of its 521 references still did not
resolve on the clean, untouched fetch**, because it lazy-loads through
query-string URLs that don't survive being written to disk.

**Take the resolved/unresolved count on the clean fetch first**, then compare.
Otherwise the site's own behaviour looks like damage you caused — or worse, real
damage looks normal. *This is the general rule about verifying a bulk operation
by re-deriving the result from the source, in a specific costume.*

### Text extractors that discard `<noscript>`

Stripping `<script>` before extracting text is obviously right. Stripping
`<noscript>` alongside it looks equally right and is **wrong**.

**Discourse — and any crawler-conscious JavaScript site — renders its entire
server-side content inside a single `<noscript>` block** and rebuilds the
visible page from it. Discard that and a 396 KB forum thread extracts to
**24 words**: a page that is archived, correctly sized, complete on disk, and
not greppable. Nothing looks broken, and the failure is invisible unless you
compare word count against file size.

**Unwrap `<noscript>`, don't drop it** — remove the tags and keep what is
between them.

### Crawler-only content inside `<noscript>`

An app-shell site serves crawlers the whole article inside `<noscript>` and
builds the real page in JavaScript from an API. Discourse does this. So does
anything else that wants to be indexed without server-rendering twice.

Archive it with JavaScript rejected — which is right — and **the page is blank
by construction**. A browser with JS *enabled* hides `<noscript>` content by
definition, and the app that would draw the thread never boots. On one archived
thread, **1,506 of 1,530 words were inside that block.**

It bites in two separate places and needs two separate fixes:

| Surface | Symptom | Fix |
|---|---|---|
| the `.txt` | extractor *discards* `<noscript>` → 24-word file beside a 400 KB page | unwrap when extracting |
| the `.html` | browser *hides* `<noscript>` → blank page | unwrap the tags in the saved file |

Fixing only the first makes the archive greppable and still unreadable, which
is the state this record was in for a day.

**Unwrap selectively** — more than ~100 words in the block, and more inside it
than outside — so an ordinary "please enable JavaScript" notice is left alone.
Leave a marker comment where the tags were, so the edit is greppable and
honest.

### Overlays the site's own JavaScript would have removed

JavaScript is rejected, which is right — it is trackers and ad bundles. But a
modern app-shell site also uses it to **take down its own loading screen**.

Discourse ships `<section id="d-splash">`: `position:absolute`, `100vw` by
`100dvh`, `z-index:1001`, plus `html{overflow-y:hidden !important}`. Its app
removes that on boot. With no JavaScript it stays up permanently — an opaque
full-viewport layer over a page whose text and every photograph are on disk,
intact, underneath, and unscrollable.

**The text extraction is clean, the file size is right, the images are all
there, and the page is blank.** No mechanical check in this document catches
it: word count, byte count and reference-resolution all pass. It was found
because a person opened the page and said so.

**Fix:** append a marked stylesheet rather than editing the page's own markup —
`#d-splash{display:none!important}` and `html,body{overflow-y:auto!important}`
— so the served bytes are still all there and the change is one greppable block
a reader can judge.

**Match strictly.** A first attempt matched any element whose class contained
"preloader" and rewrote 13 pages, 12 of which needed nothing: on one forum that
is a `display:none` div and a 44-pixel spinner, and on another it appears only
in the body class `av-preloader-disabled`. Require a named splash, or an
element sized in viewport units *and* stacked above the page.

### Never round-trip an archived page through text I/O

Reading a saved page with `open(path, encoding='utf-8', errors='replace')` and
writing it back is **not** a round trip. It rewrites CRLF to LF and turns every
byte that is not valid UTF-8 into U+FFFD.

Done once here by accident, that silently removed **5,787 bytes and 599
carriage returns** from a committed forum page, and stripped all 7,490 CRs from
seven others. The archive is supposed to hold what the server sent, byte for
byte — and `git diff` reported it as thousands of changed lines, which looks
like a huge edit rather than an encoding accident.

**Read and write bytes.** Decode a copy for matching if you must; never write
the decoded string back.

### Line endings

If `core.autocrlf` is set, git rewrites CRLF to LF in anything it thinks is
text. Helpful for source code; **for an archive it means the stored bytes are
not the bytes the server sent**, and a checksum against the origin no longer
matches. Mark archive paths `-text` in `.gitattributes`.

---

### Lazy-loaded images have no `src` to load

An `<img>` may carry no usable `src` at all: lazy-loading keeps the URL in
`data-src` (or `data-original`, `data-lazy-src`, `data-url`) and a script
copies it across when the image scrolls into view. Others ship a 1×1
transparent GIF as `src` and swap it the same way.

No JavaScript is archived, so nothing ever copies it. **The page has its text,
the photographs are on disk, every file serves with a 200 — and the page shows
no pictures.** Subresource checking does not catch this, because nothing is
missing; the browser is simply never told to ask.

**Fix:** write the lazy URL into `src`. Two cautions, both learned the hard
way:

- **Only promote a target you actually hold.** Doing it blind to one Wayback
  capture pointed `src` at 22 files that had never been fetched, turning
  invisible placeholders into broken-image icons — worse than before. Skip
  remote URLs too: an archive must not need the network to render.
- **`\bsrc=` also matches `data-src=`.** A word boundary is not enough, since
  `-` is a non-word character. Use `(?<![-\w])src` — the loose version made a
  first scan report zero affected pages when 26 images were broken.

### `--convert-links` does not always finish

wget normally rewrites every reference to a relative path, which is what makes
a saved page work offline. It does **not** do so for a requisite that was
already on disk from an earlier run: nothing is re-downloaded, and the link is
left as the server wrote it.

The result is a page whose stylesheet sits **right there in the folder** and
still never loads, because the href is root-relative. `/assets/x.css` resolves
against the *server* root — for a local archive, the top of the repository, not
the site's directory. On this record seven pages of one forum thread rendered
unstyled with all five stylesheets present on disk.

**Fix** by rewriting to a relative path, but only where the file exists. Two
things to get right:

- **Keep the `#fragment`.** Flattening `.../thread/#post1265135` to
  `index.html` silently destroys every post permalink in a forum thread. Done
  once here across seven pages before it was noticed.
- **Prefer re-fetching cleanly.** A fresh fetch let wget convert the links
  itself and needed 28 repairs where the patched-up copy had needed 1,162.

### An interrupted run leaves pages that the next run will not repair

**The tell is a page count of zero beside a healthy file count.**

`archive-page` post-processes the files *that run created* — that is what makes
it fast, and it is a trap the moment a fetch is interrupted. Stop a run
part-way and the `.html` is on disk; run it again and those files are no longer
new, so **every repair silently skips them**: no `.txt`, no lazy-image
promotion, no `<noscript>` unwrap. The second run reports something like

    53 file(s), 0 page(s), 22 image(s), 0.8 MB

and looks like a success. It is not: the archive cannot be grepped, and the
page may not render.

**Read the page count on every run.** `0 page(s)` beside a healthy file count
means post-processing was skipped, whatever else the line says.

The tool now sweeps the destination for pages with no `.txt` beside them and
repairs those too, so an interrupted run heals itself next time. Two details
matter if this is ever reimplemented:

- **"Nothing new downloaded" must not short-circuit the sweep** — re-running
  over a directory wget has already filled downloads nothing, and that is
  exactly when a page left behind needs repairing.
- **Staleness is absence of a `.txt`, not an mtime comparison.** wget rewrites
  every page it touches at the end of a run (`--convert-links`), so the `.html`
  is always newer than the `.txt` afterwards; an mtime test fires on every
  re-run and makes an ordinary repeat invocation announce that it is repairing
  an interrupted one.

### A page fetched by hand is HTML and nothing else

Sooner or later a page has to be obtained some other way — saved from a
browser, or pulled by a small script written to get past something. What comes
back is **the HTML alone**: no stylesheets, no images. Page requisites are
precisely the part `wget` was doing for you.

The result reads perfectly as text, extracts cleanly, passes every word-count
check — and renders as an unstyled wall with broken image icons. One thread
archived this way was complete in words and missing **24 stylesheets**.

So after any hand fetch, **go back for what the page references**: extract its
`<link rel=stylesheet>` and `<img>` sources, fetch those, rewrite the
references. Note that a bot check usually guards only HTML — on that site the
stylesheets, photographs and even the PDF attachments all fetched with a plain
request.

Looking at the page tells you it is ugly; the status codes tell you which of
58 files is missing.

## 4. When the page is gone or blocked

| Situation | What works |
|---|---|
| 404 | Wayback Machine. Use the **CDX API** to list *all* snapshots, not the "closest" one |
| Cloudflare / bot check (HTTP 202, 403) | Wayback if a snapshot exists; otherwise only a real browser |
| Login wall, or a social-media album | **Generally unarchivable.** Some platforms block every non-browser client *and* have no snapshots. Say so plainly rather than leaving a link |

**Not all snapshots are equal.** Pick by content length: redirect stubs are a
few hundred bytes and look like successful captures. On one thread the two most
recent snapshots were 328-byte stubs and the useful ones were three years
older.

**A redirect to the front page is a migration's fallback, not a tombstone.**
When a site changes platform it keeps the domain and changes the URL scheme,
and anything it no longer recognises lands on the homepage. Reading that as
"the article is gone" and settling for a Wayback snapshot cost one page 14 of
its 15 photographs — the live article was fine, at
`/blogs/articles/<slug>` instead of `/articles/<slug>`.

**So before reaching for the archive, try the platform's own convention**:
Shopify puts articles under `/blogs/`, WordPress under `/YYYY/MM/DD/`,
Discourse under `/t/<slug>/<id>`. Failing that, search the site for the
headline. **The live page is always better than a snapshot** — fuller text,
images the crawler never reached, and nothing to un-rewrite.

**A dead hostname is not a dead domain.** A bookmarked
`http://www.example.com/page` can fail on DNS while `example.com` answers 200 —
`www` is a subdomain like any other and sites routinely drop it. Getting this
wrong writes "the site is gone" into a record about a business that is still
trading. **Before concluding a site is dead: test the apex, follow redirects,
and read the CDX listing for the whole domain** — it will usually be showing
the site's newer URL scheme, which is the tell.

Related, and the more common case: **a site can survive while the *content*
does not.** A shop rebuilt on a new platform kept trading and dropped every
technical article it had hosted. The archive was the only source for those
pages — but "use the Wayback because the site is gone" and "use the Wayback
because this page is gone" are different findings, and only the second was
true. Say which.

**A 404 on the URL the page names is not proof the picture is gone.** A CMS
migration can move a site's images to a CDN the archive never crawled, while
the *older* copies stay indexed under the original domain. One dead site's
scanned manuals were referenced as
`img1.wsimg.com/isteam/ip/<uuid>/legacy/<hash>.jpg` — all 404 in the archive,
and `204 No Content` from the live CDN. The same hashes were present as
`thesite.com/images/<hash>.jpg`, captured before the migration, and remapping
recovered 35 of 39. **List what the archive holds for the whole domain before
concluding anything is lost.**

And when images are recovered this way, **rewrite the pages' `<img>` sources
onto them**. Otherwise the files sit beside pages that still point at the dead
host, and the archive renders exactly as empty as before — which the
resolved/unresolved baseline from §3 will tell you: 0 resolved before, 40
after.

**When something cannot be archived, write down that it cannot**, and why. A
future reader will otherwise repeat the search.

---

## 5. Size: measure, never estimate

Three separate size decisions went wrong by assuming:

1. **A sample of the largest files does not predict the set.** Sampling the
   biggest PNGs suggested re-encoding would reach 19% of original size; across
   all 1,707 images the real figure was **53%**. Quote a measured number or say
   explicitly that it is an estimate.
2. **Re-encoding can make files bigger.** Applying the same treatment to a set
   of already-efficient JPEGs took **31.5 MB to 45.7 MB** — and cost a
   generation of quality. **Test on a sample and compare before applying.**
3. **CMS duplicates are usually the real weight.** WordPress and similar
   generate `-150x150`, `-768x512` copies of every upload; one mirror held
   **323 MB of duplicate resized copies of the same 1,264 pictures.** Keeping
   the largest of each and rewriting references removed them with nothing lost.

**A CMS publishes feeds, and wget saves them as pages.** WordPress emits RSS
for the site, every category, every tag, every author and every post — **86
files on one mirror** — and each lands as `feed/index.html`, containing
`<?xml … <rss>` rather than HTML. Two consequences: a browser tries to parse
XML as HTML and renders a mess, and the feed's `<content:encoded>` repeats the
body of a post already archived beside it, so it is duplication as well as
noise.

Detect by the first bytes, not the extension, and keep them out of any index a
human reads. A word-count filter will not do it: a category feed carrying
several posts is long enough to pass.

**A CMS also duplicates PAGES, not just images.** WordPress serves every post
again at `?replytocom=N` — once per comment — and again at `?p=NNNN`. wget
follows those links and saves a byte-identical copy of each. On one mirror
**253 saved pages were 196 distinct documents**, with a single article stored
nine times.

That is cheap in bytes and expensive in readability: an index of the archive
listed the same title, at the same word count, nine times, and split the post's
photographs between the copies so each looked a third of its real size.
**Deduplicate by hashing the text, show the alias-free URL, and say how many
copies it stands for** — rather than deleting files that are already committed,
where deletion reclaims nothing.

**When rewriting references, map from the exact strings in the HTML**, not from
bare filenames — escaping, query strings and `srcset` entries all differ from
what is on disk. Then verify against the baseline from §3.

**Re-encoding someone else's mirror is legitimate; re-encoding the owner's own
originals is not.** The distinction is provenance: a third-party page is
already lossy and still online, so a smaller copy loses nothing that matters.
The owner's photographs are the primary record and are never converted.

---

## 6. Reading it back

- **Plain-looking is often correct.** Many older technical sites have no
  stylesheet at all; text with images *is* how they appear on their own server.
  Don't chase a rendering problem that isn't one.
- **Serve the archive over `http://` rather than opening files directly.** A
  `file://` page cannot reliably load subresources from sibling directories —
  Safari refuses outright, and archived pages lose their images and stylesheets
  — while over http:// the restriction does not exist and they behave like
  ordinary web pages in any browser. The whole mechanism is one line of stdlib:

  ```sh
  python3 -m http.server 8765 --bind 127.0.0.1
  ```

  **Bind loopback explicitly.** The default binds every interface, which puts a
  private record on the local network. `bin/archive-browse` wraps this, adds an
  index of what has been archived, and opens a browser at it.

  This is a *reading* tool. It cannot repair a page that was incomplete when
  captured, and it is not search — search is `grep` over the `.txt` beside each
  page, which is what those files are for.
- **URL-escape generated links; HTML-escaping is not the same thing.**
  `--restrict-file-names` writes a Wayback capture to a path holding a
  **literal percent sign** — `.../20240915160007/https%3A/example.com/page.html`.
  Put that in an `href` unchanged and the server percent-*decodes* it back to
  `https:/`, which does not exist. Every Wayback-captured page then 404s from
  the index while the files sit correctly on disk. `html.escape()` does not
  help; the path needs `quote()` so the `%` becomes `%25`.

  It fails silently in the worst way: the index builds, the counts are right,
  and only the archived pages you most needed the archive for are unreachable.
  **Verify by requesting every link the index emits and checking the status
  code** — not by opening one. On this record that was 1,039 links and took
  seconds.

- **Check generated markup mechanically, not by eye.** An index page built for
  this archive nested an `<a>` inside an `<a>`; browsers silently close the
  outer one, and the whole layout collapses in a way that looks like a styling
  problem rather than invalid HTML. One regex over the output would have caught
  it. *Same family as everything in §3 — the output looked plausible.*
- **Beware tooling that lies about binary-ish files.** `grep` on a file with
  very long lines or non-UTF-8 bytes may silently print nothing rather than
  matching — which once produced a confident, wrong diagnosis that a page had
  no stylesheets. Verify with something that decodes explicitly.

---

## 7. What to write down

Filing the page is not the task; **recording what it says is the task.**

- What the source is, **who wrote it**, and when it was retrieved
- Whether it is complete, and **what is missing that cannot be recovered**
- Which page of a series is the one worth reading
- **Why it was kept** — and if something was deliberately *not* kept, why not,
  so the same research is not repeated
- The local path, cited in preference to the URL. The URL is provenance
