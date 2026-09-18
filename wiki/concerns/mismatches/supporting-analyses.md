# Supporting-analysis mismatches

[Mismatch index](README.md) | [Calculation concerns](../statistical-calculations.md) | [Implemented supporting analyses](../../supporting-analyses.md)

## Posting-reaction correlation denominator

**SUPPORT-1 · Confirmed formula mismatch; a corrected scientific estimand still
requires derivation.** Equation (D.3) gives

$$
r_g=\beta_g\sqrt{V(\log X\mid g)/V(\log Y\mid g)},
$$

where $X$ is posting, $Y$ reactions and $V$ a group variance. The main text uses
the reported near-zero correlations to argue against posting volume as the
explanation of the reaction decline. Sources:
[D.1–D.3/Table D.4, p. 21](../../manuscript/manuscript.pdf#page=21),
[§2.2, p. 6](../../manuscript/manuscript.pdf#page=6).

[timeseries.qmd:172–185](../../../analyses/timeseries.qmd#L172) calculates the
numerator variance from `var(log(n_posts))`, but constructs `yvars` from
`emmeans(glmm_ts, component="disp", type="link")`, exponentiates its estimate,
and divides by `sqrt(yvars)`. It does not calculate the group variance of log
reactions or a total marginal variance including the AR(1) component. This
differs from the displayed D.3 denominator, independently of how the residual
dispersion is parameterized.

A read-only inspection of installed **glmmTMB 1.1.10 / emmeans 1.11.2.8** provides
additional scale evidence. `getS3method("emm_basis", "glmmTMB")` assigns a log
link to the dispersion component and uses its fixed coefficients. In this
installation, `getS3method("sigma", "glmmTMB")` returns `exp(betadisp)` for a
Gaussian intercept-only dispersion model; its help identifies that quantity as
the residual **standard deviation**. Thus the notebook's further square root
is not justified as a response standard deviation by calling its intermediate
quantity `yvars`. The manuscript's Eq. (D.2), labeled `log(sigma^2)`, also needs
reconciliation with the fitting environment's dispersion convention.

These package observations identify the inspected environment's behavior, not
the environment that produced the PDF. No AR(1) model was fitted and no
corrected study correlations were computed. The attached p-values come from
[emtrends and its summaries](../../../analyses/timeseries.qmd#L203), not a
separate test derived for this custom ratio.

**Minimal resolution.** Define whether the target is an empirical correlation,
a model-implied marginal correlation, or a standardized conditional slope.
Derive its denominator including the appropriate Gaussian and AR(1) variance
components; check scales and quality ordering with a small known-covariance
example. Then compare the verified calculation with the printed correlations
and reassess the strength of the alternative-explanation claim. Existing anchor:
[time-series correlation](../statistical-calculations.md#time-series-correlation).

The mean/AR(1) formula largely matches Appendix D for this one-country study.
Separate [diagnostic concerns](../statistical-calculations.md#time-series-diagnostics)
remain: `ftime` counts retained rows, and the plotted ACF uses concatenated
working residuals across groups. They should not be mistaken for the
denominator discrepancy above.

## Average outlet reaction totals

**SUPPORT-2 · Confirmed arithmetic discrepancy in a manuscript-related export
block; exact publication provenance remains unverified.** Figure C.5c calls
its statistic “Reactions (average outlet total).” Appendix C describes average
annual outlet totals, although its prose and the figure disagree on some summary
values. Source: [PDF pp. 19–20](../../manuscript/manuscript.pdf#page=19).

The candidate producer at
[descriptives.qmd:165–176](../../../analyses/descriptives.qmd#L165) sums reactions
per outlet/year, divides each total by the number $N$ of outlets, and then takes
the mean of those divided values. It therefore produces
$\sum_o R_o/N^2$, rather than the arithmetic average $\sum_o R_o/N$ named by
the table. Synthetic totals 100 and 300 give **100**, versus the intended
arithmetic mean **200**. The subsequent overall row averages annual values
equally at [lines 188–204](../../../analyses/descriptives.qmd#L188).

This is the same computation as the existing
[double-division concern](../statistical-calculations.md#descriptive-double-division),
now connected to a specific manuscript display. Its matching labels and table
structure support that connection; they do not prove which rendered revision
was pasted into the PDF. The separate reaction-per-post table's equal-year
overall weighting must not be conflated with this extra division.

**Minimal resolution.** Confirm the intended outlet-total estimand, remove one
division in a separate calculation change if appropriate, and check annual
outlet counts and overall weighting. Match the rebuilt table to C.5c and
reconcile the prose independently. Do not replace manuscript numbers merely by
multiplying a printed overall value by a presumed constant outlet count.

## Audience-comparison transformations

**SUPPORT-3 · Confirmed processing-description mismatch plus unreported choices.**
Figure J.10b describes a three-month rolling mean of normalized unique visitors,
averaged across outlets, and says the reaction series is constructed “in the
same way.” The prose limits ComScore coverage to February 2025. Source:
[PDF p. 35](../../manuscript/manuscript.pdf#page=35).

The controlling paths differ:

| Component | Active operations |
|---|---|
| ComScore | Build a monthly grid; retain outlets with early coverage; forward/backward fill up to six entries each; normalize each outlet by its full-series mean; average available outlets; smooth the monthly series with three rows. |
| Facebook reactions | Use the dense weekly table with zero-filled internal gaps; smooth each outlet with four weeks; normalize by its mean of smoothed values; average outlets; smooth again with three **weeks**; finally average into month-start bins. |

Sources: [make_comscore.py:17–69](../../../stages/make_comscore.py#L17),
[fill limit](../../../params.yaml#L82),
[dense weekly construction](../../../stages/make_timeseries.py#L52),
[normalization](../../../analyses/alternatives.qmd#L63),
[reaction smoothing](../../../analyses/alternatives.qmd#L88),
[final windows](../../../analyses/alternatives.qmd#L150).

Three weekly rows followed by monthly averaging are not a three-month rolling
mean. Missing-week zero filling, audience filling and variable contributor sets
are additional methodological choices not supplied by the caption. The
ComScore stage also does not explicitly intersect names with the news sample,
despite its comments; the input may already have the intended cohort. This
last issue remains the separate
[ComScore selection concern](../sampling-and-provenance.md#comscore-selection).

**Minimal resolution.** Specify windows, normalization order, filling and
contributor sets separately for each series. Verify whether the intention was
comparable temporal smoothing or deliberately different summaries, then align
the caption or calculations. Retain the February 2025 coverage limit and the
observed-versus-projected distinction for Statista's 2019–2023/2024–2028 series;
those limitations are explicit in the manuscript and are not themselves new
evidence of a code defect.

## Validation variance and its consumers

**SUPPORT-4 · Confirmed family-inconsistent calculation, with a bounded consumer
scope.** The final models and §4.3.2 use NB1 variance $\mu(1+\phi)$.
Both validation notebooks instead construct an outlet-epoch `sigma` from
$\sqrt{\operatorname{mean}[\mu(1+\mu/\theta)]}$, the NB2 form. Sources:
[PDF p. 10](../../manuscript/manuscript.pdf#page=10),
[news diagnostic calculation](../../../analyses/validation/glmm-news.qmd#L91),
[joint diagnostic calculation](../../../analyses/validation/glmm-both.qmd#L94).

For synthetic $\mu=10,\phi=2$, the NB1 variance is 30, while the expression
inside the diagnostic square root gives 60. This does not refute the NB1 fit:
the stored models were not changed by a diagnostic calculation.

Tracing consumers narrows the issue. The current mean-difference figures use
`abs(mean - mu) / mean`, and the other panels use observed/predicted means or
random effects. No downstream use of the computed `sigma` was found within
either notebook. Thus this discrepancy cannot, on present source evidence,
explain Figure G.7/H.8's reported mean-fit diagnostics or the paper's main
contrasts. Sources: [news panels](../../../analyses/validation/glmm-news.qmd#L111),
[joint panels](../../../analyses/validation/glmm-both.qmd#L114),
[PDF pp. 28, 30](../../manuscript/manuscript.pdf#page=28).

**Minimal resolution.** Remove the unused quantity or define a family-consistent
variance diagnostic and validate its aggregation, including whether a mixture
variance is intended. Keep this separate from the
[inclusion-threshold mismatch](models-and-inference.md#outlet-epoch-inclusion-threshold)
and the scientific limits of fitted-mean validation. Existing anchor:
[validation variance family](../statistical-calculations.md#validation-variance-family).
