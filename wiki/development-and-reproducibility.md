# Development and reproducibility

[Wiki index](README.md) | [Pipeline](dvc-pipeline.md) | [Notebook map](analyses-and-outputs.md)

## Environment

[environment.yaml](../environment.yaml) defines the Conda environment
`newsuse-study-algorithms`, using conda-forge, Python `>=3.11,<3.13`, and R
`>=4.3`. It includes DVC, its Google Drive extra, Arrow, reticulate, emmeans,
and the principal R analysis dependencies. It also pins several compiled
dependencies, including Matrix, lme4, TMB, nloptr, and SQLite.

[pyproject.toml](../pyproject.toml) installs the Python distribution
`newsuse-project-algorithms`, whose import package is `project`. It requires
Python >=3.11, the external `newsuse` library at Git tag `v2.3` over SSH, and
notebook/plotting dependencies. The environment constrains Python more narrowly
than the package metadata. Development extras install lint/type/test tools.

The [Makefile](../Makefile) installs `glmmTMB` 1.1.10 and `Rbeast` 1.0.1 with
`remotes::install_version`; their Conda entries are commented out. Quarto is
not declared in the Conda or Python manifests. PDF rendering also requires a
working PDF/TeX toolchain. Package manifests contain a mix of exact pins and
version ranges, not a complete environment lock, so a fresh environment is not
guaranteed to reproduce every installed version from an earlier run.

For an existing environment, activate it and inspect the executables before
installing or changing anything:

```bash
conda activate newsuse-study-algorithms
command -v python
command -v Rscript
command -v dvc
command -v quarto
python -m pip show newsuse newsuse-project-algorithms
```

R stages select Python relative to `R.home`, so R and Python must belong to
compatible installations. See [architecture](architecture.md) for the bridge.

## Provisioning and data access

The README's initial environment creation command is:

```bash
conda env create -f environment.yaml
conda activate newsuse-study-algorithms
```

`make init` is a provisioning command with substantial side effects: it runs
`git init`, installs the editable package and pre-commit hooks, creates
directories, runs `dvc init --force`, replaces the local default DVC remote with
`data/remote`, enables DVC autostaging, and installs the pinned R packages.
Do not use it merely to activate an existing environment or diagnose a failure.
For an existing checkout needing package installation, select the necessary
installation step from the Makefile instead of resetting repository configuration.

The tracked [.dvc/config](../.dvc/config) enables `core.autostage = true` but
does not specify a shared remote. Local configuration and storage determine
where `dvc pull` can retrieve data. The local directory configured by `make init`
does not itself provide the authors' data. Obtain appropriate access/storage or
supply matching input files; see [input inventory](data-contracts.md).

The SSH dependency on `newsuse` also requires repository access. Avoid copying
machine-specific paths or credentials into tracked documentation. Content-text
and classification artifacts without current pointers cannot be assumed to be
available from the active DVC pipeline.

## Inspect before executing

From the repository root:

```bash
git status --short
dvc stage list
dvc dag
dvc status
```

These DVC inspection commands do not intentionally reproduce stages, but DVC
may need access to its state database and runtime locks. If a process holds an
output lock, inspect the process and coordinate with existing work rather than
deleting its lock. A restricted filesystem can also prevent DVC opening its
state database; distinguish this tooling limitation from corrupt scientific data.

