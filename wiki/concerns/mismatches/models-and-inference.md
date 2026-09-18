# Model and inference mismatches

[Mismatch index](README.md) | [Statistical concerns](../statistical-calculations.md) | [Inference concerns](../inference-and-interpretation.md)

## Joint-model daily random effects

**MODEL-1 · Confirmed manuscript–code difference, with conflicting manuscript
descriptions.** Equation (10) gives the joint model `(1|year:month:day)`, a daily
intercept shared across groups. Table H.10 instead labels its grouping
`quality:year:month:day`. Sources:
[Eq. (10), p. 10](../../manuscript/manuscript.pdf#page=10),
[Table H.10, p. 31](../../manuscript/manuscript.pdf#page=31).

[glmm_both.R:106–109](../../../stages/glmm_both.R#L106) implements
`(1 | quality:year:month:day)`. It therefore agrees with the table's grouping,
not the main-text formula. A group-specific day intercept is different from a
shared day intercept, and from correlated daily quality slopes in the news-only
model. It changes the modeled dependence between groups on the same day.

The other major final-model features do agree: NB1 variance, fixed
quality-by-epoch interaction, outlet and outlet-epoch random intercepts,
news-model daily quality slopes, and the absence of joint fixed dispersion
quality/epoch effects. Country/sector prefixes distinguish outlet identities in
code; they are not, by themselves, evidence of another scientific model mismatch.
Sources: [news fit](../../../stages/glmm_news.R#L73),
[joint fit](../../../stages/glmm_both.R#L106),
[Eqs. (8)–(11), p. 10](../../manuscript/manuscript.pdf#page=10).

**Minimal resolution.** Identify the saved joint model that produced H.10–H.12
and inspect its formula and grouping terms. If the table and code describe the
intended model, amend Eq. (10); if the shared daily effect was intended,
compare a separately refitted specification and all downstream contrasts.
Current source establishes the mismatch, not which specification is preferable.

## Joint-model reference label

**MODEL-2 · Confirmed table-label defect in the current export path.** Table
H.10 calls its intercept “low,” yet includes a separate low coefficient and
omits a high coefficient. Source: [PDF p. 31](../../manuscript/manuscript.pdf#page=31).

The joint stage does not explicitly order the quality factor; its inputs are
character tier labels, including `non-news`.
[make_dataset.R:54](../../../stages/make_dataset.R#L52) writes quality as
character, and [glmm_both.R:69–74](../../../stages/glmm_both.R#L69) sets sector
ordering without setting quality ordering. A bounded R `model.matrix` example
with those character labels and default treatment contrasts uses **high** as
the reference, with low, medium and non-news coefficients. This matches the
pattern printed in H.10, without loading the actual fit.

The export notebook sets `QUALITY = ["low", "medium", "high"]` at
[model-tables.qmd:78](../../../analyses/model-tables.qmd#L77) and uses its first
entry as the default `ref` in
[sanitize_term:154–163](../../../analyses/model-tables.qmd#L154). The
[joint-table call](../../../analyses/model-tables.qmd#L272) does not override it.
The label therefore comes from a constant, not the joint model's contrast basis.

**Minimal resolution.** Derive the reference label from each fitted component's
design/contrasts and regenerate its table. Verify conditional and dispersion
components independently. This finding concerns coefficient interpretation and
table labeling; it does not establish that fitted means or causal contrasts are
wrong. Later reordering of an `emmeans` grid is not a change to the fitted
coefficient reference category.

## Outlet-epoch inclusion threshold

**MODEL-3 · Confirmed rule mismatch; manuscript internally inconsistent.**
Appendix G.1 says at least 20 observations; the G.7 caption says fewer than 150
were excluded; H.8 uses fewer than 20. Sources:
[p. 28](../../manuscript/manuscript.pdf#page=28),
[p. 30](../../manuscript/manuscript.pdf#page=30).

[params.yaml:126–127](../../../params.yaml#L126) sets `min_posts: 20`.
[changepoints_postprocess.py:194–200](../../../stages/changepoints_postprocess.py#L194)
keeps `n_posts > 20`, so the minimum retained integer count is **21**. Both
final stages join this key map and drop missing epochs:
[news](../../../stages/glmm_news.R#L23),
[joint news branch](../../../stages/glmm_both.R#L29),
[joint non-news branch](../../../stages/glmm_both.R#L46).
The validation notebooks take their data from the stored model frames and apply
no separate 150-observation rule in their summary blocks:
[news](../../../analyses/validation/glmm-news.qmd#L88),
[joint](../../../analyses/validation/glmm-both.qmd#L91).

**Minimal resolution.** Decide whether the intended estimation rule is ≥20,
>20 or ≥150, and whether diagnostics have a separate display filter. Check
groups at 20 and 21 and identify actual affected keys. A count-20 fixture is
excluded by current code and retained by the “at least 20” description. No
current-data count of such groups or fitted-result impact is asserted here.

## Parallel-trends covariance and periods

**INFERENCE-1 · Confirmed computational and period-selection discrepancies.**
Section 4.4 defines a quadratic test using the covariance of the **same vector
of sequential log DiD estimates**. It describes a pre-suppression comparison
over epochs 0–4 and reports χ²(5) ≈ 9.34, p ≈ 0.096. The five-contrast wording
is itself ambiguous because those epochs contain four internal transitions.
Sources: [pp. 10–11](../../manuscript/manuscript.pdf#page=10).

The controlling code is
[glmm-both.qmd:774–797](../../../analyses/glmm-both.qmd#L774):

```r
ptcon <- contrast(ptemm, interaction = c("consec", "consec"))
E <- .tidy(ptcon)$estimate
V <- vcov(con)
```

`con` was created earlier from an epoch-only marginal mean, whereas `ptcon`
is a news/non-news interaction contrast. Their covariances have different
estimands even when both matrices are 11 × 11. Sources:
[earlier objects](../../../analyses/glmm-both.qmd#L246),
[test function](../../../analyses/glmm-both.qmd#L780).

With `START_WAR = 5`, `END_WAR = 10` and `LAST_EPOCH = 11` from
[lines 99–102](../../../analyses/glmm-both.qmd#L99), the selections are:

| Named test | R rows of the sequential DiD object | Actual transitions |
|---|---|---|
| Before | 1:5 | 0→1, 1→2, 2→3, 3→4, **4→5**. |
| During | 6:10 | 5→6 through 9→10. |
| After | 11 | 10→11. |

The “before” test therefore includes the transition into the first
post-announcement epoch. The same wrong covariance object is used for all three
tests. Fixing only the five-versus-four wording does not repair the covariance.

A synthetic 48-cell `emmeans::emmobj` with four quality groups, 12 epochs,
zero means and identity covariance reproduced these contrast labels. Under the
notebook's grouping operations, the first variance from `con` was **2/3**,
versus **8/3** for `ptcon`. This proves the matrices are not interchangeable;
these are arbitrary test inputs, not the study's covariance or corrected tests.

**Minimal resolution.** Use the covariance attached to the exact contrast
object supplying estimates, explicitly identify contrast labels, and define the
pre-period without crossing onset if “epochs 0–4” is intended. Check covariance
rank and degrees of freedom before evaluating the quadratic form. Then recompute
only the affected inference from a verified fit and reassess the manuscript's
trend-test claims. No replacement p-values or causal conclusion are supplied
by this investigation. Canonical computational record:
[parallel-trends concern](../statistical-calculations.md#parallel-trends-covariance-and-indexing).

## Inference settings and unresolved p-values

**INFERENCE-2 · Reporting gap and unresolved output provenance, not a confirmed
numerical explanation of the paper's conflicting p-values.** Section 4.3 states
log-scale inference and back-transformation but does not identify a general
multiplicity algorithm. The code specifies `adjust: mvt` in
[params.yaml:132–135](../../../params.yaml#L132), configures it in the
[news](../../../analyses/glmm-news.qmd#L45),
[joint](../../../analyses/glmm-both.qmd#L45) and
[total-effects](../../../analyses/glmm-total.qmd#L46) notebooks, and applies
contrast-family-specific calls. See [PDF p. 10](../../manuscript/manuscript.pdf#page=10).

Appendix I's prose gives p ≈ .048 for non-news 8/4 and p ≈ .003 for medium
8/4; I.9c prints .020 and .001. The source now supplies a possible place to
investigate family/adjustment differences, but does not establish their cause.
The [total-effects notebook](../../../analyses/glmm-total.qmd#L197) uses the
joint model and explicit seeds for its focal summaries; the
[joint notebook](../../../analyses/glmm-both.qmd#L50) has no explicit R seed.
Source: [Appendix I, pp. 33–34](../../manuscript/manuscript.pdf#page=33).

Several important elements **do align**: summing outlet and outlet-epoch effects,
using their within-tier/epoch variance for a half-variance correction, and
averaging quality effects on the log scale. The code's
[reference-grid update](../../../analyses/glmm-news.qmd#L155) supports the final
expression in Eq. (4), despite that equation's inconsistent opening notation.
Uncertainty in the estimated correction and segmentation is still not propagated;
these remain [methodological concerns](../inference-and-interpretation.md), not
newly demonstrated contradictions with an explicit uncertainty procedure in the
paper.

The joint notebook's [baseline weights](../../../analyses/glmm-both.qmd#L268)
use epochs 0–4; the total-effects notebook uses focal epochs 4, 8 and 11.
Consequently H.12's final cumulative 0.31 and I.9c's 11/4 value 0.30 must not
be reported as a numerical mismatch merely because they differ.

**Minimal resolution.** Record each result's model, contrast weights, tested
family, adjustment, seed and output version. Match the printed I.9c and prose
values to those exports before assigning an explanation. Keep the separate
[supplementary contrast concern](../statistical-calculations.md#supplementary-contrast-intervals)
for the older 4→9 versus 4→8 weight blocks; do not confuse those blocks with the
explicit 4/8/11 total-effects analysis.
