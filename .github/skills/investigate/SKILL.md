---
name: investigate
description: Investigate a reported pipeline, data, model, or notebook behavior using bounded read-only checks, and report evidence and a minimal fix direction without modifying project files or artifacts.
---

# Investigate

Read [AGENTS.md](../../../AGENTS.md). Start at the reported command, output,
formula, join, or notebook chunk. Establish expected and observed behavior and
inspect existing changes or active computations before checking artifacts.

Trace the controlling path through `params.yaml`, the `project` configuration
bridge, actual stage code, DVC declarations, and downstream notebook consumers.
Use the [wiki](../../../wiki/README.md) to navigate; verify its claims against
source. Distinguish active stages from historical lock entries and incidental
local files from reproducible inputs.

Prefer static inspection and small, isolated in-memory reproductions. When
data is available, inspect Parquet metadata or only necessary columns before
loading millions of posts. Use focused existing tests if relevant tests exist;
this repository currently has no tracked dedicated test suite. Check join
cardinality, missing values, timezones, aggregation weights, factor order,
model family, scale, and contrast direction as appropriate to the symptom.

Do not modify source, tests, configuration, documentation, lockfiles, data, or
models. Do not import top-level stage scripts, run `make init`, `dvc repro`,
`dvc pull`, or render notebooks: these can execute or overwrite the computation
being investigated. A tiny reproduction may use temporary files outside the
repository, provided it does not run the production pipeline or alter inputs.
Do not remove active DVC locks or interrupt another computation.

Report observed behavior, supporting paths and checks, confirmed findings,
remaining hypotheses, and the smallest plausible fix with a validation plan.
If read-only evidence cannot establish numerical impact, say so. Recommend a
separate authorized reproduction or implementation task rather than treating
investigation as permission to change the analysis. Return findings to the user;
do not create wiki pages or a bug tracker during this workflow.

Adapted from the [confidantic reference skill](https://github.com/sztal/confidantic/blob/master/.github/skills/investigate/SKILL.md).
