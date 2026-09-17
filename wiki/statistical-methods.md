# Statistical methods as implemented

[Wiki index](README.md) | [Study design](study-design.md) | [Notebook map](analyses-and-outputs.md)

This page describes calculations in the current sources. It does not establish
that every modeling choice has been independently validated. Shared settings
come from [params.yaml](../params.yaml); formulas and some contrast definitions
remain in scripts and notebooks.

## Preliminary news model

[glmm_reactions.R](../stages/glmm_reactions.R) fits an NB2 GLMM to news reactions.
Quality is ordered `low`, `medium`, `high`; year/month/day become factors. Rows
missing any selected modeling field are dropped. The conditional formula is:

```r
reactions ~ quality + log_n_posts +
    (1 | country:name) + (1 + quality | year:month:day)
```

The dispersion formula has the same predictors and random-effect structure.
Zero inflation is disabled by the actual `ziformula = ~0` call, despite the
helper's default. The post-frequency covariate enters this preliminary model;
it does not enter the final epoch models. The fitted object is saved to
`models/glmm/reactions/main.rds`.

[make_dataset.R](../stages/make_dataset.R) predicts mean `mu`, log-link value,
and dispersion `theta` using the model and the full news dataset, with
`allow.new.levels = TRUE`. Its NB2 summaries are:

```text
variance = mu * (1 + mu / theta)
CV       = sqrt(variance) / mu
```

The output stores `reactions_disp = 1 / theta`, not `theta`. Its
`reactions_avg` denominator comes from the **observed** outlet reactions in
[news ingestion](../stages/make_news.py), grouped by country/quality/name:

```text
reactions_rel      = reactions / reactions_avg
reactions_rel_mu   = mu / reactions_avg
reactions_rel_var  = variance / reactions_avg^2
reactions_rel_link = link - log(reactions_avg)
reactions_rel_cv   = CV
```

These are post-level predictions and normalized values; they are not weekly
values yet. The augmentation has a fallback replacing missing reactions with
rounded predictions, although current ingestion already removes missing
reactions. Changes to ingestion can therefore activate otherwise unused logic.

## Weekly aggregation and signals

[make_weekly.py](../stages/make_weekly.py) combines news and non-news, with
`quality = "non-news"` for the latter. It builds a week index from calendar
days and ISO-week transitions, computes daily outlet means, then averages the
daily means within each week. Post counts sum across days. Thus an observed
posting day has equal weight within an outlet/week, irrespective of its volume;
missing posting days are not inserted as zero days at this step. Weekly output
timestamps are normalized to Monday, and the sectors are saved separately.

[make_signal.py](../stages/make_signal.py) reads **news** weekly data. It logs
`reactions_mu` and `reactions_rel_mu`, leaves the CV variables unlogged, and
averages over outlets within `signal.groups` and `week_t`. Defaults group by
country. Exponentiating a logged mean signal yields a geometric aggregation of
outlet values, not the arithmetic mean of all posts. Weekly `n_posts` is also
averaged over outlets.

The script drops the first and last rows of the aggregated result to exclude
partial weeks. This is a global slice, not trimming within each country. The
current input is US-only; multi-country generalization needs review. The BEAST
time coordinate is `calendar_year + ISO_week / 52 + 0.5 / 52`, so it should not
be described as an exact day-of-year fraction.

The separate [make_timeseries.py](../stages/make_timeseries.py) builds an
outlet-by-week grid from both weekly tables, excludes the two endpoint weeks,
interpolates **week indices only inside observed spans**, drops unresolved
endpoints, and fills missing `n_posts` and `reactions` with zero. It asserts no
nulls and consecutive week indices per outlet group. It does not interpolate
engagement or guarantee coverage outside each outlet's observed span.

## BEAST detection and peak selection

[changepoints_detect.R](../stages/changepoints_detect.R) uses master seed 303
to sample 1,000 distinct seeds. It reuses that seed list across two configured
subsets: `(reactions_mu, reactions_cv)` and
`(reactions_rel_mu, reactions_rel_cv)`. Each subset gets 1,000 `beast123` calls.
Metadata supplies irregular ordering, weekly `deltaTime = 1/52`, no seasonal
component, outliers enabled, and no preliminary detrending/deseasonalization.
The trend prior allows orders 0–1, 0–30 knots, and a minimum separation of 13
time steps. Output retains subset, run index, candidate date, and probability.

