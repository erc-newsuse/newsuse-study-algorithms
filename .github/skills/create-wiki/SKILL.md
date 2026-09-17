---
name: create-wiki
description: Create source-supported research, architecture, data, pipeline, or technical reference pages under this repository's wiki directory. Use for durable project knowledge, not session logs or bug tracking.
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
Describe reproducibility limitations in context, without creating a task backlog
or inventing numerical effects of a suspected defect.

Update `wiki/README.md` and affected wiki cross-links so the page is discoverable.
Validate relative links, Markdown fences, filenames, and claims against sources.
Do not modify files outside `wiki/`, execute model fits, or render analyses as
part of this skill. Report the new page and any evidence unavailable for review.

Adapted from the [confidantic reference skill](https://github.com/sztal/confidantic/blob/master/.github/skills/create-wiki/SKILL.md).
