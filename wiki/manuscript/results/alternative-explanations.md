# Alternative explanations

[Manuscript guide](../README.md) · [Main results](suppression-and-recovery.md) · [Post format](post-format-and-recovery.md)

## Role in the argument

Section 2.2 and Appendix J examine whether engagement changes could instead
reflect news supply, general news demand or Facebook's user base. Appendix K
separately examines posting format. These analyses support the authors' causal
interpretation through additional comparisons; they are not all covariates in
one comprehensive adjusted model. Sources: §2.2,
[pp. 6–7](../../manuscript/manuscript.pdf#page=6); Appendices J–K,
[pp. 35–38](../../manuscript/manuscript.pdf#page=35).

| Alternative | Evidence considered | Conclusion advanced by the article |
|---|---|---|
| Less news posted | Weekly posting trajectories and posting–reaction associations. | Posting changes do not explain the suppression pattern. |
| Less demand for news generally | ComScore website audiences, survey context and referral evidence discussed from other studies. | Broader demand changes are too small or differently timed to explain the reaction collapse. |
| Declining Facebook use | Non-news reactions and U.S. user-count series. | A platform-wide decline is inconsistent with those comparison trajectories. |
| Changed formats | Link proportions and outlet recovery/residual analyses. | Format does not explain the broad initial decline, but is associated with differential recovery. |

Sources: §2.2, [pp. 6–7](../../manuscript/manuscript.pdf#page=6);
Appendices D, J and K, [p. 21](../../manuscript/manuscript.pdf#page=21),
[pp. 35–38](../../manuscript/manuscript.pdf#page=35).

## Posting-frequency model

The authors examine weekly mean reactions and posting counts, averaged by outlet
and separated into low, medium, high and non-news groups. They fit a Gaussian
linear model in log–log space, with group-specific mean relationships,
group-heteroscedastic errors and AR(1) temporal dependence. The specification,
as printed in Appendix D, is:

```text
log(mu) ~ log(n_posts) * quality + ar1(time + 0 | quality)    (D.1)
log(sigma^2) ~ quality                                     (D.2)
```

Time is described as an integer sequence starting at zero within each group.
The model uses maximum likelihood and glmmTMB in R. The autoregressive component
is intended to account for temporal dependence when assessing posting–reaction
associations. Source: Appendix D, Eqs. (D.1)–(D.2),
[p. 21](../../manuscript/manuscript.pdf#page=21).

Equation (D.3) translates the group slope into the reported correlation:

$$
r(\log X,\log Y\mid g)
=\beta_g\sqrt{\frac{V(\log X\mid g)}{V(\log Y\mid g)}}.\qquad (D.3)
$$

$X$ denotes post counts, $Y$ reaction counts, $g$ the group, and $\beta_g$ its
log–log slope. The authors describe this as a Pearson correlation adjusted for
autocorrelation, and equate its significance with the relevant group-specific
slope test. This is the manuscript's stated method; the summary does not replace
it with an ordinary correlation calculated on weekly observations. Source:
Appendix D, Eq. (D.3), [p. 21](../../manuscript/manuscript.pdf#page=21).

| Group | Correlation reported in §2.2 | p-value reported in §2.2 |
|---|---:|---:|
| Non-news | ≈ −0.002 | ≈ 1.000 |
| Low-quality news | ≈ 0.071 | ≈ 0.625 |
| Medium-quality news | ≈ 0.094 | ≈ 0.227 |
| High-quality news | ≈ 0.083 | ≈ 0.396 |

Source: §2.2, [p. 6](../../manuscript/manuscript.pdf#page=6).

The article interprets these small, nonsignificant correlations as evidence
against posting-volume changes driving reaction changes. Figure D.6 contrasts
residual autocorrelation under independent errors with the AR(1) fit, which
the authors say removes almost all temporal dependence. Table D.4 reports
R² ≈ **0.963** and autoregressive coefficient $\phi$ ≈ **0.983**. This $\phi$
is an autocorrelation coefficient, not either negative binomial dispersion
parameter. Source: Appendix D, Figure D.6 and Table D.4,
[p. 21](../../manuscript/manuscript.pdf#page=21).

Table D.4 includes conditional intercepts and posting-slope interactions, plus
group dispersion coefficients. Its reference is non-news: intercept **8.351**
(SE **0.417**) and log-post slope **−0.005** (SE **0.094**, p **0.962**).
Slope interactions are **0.143** for low (p **0.329**), **0.195** for medium
(p **0.161**) and **0.187** for high (p **0.213**). Those individual coefficient
tests are not the group-specific correlation tests in the preceding table.
Source: Table D.4, [p. 21](../../manuscript/manuscript.pdf#page=21).

## Off-platform news demand

Appendix J compares Facebook reactions with ComScore Media Metrix unique
website visitors for an available subset of news organizations. Coverage extends
from the start of the study to **February 2025**. The footnote explicitly says
these data cannot assess the later aftermath of suppression. Source: Appendix J,
[p. 35](../../manuscript/manuscript.pdf#page=35).

Figure J.10b's caption describes a three-month rolling mean of unique visitors,
relative to the overall mean and then averaged across outlets; a similarly
constructed reaction series appears below. Both are indexed to their overall
means, rather than to epoch 4. The plot marks the first U.S. COVID case and
important feed changes. The main pattern is a COVID-era audience peak and a
subsequent comparatively mild decline, rather than a change matching the scale
and timing of Facebook reaction suppression. The authors interpret much of
the audience decline as return toward pre-pandemic levels. Source: Appendix J
and Figure J.10b, [p. 35](../../manuscript/manuscript.pdf#page=35).

Figure J.10c lists these audience-series labels: ABC News, AP, Breitbart,
Business Insider, BuzzFeed News, cnbc.com, CNN, Daily Kos, Forbes, Fox News,
ft.com, HuffPost, MSNBC, newyorker.com, npr.org, pbsfrontline, pbsnewshour,
reuters.com, The Blaze, The Economist, The New York Times, The Week, USA Today,
Vox, Washington Post and wsj.com. The website/property labels are retained rather
than assumed to be a one-to-one representation of all 40 Facebook outlets.
Source: Figure J.10c, [p. 35](../../manuscript/manuscript.pdf#page=35).

For context, the manuscript cites evidence of modest increases in news avoidance,
a 7%–10% decline in reported U.S. news interest around 2021, and relatively
stable referral traffic from other social platforms except Twitter/X during
2021–2023. It also says a higher percentage of Americans reported using Facebook
for news in 2025 than in 2021. These are the article's accounts of references
(30), (31), (68) and (69); the underlying sources have not been separately
reviewed for this reference set. Sources: §2.2,
[p. 6](../../manuscript/manuscript.pdf#page=6); Appendix J,
[p. 35](../../manuscript/manuscript.pdf#page=35).

## Facebook user counts

Figure J.10a shows U.S. Facebook users relative to the 2019 baseline, using
Statista as cited by the article. Its caption distinguishes **2019–2023 values**
from **2024–2028 projections**. The plotted upward trajectory therefore combines
historical values and projections. The prose uses it, alongside growing
non-news reactions, to argue against a shrinking platform audience; the
observed/projected distinction should remain explicit when restating that
argument. Source: Appendix J and Figure J.10a,
[p. 35](../../manuscript/manuscript.pdf#page=35).

## What these comparisons contribute

The authors conclude that neither general news-demand changes, declining
Facebook use nor altered posting volume plausibly explains the magnitude of
the suppression pattern. This is their interpretation of a set of differently
scoped comparisons. The website series has limited outlet coverage and stops
before most of 2025; user-count estimates include projections; nonsignificant
posting associations are not direct estimates of every possible supply effect.
The manuscript's own scope limits are carried into
[interpretation and limitations](../interpretation-and-limitations.md).
Sources: §2.2, [pp. 6–7](../../manuscript/manuscript.pdf#page=6);
Appendix J, [p. 35](../../manuscript/manuscript.pdf#page=35).