[changepoints_postprocess.py](../stages/changepoints_postprocess.py) then:

1. Combines probabilities at a shared subset/run/date with `1 - product(1 - p)`.
2. Constructs calendar month/day fields from the fractional dates, matches
   calendar year and ISO week to a grid derived from the news dataset, and
   combines multiple candidates within a run/week using the same operation.
3. Sums weekly probabilities over runs and divides by the maximum observed run
   index. Missing weekly probabilities become zero.
4. Applies a trailing rolling window, again using `1 - product(1 - p)`, and
   backward-fills the initial window gaps. The configured timescale is about
   8.70 weeks, rounded to nine for the rolling window.
5. Runs `scipy.signal.find_peaks` with configured distance (the unrounded
   timescale), prominence 0.05, and height 0.5. It measures peak widths with
   `peak_widths` defaults, rounds the left/right grid positions, and adds six
   days to the right date.

The selected subset is `reactions-rel-mu-cv`. Peak widths describe the shape
of the processed probability curve at the default half-prominence level;
they are not automatically Bayesian credible intervals for a changepoint date.
The product-complement operations and rolling transformation should be described
explicitly, rather than calling the final curve a simple average posterior.

## Epoch construction

Postprocessing initializes all news and non-news posts to epoch 0. For each
selected peak time, posts with `timestamp >= boundary` advance one epoch.
`epoch_t` is elapsed weeks from the most recent boundary; the initial boundary
is the earliest combined post timestamp. It retains country/name/epoch groups
with `n_posts > epochs.min_posts`, currently **at least 21** posts. The resulting
key map contains only `key`, `epoch`, and `epoch_t`.

