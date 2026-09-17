# Supporting analyses

[Wiki index](README.md) | [Notebook map](analyses-and-outputs.md) | [Concerns](concerns/README.md)

This page describes the descriptive, time-series, and audience analyses outside
the DVC model stages. Formulas describe implemented calculations, not validated
interpretations. Rendering executes code; the time-series notebook fits models.

## Descriptive summaries

[descriptives.qmd](../analyses/descriptives.qmd) combines the augmented news
dataset with non-news posts, assigning the latter `quality = "non-news"`.
Its basic table groups posts by quality and year. Post totals are row counts;
reaction averages are post-level arithmetic means within those groups. The
overall post count sums annual counts, while the overall reaction average is
the unweighted mean of annual averages. It therefore gives each available year
equal weight, rather than each post. Partial years still contribute one annual
mean. Missing reaction values follow pandas' mean/sum behavior.

The second table first groups by country, outlet name, quality, and year:

| Label | Implemented calculation within a quality/year group |
|---|---|
| Posts (average outlet total) | Arithmetic mean of outlet post counts. |
| Reactions (average outlet total) | Divide each outlet reaction total by the number of distinct country/name pairs, then average those divided totals. With N outlet rows this is sum of outlet totals / N². |
| Overall row in this second table | Unweighted mean of the annual values in each column. |

The reaction label and calculation differ from the usual mean of outlet totals;
see [double division](concerns/statistical-calculations.md#descriptive-double-division).
Neither table implements the daily-then-weekly weighting of the DVC
[weekly aggregation](statistical-methods.md#weekly-aggregation-and-signals).
Tables are formatted and printed as LaTeX; they are not separate tracked table
artifacts. See the notebook map for prerequisites and outputs.

The three-panel `descriptives/descriptives-basic.pdf` shows outlet post-count
and mean-reaction distributions as boxplots and a post-level complementary
empirical CDF of reactions. Boxplot y axes and both CCDF axes use log scales.
The detailed table headed "News" groups the combined dataset by quality/name
and reports counts and mean, standard deviation, median, and IQR of engagement;
that block does not explicitly filter out non-news. A second table reads
non-news separately and summarizes reactions/comments by name. The final
engagement-correlation block drops rows missing any reactions/comments/shares,
takes natural logs without a pseudocount, and calls Pearson correlation,
extracting reactions versus comments and shares. This differs from the custom
model-derived statistic below.

## Posting and engagement time series

[timeseries.qmd](../analyses/timeseries.qmd) reads `weekly.parquet` and
`weekly-non-news.parquet`, not the dense `timeseries.parquet`. It averages
`reactions` and `n_posts` across available outlets by country, quality, timestamp,
and week index, then removes the first and last row within each country/quality
group. Counts here are mean outlet counts, not sector-wide totals. The sparse
weekly inputs do not insert zero observations for missing outlet/weeks.

R creates a nominal quality factor with levels `non-news`, `low`, `medium`,
`high`, a sequential time index starting at zero within each country/quality,
its factor `ftime`, and a `country:quality` group label. The independent model is:

```r
log(reactions) ~ 1 + quality * log(n_posts)
# family = gaussian; dispformula = ~ 1 + quality
```

The second model adds `ar1(ftime + 0 | group)`. Thus the conditional slopes and
intercepts vary by quality, dispersion varies by quality, and the second fit
adds an AR(1) covariance structure within groups. `ftime` counts retained rows;
it is not constructed from elapsed calendar-week differences. The notebook
compares fits with `anova(glmm_lm, glmm_ts)` and reports squared correlation
between fitted values and the logged response as its R-squared summary.

The quantity named `correlations` is computed as follows:

```text
beta_q = reference log(n_posts) slope + relevant quality interaction
xvar_q = sample variance of log(n_posts) within quality
d_q    = exp(link-scale emmeans estimate for the dispersion component)
r_q    = beta_q * sqrt(xvar_q) / sqrt(d_q)
```

This is a custom model-derived statistic, not a direct call to Pearson
correlation. Its denominator and interpretation require
[review](concerns/statistical-calculations.md#time-series-correlation).
The printed table combines this statistic with adjusted p-values from
`emtrends(glmm_ts, ~quality, var = "n_posts")`; those p-values are trend tests,
not a separately implemented test of the custom statistic.

For the time-series figure, the notebook takes a further global `weekly[1:-1]`
slice and computes four-row rolling means by quality. Both panels use log y
axes. Event markers use the annotation workbook's `Date`; elections use
configuration dates and the first-US-COVID marker is a notebook constant.
The ACF figure uses each model's complete working-residual vector, without
splitting it by country/quality. This and row-based time indexing matter when
interpreting lags; see [time-series diagnostics](concerns/statistical-calculations.md#time-series-diagnostics).
The notebook also prints an AR(1) model coefficient table. Its two PDFs are
`glmm/timeseries/timeseries.pdf` and `glmm/timeseries/acf.pdf` under figures;
the new fitted objects remain notebook objects, not DVC RDS outputs.

## Audience and alternative explanations

[alternatives.qmd](../analyses/alternatives.qmd) uses processed ComScore data,
the dense news time series, the Statista workbook, and event annotations.
The [ComScore stage](data-contracts.md#non-news-and-audience-processing) supplies
bounded forward/backward-filled monthly observations. The notebook then:

1. Divides each outlet's ComScore observations by that outlet's full-series mean.
   It drops missing rows and averages available outlets at each month, retaining
   contributor counts. This is an equal-outlet average, not total audience.
2. Selects news rows from `timeseries.parquet`. Within country/name it computes
   four-week rolling reaction means with four observations required, drops
   missing rolling results, and divides by each outlet's mean of those smoothed
   values. It averages normalized values across available outlets per week.
   Zero-filled internal weeks participate in the rolling calculation.
3. Smooths the monthly normalized ComScore mean with a three-row rolling mean.
   It independently smooths the normalized weekly reaction series with a
   three-row rolling mean and then averages it into month-start bins. These
   rolling windows have different time units; neither denominator is a
   pre-policy baseline.

`comscore.pdf` plots these relative series as percentages. Selected annotation
rows supply `Timestamp` (normalized from workbook `timestamp`), not `Date`, for
label positions. The y coordinate uses the corresponding month-start value,
falling back to the last series value when that month is absent; `adjust_text`
can further move labels. See [annotation alignment](concerns/epochs-and-annotations.md#annotation-coordinates).

For `statista.pdf`, year values become January 1 dates, and user counts are
divided by the first row's count. The legend calls this "relative to 2019";
that description depends on the first input row being 2019. These plots provide
context, not by themselves a test ruling out all alternative causal explanations;
see [interpretation limits](concerns/inference-and-interpretation.md#causal-comparison).
