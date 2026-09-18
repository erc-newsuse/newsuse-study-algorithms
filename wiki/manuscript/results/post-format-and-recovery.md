# Post format and differential recovery

[Manuscript guide](../README.md) · [Main results](suppression-and-recovery.md) · [Interpretation](../interpretation-and-limitations.md)

## Question and proposed mechanism

Appendix K asks whether differences in posting strategies help explain why
high-quality outlets recover less strongly than other news tiers. It focuses on
external-link posts, motivated by the article's account of earlier algorithmic
changes and Meta's June 2025 advice to favor images or video over links. The
proposed mechanism is a format-related penalty correlated with quality, rather
than an independently established algorithmic preference against high-quality
outlets. Source: Appendix K introduction,
[p. 36](../../manuscript/manuscript.pdf#page=36).

## Link-share trajectories

Figure K.11 reports mean proportions of link posts across epochs by quality tier,
also displaying non-news. Appendix K.1 describes relatively stable news-format
patterns before and during suppression: approximately 80%–90% links for high,
74%–81% for low, and 69%–84% for medium. From epoch 9 onward, link shares decline
substantially. Source: Appendix K.1 and Figure K.11,
[p. 36](../../manuscript/manuscript.pdf#page=36).

| Tier | Approximate links in epoch 8 | Approximate links in epoch 11 | Decline stated in text |
|---|---:|---:|---:|
| Low | 74% | 52% | 22 percentage points |
| Medium | 72% | 39% | 33 percentage points |
| High | 80% | 60% | 20 percentage points |

Source: Appendix K.1, [p. 36](../../manuscript/manuscript.pdf#page=36).

The authors interpret medium outlets as adapting fastest and high-quality
outlets as retaining the greatest link dependence. They propose that dependence
on external website traffic may help explain slower adoption of native formats.
That business-model account is an interpretation; the appendix does not measure
each outlet's revenues or motivations. Its description of rank ordering is
also not completely consistent across sentences; see
[format interpretation notes](../reference/reading-notes.md#format-analysis-description).
Source: Appendix K.1, [p. 36](../../manuscript/manuscript.pdf#page=36).

## Outlet-level recovery regression

The outcome is the **log ratio of an outlet's mean reactions in epoch 11 to its
mean in epoch 4**. Predictors are continuous quality score, epoch-11 link-post
proportion, and primary medium, with broadcast as the reference category. The
authors exclude The New Republic because its low epoch-4 baseline produced an
outlier ratio of 28.4; they report an OLS fit on **36 outlets**. The route from
the 40-outlet study sample to this regression's eligible sample is not fully
enumerated. Source: Appendix K.2,
[pp. 36–37](../../manuscript/manuscript.pdf#page=36).

The following **explanatory formula** restates that prose, rather than introducing
a new numbered manuscript equation:

$$
\log R_o=\beta_0+\beta_Q Q_o+\beta_L L_{o,11}
+\beta_P I(o\text{ is print})
+\beta_O I(o\text{ is purely online})+\epsilon_o,
\qquad R_o=\frac{\overline Y_{o,11}}{\overline Y_{o,4}}.
$$

$L$ is a proportion on a 0–1 scale; $Q$ is the continuous score, not a pair of
quality-tier indicators. Source: Appendix K.2,
[p. 36](../../manuscript/manuscript.pdf#page=36).

| Table K.13 term | b | SE | t | p |
|---|---:|---:|---:|---:|
| Intercept | 0.245 | 0.507 | 0.483 | 0.633 |
| Quality | 1.094 | 0.704 | 1.553 | 0.131 |
| Proportion of links, epoch 11 | −1.676 | 0.448 | −3.740 | <0.001 |
| Print | −0.652 | 0.318 | −2.051 | 0.049 |
| Purely online | −0.953 | 0.343 | −2.781 | 0.009 |

Reported fit: **R² = 0.458**, **adjusted R² = 0.388**,
**F(4, 31) = 6.55**, **p < 0.001**, **n = 36**.
Source: Table K.13, [p. 37](../../manuscript/manuscript.pdf#page=37).

Link proportion is the strongest reported predictor. The text interprets its
rounded coefficient −1.68 as an approximately 81% lower recovery ratio for an
otherwise comparable all-link outlet versus a no-link outlet, using
$\exp(-1.68)\approx0.19$. Print and purely online outlets have lower fitted
recovery than broadcast. Quality is not statistically significant after those
adjustments. This is a conditional association in the outlet regression, not
evidence that every quality-related process has zero effect. Sources: Appendix
K.2, [pp. 36–37](../../manuscript/manuscript.pdf#page=36).

The authors explicitly note that epoch-11 link proportion is measured
concurrently with the outcome, preventing a straightforward causal
interpretation. They nevertheless interpret format and medium as explaining
much of the recovery variation. Both the association and that caveat belong
in any account of Appendix K. Source: Appendix K.2,
[p. 37](../../manuscript/manuscript.pdf#page=37).

## Epoch-specific link–residual correlations

Appendix K.3 correlates link-post proportions with outlet-level residuals from
the main negative binomial model within each epoch. It defines those residuals
as log-scale deviations of observed outlet mean reactions from the mean expected
given tier and epoch. A negative association indicates that outlets posting
more links receive fewer reactions than that tier/epoch expectation. The
authors report Pearson and Spearman correlations and 95% bootstrap intervals.
Source: Appendix K.3, [p. 37](../../manuscript/manuscript.pdf#page=37).

| Epochs | Pearson results reported in prose | Spearman results reported in prose | Interpretation offered |
|---|---|---|---|
| 0 | Weakly negative; CI narrowly excludes zero. | Weakly negative; CI narrowly excludes zero. | Isolated early fluctuation. |
| 1–7 | Range −0.15 to +0.17; intervals include zero. | Range −0.14 to +0.27; intervals include zero. | No consistent association. |
| 8 | −0.25; CI includes zero. | −0.30; CI includes zero. | Transitional negative association. |
| 9 | −0.53 [−0.68, −0.36]. | −0.58 [−0.76, −0.30]. | Strong negative relationship. |
| 10 | −0.29; upper CI endpoint near zero. | −0.41; CI excludes zero. | Rank relationship persists; linear result less precise. |
| 11 | −0.43; complete numerical interval not printed in prose. | −0.49; CI excludes zero. | Negative association continues. |

Sources: Appendix K.3 and Figure K.12,
[pp. 37–38](../../manuscript/manuscript.pdf#page=37).

The table retains prose-reported values; it does not read exact missing endpoints
off the plotted bands. The appendix does not give the number of bootstrap
replicates, random seed or interval construction method. Its characterization of
the epoch-0 bands should be read alongside the
[figure/prose note](../reference/reading-notes.md#format-analysis-description).
Source: Figure K.12 and Appendix K.3,
[pp. 37–38](../../manuscript/manuscript.pdf#page=37).

## Timing and relation to the main story

The authors interpret the emergence of the negative relationship in epoch 9
(September 2024–March 2025) as suggesting that format-specific changes began
before the January 2025 formal policy reversal and June 2025 posting advice.
Because this is an epoch-level association over an interval spanning January,
it should be retained as their timing interpretation rather than an independently
dated deployment observation. Source: Appendix K.3,
[p. 38](../../manuscript/manuscript.pdf#page=38).

Appendix K's synthesis is that broad suppression operated largely independently
of news format, whereas differential recovery is associated with link dependence
and medium. This qualifies the headline emphasis on high-quality news: the
article reports a quality-patterned outcome, then advances format as a possible
explanation. Its final paragraph is unfinished in this PDF, so these summaries
do not supply the missing conclusion. Source: Appendix K.4,
[p. 38](../../manuscript/manuscript.pdf#page=38).
