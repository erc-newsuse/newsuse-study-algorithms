# Causal comparisons

[Manuscript guide](../README.md) · [Contrasts](marginal-means-and-contrasts.md) · [Results](../results/suppression-and-recovery.md)

## Counterfactual role of non-news pages

The manuscript interprets changes in news engagement relative to changes in
non-news engagement as evidence of news-specific algorithmic effects. It assumes
that sports, retail, restaurant and entertainment pages would not be directly
affected by policies targeting news and civic content, and that their relative
changes approximate news engagement's counterfactual changes without those
policies. This is an observational comparison with a substantive assumption,
not randomized assignment. Sources: §2.1,
[p. 5](../../manuscript/manuscript.pdf#page=5); §4.4,
[pp. 10–11](../../manuscript/manuscript.pdf#page=10).

## Ratio of ratios

Equation (12) compares corresponding within-sector contrasts:

$$
\tau_i=\frac{\psi_{i,\mathrm{news}}}{\psi_{i,\mathrm{non\text{-}news}}}.
\qquad (12)
$$

For a sequential contrast, an explanatory expansion is:

$$
\tau_i^{(s)}=
\frac{\mu_{i,\mathrm{news}}/\mu_{i-1,\mathrm{news}}}
{\mu_{i,\mathrm{non\text{-}news}}/\mu_{i-1,\mathrm{non\text{-}news}}}.
$$

The corresponding log quantity is a difference of differences of log means.
On the response scale it is a **ratio of ratios**, not an additive difference
of reaction counts. Values below one indicate that news changed less favorably
than non-news over the same comparison; values above one indicate more favorable
relative change. Source: §4.4, Eq. (12),
[p. 10](../../manuscript/manuscript.pdf#page=10).

## Three reference-period conventions

| Estimand | Within-sector denominator | Where reported |
|---|---|---|
| Immediate DiD | Previous epoch | Table H.12, left half. |
| Cumulative baseline comparison | Geometric mean of epochs 0–4 | Figure 4 and Table H.12, right half. |
| Focal total-change comparison | One specific epoch: 4 for suppression/net change, 8 for recovery | Figure I.9c. |

Sources: §4.4, [p. 10](../../manuscript/manuscript.pdf#page=10);
Figure 4, [p. 6](../../manuscript/manuscript.pdf#page=6);
Table H.12, [p. 32](../../manuscript/manuscript.pdf#page=32);
Figure I.9c, [p. 34](../../manuscript/manuscript.pdf#page=34).

For clarity, the cumulative baseline can be written as the following
**explanatory expansion** of the prose in §4.4:

$$
G_s=\exp\left(\frac15\sum_{t=0}^{4}\log\mu_{t,s}\right),\qquad
\tau_{i,\mathrm{baseline}}=
\frac{\mu_{i,\mathrm{news}}/G_{\mathrm{news}}}
{\mu_{i,\mathrm{non\text{-}news}}/G_{\mathrm{non\text{-}news}}}.
$$

This reference is an equal-weight average of five epoch log means, not a
duration-weighted pre-policy mean. The focal 11/4 contrast uses epoch 4 alone.
Consequently Table H.12's epoch-11 estimate **0.31** and Figure I.9c's **0.30**
have different denominators and must not be conflated as one exact estimate.
Sources: §4.4, [p. 10](../../manuscript/manuscript.pdf#page=10);
Table H.12, [p. 32](../../manuscript/manuscript.pdf#page=32);
Figure I.9c, [p. 34](../../manuscript/manuscript.pdf#page=34).

## Equiproportional trends assumption

The article's parallel-trends requirement is expressed in **log space**:
without the intervention, the news and non-news means would change in the same
proportion. Equal absolute reaction levels or equal additive changes are not
required. The authors recognize that the unobserved counterfactual during the
intervention cannot be directly tested. They examine earlier observed trends
as supporting evidence. Source: §4.4,
[p. 10](../../manuscript/manuscript.pdf#page=10).

Equation (13) states the null hypothesis:

$$
H_0:\ \forall i,\ \log\tau_i^{(s)}=0. \qquad (13)
$$

The text uses the asymptotic normality of maximum-likelihood estimates to form
$T=\boldsymbol\tau^\top\Sigma^{-1}\boldsymbol\tau$, where the vector contains
log DiD estimators and $\Sigma$ is their covariance matrix. It reports the
following tests without providing the numerical covariance matrix. Sources:
§4.4, Eq. (13), [pp. 10–11](../../manuscript/manuscript.pdf#page=10).

| Period described by authors | Reported statistic | p-value | Interpretation in the article |
|---|---:|---:|---|
| Before suppression, “epochs 0 to 4” | χ²(5) ≈ 9.34 | ≈ 0.096 | Cannot reject log-parallel trends. |
| “Epochs 6 to 10” | χ²(5) ≈ 238.3 | < 0.001 | Strong evidence that news and non-news changes diverged. |
| Epoch 11 versus 10 | χ²(1) = 0.55 | ≈ 0.459 | Cannot reject equal proportional changes in the last transition. |

Source: §4.4, [p. 11](../../manuscript/manuscript.pdf#page=11).

The first test's index convention is ambiguous: five sequential contrasts are
named for epochs 0–4, whereas Table H.12 has no immediate contrast for epoch 0.
The reported statistics are retained without reconstructing that selection.
See [trend-test indexing](../reference/reading-notes.md#trend-test-indexing).
Failure to reject a pre-period null supports the authors' argument but does
not directly establish the unobserved post-period counterfactual, a distinction
consistent with their stated inability to test it. Sources: §4.4,
[pp. 10–11](../../manuscript/manuscript.pdf#page=10); Table H.12,
[p. 32](../../manuscript/manuscript.pdf#page=32).

## Interpretation of the reported effects

The article's strongest immediate relative decline is at the transition into
epoch 8: RR **0.46**, interval **[0.21, 0.97]**, p **0.034**. Cumulative
baseline comparisons are significantly below one from epoch 6 through epoch 11.
At epoch 11 the cumulative baseline RR is **0.31 [0.16, 0.60]**. Source:
Table H.12, [p. 32](../../manuscript/manuscript.pdf#page=32).

For the specific epoch-11/epoch-4 comparison, overall news grows to **1.11** of
its earlier mean, while non-news grows to **3.67**. Figure I.9c reports their
ratio as **0.30 [0.17, 0.53]**, summarized as a 70% counterfactual shortfall.
For high-quality news the corresponding ratio is **0.17 [0.07, 0.38]**, or an
83% shortfall. These statements are conditional causal interpretations of the
comparison, not direct observations of what would have happened without policy.
Sources: Appendix I and Figure I.9c,
[pp. 33–34](../../manuscript/manuscript.pdf#page=33).

## Attribution and limits of the design

Section 4.4 explicitly says uncertain announcement, implementation and deployment
dates prevent unequivocal attribution to individual interventions. The authors
interpret effects as the combined influence of changes proximal to an epoch or
boundary, with known events as leading candidates. They argue that temporal
differencing removes time-invariant effects and comparison-group differencing
removes common time-varying effects, under the trend assumption. Source: §4.4,
[p. 11](../../manuscript/manuscript.pdf#page=11).

The auxiliary analyses address several plausible alternatives but are different
pieces of evidence, not extra terms automatically included in the joint model.
See [alternative explanations](../results/alternative-explanations.md),
[post-format recovery](../results/post-format-and-recovery.md), and
[interpretation and limitations](../interpretation-and-limitations.md).
Sources: §2.2, [pp. 6–7](../../manuscript/manuscript.pdf#page=6);
Appendices J–K, [pp. 35–38](../../manuscript/manuscript.pdf#page=35).
