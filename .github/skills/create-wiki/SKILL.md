---
name: create-wiki
description: Create source-supported project reference pages or evidence-backed concern records under wiki when documentation work is requested. Does not change computations or create session logs.
---

# Create wiki pages

Read [AGENTS.md](../../../AGENTS.md), the [wiki index](../../../wiki/README.md),
and nearby pages before choosing a new page. Extend an existing page when the
topic already has a clear home. Derive audience and purpose from the task;
clarify only ambiguities that materially affect the document.

Trace claims to the appropriate evidence: `dvc.yaml` for declared stages,
`stages/` for transformations and formulas, `params.yaml` for shared settings,
`analyses/` for downstream inference, and environment/build files for tooling.
Read-only artifact metadata can supplement these sources when available.
Never assume data access or execute a stage just to learn its schema.

Create pages only under `wiki/`, with descriptive lowercase, hyphenated names.
Explain what a contributor needs to understand or change the subsystem. Include
purpose, data flow, important contracts, limitations, and source links as useful;
do not force empty template sections. Use tables for inventories, equations for
implemented calculations, and Mermaid when a dependency diagram adds clarity.

Separate implementation facts from scientific interpretation and unverified
questions. Label artifact counts and dates as snapshots. Distinguish policy
annotations from detected epochs and declared DVC edges from runtime dependencies.
Use reference pages for verified behavior. Put detailed unresolved questions in
the [concerns register](../../../wiki/concerns/README.md), following its evidence,
classification, and resolution conventions. Link both ways and keep a brief
caveat beside the affected explanation. A concern record is technical evidence,
not an assignment or authorization to fix computations. Do not invent numerical
effects, create session logs, or mark a concern resolved by improving its prose.

Update `wiki/README.md` and affected wiki cross-links so the page is discoverable.
Validate relative links, Markdown fences, filenames, and claims against sources.
Do not modify files outside `wiki/`, execute model fits, or render analyses as
part of this skill. Report the new page and any evidence unavailable for review.

Adapted from the [confidantic reference skill](https://github.com/sztal/confidantic/blob/master/.github/skills/create-wiki/SKILL.md).
