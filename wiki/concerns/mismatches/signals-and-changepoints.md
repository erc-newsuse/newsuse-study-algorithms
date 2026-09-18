# Signal and changepoint mismatches

[Mismatch index](README.md) | [Epoch concerns](../epochs-and-annotations.md) | [Implemented methods](../../statistical-methods.md)

## Preliminary posting-frequency predictor

**SIGNAL-1 · Confirmed predictor-definition mismatch; manuscript wording partly
incomplete.** Appendix E, Eqs. (E.1)–(E.2), describes `n_posts` as an outlet's
average number of posts over the entire studied period, although the sentence
omits the unit after “per.” Source: [PDF p. 22](../../manuscript/manuscript.pdf#page=22).

[make_news.py:134–147](../../../stages/make_news.py#L134) instead counts posts
within `country, quality, name, year, month, day`, joins that count to posts and
takes its logarithm. [glmm_reactions.R:29,83–89](../../../stages/glmm_reactions.R#L25)
uses this daily count in both conditional and dispersion formulas. An outlet
posting once on one day and nine times on another therefore has predictor values
0 and log(9), rather than one full-period outlet average. Counts are constructed
before the final missing-reaction exclusion.

**Consequence and limit.** This changes the covariate entering the preliminary
model and hence the predictions supplied to changepoint detection. It is not
just a missing rate unit in the prose. The fitted coefficient and effect on
boundaries have not been recomputed.

**Minimal resolution.** Establish the intended covariate and sampling denominator,
compare it with the fitted model's stored frame, and reconcile Appendix E.
Any substantive predictor change requires checking preliminary estimates,
signals, segmentation and downstream contrasts, not merely editing a label.

## Aggregation and log transformation

**SIGNAL-2 · Confirmed order-of-operations mismatch; CV wording remains
ambiguous within the manuscript.** Section 4.2 says to average outlet-day
predictions into outlet weeks, average across outlets, then log-transform the
obtained averages. Appendix F refers to log-transformed expected reactions and
coefficients of variation less explicitly. Sources:
[§4.2, p. 9](../../manuscript/manuscript.pdf#page=9),
[F, p. 23](../../manuscript/manuscript.pdf#page=23).

The [weekly stage](../../../stages/make_weekly.py#L60) does the daily-to-weekly
aggregation. The [signal stage](../../../stages/make_signal.py#L19) then logs
`reactions_mu` and `reactions_rel_mu` **before averaging across outlets**, and
leaves both CV columns unlogged. For positive outlet-week values $m_o$, the
manuscript's sequence gives $\log(\operatorname{mean}_o m_o)$, whereas code gives
$\operatorname{mean}_o\log m_o$. On the original scale these are arithmetic and
geometric aggregation, respectively. A synthetic pair 1 and 9 gives 1.609438
versus 1.098612 on the log scale. The difference varies with cross-outlet
dispersion; it need not be a constant shift.

[make_dataset.R](../../../stages/make_dataset.R#L41) correctly implements the
preliminary NB2 variance and the stated mean normalization against observed
`reactions_avg`. It sets `reactions_rel_cv = reactions_cv`: scaling an outcome
by a positive outlet constant does not change its CV. That identity is not an
additional defect. The active detector also runs both absolute and relative
mean subsets, with the relative subset selected for epochs in
[params.yaml:119–122](../../../params.yaml#L119).

**Minimal resolution.** Specify the intended arithmetic/geometric target and
the transform for each signal. Preserve a small heterogeneous-outlet fixture
that distinguishes the two orders, then compare real signals and boundaries in
a separate analysis if the operation changes. Do not treat the final models'
intentional log-scale averaging across quality tiers as proof that this earlier
signal construction matches §4.2; they are different operations.

## Probability processing and peak selection

**SIGNAL-3 · Confirmed algorithm mismatch.** Appendix F describes smoothing
each run with a centered ±2-week product-complement window, then averaging runs,
keeping peaks at least 0.5 high and at least four weeks apart. Its use of $P$
instead of $\widetilde P$ in the averaging step is a textual ambiguity, but the
window and stated order are otherwise explicit. Sources:
[PDF pp. 23–24](../../manuscript/manuscript.pdf#page=23).

| Operation | Manuscript | Active code |
|---|---|---|
| Per-run inputs | Weekly posterior array. | Candidate `trend$cp`/`trend$cpPr` rows; probabilities at duplicate dates and within run/week are combined by product complement. |
| Smoothing order | Smooth each run, then take the run mean. | Average run/week probabilities first, then smooth the average series. |
| Window | Centered ±2 weeks, five available points in the interior. | Trailing `round(8.69642857) = 9` points, with early missing windows backward-filled. |
| Minimum peak separation | Four weeks. | `distance = 8.696428571428571` samples; it rules out peaks eight samples apart. |
| Peak height | At least 0.5. | `height = 0.5`: agreement. |
| Prominence | No additional threshold specified. | `prominence = 0.05`. |
| Interval rule | Peak widths, without an exact width level. | `peak_widths` defaults, rounded endpoints, plus six days on the right. |

Code evidence: [candidate extraction](../../../stages/changepoints_detect.R#L58),
[date/week aggregation](../../../stages/changepoints_postprocess.py#L29),
[run averaging and smoothing](../../../stages/changepoints_postprocess.py#L75),
[peak selection](../../../stages/changepoints_postprocess.py#L112),
and [parameters](../../../params.yaml#L95).

The nonlinear operations do not commute. For two synthetic runs with adjacent
probabilities `[0.9, 0]` and `[0, 0.9]`, smoothing each then averaging gives
**0.9**; averaging first then smoothing gives **0.6975**. This example isolates
the ordering difference even before changing window length. Backward filling
also differs from the manuscript's shorter available-neighbor windows at the
start of the series.

The code normalizes by the maximum observed run index rather than the configured
completed-run count. This remains a separate
[empty-run fragility](../epochs-and-annotations.md#run-normalization-and-empty-detections).
Conversely, the 1,000 runs, weekly resolution, nonseasonal trend, outlier
component, orders 0–1, maximum 30 knots and 13-week BEAST separation are largely
aligned. The 13-week prior setting must not be confused with the later peak
separation. Table F.6 prints `trendMinKnotNumber`; configuration uses
`trendMinKnotNum`. That spelling difference does not establish that the active
minimum-knot setting is ineffective.

**Consequence and limit.** These operations select the dates that define the
regression epochs. No alternative detection or fit was run, so the investigation
does not assert which boundaries or headline percentages would change.

**Minimal resolution.** Identify the procedure used for the manuscript's saved
segmentation and decide which description is intended. Validate the intended
window, operation order, peak restrictions and run denominator on explicit
probability arrays. A change to production processing requires checking dates,
eligibility, all fitted models and the fixed focal-epoch consumers together.

## Calendar coordinate defect

**SIGNAL-4 · Confirmed computational defect on a bounded calendar example;
numerical impact on the manuscript remains unverified.** The paper interprets
boundaries as calendar times, but does not specify this implementation's
fractional-year conversion. Sources: Figure 2 and Table F.7,
[pp. 4, 25](../../manuscript/manuscript.pdf#page=4).

[make_signal.py:40–45](../../../stages/make_signal.py#L40) uses calendar year plus
`ISO_week/52 + 0.5/52`. Consecutive synthetic Mondays produce:

| Input Monday | Encoded time | Reconstructed date from current post-processing |
|---|---:|---|
| 2019-12-23 | 2020.0096153846155 | 2020-01-05 |
| 2019-12-30 | 2019.0288461538462 | 2019-01-11 |
| 2020-01-06 | 2020.048076923077 | 2020-01-19 |

The second date belongs to ISO week 1 of 2020 but retains calendar year 2019 in
the encoding. The first crosses the next integer year because of the added
half-week. The encoded sequence is consequently non-monotonic.
[Post-processing](../../../stages/changepoints_postprocess.py#L35) independently
constructs month from the fraction times 12 and day from a different day-offset
calculation; it is not the inverse of that time representation. Subsequent
year/week joins cannot repair an already wrong year.

**Minimal resolution.** Define one time coordinate with an explicit epoch and
inverse mapping; test year-end, week 53, leap years, month ends and time-of-day
boundaries. Inspect actual stored signal coordinates and BEAST handling before
quantifying impact. Correcting date conversion may change period assignment and
cannot be treated as cosmetic relabeling. This strengthens the existing
[calendar concern](../epochs-and-annotations.md#calendar-conversion-and-weekly-alignment)
without certifying a revised changepoint calendar.
