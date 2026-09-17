# Architecture and configuration

[Wiki index](README.md) | [Pipeline](dvc-pipeline.md) | [Development](development-and-reproducibility.md)

## Components and responsibilities

| Component | Responsibility |
|---|---|
| [project/](../project/) | Installable Python bridge exporting configuration and rooted paths. |
| [stages/](../stages/) | Top-level Python and R scripts invoked by DVC. |
| [dvc.yaml](../dvc.yaml) | Active commands and declared dependencies, parameters, and outputs. |
| [params.yaml](../params.yaml) | Shared processing, BEAST, inference, path, and plotting settings. |
| [analyses/](../analyses/) | Manual Quarto inference, diagnostics, figures, and tables. |
| [environment.yaml](../environment.yaml), [pyproject.toml](../pyproject.toml), [Makefile](../Makefile) | Conda/Python requirements, package installation, development commands, and additional R installation. |

Python handles ingestion, aggregation, dense time-series construction, and
changepoint postprocessing. R supplies `glmmTMB`, `Rbeast`, and `emmeans` for
modeling and inference. Quarto notebooks mix languages through reticulate:
Python accesses `r.<object>` and R accesses `py$<object>`. The active pipeline
has seven Python and five R stages; [stages/beast.R](../stages/beast.R) is an
additional historical standalone script, not a sourced helper of the active stage.

This division centralizes file paths and shared parameters while keeping
scientific computation in scripts. It does not centralize every choice:
model formulas, some date handling, and notebook epoch constants are hardcoded.

## Configuration lifecycle

[project/__init__.py](../project/__init__.py) executes:

```python
root = Path(__file__).parent.parent
config = Config(dvc.api.params_show()).resolve()
paths = config.pop("paths")(root=root)
```

`dvc.api.params_show()` supplies the parameter mapping. In the inspected
`newsuse` v2.3 implementation, `Config` wraps OmegaConf; `resolve()` resolves
interpolations, including the registered `eval` resolver. `make!` nodes remain
factory specifications that can be called or invoked with `.make()`. Resolution
does not eagerly instantiate every factory. The last line above explicitly
constructs the `Paths` object and removes `paths` from `config`.

| Syntax | Consumer and effect |
|---|---|
| `${eval:365.25 / 12 / 7 * 2}` | `newsuse.config`/OmegaConf evaluates the expression. |
| `${..timescale}` / `${.alpha}` | OmegaConf relative interpolation. |
| `make!: "newsuse.config:Paths"` | Callable factory; `project` constructs it with the repository root. |
| `@proc/news.parquet` | `Paths` resolves another named path and its suffix on access. |
| Plotting `make!: "matplotlib:cycler"` | Notebooks explicitly call the factory while preparing `rcParams`. |

Use DVC commands from the project root. Rooting output paths in `project` does
not establish which repository a parameter lookup finds from an arbitrary
working directory. Imports load configuration once per Python module lifetime;
a long-running session should not assume it reloads after YAML edits.

External behavior was checked against installed v2.3 source, matching the
dependency in [pyproject.toml](../pyproject.toml). Upstream references:
[configuration](https://github.com/erc-newsuse/newsuse/blob/v2.3/newsuse/config/__init__.py)
and [paths](https://github.com/erc-newsuse/newsuse/blob/v2.3/newsuse/config/paths.py).
Some bridge comments describe more automatic factory resolution than the
executed implementation provides.

## Python and R access

Python stages typically use:

```python
from newsuse.data import DataFrame
from project import config, paths

data = DataFrame.from_(paths.news)
```

R stages select the environment-local interpreter and convert Python paths for R I/O:

```r
library(reticulate)
use_python(normalizePath(R.home("../../bin/python")), required = TRUE)
project <- import("project")
config <- project$config
paths <- project$paths
data <- arrow::read_parquet(as.character(paths$news))
```

Python path objects support `paths$glmm / "news"` in these R scripts. Several
notebooks copy the path namespace via `project$paths[["__copy__"]]()`. A
compatible R/Python environment is part of the runtime contract; launching
system R can select the wrong Python even if the shell's `python` looks correct.

## Storage and external dependencies

Processed tables use Parquet; Python uses the external `newsuse.data.DataFrame`
wrapper or pandas, and R uses Arrow. `DataFrame.from_`/`to_` dispatch by storage
type and also support Excel; they are not a repository-wide schema validator.
Column contracts and assertions are mainly expressed in stage code.

Fitted models are R `.rds` objects containing fitted state and model frames.
Notebook inference depends on compatibility and freshness, not just file
existence. Statista data, event annotations, and notebook outlet exports use
Excel; ComScore raw and processed data use Parquet.

`newsuse` is installed from GitHub over SSH at `v2.3`. It supplies configuration,
paths, tabular I/O, and `newsuse.data.sotrender` readers. Its availability and
transitive dependencies matter even though the local bridge is small. Inspect
that pinned version when external behavior is relevant. See
[data contracts](data-contracts.md) for timestamp and factor-conversion boundaries.
