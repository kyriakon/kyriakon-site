# kyriakon-site

Static marketing/landing site for [kyriakon.net](https://kyriakon.net) — secure email,
static web hosting, and `pass` repositories, run by Orthodox Christians.

Built as plain static HTML + [Tailwind CSS v4](https://tailwindcss.com) via the **standalone
CLI** — no Node, no `package.json`, no build step on the server. Compiled CSS is committed,
so GitHub Pages serves the site straight from the repo.

## Stack

- **HTML** — semantic, hand-written, four pages (`/`, `/hosting/`, `/press/`, `/kleio/`).
- **Tailwind v4** — standalone binary, tokens defined in `src/input.css`.
- **Bun** — dev server only (`dev.ts`); not a runtime dependency of the site.

## Requirements

- `tailwindcss` standalone binary on `PATH` (macOS arm64: grab `tailwindcss-macos-arm64`
  from the [releases page](https://github.com/tailwindlabs/tailwindcss/releases)).
- `bun` — for the dev server only.

## Develop

```sh
bun dev.ts
```

Serves at **http://localhost:8017**, rebuilds Tailwind whenever `src/input.css` or any page
changes, and live-reloads the browser.

## Build

```sh
./build.sh
```

Compiles `src/input.css` → `assets/main.css` (minified). Run this and commit the result —
Pages has no build step.

## Deploy

Static site, hosted on GitHub Pages with a custom domain (`kyriakon.net`, see `CNAME`).
Push to `main`; Pages serves from the repo root. Full DNS/Pages setup steps live in
[`docs/site-plan.md`](docs/site-plan.md).

## Design

Visual system and style rules (colors, type, components, the no-em-dash rule) are documented
in [`DESIGN.md`](DESIGN.md). Shared vocabulary lives in the meta repo
(`../kyriakon/docs/CONTEXT.md`).

## Layout

```
index.html          splash page (cards, trust line, footer)
hosting/            under construction
press/              under construction
kleio/              under construction
src/input.css       Tailwind entry + theme tokens
assets/main.css     compiled CSS (committed)
assets/             favicon + mark
dev.ts              dev server + live reload
build.sh            Tailwind build
docs/site-plan.md   decisions + deployment steps
DESIGN.md           design system
```
