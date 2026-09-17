---
name: update-wiki
description: Correct or extend existing wiki pages when this research project's code, data contracts, methods, or workflows change. Maintains evidence and navigation without modifying computational files.
---

# Update wiki pages

Read [AGENTS.md](../../../AGENTS.md), the target page, its relevant source files,
and linked pages affected by the requested change. Use the
[wiki index](../../../wiki/README.md) to find the correct home when no page is named.

Determine whether the request corrects stale facts, adds verified information,
clarifies interpretation, or changes a documented decision. Check actual code
and configuration rather than copying comments or old README claims. For DVC
changes compare declarations with script I/O and notebook consumers; for
statistical changes inspect formulas, factor levels, and contrast definitions.

Make the smallest coherent update that covers affected pages. Preserve useful
context and source links; revise contradicted statements and cross-references.
Update the index for renamed or newly required pages. Keep detailed knowledge
in one place and link to it rather than duplicating it.

Label observations from local artifacts as snapshots and retain uncertainty
where data or reproduction evidence is unavailable. Never recast an unresolved
statistical inconsistency as a validated scientific conclusion. Keep durable
technical limitations in context and omit task-session logs and bug backlogs.

Edit only `wiki/`. Report needed changes to agent guidance or computational
files separately unless the user explicitly expands the task. Do not run
`dvc repro`, `make init`, or Quarto rendering to update prose. Check Markdown,
relative links, navigation, and source consistency; report what changed and
what was verified.

Adapted from the [confidantic reference skill](https://github.com/sztal/confidantic/blob/master/.github/skills/update-wiki/SKILL.md).
