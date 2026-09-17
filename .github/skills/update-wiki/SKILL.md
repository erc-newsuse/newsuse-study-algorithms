---
name: update-wiki
description: Correct or extend this project's wiki references and concern records when behavior, workflows, or supporting evidence changes. Maintains evidence and navigation without modifying computational files.
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
statistical inconsistency as a validated scientific conclusion. Keep verified
explanations in reference pages; consolidate detailed unresolved questions in
the [concerns register](../../../wiki/concerns/README.md), following its evidence,
classification, and resolution conventions. Preserve short caveats and links
beside the affected behavior, with links back from concern records. Resolve a
concern only with supporting evidence, not because its prose was corrected.
Omit session logs, assignments, and implementation commitments.

Edit only `wiki/`. Report needed changes to agent guidance or computational
files separately unless the user explicitly expands the task. Do not run
`dvc repro`, `make init`, or Quarto rendering to update prose. Check Markdown,
relative links, navigation, and source consistency; report what changed and
what was verified.

Adapted from the [confidantic reference skill](https://github.com/sztal/confidantic/blob/master/.github/skills/update-wiki/SKILL.md).
