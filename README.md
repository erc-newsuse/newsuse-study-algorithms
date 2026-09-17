# NEWSUSE | Algorithms

Analysis of the impact of news feed algorithm changes on Facebook on user engagement
and posting patterns of media organizations. Current ingestion covers 2016 through
December 2025, including the period before, during, and after the "War on News".

Contributor guidance: [AGENTS.md](AGENTS.md). Detailed project reference:
[wiki](wiki/README.md), including [data contracts](wiki/data-contracts.md), the
[DVC pipeline](wiki/dvc-pipeline.md), and [statistical methods](wiki/statistical-methods.md).
Notebook calculations are explained in [supporting analyses](wiki/supporting-analyses.md).
Unresolved discrepancies and verification limits have a separate
[concerns register](wiki/concerns/README.md).

Companion repository for the paper:

> **TBA**

This is a mixed **Python + R** project orchestrated by [DVC](https://dvc.org/)
(Data Version Control). Raw Facebook post data from Sotrender is processed through
a 12-stage pipeline that produces weekly time series, detects structural changepoints
via Bayesian methods, and fits generalized linear mixed models (GLMMs) to quantify
engagement shifts across detected epochs and news/non-news groups. Causal
interpretation depends on the study's comparison assumptions. Further inference
and figure generation are handled by [Quarto](https://quarto.org/) notebooks.


## Architecture and design decisions

### Why Python + R

The project uses **Python** for data wrangling, time series construction, and
changepoint postprocessing, and **R** for statistical modeling and inference.
The R components use three specialist packages:

- **`glmmTMB`** -- fitting complex GLMMs with separate dispersion sub-models,
  nested random effects, and negative binomial families (`nbinom1`, `nbinom2`)
- **`emmeans`** -- estimated marginal means, pairwise contrasts, and
  multiplicity-adjusted p-values (multivariate t distribution)
- **`Rbeast`** -- Bayesian Estimator of Abrupt change, Seasonality, and Trend;
  used for changepoint detection on engagement signals

### The `project/` bridge package

A small Python package (`project/`) serves as the single entry point for
configuration in both languages:

- **Python stages** import it directly: `from project import config, paths`
- **R stages** access it via reticulate: `reticulate::import("project")`

This guarantees that every stage -- regardless of language -- reads the same
parameter values and resolves file paths identically.

### Shared configuration in `params.yaml`

Shared parameters live in `params.yaml` and are consumed by both Python and R
through the `project` bridge package. Model formulas and some notebook constants
remain in code. DVC supplies the parameter mapping; `newsuse.config.Config`
resolves OmegaConf expressions, and its callable factories construct objects
when invoked. `project` explicitly constructs the rooted `Paths` object.
See [configuration details](wiki/architecture.md#configuration-lifecycle).

The file uses these `newsuse` configuration conventions:

| Syntax | Purpose |
|---|---|
| `@ref/subpath` | Hierarchical path references (e.g. `@proc/news.parquet` resolves to `data/proc/news.parquet`) |
| `make!:` | Callable factory specifications (e.g. `newsuse.config:Paths`, `matplotlib:cycler`); not all are constructed by `Config.resolve()` |
| `${eval:...}` | Inline arithmetic expressions (e.g. `${eval:365.25 / 12 / 7 * 2}` for a 2-month window in weeks) |

### Data exchange

- **Processed tables**: primarily Apache Parquet (Python tabular I/O and R `arrow`)
- **Fitted models**: R `.rds` files (serialized glmmTMB objects, loaded in analysis notebooks)
- **Auxiliary data**: Excel (`.xlsx`) for Statista, event annotations, and notebook outlet exports; ComScore uses Parquet


## DVC pipeline

The pipeline is defined in `dvc.yaml` and consists of **12 stages in three phases**.
All declared outputs use `persist: true` to avoid pre-run cleanup; stage commands
can still overwrite them. Additional script outputs and dependencies are not
fully declared; see the [tracking boundaries](wiki/dvc-pipeline.md#tracking-boundaries).

### Pipeline DAG

The main chain is news ingestion → preliminary GLMM → augmented dataset → weekly
summaries → signals → BEAST → epochs → final GLMMs. Non-news joins the weekly and
final-model branches; dense time series and ComScore support auxiliary analyses.
The 2025 input extends both sectors.

See the [full dependency graph and stage interfaces](wiki/dvc-pipeline.md), which
distinguishes DVC-declared edges from additional script dependencies.

### Stage summary

| Phase | Stage | Script | Language | Description |
|---|---|---|---|---|
| 1 | `news` | `stages/make_news.py` | Python | Process raw Sotrender news exports, generate deterministic keys, merge imputed reactions |
| 1 | `non-news` | `stages/make_nonnews.py` | Python | Process non-news Facebook page exports |
| 1 | `comscore` | `stages/make_comscore.py` | Python | Process ComScore audience data with bounded imputation |
| 1 | `glmm@reactions` | `stages/glmm_reactions.R` | R | Preliminary nbinom2 GLMM characterizing per-outlet engagement distributions |
| 1 | `dataset` | `stages/make_dataset.R` | R | Augment news data with GLMM-derived predictions (mean, variance, CV) |
| 2 | `weekly` | `stages/make_weekly.py` | Python | Two-step daily-to-weekly aggregation (daily means, then weekly means) |
| 2 | `signal` | `stages/make_signal.py` | Python | Country-level engagement signals from log-transformed weekly data |
| 2 | `timeseries` | `stages/make_timeseries.py` | Python | Grid within outlet observation spans; interpolate week indices and zero-fill missing counts/reactions |
| 3 | `changepoints-detect` | `stages/changepoints_detect.R` | R | 1000 seeded BEAST runs for each of two signal subsets |
| 3 | `changepoints-postprocess` | `stages/changepoints_postprocess.py` | Python | Aggregate probabilities, smooth, detect peaks, assign epoch labels |
| 3 | `glmm-news` | `stages/glmm_news.R` | R | nbinom1 GLMM testing quality x epoch interaction (news only) |
| 3 | `glmm-both` | `stages/glmm_both.R` | R | nbinom1 GLMM comparing news vs. non-news (difference-in-differences design) |

The `glmm` stage uses DVC's `foreach` expansion -- currently parameterized over
`[reactions]` -- to generate `glmm@reactions`.


## Stage scripts vs. analysis scripts

The project separates **automated pipeline stages** from **manual analysis**:

- **`stages/`**: 7 Python + 5 R scripts are executed by DVC (`dvc repro`) to
  produce processed data and fitted models. The additional `beast.R` is a
  historical standalone prototype, not an active stage or sourced helper.

- **`analyses/`** (Quarto `.qmd` notebooks): executed manually after the pipeline
  completes. They load fitted models and processed data, run `emmeans`-based
  inference (estimated marginal means, contrasts, difference-in-differences),
  and generate figures and LaTeX tables for the paper. `timeseries.qmd` also
  fits models during rendering. See the [complete notebook map](wiki/analyses-and-outputs.md)
  for inputs, outputs, and the outlet spreadsheet filename mismatch.

  | Notebook | Content |
  |---|---|
  | `descriptives.qmd` | Summary statistics and distributional plots (Python only) |
  | `timeseries.qmd` | AR(1) time series model, reactions-posts correlation |
  | `changepoints.qmd` | Changepoint probability visualization and epoch boundaries |
  | `alternatives.qmd` | Ruling out alternative explanations |
  | `glmm-news.qmd` | EMMs and contrasts for quality x epoch (news only) |
  | `glmm-both.qmd` | DiD analysis: news vs. non-news across epochs |
  | `glmm-total.qmd` | Total and causal effects across focal epochs (4, 8, 11) |
  | `glmm-outlets.qmd` | Outlet-level random effect analysis |
  | `model-tables.qmd` | Publication-ready model coefficient tables (LaTeX) |

- **`analyses/validation/`**: diagnostics of the existing news and joint models,
  including observed/predicted group means and random-effect distributions.
  These notebooks do not refit alternative model specifications.


## Repository setup

### Prerequisites

- [Conda](https://docs.anaconda.com/getting-started/) or [Miniconda](https://docs.anaconda.com/miniconda/)
- [Git](https://git-scm.com/)
- [DVC](https://dvc.org/) (installed via Conda, see `environment.yaml`)
- [Quarto](https://quarto.org/) (for rendering analysis notebooks)

### Initial setup

1. **Clone the repository**

```bash
git clone git@github.com:erc-newsuse/newsuse-study-algorithms.git
cd newsuse-study-algorithms
```

2. **Create and activate the Conda environment**

```bash
conda env create -f environment.yaml
conda activate newsuse-study-algorithms
```

The environment specifies Python >= 3.11 and < 3.13, R >= 4.3, DVC, and the
principal R dependencies except `glmmTMB` and `Rbeast` (installed next).
Quarto is installed separately; PDF rendering also needs a PDF/TeX toolchain.

3. **Initialize the project**

```bash
make init
```

This is initial provisioning, not routine maintenance of an existing checkout.
It runs `git init`, reinitializes DVC with `--force`, and replaces the local
default remote with `data/remote`. Review existing setup first. Its steps include:

- `pip install -e .[dev]` -- installs the `project/` package in editable mode
  along with all Python dependencies (including `newsuse` v2.3 from GitHub)
- `pre-commit install` -- sets up Git pre-commit hooks (ruff linting)
- Creates required directories (`data/raw/`, `data/proc/`, etc.)
- `dvc init --force` and `dvc remote add ... --local --force` -- initialize DVC and set the local default remote; enable DVC autostaging
- Installs pinned R packages via `remotes::install_version`:
  - `glmmTMB` 1.1.10
  - `Rbeast` 1.0.1

4. **Fetch raw data**

The following files have tracked DVC pointers but are not stored in Git.
Contact the study authors for appropriate data/remote access, or supply matching
files in `data/raw/`. The tracked DVC config does not define a shared remote;
`make init` creates a local remote path, not access to the authors' data.

Active pipeline inputs and the notebook's Statista input:

| File | Description |
|---|---|
| `news-us.parquet` | Facebook news post data from Sotrender |
| `non-news-us.parquet` | Facebook non-news page data from Sotrender |
| `metadata.parquet` | Outlet-level metadata (quality ratings, ideology, media type) |
| `imputed-reactions.parquet` | Imputed reaction counts for posts with missing data |
| `comscore.parquet` | ComScore monthly unique visitor estimates |
| `2025.parquet` | Extended 2025 data (news + non-news) |
| `statista-facebook-users.xlsx` | Statista reference data on Facebook user counts |

The Git-tracked `data/aux/events.xlsx` supplies notebook annotations.
Optional `content-news-us.parquet` and `content-non-news-us.parquet` files are
not inputs to the current DAG and have no tracked DVC pointers. Historical
classification artifacts and `ml` configuration do not define an active
classification workflow. See [data provenance](wiki/data-contracts.md).

If you have access to the DVC remote:

```bash
dvc pull
```


## Running the pipeline

### Inspect the pipeline

```bash
# List all stages
dvc stage list

# Visualize the DAG
dvc dag

# Check what needs to be (re)run
dvc status
```

### Execute the complete pipeline

```bash
dvc repro
```

### Execute specific stages

```bash
# Target stages and their changed dependencies
dvc repro news
dvc repro non-news
dvc repro dataset
dvc repro changepoints-detect
dvc repro glmm-news

# Everything up to and including a specific stage
dvc repro glmm-both
```


## Running the analyses

Ensure the required pipeline artifacts are ready, then check each notebook's
[additional prerequisites](wiki/analyses-and-outputs.md). DVC status alone is
insufficient: epoch metadata is an undeclared output, and the outlet notebook
expects a spreadsheet without a matching tracked producer.

```bash
cd analyses

# Render a single notebook
quarto render descriptives.qmd
quarto render glmm-both.qmd

# Render all notebooks only after resolving every notebook's prerequisites
quarto render

# Render validation analyses
cd validation
quarto render
```

Output format is configured per-notebook (HTML with embedded resources and/or PDF).


## Project structure

```
.
├── analyses/                 Quarto analysis notebooks (manual, post-pipeline)
│   ├── validation/           Fitted-model diagnostic notebooks
│   ├── _quarto.yml           Quarto project config
│   ├── descriptives.qmd
│   ├── timeseries.qmd
│   ├── changepoints.qmd
│   ├── alternatives.qmd
│   ├── glmm-news.qmd
│   ├── glmm-both.qmd
│   ├── glmm-total.qmd
│   ├── glmm-outlets.qmd
│   └── model-tables.qmd
├── data/
│   ├── raw/                  Raw input data (DVC-tracked, not in Git)
│   ├── proc/                 Processed data (pipeline outputs)
│   └── aux/                  Auxiliary data (event annotations, etc.)
├── figures/                  Generated plots (organized by analysis)
├── models/
│   └── glmm/                Fitted glmmTMB model objects (.rds)
├── project/                  Python bridge package
│   ├── __init__.py           Config + paths initialization
│   └── __about__.py          Version info
├── stages/                   DVC pipeline scripts
│   ├── make_news.py
│   ├── make_nonnews.py
│   ├── make_comscore.py
│   ├── make_dataset.R
│   ├── make_weekly.py
│   ├── make_signal.py
│   ├── make_timeseries.py
│   ├── glmm_reactions.R
│   ├── changepoints_detect.R
│   ├── changepoints_postprocess.py
│   ├── glmm_news.R
│   ├── glmm_both.R
│   └── beast.R               Historical standalone BEAST prototype
├── wiki/                     Detailed research and computational reference
├── AGENTS.md                 Canonical contributor guidance
├── .github/skills/           Four reusable project workflows
├── dvc.yaml                  Pipeline DAG definition
├── params.yaml               Shared project parameters
├── environment.yaml          Conda environment specification
├── pyproject.toml            Python project metadata and tool config
├── Makefile                  Development commands
└── README.md
```


## External dependencies

### `newsuse` library (v2.3)

The core dependency is the [`newsuse`](https://github.com/erc-newsuse/newsuse)
Python library (installed from GitHub via pip), which provides:

- **`newsuse.config.Config`** -- recursive parameter resolution with `make!:` factories
- **`newsuse.config.Paths`** -- path DSL (`@ref/subpath`) resolution into `pathlib.Path` objects
- **`newsuse.data.DataFrame`** -- pandas-based I/O wrapper dispatching by storage type, including Parquet and Excel
- **`newsuse.data.sotrender`** -- Sotrender export readers with filename-based metadata extraction

### Key R packages

| Package | Version | Purpose |
|---|---|---|
| `glmmTMB` | 1.1.10 | Generalized linear mixed models with dispersion modeling |
| `Rbeast` | 1.0.1 | Bayesian changepoint detection |
| `emmeans` | (conda) | Estimated marginal means and contrasts |
| `broom.mixed` | (conda) | Tidy model summaries for mixed models |
| `arrow` | (conda) | Parquet I/O for R |
| `reticulate` | (conda) | Python interop (imports `project` package from R) |


## Development tools

The project uses several code quality tools, configured in `pyproject.toml`:

| Tool | Command | Scope |
|---|---|---|
| **ruff** | `make lint` | Lint checks on `project/` only; no formatting in this target |
| **mypy** | `make mypy` | Static type checking of `project/` only |
| **pytest** | `make test` | Configured collection/doctests; no dedicated test suite is tracked |
| **coverage** | `make coverage` | Coverage of configured pytest collection, not pipeline validation |
| **pre-commit** | (automatic) | File checks, Ruff automatic fixes, and formatting; may rewrite files |

There is no tracked `tests/` directory. Stage assertions and notebook diagnostics
provide selected checks, not a comprehensive automated statistical test suite.
See [validation guidance](wiki/development-and-reproducibility.md#validation-by-change-type).
Run `make help` for a list of development commands.


## Troubleshooting

### DVC issues

```bash
# Check pipeline status
dvc status

# Inspect configuration
dvc config --list

# Force a target rerun only when intentional recomputation is required
dvc repro --force <stage-name>
```

### R package issues

If R packages fail to install or load, ensure the Conda environment is active and
install the pinned versions:

```bash
conda activate newsuse-study-algorithms
R -e 'remotes::install_version("glmmTMB", version = "1.1.10", repos = "http://cran.us.r-project.org", upgrade = "never")'
R -e 'remotes::install_version("Rbeast", version = "1.0.1", repos = "http://cran.us.r-project.org", upgrade = "never")'
```

### Python package issues

```bash
# Reinstall the project package and dependencies
pip install -e .[dev]

# Or update the full Conda environment
conda env update -f environment.yaml
```

### Quarto rendering

If Quarto notebooks fail, ensure:

1. Required models/data are current, including undeclared epoch metadata and notebook-specific inputs
2. The correct Conda environment and Quarto installation are available
3. R can find `reticulate` and the Python environment:
   `R -e 'reticulate::py_config()'`
