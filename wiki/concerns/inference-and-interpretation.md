# Inference and interpretation concerns

[Register](README.md) | [Methods](../statistical-methods.md) | [Study design](../study-design.md)

## Marginal-mean correction uncertainty

**Classification: methodological assumption.** The
[news](../../analyses/glmm-news.qmd), [joint](../../analyses/glmm-both.qmd), and
[total](../../analyses/glmm-total.qmd) notebooks derive a heterogeneity adjustment
from outlet random effects and modify `rg@bhat`; they do not explicitly propagate
uncertainty from estimating that adjustment into the grid covariance. The
[reference](../statistical-methods.md#marginal-means-and-contrasts) explains the
implemented operation. A lognormal-moment rationale for a latent mean does not
change the count response from negative-binomial to lognormal.

**Limits:** this does not establish the size or direction of interval error or
that the correction targets the intended population mean.
**Next check and resolution:** specify the marginal estimand, derive the role of
estimated/shrunken random effects and covariance, and compare an appropriate
uncertainty treatment in separate statistical work. Resolve when the correction
and interval interpretation are justified, or when the conditional nature and
remaining uncertainty are explicitly accepted as a study limitation.

## Selected epochs treated as fixed

**Classification: methodological assumption.**
[postprocessing](../../stages/changepoints_postprocess.py) selects boundaries
from reaction-derived signals, then the [news](../../stages/glmm_news.R) and
[joint](../../stages/glmm_both.R) models and notebooks condition on that epoch
map. The pipeline does not propagate changepoint-selection uncertainty into
final contrast intervals. Peak widths are peak-shape measures, not a substitute
for that propagation; see [methods](../statistical-methods.md#beast-detection-and-peak-selection).

**Limits:** no unconditional coverage or sensitivity result has been established.
**Next check and resolution:** state the conditional estimand and assess boundary
sensitivity or an appropriate repeated-selection procedure in separate research
work. Resolve the interpretation by providing such evidence or explicitly
limiting claims to the selected segmentation; do not relabel peak widths as
confidence or credible intervals.

## Causal comparison

**Classification: methodological assumption.**
[glmm-both.qmd](../../analyses/glmm-both.qmd) and
[glmm-total.qmd](../../analyses/glmm-total.qmd) interpret news/non-news contrasts
using non-news pages as a counterfactual. A causal reading requires appropriate
equiproportional trends without the news intervention and consideration of
differential shocks, measurement changes, composition, and treatment of the
comparison group. See [study design](../study-design.md#comparisons-and-causal-interpretation).

**Limits:** non-rejection of a pre-period test does not establish parallel trends;
the implemented test also has a separate
[calculation concern](statistical-calculations.md#parallel-trends-covariance-and-indexing).
Low custom correlations in [timeseries.qmd](../../analyses/timeseries.qmd) do
not establish independence or identify an algorithmic mechanism. Audience plots
in [alternatives.qmd](../../analyses/alternatives.qmd) provide context rather
than eliminate all alternative explanations.
**Next check and resolution:** substantiate comparison-group exposure and
collection stability, validate the pre-period calculation, and assess plausible
alternative explanations and sensitivity. Resolve by matching the strength of
claims to that evidence; correcting a test alone does not validate causality.
