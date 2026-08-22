# Kyriakon.net website — plan & decisions

Status: **coming-soon placeholder** — the splash page is built, nothing is live yet.
Repo: `kyriakon-site`. Hosted on GitHub Pages to begin with; the long-term home is
the OpenBSD box's `httpd` (proposal §9, Phase 2).

## Decisions made

- **Stack**: static HTML + Tailwind CSS **standalone CLI** (v4, no Node, no `package.json`).
  Build: `./build.sh`; compiled CSS is committed so Pages serves it without a build.
- **Dev server**: `bun dev.ts` — serves at `http://localhost:8017`, rebuilds Tailwind on any
  HTML/`src/input.css` change, live-reloads via a polling `/__version` endpoint.
- **Pages**: `index.html` (splash, 2/1 card layout — Hosting + Kyriakon Press side-by-side,
  Kleio full-width below) + `/hosting/`, `/press/`, `/kleio/` under-construction pages
  (fully centred on screen, "Still under construction - check back soon! 🏗️").
- **Brand**: the ☧ Chi-Rho mark rendered as a text glyph (crimson, bold, `scale-x-125`,
  arrow cursor); `assets/kyriakon.png` kept as the favicon.
- **Colour**: burgundy/crimson `#7b1e26` primary, muted liturgical gold `#b8860b` secondary,
  warm off-white `#faf7f2` background, near-black ink `#1c1a17`.
- **Typography**: serif display stack (`Iowan Old Style`/Palatino/Georgia) + system sans body.
- **Copy** (exact, current):
  - Tagline: "Secure email, static web hosting, and pass repositories."
  - Subline: "Principled hosting, run by Orthodox Christians."
  - Trust line (blockquote, gray left bar): "Secure email, a config you can audit yourself,
    and Orthodox admins you can actually meet."
  - Hosting card: "Prioritize your privacy with secure zero-access mail - built to last,
    security by design. Your subscription also includes static web hosting and gemini for a
    simple web presence." Footer: "Built on OpenBSD" / "£20 / Year".
  - Press card: "Orthodox liturgical and catechetical publishing." Footer: "Explore volumes →".
  - Kleio card: "Kleio - the pass-compatible password manager we recommend for communal
    security. Built for longevity with open-source stewardship." Buttons: "View Repository"
    (→ `github.com/kyriakon/kleio`, new tab) and "Learn More" (→ `/kleio/`). Whole card
    clickable → `/kleio/`.
  - Footer: "**Audit us.** Every non-secret piece of infrastructure config is published on
    GitHub." (left) + envelope icon + `hello@kyriakon.net` mailto link (right).
- **Style rules**: no em-dashes anywhere (plain hyphens); "gemini" lowercase in card copy;
  card icons are solid-ink SVGs (envelope / bookcase / lock); the Kleio card's gold border
  hover is suppressed while over the "View Repository" button only (CSS `:has()`), and
  "Learn More" has no hover effect.
- **Vocabulary** (shared terms from `../kyriakon/docs/CONTEXT.md`): `shell-less user`,
  `audit us`, `zero-access mail`, `recovery phrase`. Mail is **zero-access mail** — never
  "encrypted at rest" (too weak) or "end-to-end" (overclaim).
- **Domain**: `kyriakon.net` apex canonical, `www.kyriakon.net` redirects to it. Temporary
  GitHub Pages bridge until the box's `httpd` takes over (§9 Phase 2).

## Sections / services

- **Hosting** — email, static + Gemini web, `pass` git repos. Core offering; page (`/hosting/`).
- **Kleio** — `pass`-compatible password manager (repo: `github.com/kyriakon/kleio`); page
  (`/kleio/`), intended `kleio.kyriakon.net`.
- **Press** — "Kyriakon Press", Orthodox liturgical/catechetical publishing; page (`/press/`),
  intended `press.kyriakon.net`.

## Deployment — steps for Oliver (not yet done)

### 1. Cloudflare Email Routing (manual, dashboard)

1. Cloudflare dashboard → kyriakon.net → **Email**.
2. Email Routing is already enabled (MX records point at Cloudflare).
3. Add Oliver's personal inbox as a **destination address** and click the verification email.
4. Add a routing rule: `hello@kyriakon.net` → that destination.
5. **Do not delete**: the `ob.kyriakon.net` record (personal site) or the MX records.

### 2. DNS → GitHub Pages (Cloudflare dashboard)

1. Add four **A records** for the apex, **DNS-only (grey cloud, not proxied)**:
   - `@` → `185.199.108.153`
   - `@` → `185.199.109.153`
   - `@` → `185.199.110.153`
   - `@` → `185.199.111.153`
2. Add a **redirect rule**: `www.kyriakon.net/*` → `https://kyriakon.net/$1` (301).
3. Leave MX and `ob.kyriakon.net` untouched. (`CNAME` file is already committed:
   `kyriakon.net`; `.nojekyll` too.)

### 3. GitHub Pages

1. Push `kyriakon-site` to GitHub (`kyriakon/kyriakon-site`).
2. Repo → Settings → Pages → source: branch `main`, folder `/ (root)`.
3. Custom domain: `kyriakon.net`.
4. Tick **Enforce HTTPS** once DNS has propagated.

### 4. Press/Kleio subdomains (deferred)

`press.kyriakon.net` and `kleio.kyriakon.net` are intended as separate sites — each needs
its own GitHub Pages repo + CNAME (or a box `httpd` vhost later, or a Cloudflare redirect
to `kyriakon.net/press/` / `kyriakon.net/kleio/`). Cards link to `/press/` and `/kleio/`
for now.

### 5. Long-term (Phase 2)

Move the site to the box's `httpd`; DNS moves from Cloudflare to `nsd` + Hurricane Electric
(proposal §6.13); remove the GitHub Pages A records.

## Content requirements (from the proposal)

- Promotes Kleio as the recommended password manager (§3, §7) — "View Repository" links the Kleio repo.
- Individual tier at £20/yr if pricing is shown (§2) — "£20 / Year" in the Hosting card footer.
- "Audit us" posture — all non-secret infra config is published for audit (§2); footer links `kyriakon-infra`.