Stage declarations have [tracking gaps](dvc-pipeline.md#tracking-boundaries).
An "up to date" status covers declared dependencies, not all runtime inputs,
notebook prerequisites, package versions, or correctness of the analysis.

## Reproduction and rendering

When recomputation is the task and no conflicting computation is active:

```bash
dvc repro
# Or a target and its changed dependencies:
dvc repro glmm-news
dvc repro changepoints-detect changepoints-postprocess
```

The dataset contains millions of posts, fitted RDS files are hundreds of MB,
and BEAST is configured for 1,000 runs for each of two subsets. Final and
preliminary fits can use up to 16 cores. These are workload descriptions, not
runtime or memory guarantees. Inspect the target's full dependency chain before
launching it; `persist: true` does not protect outputs from being overwritten
by a stage script. Reproduction can update and autostage DVC metadata.

For an analysis, check the [notebook inventory](analyses-and-outputs.md), model
freshness, epoch metadata, annotation alignment, and any spreadsheet inputs.
Then render a named notebook in the configured environment, for example:

```bash
cd analyses
quarto render descriptives.qmd
quarto render glmm-total.qmd
quarto render validation/glmm-news.qmd
```

These examples are alternative targets, not a mandated sequence. Rendering
`timeseries.qmd` fits additional models. A directory-wide render includes the
outlet notebook with its unresolved input filename, so it is not a guaranteed
one-command publication build. Outputs are generally outside DVC tracking.

## Validation by change type

| Change | Useful validation and its limits |
|---|---|
| Documentation / skills | Verify source claims, relative links and anchors, Markdown fences, skill frontmatter, navigation, and inventory coverage. No model rerun is needed. |
| Python bridge | `make lint` (`ruff check project`) and `make mypy` (`mypy project`), plus a focused configuration check in the intended environment. These commands exclude stages and notebooks. |
| Data transformation | Focused examples for key/join cardinality, null handling, dates, and aggregation; inspect the affected DVC declarations and consumers. Run a relevant stage only when reproducing artifacts is part of the task. |
| Statistical model / inference | Check formula, factors, family/dispersion parameterization, contrast order and scale; assess convergence and changed estimates when a fit is performed. A successful process exit is not a scientific validation. |
| Notebook / figure | Check actual input contracts, render the relevant notebook when required, and inspect outputs rather than treating file creation as proof of correct labels or statistics. |

[pyproject.toml](../pyproject.toml) configures pytest to collect `tests` and
`project`, including doctests; the reviewed tracked tree has no `tests/`
directory or dedicated unit tests. `make test` invokes pytest and `make coverage`
wraps it, but those targets do not supply a hidden pipeline test suite.
Stage assertions cover selected invariants, such as keys, date endpoints,
integral reaction counts, and time-series continuity, not the entire analysis.

[.pre-commit-config.yaml](../.pre-commit-config.yaml) includes whitespace and
structured-file checks plus Ruff with `--fix` and formatting. These hooks can
rewrite files. Use checks appropriate to the task and review any resulting
edits rather than running broad mutation commands for documentation validation.

## Bounded checks before recomputation

Read scripts as text; importing their top-level code can execute the pipeline.
Use small in-memory inputs or selected Parquet columns in the configured
environment. These checks do not establish full scientific validity:

| Question | Check without fitting or rendering | Evidence requiring later, separately scoped work |
|---|---|---|
| Are weights and denominators intended? | Hand-calculate examples with unequal posts/day, outlets, and years; compare each aggregation level with the relevant expression. For outlet totals 100 and 300, the current descriptive reaction formula yields 100, versus mean 200. | Measure impact on exported results after the intended estimand is confirmed. |
| Which posts are eligible? | Inspect selected metadata nulls and small join fixtures, key uniqueness, default join types, grouping null rules, and the strict epoch threshold. Count weekly contributors using narrow columns. | A complete key-level attrition account across compatible raw and processed snapshots; collection records to explain missing weeks. |
| Are factors and contrasts aligned? | Enumerate declared levels and positional weights, translate R positions to epoch labels/dates, check signs and zero sums where appropriate. Trace covariance and estimates to the same contrast object. | Evaluate corrected contrasts from a compatible model and verify their downstream tables. |
| Which optimizer runs? | Inspect the stage call and `formals(glmmTMB::glmmTMBControl)$optimizer`; constructing the control object does not fit a model. Check `packageVersion("glmmTMB")` and distinguish `optArgs` from `optimizer`. | Inspect stored model calls, `fit$convergence`, optimizer messages, and `sdr$pdHess`; compare estimates/convergence if controls are changed. Loading large RDS files still has resource costs. |
| Can a notebook consume its inputs? | Match every read with an actual producer/schema; check epoch metadata, workbook fields, spreadsheet names, and sample-dependent columns. Inspect [seed scope](statistical-methods.md#optimizers-and-random-seeds) and [figure coordinates](analyses-and-outputs.md#figure-coordinates). | Render the named notebook in an isolated, compatible workflow and inspect its tables/figures when execution is part of the task. |

For example, an isolated pandas reproduction of the documented denominator is:

```python
import pandas as pd

totals = pd.Series([100.0, 300.0])
assert totals.div(len(totals)).mean() == 100.0  # current expression
assert totals.mean() == 200.0                  # mean of outlet totals
```

This checks arithmetic, not the intended scientific estimand. Similarly, a
two-post fixture with one missing quality label demonstrates exclusion from
`groupby(["country", "quality", "name"])` followed by an inner merge; it does
not establish current real-data losses. Record verified limitations in the
[concerns register](concerns/README.md) when documentation work is requested.
An [investigation](../.github/skills/investigate/SKILL.md) itself remains read-only.

## Review snapshot and freshness

During the initial documentation review on **2026-09-17**, read-only
`dvc stage list` and `dvc dag` inspection succeeded and confirmed 12 stages.
`dvc status` could not establish freshness because an existing `dvc repro`
process held the news-model directory lock. There were pre-existing changes
to `dvc.lock`; the review did not reset them, remove runtime locks, rerun models,
or render notebooks. The status observation is historical, not a claim that
the same process will still be running on a future visit.

The inspected project environment had `newsuse` 2.3, DVC 3.63.0, pandas 2.3.3,
and PyArrow 21.0.0. R/Python/DVC executables existed in that environment;
Quarto was absent from its `bin` directory. This does not rule out an external
Quarto installation. These observations supplement the manifests rather than
replace them with a machine-specific environment recipe.

The [data snapshot](data-contracts.md#observed-local-snapshot) describes files
seen during this review. It does not establish that stored models, current
tables, event annotations, and notebook exports all belong to one completed
pipeline run. Before using publication results, verify that relationship.
The [artifact synchronization concern](concerns/reproducibility.md#artifact-synchronization)
defines the evidence needed; [environment and optional-input gaps](concerns/reproducibility.md#optional-artifacts-and-environment)
remain distinct from whether a particular pipeline run completed.
