# Statistical calculation concerns

[Register](README.md) | [Methods](../statistical-methods.md) | [Supporting analyses](../supporting-analyses.md)

## Descriptive double division

**Classification: confirmed discrepancy.** In the average-outlet table,
[descriptives.qmd](../../analyses/descriptives.qmd) divides outlet reaction
totals by the outlet count and then takes their mean. This yields sum / N²,
whereas the label suggests sum / N. A bounded example with totals 100 and 300
returns 100 instead of the arithmetic mean 200. The separate overall reaction
average weights annual means equally, as described in
[descriptive summaries](../supporting-analyses.md#descriptive-summaries).

The September 18 comparison identifies Figure C.5c as the corresponding
manuscript display; see the [source comparison](mismatches/supporting-analyses.md#average-outlet-reaction-totals).
**Limits:** the arithmetic discrepancy is established, but an exact export-to-PDF
provenance link and the numerical impact on the printed table remain unverified.
**Next check and resolution:** confirm the intended estimand and manuscript
consumer. If the intended statistic is the mean outlet total, remove one
division in a separate computational change and verify unequal outlet totals,
changing yearly outlet counts, and overall-row weighting. Resolve after the
formula/label agree and affected exports have been checked.

## Time-series correlation

**Classification: confirmed manuscript–code discrepancy, with an unresolved
statistical estimand.**
[timeseries.qmd](../../analyses/timeseries.qmd) labels
`beta * sqrt(var(log(n_posts))) / sqrt(exp(dispersion EMM))` as correlation.
The [reference](../supporting-analyses.md#posting-and-engagement-time-series)
records its construction. A dispersion-component prediction is not automatically
the total marginal response variance needed for an ordinary standardized slope.
The table attaches `emtrends` p-values to this derived statistic. Equation (D.3)
instead names the variance of log reactions in the denominator. A September 18
inspection of installed glmmTMB 1.1.10 and emmeans 1.11.2.8 established that the
Gaussian dispersion prediction used here exponentiates to residual standard
deviation, not response variance. The source also omits the AR(1) contribution
from this denominator. Full evidence and package-version limits are in the
[manuscript comparison](mismatches/supporting-analyses.md#posting-reaction-correlation-denominator).

**Limits:** no fit or numerical range check was performed; the environment of
the published fit, the appropriate total variance and the intended estimand
remain unverified. This does not supply corrected manuscript correlations.
**Next check and resolution:** derive the intended model-based correlation,
including the AR(1) contribution and any conditioning, align quality ordering,
and verify on a small model with known covariance. Resolve by validating the named
statistic or choosing an accurate label and separate interpretation for its
trend tests; then inspect affected tables.

## Time-series diagnostics

**Classification: potential fragility.** In
[timeseries.qmd](../../analyses/timeseries.qmd), `ftime` numbers retained rows,
and `plot_acf` receives the full working-residual vector across groups. The
figure labels its lag axis in weeks. Missing group/weeks can make row distance
differ from calendar distance, and concatenated residuals introduce group
boundaries into the ACF. Additional global endpoint slicing and rolling by
quality alone also warrant review before multi-country reuse.

**Limits:** current outlet gaps do not prove gaps in the aggregated group series;
no diagnostic impact was measured. See the
[implemented workflow](../supporting-analyses.md#posting-and-engagement-time-series).
**Next check and resolution:** inspect group/week continuity and residual order,
then compare group-specific ACFs and verify the intended rolling groups.
Resolve when time spacing, group boundaries, and diagnostic labels agree, or
their restricted interpretation is explicitly justified.

## Parallel-trends covariance and indexing

**Classification: confirmed discrepancy.** The parallel-trends block in
[glmm-both.qmd](../../analyses/glmm-both.qmd) gets estimates from `ptcon` but
uses `vcov(con)` from an earlier contrast object. Its before-period slice uses
`1:START_WAR`, while the baseline is described as epochs 0–4. These issues
affect the notebook's parallel-trends tests, not the underlying fitted RDS.

The September 18 [manuscript comparison](mismatches/models-and-inference.md#parallel-trends-covariance-and-periods)
enumerates the transitions and reproduces the mismatch with a synthetic
`emmeans` grid: the before-period slice includes **4→5**, and the two covariance
objects have different variances even when their dimensions agree.

**Limits:** the source and synthetic example establish the defect, but no actual
fit was loaded and no replacement trend-test statistic or p-value was computed.
**Next check and resolution:** match estimate/covariance row order and explicitly
define the pre-period. Compare statistics using the matching contrast
covariance in a separate inference check. Resolve when object alignment and
period definitions are demonstrated. See
[causal interpretation](../study-design.md#comparisons-and-causal-interpretation).

## Validation variance family

**Classification: confirmed discrepancy.** Both
[news](../../analyses/validation/glmm-news.qmd) and
[joint](../../analyses/validation/glmm-both.qmd) validation notebooks load final
NB1 models but construct `sigma` with `sqrt(mean(mu * (1 + mu / theta)))`, an
NB2-style expression. The families and actual output roles are described in
[final models](../statistical-methods.md#final-epoch-models) and the
[notebook map](../analyses-and-outputs.md).

The September 18 [consumer trace](mismatches/supporting-analyses.md#validation-variance-and-its-consumers)
found no later use of `sigma` within either notebook. Their mean-fit panels use
other quantities, including `abs(mean - mu) / mean`.

**Limits:** this does not establish that the stored fit or the manuscript's
Figures G.7/H.8 are wrong. The unused expression is a local calculation defect,
not an established source of error in published intervals or main contrasts.
**Next check and resolution:** inspect the saved family and predicted dispersion
meaning, trace uses of `sigma`, and derive the family-consistent summary. Resolve
after the intended summary is tested on known mean/dispersion inputs and its
consumers are checked, or the unused quantity is explicitly removed in a
separate computational change.

## Supplementary contrast intervals

**Classification: confirmed discrepancy.** Supplementary weights in
[glmm-news.qmd](../../analyses/glmm-news.qmd) use R positions 5 and 10;
[glmm-both.qmd](../../analyses/glmm-both.qmd) uses 5 and 9. Under the current
0–11 epoch ordering these are 4→9 and 4→8. Further contrasts can reverse signs;
see [contrast conventions](../statistical-methods.md#marginal-means-and-contrasts).

**Limits:** the difference is established, but the intended scientific intervals
may differ; neither should be silently changed to match the other.
**Next check and resolution:** print level/weight/interval mappings and compare
them with the intended table descriptions. Resolve by confirming and labeling
the intentional difference or correcting weights and validating affected ratios.
