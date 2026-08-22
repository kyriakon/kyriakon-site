# DESIGN.md — kyriakon-site

Design system and visual decisions for the static marketing site. Source of truth is the
scaffold itself (`index.html`, the `/hosting/` `/press/` `/kleio/` stubs, `src/input.css`,
`assets/favicon.svg`); this document records the *why* so changes stay consistent.

## Principles

- **Quiet and liturgical, not corporate.** Warm paper background, serif display type, and
  a single crimson accent. The Chi-Rho mark carries the brand; no logo lockups, no hero
  imagery.
- **Trust through verifiability.** The "Audit us" footer posture is a content commitment,
  not a decoration — the design keeps it visible on every page without shouting.
- **Progressive by default.** Plain semantic HTML; the only JavaScript is the dev server's
  live-reload snippet, injected at serve time and never in committed markup.

## Brand

- **Mark**: the Chi-Rho glyph `☧` rendered as a text character — crimson, bold, stretched
  horizontally with `scale-x-125`. This is used as the header glyph, the sub-page glyph, and
  the SVG favicon (same fill, same `1.25` horizontal scale). No image asset for the logo.
- **Name**: "Kyriakon.net" in display serif, semibold, tight tracking.
- **Voice** (copy, not markup): plain hyphens only, never em-dashes; "gemini" lowercase.

## Color tokens

Defined in `src/input.css` as Tailwind v4 `@theme` CSS variables.

| Token      | Hex       | Role |
|------------|-----------|------|
| `ink`      | `#1c1a17` | Text, borders, icons, primary button fill |
| `paper`    | `#faf7f2` | Page background |
| `crimson`  | `#7b1e26` | Brand accent — mark, links, back-arrow |
| `gold`     | `#b8860b` | Secondary accent — card hover border |
| `byzantium`| `#702963` | Reserved (defined, currently unused) |

- **Opacity modifiers** do the tonal work: `text-ink/80`, `text-ink/60`, `border-ink/10`,
  `border-ink/25`, `bg-white/60`. No additional gray scale is defined — restraint is the rule.
- **Cards** sit on `bg-white/60` over `paper`, with `border-ink/10`; hover raises the border
  to `gold`.

## Typography

- **Display**: serif stack — `Iowan Old Style`, `Palatino`, `Georgia`, `Times New Roman`, serif.
  Used for headings, the blockquote, and the mark. Classes: `font-display`, `font-semibold`,
  `tracking-tight`.
- **Body**: system sans stack — `system-ui`, `-apple-system`, `Segoe UI`, `Roboto`, sans-serif.
  Used for all paragraph and label copy. Class: `font-body`.
- **Scale** (splash page): mark `text-6xl`; H1 `text-4xl` → `sm:text-5xl`; card H2 `text-xl`;
  body `text-lg` / `text-sm`; blockquote `text-xl italic`.
- **No web-font loading.** Everything falls back through locally installed faces.

## Layout

- **Container**: centered `max-w-3xl` on the splash, `max-w-2xl` on sub-pages, `px-6`,
  generous vertical padding (`py-16` → `sm:py-24`).
- **Splash**: header → 2-column card grid (`sm:grid-cols-2`, gap `6`) → trust blockquote →
  footer. The Kleio card spans both columns (`sm:col-span-2`) and is a wider row, not a
  third grid cell.
- **Sub-pages**: fully centered placeholder — mark, H1, "Still under construction" line, and a
  `← Back` link, vertically centered with `min-h-screen`.

## Components

### Card
`rounded-xl border border-ink/10 bg-white/60 p-6`, full-card `<a>`, hover → `border-gold`.
Footer row separated by `border-t border-ink/10` with `mt-auto` so both cards in a row
bottom-align. Icons are inline solid-ink SVGs (`stroke="currentColor"`, `aria-hidden`),
24×24 viewBox, stroke-width 1.5.

### Kleio card (special case)
`card-hover` + an absolutely-positioned overlay `<a href="/kleio/" aria-label="Kleio">` for
the whole-card click, with the two buttons (`View Repository`, `Learn More`) layered `z-10`
above it. The gold hover border is **suppressed** while hovering the "View Repository" button
only, via the one piece of custom CSS:

```css
.card-hover:hover:not(:has(.repo-btn:hover)) { border-color: var(--color-gold); }
```

"Learn More" has no hover effect; "View Repository" uses `bg-ink` fill.

### Blockquote (trust line)
`border-l-4 border-ink/25 pl-6`, display serif italic, `max-w-xl` centered.

### Footer
Full-width `border-t border-ink/10`; left = "**Audit us.**" line, right = envelope icon +
`hello@kyriakon.net` mailto. Stacks vertically on mobile (`flex-col sm:flex-row`).

## Interaction & state

- **Links**: underlined only where emphasis is needed (footer, back-arrow); hover → `crimson`.
- **Cards**: `transition` on border color, no lift/shadow.
- **Buttons**: `View Repository` is solid (`bg-ink` → `hover:bg-ink/90`, `text-paper`);
  `Learn More` is outlined (`border-ink/20 bg-white`), no hover.

## Accessibility

- Decorative SVGs (icons, the mark) are `aria-hidden="true"`.
- The Kleio overlay link carries an `aria-label` since it has no text content.
- Color contrast: `text-ink/60` secondary copy is for non-critical labels; primary copy stays
  full-strength `ink` on `paper`.
- Hover is never the only signal for a link — text is present; border change is an enhancement.

## File map

| File | Purpose |
|------|---------|
| `index.html` | Splash page (header, 3 cards, blockquote, footer) |
| `hosting/`, `press/`, `kleio/index.html` | Under-construction stubs, shared layout |
| `src/input.css` | Tailwind entry — `@theme` tokens + one custom rule |
| `assets/main.css` | Compiled output, committed |
| `assets/favicon.svg` / `favicon.png` | Chi-Rho mark, SVG + PNG fallback |
| `build.sh` | Compiles Tailwind via standalone CLI |
| `dev.ts` | Dev server + rebuild + live reload |

## Style rules (non-negotiable)

- No em-dashes anywhere; plain hyphens.
- "gemini" lowercase in card copy.
- Card icons are solid-ink, 24×24, stroke-width 1.5, `aria-hidden`.
- Shared vocabulary from `../kyriakon/docs/CONTEXT.md`: "shell-less user", "audit us",
  "zero-access mail", "recovery phrase". Never "encrypted at rest" or "end-to-end" for mail.
