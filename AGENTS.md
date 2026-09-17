# Agent guidance

This is the canonical contributor guidance for this repository. Start here, use
the [README](README.md) for orientation, and follow the [wiki](wiki/README.md)
for details relevant to the task. Copilot instructions and project skills refer
here rather than maintain competing project rules.

## Purpose and architecture

NEWSUSE | Algorithms supports a scientific study of Facebook engagement and
posting by news outlets and non-news pages before, during, and after the
"War on News" policy period. Current ingestion covers 2016 through December
2025. Reactions per post are the main modeled outcome; news quality tiers and
non-news pages support comparisons across detected epochs. Policy annotations
and statistical changepoints are separate evidence. See [study design](wiki/study-design.md).

- `project/` is a small Python configuration bridge, not the analysis engine.
  Both Python and R use its `config` and `paths` exports.
- `stages/` holds executable scripts: Python wrangling and postprocessing, R
  GLMM fitting and BEAST detection. Do not import a stage to inspect it: its
  top-level code can run expensive work and overwrite outputs.
- `dvc.yaml` defines 12 active stages, including `glmm@reactions` expanded by
  `foreach`. `dvc.lock` also contains historical entries; it is not an active
  stage inventory. See the [pipeline reference](wiki/dvc-pipeline.md).
- `analyses/` contains manually rendered Quarto notebooks. They perform further
  inference and produce publication outputs outside DVC; `timeseries.qmd` also
  fits models. See the [notebook map](wiki/analyses-and-outputs.md).
- `params.yaml` holds shared configuration, but formulas and some notebook
  constants remain in code. The external `newsuse` package is pinned to `v2.3`
  in `pyproject.toml`; its source is not part of this repository.

## Working on a task

1. Inspect `git status` and relevant sources before editing. Preserve existing
   edits and active computations, including DVC lockfiles and outputs.
2. Read the relevant wiki page, then verify claims against current source.
   Implementation outranks stale prose as evidence of behavior; comments alone
   do not establish scientific validity or implementation details.
3. Use `from project import config, paths` in Python. R uses reticulate with the
   Python interpreter from its Conda environment. Keep configuration and path
   resolution shared; see [architecture](wiki/architecture.md).
4. Trace inputs, outputs, downstream stages, and notebook consumers before
   changing a data contract or scientific calculation. For computational changes,
   maintain affected DVC `deps`, `params`, and `outs`; current declarations have
   [known coverage gaps](wiki/dvc-pipeline.md#tracking-boundaries).
5. Validate the affected behavior at the smallest useful scope. Explain what was
   checked, what remains unverified, and any impact on scientific results.
6. Update affected durable documentation when behavior or workflow changes.
   Put operating instructions here and detailed explanations in the wiki.

## Scientific contracts to preserve

Changes to these are scientific changes, even when the code edit looks small.
Read the [data contracts](wiki/data-contracts.md) and
[statistical methods](wiki/statistical-methods.md) before altering them.

- Preserve deterministic post keys, join cardinality, deduplication order, and
  the distinction between raw imputation keys and regenerated news keys.
- Original nonmissing news reactions take precedence over imputed values.
  The 2025 extension has its own append, metadata-fill, and deduplication path.
- Weekly engagement averages daily means over observed posting days; signal
  construction then averages across outlets. These are not pooled post means.
- `reactions_avg` is an observed outlet mean. Relative predicted means divide
  by it. The dataset stores the reciprocal of the preliminary NB2 dispersion
  prediction; do not confuse this with final NB1 dispersion.
- Preserve factor order, conditional and dispersion formulas, random effects,
  and link/response scales. Final fitted models disable zero inflation.
- Epochs come from the selected changepoint subset, start at zero, and are
  assigned by post time. The filter is `n_posts > epochs.min_posts` (currently
  strictly more than 20), not greater than or equal to 20.
- Inspect notebook contrast weights, level order, sign, and reference periods.
  Several assume 12 epochs and focal epochs 4, 8, and 11. New boundaries require
  reviewing these assumptions and the independent event annotations.
- Describe DiD contrasts as ratios of ratios on the response scale. Distinguish
  modeled associations from causal interpretations and their assumptions.

## Commands and validation

Activate `newsuse-study-algorithms` and work from the repository root for DVC.
Use the [development guide](wiki/development-and-reproducibility.md) for setup
and notebook prerequisites.

```bash
conda activate newsuse-study-algorithms
dvc stage list
dvc dag
dvc status
make lint
make mypy
```

`make lint` and `make mypy` check only `project/`. Pytest/coverage commands are
configured, but no dedicated test suite is tracked. Their existence does not
establish pipeline or statistical coverage. Choose checks suited to the actual
change; documentation changes need link, source-consistency, and skill checks.
Pre-commit includes automatic fixes and formatting, so review its edits.

`dvc repro <stage>` can rerun dependencies and overwrite large artifacts;
Quarto rendering executes notebook code. Run them when the task requires
recomputation, not as a routine documentation check. Inspect running work first;
do not remove a lock belonging to a live process. `make init` runs `git init`,
`dvc init --force`, replaces the local default remote, and installs packages.
It is initial provisioning, not routine environment activation or repair.

## Evidence and project skills

Link factual documentation to sources. Label local counts, schemas, and epoch
dates as snapshots; distinguish them from stable contracts. Do not invent paper
results, metadata provenance, or justifications absent from the repository.
Record suspected inconsistencies with evidence and verification limits,
without silently changing calculations to fit an interpretation.
Use [supporting analyses](wiki/supporting-analyses.md) for notebook-specific
weights and formulas, and the [concerns register](wiki/concerns/README.md) for
unresolved calculation, provenance, interpretation, and reproducibility questions.

- [agent-context-update](.github/skills/agent-context-update/SKILL.md): refresh
  guidance and documentation after repository changes.
- [create-wiki](.github/skills/create-wiki/SKILL.md): create durable reference pages.
- [update-wiki](.github/skills/update-wiki/SKILL.md): maintain existing reference pages.
- [investigate](.github/skills/investigate/SKILL.md): investigate behavior without
  modifying project files or artifacts.

The wiki has two layers: reference pages explain verified behavior; `wiki/concerns/`
holds detailed unresolved questions, classified evidence, verification limits,
and resolution criteria. Keep short caveats and links in the affected reference
pages. Documentation maintenance may update the register; an investigation only
reports findings and does not edit it. A prose correction does not resolve an
underlying computational concern. Neither layer is a session log, assignment
list, or authorization to change the analysis.
