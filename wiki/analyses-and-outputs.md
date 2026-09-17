# Analyses and publication outputs

[Wiki index](README.md) | [Methods](statistical-methods.md) | [Development](development-and-reproducibility.md)

## Execution model

The 11 `.qmd` files are manually executed Quarto notebooks, outside the DVC DAG.
[analyses/_quarto.yml](../analyses/_quarto.yml) only sets the project title.
Individual notebooks configure HTML/PDF formats, embedded HTML resources, and
execution with caching and daemon disabled. Rendering runs code, which can fit
models, write spreadsheets, and overwrite figures; it is not just formatting.

Mixed notebooks initialize R/reticulate and use the same `project` bridge as
stages. Python-only notebooks load it directly. Most final-model notebooks load
RDS files and use their stored model frames, so a current Parquet file does not
prove the model frame has been refreshed. See [architecture](architecture.md).

## Notebook inventory

Paths below omit the `data/proc/` prefix for processed tables. Figure destinations
are under `figures/`. LaTeX tables are generally printed into notebook output,
not saved as separate tracked `.tex` files.

| Notebook | Inputs / prerequisites | Computation and outputs |
|---|---|---|
| [descriptives.qmd](../analyses/descriptives.qmd) | Raw metadata, `dataset.parquet`, `non-news.parquet`. Python only. | [Descriptive calculations](supporting-analyses.md#descriptive-summaries), outlet distributions, engagement correlations; LaTeX tables and `descriptives/descriptives-basic.pdf`. |
| [timeseries.qmd](../analyses/timeseries.qmd) | `weekly.parquet`, `weekly-non-news.parquet`, events, election settings. R + Python. | [Gaussian and AR(1) models](supporting-analyses.md#posting-and-engagement-time-series), posting associations, model comparison, residual ACF, model table; `glmm/timeseries/timeseries.pdf`, `acf.pdf`. |
| [changepoints.qmd](../analyses/changepoints.qmd) | `dataset.parquet`, `epochs.parquet`, `changepoints.parquet`, `epoch-meta.parquet`, `signal.parquet`, events. Python only. | Relative mean/CV signal and peak-bound plots with annotations; event table; `changepoints/changepoints.pdf`, `changepoints-mean.pdf`. |
| [alternatives.qmd](../analyses/alternatives.qmd) | `comscore.parquet`, `timeseries.parquet`, raw Statista workbook, events. Python only. | [Normalized audience/engagement trends](supporting-analyses.md#audience-and-alternative-explanations) and platform user counts; `alternatives/comscore.pdf`, `statista.pdf`. |
| [glmm-news.qmd](../analyses/glmm-news.qmd) | `models/glmm/news/main.rds`, epochs/epoch metadata/peaks, dataset post types. R + Python. | Corrected EMMs, quality/epoch and sequential contrasts, joint tests, supplementary contrasts; LaTeX tables, four PDFs under `glmm/news/`, `outlets-emm-news.xlsx`. |
| [glmm-both.qmd](../analyses/glmm-both.qmd) | `models/glmm/both/quality.rds`, epochs/epoch metadata/peaks, non-news post types. R + Python. | Corrected sector/quality EMMs, baseline/sequential DiD, parallel-trends calculation, supplements; LaTeX tables, `glmm/both/both-emmeans.pdf`, `both-contrasts.pdf`, `outlets-emm-non-news.xlsx`. |
| [glmm-total.qmd](../analyses/glmm-total.qmd) | Joint `quality.rds`, epoch metadata, peaks. R + Python. | Focal epoch contrasts 4→8, 8→11, 4→11 and their news/non-news ratios; LaTeX tables, `glmm/total/emmeans.pdf`, `effects.pdf`. |
| [glmm-outlets.qmd](../analyses/glmm-outlets.qmd) | Dataset post types, epoch key map, `outlets-emm.xlsx` (see mismatch below). Python only. | Exploratory outlet ratios and post-type associations; inline results/plot, no explicit figure save. |
| [model-tables.qmd](../analyses/model-tables.qmd) | All three active RDS objects. R + Python. | Extends `broom.mixed` tidying to include dispersion fixed/random summaries; prints LaTeX coefficient tables. Creates a figure directory but saves no figure. |
| [validation/glmm-news.qmd](../analyses/validation/glmm-news.qmd) | News `main.rds` and stored model frame. R + Python. | Observed/predicted group means and conditional/dispersion random-effect distributions; four PDFs under `glmm/validation/news/`. |
| [validation/glmm-both.qmd](../analyses/validation/glmm-both.qmd) | Joint `quality.rds` and stored model frame. R + Python. | Corresponding diagnostics for the joint model; four PDFs under `glmm/validation/both/`. |

News-model figure names are `news-emmeans.pdf`, `news-contrast.pdf`,
`news-quality-contrast.pdf`, and `epochs-timeline.pdf`. Both validation notebooks
write `group-means-rdiffs.pdf`, `quality-means.pdf`, `cond-re.pdf`, and `disp-re.pdf`
in their respective directories. The validation notebooks inspect fitted models;
they do not refit alternative specifications.

## Notebook dependencies beyond DVC

The main model notebooks independently create their reference grids and do not
require running another notebook to populate Python/R variables. The
total-effects notebook loads the joint model and repeats its own correction
and grouping. Rendering it does not first execute `glmm-both.qmd`.

The notable file-level dependency is the outlet workflow: `glmm-news.qmd` writes
`outlets-emm-news.xlsx` and `glmm-both.qmd` writes `outlets-emm-non-news.xlsx`.
These contain observed outlet/epoch summaries, random-effect information, and
link-post proportions, despite the `emm` name. `glmm-outlets.qmd` instead reads
`outlets-emm.xlsx`. No tracked producer of that exact filename was found.
The [spreadsheet concern](concerns/reproducibility.md#notebook-execution-and-outlet-spreadsheet)
records the unresolved producer-consumer contract and the checks needed to
resolve it. Do not silently rename or combine the outputs.

`epoch-meta.parquet`, required by several notebooks, is written by changepoint
postprocessing but omitted from its DVC outputs. A clean checkout with pulled
tracked artifacts can therefore lack it. Inspect this explicitly before
rendering; `dvc status` alone cannot certify all notebook prerequisites.
See [DVC coverage](concerns/reproducibility.md#dvc-declaration-coverage).

## Epoch and artifact assumptions

- The joint and total notebooks assume epochs 0–11, an onset index of 5, an end
  index of 10, and a pre-policy baseline of 0–4. The total and outlet notebooks
  focus on 4, 8, and 11. The news notebook also has last-epoch plotting logic and
  positional supplementary contrasts.
- The event workbook independently carries changepoint numbers and bounds.
  Several notebooks select particular `(Changepoint, Event)` rows and plot the
  annotation date against a weekly signal. New segmentation, signal coverage,
  or annotation rows need alignment checks.
- Several plotting blocks extend first/last epoch start/mid/end values for
  visual spacing. Distinguish those in-memory display coordinates from saved
  epoch metadata when checking dates.
- Data-dependent column selections such as the `link` post-type column and
  hardcoded outlet examples can fail if the underlying sample changes.
- A directory-wide render includes exploratory and diagnostic work; there is
  no tracked render order resolving the outlet spreadsheet mismatch. Prefer a
  named notebook after checking its actual inputs.

See [fixed epoch positions](concerns/epochs-and-annotations.md#fixed-epoch-positions)
for compatibility checks after segmentation changes.

## Figure coordinates

The filenames below use the destinations in the notebook inventory. A figure's
annotation coordinate is distinct from the scientific observation or fitted mean.

| Source / figures | Time or annotation coordinate |
|---|---|
| [changepoints.qmd](../analyses/changepoints.qmd): `changepoints.pdf`, `changepoints-mean.pdf` | Signals use weekly timestamps; peaks/bounds are detected coordinates; event markers use workbook `Date`. Outer epoch start/end and midpoints are extended for display. The printed event table separately exposes detected timestamps and annotation dates. |
| [timeseries.qmd](../analyses/timeseries.qmd): `timeseries.pdf` | Smoothed weekly data; event markers use workbook `Date`, with configured elections and a fixed COVID date. `acf.pdf` uses residual-vector lag, not event dates. |
| [alternatives.qmd](../analyses/alternatives.qmd): `comscore.pdf` | Monthly plotted series; selected labels use workbook `Timestamp` (from `timestamp`), with month lookup for height and subsequent text adjustment. `statista.pdf` uses January 1 for each input year and has no policy-date overlay. |
| [glmm-news.qmd](../analyses/glmm-news.qmd), [glmm-both.qmd](../analyses/glmm-both.qmd): EMM, contrast, and epoch timeline figures | Saved epoch start/mid/end coordinates; some plotting data extend first/last intervals and shift labels for spacing. These display changes do not rewrite saved epoch metadata. |
| [glmm-total.qmd](../analyses/glmm-total.qmd): `emmeans.pdf`, `effects.pdf` | Categorical focal epoch/transition positions rather than an announcement-date time axis. |
| Descriptive, validation, and outlet plots; printed model tables | Distribution, group, or association coordinates; not policy-date annotations. See their source notebooks in the inventory. |

Alignment questions and resolution criteria belong in
[annotation coordinates](concerns/epochs-and-annotations.md#annotation-coordinates).

## Inference and interpretation

The EMM correction, model families, and contrast scales are described in
[methods](statistical-methods.md); other calculations are in
[supporting analyses](supporting-analyses.md). Consult
[calculation concerns](concerns/statistical-calculations.md) and
[interpretation concerns](concerns/inference-and-interpretation.md) before relying
on unresolved summaries. The wiki maps the computation; it does not certify
publication findings without a compatible, synchronized reproduction.
