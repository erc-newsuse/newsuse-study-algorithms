---
name: agent-context-update
description: Audit and refresh this repository's AGENTS.md, Copilot instructions, project skills, and affected wiki or README guidance after architecture, data, tooling, or workflow changes. Does not change computations.
---

# Agent context update

Read [AGENTS.md](../../../AGENTS.md) and the [wiki index](../../../wiki/README.md).
Use a supplied focus or revision range when available; otherwise audit the
complete agent guidance and all four project skills.

Inspect the working tree, tracked inventory, and relevant source changes before
editing. Verify architecture and commands against `project/`, `stages/`,
`analyses/`, `dvc.yaml`, `params.yaml`, `environment.yaml`, `pyproject.toml`, and
`Makefile`. Compare active DVC declarations with actual reads, writes, and
configuration usage; historical lock entries are not active stages.

Update durable operating rules in root `AGENTS.md`. Keep Copilot instructions a
short entry point. Put detailed explanations in the relevant wiki pages and
correct affected README claims. Update skill paths, triggers, and commands when
needed; avoid duplicating architecture descriptions across skills.

Distinguish verified code behavior, observed artifact snapshots, scientific
assumptions, and unresolved discrepancies. Do not promote a comment's rationale
to a verified result. Maintain source links and navigation; remove unsupported
claims rather than filling gaps with guesses. Keep task progress and bug
backlogs out of the wiki.

Limit edits to agent guidance and documentation. Preserve unrelated work;
do not install dependencies, run `make init`, reproduce stages, render notebooks,
or update DVC/data/model artifacts to refresh context. If a discrepancy needs a
computational fix, report the evidence and suggested follow-up separately.

Validate skill frontmatter and links, compare documented stages and notebooks
with their source inventory, and reread changed guidance for agreement.
Report changed documents, checks performed, and remaining verification limits.

Adapted from the [confidantic reference skill](https://github.com/sztal/confidantic/blob/master/.github/skills/agent-context-update/SKILL.md).