Epoch metadata uses the news dataset's minimum and maximum timestamps plus
detected boundaries, saving start/mid/end with epoch implied by row order.
It can retain time-of-day offsets from source timestamps. In the reviewed
local snapshot there were 12 epochs, but neither 12 nor their dates is a
general BEAST guarantee. [Notebook conventions](analyses-and-outputs.md#epoch-and-artifact-assumptions)
depend on this particular segmentation.

The following dates summarize that **2026-09-17 local artifact observation**.
Displayed dates omit time-of-day; actual assignment uses full timestamps.
Adjacent intervals share a boundary, with posts at that timestamp assigned to
the later epoch. The final end is the observed news endpoint.

| Epoch | Start date | End date |
|---|---|---|
| 0 | 2016-01-01 | 2016-06-20 |
| 1 | 2016-06-20 | 2017-03-06 |
| 2 | 2017-03-06 | 2018-03-19 |
| 3 | 2018-03-19 | 2020-04-06 |
| 4 | 2020-04-06 | 2021-03-01 |
| 5 | 2021-03-01 | 2021-08-02 |
| 6 | 2021-08-02 | 2022-10-10 |
| 7 | 2022-10-10 | 2023-06-26 |
| 8 | 2023-06-26 | 2024-09-02 |
| 9 | 2024-09-02 | 2025-03-10 |
| 10 | 2025-03-10 | 2025-09-22 |
| 11 | 2025-09-22 | 2025-12-16 |

These boundaries are not policy dates or guaranteed outputs of a future run.
Artifact synchronization was not established; see the
[freshness record](development-and-reproducibility.md#review-snapshot-and-freshness).

## Final epoch models

Both final fits use NB1, with variance convention `mu * (1 + phi)`, and
`ziformula = ~0`. Each uses `optim` with CG, up to 1,000 iterations, profiling
disabled, and parallelism capped by `parallel.maxcores` (16). Optimizer and
family choices are implemented facts; comments asserting superior fit are not
a substitute for a recorded comparison.

The [news model](../stages/glmm_news.R) fits:

```r
# Conditional
reactions ~ 1 + quality * epoch +
    (1 | country:name) + (1 | country:name:epoch) +
    (1 + quality | year:month:day)
# Dispersion
~ quality * epoch + (1 | country:name) + (1 | country:name:epoch)
```

It explicitly sets quality levels `low`, `medium`, `high` and epoch as a factor,
joins the eligible epoch map, and drops rows without epochs. Ideology and media
are prepared but do not enter these formulas. Output: `models/glmm/news/main.rds`.

The [joint model](../stages/glmm_both.R) adds non-news posts with quality set to
`non-news`, and sector levels `non-news`, `news`:

```r
# Conditional
reactions ~ 1 + quality * epoch +
    (1 | country:sector:name) + (1 | country:sector:name:epoch) +
    (1 | quality:year:month:day)
# Dispersion
~ 1 + (1 | country:sector:name) + (1 | country:sector:name:epoch)
```

Quality is not explicitly reordered in this fitting script; inference notebooks
subsequently permute the reference grid to `non-news`, `low`, `medium`, `high`.
The joint dispersion model has no fixed quality-by-epoch term, but **does** have
outlet/epoch random effects. Output: `models/glmm/both/quality.rds`.

## Marginal means and contrasts

[glmm-news.qmd](../analyses/glmm-news.qmd),
[glmm-both.qmd](../analyses/glmm-both.qmd), and
[glmm-total.qmd](../analyses/glmm-total.qmd) extract conditional outlet and
outlet/epoch random effects. Within quality/epoch groups they compute the
variance of their sums, then adjust the `emmeans` reference-grid coefficients
by solving `X * offset = variance / 2` and adding the solution to `rg@bhat`.
This implements a log-scale heterogeneity correction. The response remains
negative-binomial; a lognormal-moment argument for a latent mean does not make
the observed count distribution lognormal. The code changes the coefficient
point estimates without explicitly propagating uncertainty in this correction.

Inference defaults are alpha 0.05, confidence 0.95, and `mvt` multiplicity
adjustment, with notebook-specific overrides/seeds. Contrast families include
effects relative to a grand mean, consecutive epochs, and quality differences
within epochs. The joint grid groups three news quality levels into a news
sector, with equal-quality contrast weights where explicitly coded.

For before/after means, the intended DiD response-scale quantity is:

```text
RR = (news_after / news_before) / (nonnews_after / nonnews_before)
```

The baseline in the joint notebook uses equal log-scale weights across epochs
0–4. The total-effects notebook compares 4→8, 8→11, and 4→11. Some supplementary
contrasts reverse signs; always inspect their actual weights before interpreting
a ratio above or below one as a decrease, recovery, or relative disadvantage.

## Interpretation and review points

These source discrepancies need targeted investigation before relying on the
affected numerical results; this documentation does not measure their impact.

- In [glmm-both.qmd](../analyses/glmm-both.qmd), the parallel-trends section takes
  estimates from `ptcon` but covariance from `con`, an earlier overall epoch
  contrast rather than that interaction object. The "before" index range also
  uses `1:START_WAR`, whereas the baseline is described as epochs 0–4. Verify
  covariance alignment and the transition included at the intervention boundary.
- Both validation notebooks compute `sigma` using an NB2-style
  `mu * (1 + mu / theta)` expression while loading final NB1 models. Check the
  intended dispersion interpretation and whether that summary is used by a
  reported result. See [news validation](../analyses/validation/glmm-news.qmd)
  and [joint validation](../analyses/validation/glmm-both.qmd).
- The news supplement assigns contrast weights at R positions 5 and 10; the
  joint supplement uses 5 and 9. With epochs 0–11, these compare 4→9 and 4→8,
  respectively. Do not describe them as the same interval without verification.
- Fractional-year conversion in postprocessing independently constructs month
  and day, rather than using a single decimal-year conversion. Year/ISO-week
  matching and normalization by maximum observed run index also embed
  assumptions, including retention of the last run. Check boundary and empty-run
  behavior before changing the time range or treating this as a general method.

Data-derived epochs are treated as fixed in downstream model inference. These
scripts do not propagate changepoint-selection uncertainty through the final
GLMM contrasts. Non-news counterfactual validity and annotation alignment are
additional interpretation questions described in [study design](study-design.md).
