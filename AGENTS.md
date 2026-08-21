# AGENTS.md

`kyriakon-site` is the static marketing/landing site for kyriakon.net.

## Orientation

**This repo is one of several `kyriakon-*` repos, cloned as siblings.** Read the meta repo first
for anything beyond a small, well-scoped change: `../kyriakon/docs/decisions/kyriakon-net-project-proposal.md`
and `../kyriakon/docs/CONTEXT.md`. If `../kyriakon` isn't present alongside this repo, say so
rather than guessing at proposal content.

## Build & test

- Static site; no build step for plain HTML/CSS/markdown. If a generator is introduced later, its
  build/test commands go here.
- The site promotes Kleio as the recommended password manager for `pass` repos hosted on
kyriakon.net (proposal §3, §7) — a copy/content requirement that must stay accurate against the live
offering.

## Code style

- **No secrets, ever, in any tracked file** — no API tokens, no analytics keys. Use
  `example.invalid` for any sample domain.
- Keep copy consistent with the meta repo's shared vocabulary (`../kyriakon/docs/CONTEXT.md`): say
  "shell-less user", not "shell user" or "pubnix user".

## Agent skills

### Issue tracker

Issues live in GitHub Issues, driven via the `gh` CLI. See `docs/agents/issue-tracker.md`.

### Triage labels

Five canonical triage labels, strings equal to their names: `needs-triage`, `needs-info`,
`ready-for-agent`, `ready-for-human`, `wontfix`. See `docs/agents/triage-labels.md`.

### Domain docs

Single-context. Shared vocabulary in the meta repo (`../kyriakon/docs/CONTEXT.md`). See
`docs/agents/domain.md`.
