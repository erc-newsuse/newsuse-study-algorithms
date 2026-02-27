# NEWSUSE | Algorithms — Copilot Instructions

## Project Overview

Research codebase for a paper analysing how Facebook algorithm changes affected news engagement (2021–2024). It is a **mixed Python + R project** orchestrated by DVC, with Quarto notebooks for analysis.

## Architecture

```
Raw data (DVC-tracked)
  └─> Python stages (data wrangling)   → data/proc/*.parquet
  └─> R stages (GLMM + changepoints)   → models/glmm/**, data/proc/beast.parquet
  └─> Python stages (signal/timeseries)
  └─> Quarto notebooks (analyses/)     → figures/**, HTML/PDF reports
```

- **`project/`** — installable Python package; accessed from both Python and R stages.
- **`stages/`** — DVC pipeline scripts (`.py` and `.R`). Each stage is a standalone script, not importable.
- **`analyses/`** — Quarto (`.qmd`) analysis notebooks; run manually after the pipeline, not part of DVC.
- **`params.yaml`** — single source of truth for all parameters consumed by both Python and R.
- **`dvc.yaml`** — declares the full DAG: inputs, outputs, params, and commands.

## Critical Patterns

### Accessing config and paths in Python stages

Every Python stage uses:

```python
from project import config, paths
```

`config` is a `newsuse.config.Config` object loaded from `dvc.api.params_show()`. `paths` is a resolved `Paths` object providing `pathlib.Path`-like attributes (e.g. `paths.news`, `paths.epochs`).

### Accessing config and paths in R stages and Quarto notebooks

R scripts import the Python `project` module via `reticulate`:

```r
use_python(normalizePath(R.home("../../bin/python")), required = TRUE)
project <- import("project")
config  <- project$config
paths   <- project$paths
```

Path objects support `/` operator: `paths$glmm / "news"`.

### Reading/writing data

- Python: `DataFrame.from_(path)` (from `newsuse.data`) and `df.to_(path)` — wraps Parquet I/O.
- R: `read_parquet(as.character(paths$news))` using `arrow`.

### `params.yaml` path DSL

Paths use `@ref/subpath` shorthand (e.g. `@proc/news.parquet` resolves relative to the `proc` key). `make!:` entries specify a factory class.

## Developer Workflows

### Setup (first time)

```bash
conda env create -f environment.yaml && conda activate newsuse-study-algorithms
make init   # installs pip package, pre-commit, inits DVC, installs glmmTMB + Rbeast via R
dvc pull    # fetch raw data (requires remote access)
```

**Note:** `glmmTMB` (1.1.10) and `Rbeast` (1.0.1) are pinned and installed via `make init` using `remotes::install_version`, not conda, because conda packages are commented out in `environment.yaml`.

### Run the full pipeline

```bash
dvc repro
```

### Run a specific stage

```bash
dvc repro glmm-news      # R-based GLMM for news
dvc repro changepoints-detect changepoints-postprocess
```

### Render analyses (after pipeline completes)

```bash
cd analyses && quarto render              # all notebooks
quarto render glmm-news.qmd              # single notebook
cd validation && quarto render           # validation analyses
```

### Lint / type-check Python

```bash
make lint    # ruff check project/
make mypy    # mypy project/
```

## Key Files

| File | Purpose |
|---|---|
| [dvc.yaml](../dvc.yaml) | Full pipeline DAG |
| [params.yaml](../params.yaml) | All parameters & path config |
| [project/\_\_init\_\_.py](../project/__init__.py) | `config` and `paths` exports |
| [stages/make_news.py](../stages/make_news.py) | Main data ingestion stage (pattern reference) |
| [stages/glmm_news.R](../stages/glmm_news.R) | R stage pattern with reticulate + glmmTMB |
| [environment.yaml](../environment.yaml) | Conda env (Python ≥ 3.11, R ≥ 4.3) |

## External Dependency

The `newsuse` Python library (`newsuse @ git+ssh://...newsuse.git@v2.3`) provides `DataFrame`, `Config`, and utilities. It is **not** in this repository — treat it as a stable external API.
