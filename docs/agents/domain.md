# Domain Docs

How the engineering skills should consume this repo's domain documentation when exploring the codebase.

## Before exploring, read these

- **`../kyriakon/docs/CONTEXT.md`** — the shared glossary across all `kyriakon-*` repos (shell-less
  user, pricing tiers, dogfooding, audit us).
- **`../kyriakon/docs/decisions/`** — cross-cutting ADRs, starting with the founding project
  proposal. Read decisions that touch the area you're about to work in.
- **`CONTEXT.md`** at this repo's root — repo-local terms specific to this service/site, if any.

If any of these files don't exist, **proceed silently**. Don't flag their absence; don't suggest
creating them upfront. The `/domain-modeling` skill creates them lazily when terms or decisions
actually get resolved.

## File structure

Single-context repo (this repo):

```
/
├── CONTEXT.md                       ← repo-local vocabulary (optional)
└── docs/decisions/                  ← repo-local ADRs (optional)
```

Shared vocabulary and cross-cutting ADRs live in the meta repo (`../kyriakon`), not here.

## Use the glossary's vocabulary

When your output names a domain concept (in an issue title, a refactor proposal, a hypothesis, a
test name), use the term as defined in the meta repo's `CONTEXT.md`. Don't drift to synonyms the
glossary explicitly avoids.

If the concept you need isn't in the glossary yet, that's a signal — either you're inventing
language the project doesn't use (reconsider) or there's a real gap (note it for `/domain-modeling`).

## Flag ADR conflicts

If your output contradicts an existing ADR, surface it explicitly rather than silently overriding:

> _Contradicts ADR-0007 (event-sourced orders) — but worth reopening because…_
