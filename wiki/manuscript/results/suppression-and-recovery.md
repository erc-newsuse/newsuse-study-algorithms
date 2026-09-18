# Suppression and recovery

[Manuscript guide](../README.md) · [Epoch calendar](../reference/epochs-and-policy-context.md) · [Causal estimands](../methods/causal-comparisons.md)

## Reading the estimates

The outcome throughout this page is **reactions per post**, with modeled means
and ratios on the response scale. “Overall news” averages across quality tiers
on the log scale; it is not the pooled arithmetic mean of all news posts.
News-only estimates from Table G.9 and joint-model estimates from Table H.11 are
kept separate. Sources: §4.3.2,
[p. 10](../../manuscript/manuscript.pdf#page=10); Tables G.9 and H.11,
[p. 29](../../manuscript/manuscript.pdf#page=29),
[p. 31](../../manuscript/manuscript.pdf#page=31).

Intervals below reproduce the printed 2.5% and 97.5% endpoints. A dash means no
reported comparison. **Printed p = 0.000 is retained as rounded output, not
interpreted as a probability exactly equal to zero.** No numerical estimates
have been recomputed. Table-specific discrepancies are recorded in
[reading notes](../reference/reading-notes.md#focal-comparison-p-values).

## Main temporal narrative

Figure 1 juxtaposes comparatively stable posting with large reaction changes.
Before 2021 there are fluctuations around elections and other events. Following
the announced February 2021 news-deprioritization policy, news reactions move
downward, reach their lowest modeled level in epoch 8, then increase around the
2024 election and through 2025. Non-news reactions do not exhibit the same
suppression trajectory. Sources: §2 and Figure 1,
[pp. 2–3](../../manuscript/manuscript.pdf#page=2).

The main numerical landmarks are:

| Claim | Comparison and source | Meaning and qualification |
|---|---|---|
| 77% decrease | Overall news, epoch 8 / epoch 4 = 0.23; Figure I.9c. | Suppression trough versus the immediate pre-suppression epoch; p printed 0.000. |
| 379% increase | Overall news, epoch 11 / epoch 8 = 4.79; Figure I.9c. | Recovery from the trough; p printed 0.000. |
| 11% increase | Overall news, epoch 11 / epoch 4 = 1.11; Figure I.9c. | Net change from the earlier level; p = 0.536, so not statistically established as an increase. |
| 70% shortfall | News 11/4 ratio divided by non-news 11/4 ratio = 0.30; Figure I.9c. | Counterfactual interpretation after accounting for non-news growth; p printed 0.000. |
| 83% shortfall | High-quality 11/4 ratio divided by non-news 11/4 ratio = 0.17; Figure I.9c. | High-quality counterfactual shortfall; p printed 0.000. |

Sources: §2, [pp. 3–5](../../manuscript/manuscript.pdf#page=3);
Appendix I and Figure I.9c,
[pp. 33–34](../../manuscript/manuscript.pdf#page=33).

The focal intervals are epoch 4, April 6, 2020–March 1, 2021; epoch 8, June 26,
2023–September 2, 2024; and epoch 11, September 22–December 16, 2025. The
77% estimate therefore compares selected intervals, rather than averaging all
pre-policy observations against all observations during suppression. Source:
Table G.9, [p. 29](../../manuscript/manuscript.pdf#page=29).

## News-only means across all epochs

These are the **overall** rows of Table G.9. The grand-mean contrast denominator
is the geometric mean over all epochs; the sequential denominator is the previous
epoch. The EMMs themselves are not significance tests. Source: Table G.9,
[p. 29](../../manuscript/manuscript.pdf#page=29).

| Epoch | News EMM [95% CI] | Epoch / grand mean [95% CI] | z | p | Epoch / previous [95% CI] | z | p |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 0 | 2048.42 [1208.09, 3473.28] | 1.26 [0.95, 1.66] | 2.36 | 0.197 | — | — | — |
| 1 | 3253.85 [1922.62, 5506.84] | 2.00 [1.52, 2.62] | 7.23 | 0.000 | 1.59 [1.07, 2.37] | 3.26 | 0.012 |
| 2 | 1962.45 [1159.69, 3320.89] | 1.20 [0.92, 1.58] | 1.94 | 0.464 | 0.60 [0.41, 0.90] | -3.59 | 0.003 |
| 3 | 1549.49 [915.76, 2621.80] | 0.95 [0.72, 1.25] | -0.53 | 1.000 | 0.79 [0.53, 1.17] | -1.68 | 0.600 |
| 4 | 2361.04 [1392.39, 4003.55] | 1.45 [1.10, 1.91] | 3.82 | 0.002 | 1.52 [1.02, 2.27] | 2.97 | 0.031 |
| 5 | 1961.23 [1154.02, 3333.09] | 1.20 [0.91, 1.59] | 1.88 | 0.514 | 0.83 [0.55, 1.25] | -1.29 | 0.866 |
| 6 | 1486.51 [876.69, 2520.50] | 0.91 [0.69, 1.20] | -0.95 | 0.991 | 0.76 [0.51, 1.14] | -1.92 | 0.413 |
| 7 | 848.96 [501.63, 1436.79] | 0.52 [0.40, 0.68] | -6.82 | 0.000 | 0.57 [0.38, 0.85] | -3.94 | 0.001 |
| 8 | 544.72 [321.26, 923.62] | 0.33 [0.25, 0.44] | -11.32 | 0.000 | 0.64 [0.43, 0.96] | -3.12 | 0.018 |
| 9 | 977.76 [577.62, 1655.09] | 0.60 [0.46, 0.79] | -5.34 | 0.000 | 1.79 [1.20, 2.68] | 4.12 | 0.000 |
| 10 | 2143.06 [1258.14, 3650.41] | 1.31 [0.99, 1.75] | 2.74 | 0.071 | 2.19 [1.46, 3.29] | 5.43 | 0.000 |
| 11 | 2607.14 [1529.66, 4443.60] | 1.60 [1.20, 2.13] | 4.69 | 0.000 | 1.22 [0.80, 1.84] | 1.33 | 0.845 |

The news-only means fall from **2,361.04** in epoch 4 to **544.72** in epoch 8,
then rise to **2,607.14** in epoch 11. Significant overall sequential declines
occur from epoch 6 to 7 and 7 to 8, followed by significant increases from 8 to 9
and 9 to 10. The last transition, 10 to 11, is not significant. These sequential
tests are distinct from both the grand-mean tests and the focal 4/8/11 tests.
Sources: §2 and Figure 2b,
[pp. 3–4](../../manuscript/manuscript.pdf#page=3); Table G.9,
[p. 29](../../manuscript/manuscript.pdf#page=29).

## Focal quality-specific news-only means

The following entries reproduce the EMM panel for low, medium and high tiers in
epochs 4, 8 and 11. All values come from the news-only model; subsequent focal
ratio tables are quoted separately from Figure I.9c. Source: Table G.9,
[p. 29](../../manuscript/manuscript.pdf#page=29).

| Epoch | Tier | EMM | Lower 95% endpoint | Upper 95% endpoint |
| --- | --- | --- | --- | --- |
| 4 | low | 4850.44 | 1930.64 | 12186.00 |
| 4 | medium | 1442.50 | 566.70 | 3671.82 |
| 4 | high | 1881.11 | 774.88 | 4566.61 |
| 8 | low | 805.91 | 320.79 | 2024.64 |
| 8 | medium | 539.94 | 212.12 | 1374.37 |
| 8 | high | 371.44 | 153.01 | 901.67 |
| 11 | low | 4478.68 | 1762.94 | 11377.94 |
| 11 | medium | 3455.80 | 1340.51 | 8908.94 |
| 11 | high | 1144.98 | 471.30 | 2781.63 |

The remaining contrasts for these same nine Table G.9 rows are retained below.
In the first table, the grand mean is across epochs **within the named tier**,
and the sequential denominator is that tier's immediately preceding epoch
(3, 7 or 10). In the second, the denominator is the geometric mean across tiers
**within the named epoch**. These are different hypotheses from Figure I.9c's
focal 8/4, 11/8 and 11/4 comparisons. Source: Table G.9,
[p. 29](../../manuscript/manuscript.pdf#page=29).

| Epoch | Tier | Epoch / tier grand mean [95% CI] | z | p | Epoch / previous [95% CI] | z | p |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 4 | low | 1.67 [1.04, 2.69] | 3.06 | 0.026 | 1.80 [0.90, 3.59] | 2.37 | 0.162 |
| 4 | medium | 1.02 [0.62, 1.69] | 0.14 | 1.000 | 1.13 [0.56, 2.29] | 0.48 | 1.000 |
| 4 | high | 1.78 [1.12, 2.81] | 3.57 | 0.004 | 1.75 [0.90, 3.41] | 2.35 | 0.172 |
| 8 | low | 0.28 [0.17, 0.45] | -7.67 | 0.000 | 0.73 [0.36, 1.46] | -1.28 | 0.871 |
| 8 | medium | 0.38 [0.23, 0.63] | -5.50 | 0.000 | 0.74 [0.36, 1.50] | -1.20 | 0.908 |
| 8 | high | 0.35 [0.22, 0.56] | -6.51 | 0.000 | 0.49 [0.25, 0.96] | -3.00 | 0.028 |
| 11 | low | 1.54 [0.94, 2.54] | 2.48 | 0.146 | 1.04 [0.50, 2.14] | 0.15 | 1.000 |
| 11 | medium | 2.46 [1.46, 4.13] | 4.93 | 0.000 | 1.66 [0.78, 3.53] | 1.89 | 0.439 |
| 11 | high | 1.08 [0.68, 1.71] | 0.48 | 1.000 | 1.04 [0.53, 2.04] | 0.17 | 1.000 |

| Epoch | Tier | Tier / epoch quality grand mean [95% CI] | z | p |
| --- | --- | --- | --- | --- |
| 4 | low | 2.05 [1.05, 4.03] | 2.50 | 0.033 |
| 4 | medium | 0.61 [0.31, 1.20] | -1.70 | 0.204 |
| 4 | high | 0.80 [0.41, 1.54] | -0.80 | 0.700 |
| 8 | low | 1.48 [0.75, 2.90] | 1.36 | 0.361 |
| 8 | medium | 0.99 [0.50, 1.95] | -0.03 | 0.999 |
| 8 | high | 0.68 [0.35, 1.32] | -1.36 | 0.364 |
| 11 | low | 1.72 [0.87, 3.39] | 1.86 | 0.150 |
| 11 | medium | 1.33 [0.67, 2.63] | 0.96 | 0.600 |
| 11 | high | 0.44 [0.23, 0.85] | -2.90 | 0.010 |

The manuscript reports suppression of 83%, 62% and 80% for low, medium and high
tiers, followed by recovery of 454%, 542% and 209%, respectively. Thus low-quality
sources have the largest proportional drop, while high-quality sources have the
weakest rebound. Appendix I explicitly says evidence that the initial suppression
magnitudes differ across tiers is limited: its medium-versus-overall comparison
has only marginal significance (p ≈ 0.087). A significant change within each tier
does not itself establish a significant difference between their changes.
Sources: §2, Figure 3, [p. 5](../../manuscript/manuscript.pdf#page=5);
Appendix I, [p. 33](../../manuscript/manuscript.pdf#page=33).

Figure 2c addresses another question: each tier's position relative to the
within-epoch geometric mean, with omnibus tests of tier differences. The text
emphasizes convergence toward depressed reaction levels during suppression and
renewed tier differences during recovery. This does not make the tier means
literally equal during every suppression epoch. Source: Figure 2c and §2,
[pp. 4–5](../../manuscript/manuscript.pdf#page=4).

## Joint-model news and non-news estimates

The next tables preserve the news and non-news rows from Table H.11. News means
use the joint model and therefore differ slightly from Table G.9. Within-sector
baseline contrasts compare each epoch with that sector's geometric mean over
epochs 0–4; these are **not yet** news/non-news DiD ratios. Source: Table H.11,
[p. 31](../../manuscript/manuscript.pdf#page=31).

| Epoch | Joint-model news EMM [95% CI] | Non-news EMM [95% CI] |
| --- | --- | --- |
| 0 | 2037.96 [1127.02, 3685.18] | 4184.91 [1822.22, 9611.04] |
| 1 | 3256.06 [1805.05, 5873.49] | 5400.99 [2354.39, 12389.92] |
| 2 | 1961.23 [1087.32, 3537.54] | 3444.51 [1503.01, 7893.91] |
| 3 | 1549.15 [858.91, 2794.08] | 3759.81 [1641.76, 8610.40] |
| 4 | 2361.24 [1305.46, 4270.87] | 4462.68 [1973.05, 10093.77] |
| 5 | 1963.12 [1082.25, 3560.93] | 3923.82 [1721.82, 8941.89] |
| 6 | 1487.88 [822.62, 2691.12] | 5483.49 [2427.59, 12386.21] |
| 7 | 849.45 [470.91, 1532.30] | 5512.04 [2439.31, 12455.41] |
| 8 | 545.22 [301.44, 986.13] | 7774.56 [3443.27, 17554.18] |
| 9 | 981.35 [543.95, 1770.48] | 7304.92 [3210.65, 16620.24] |
| 10 | 2144.37 [1178.40, 3902.15] | 12073.98 [5179.22, 28147.27] |
| 11 | 2609.94 [1433.69, 4751.21] | 16394.54 [6955.23, 38644.45] |

Within-sector contrasts from the same Table H.11:

| Epoch | Sector | Epoch / baseline 0–4 [95% CI] | z | p | Epoch / previous [95% CI] | z | p |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 0 | non-news | 1.00 [0.66, 1.51] | -0.02 | 1.000 | — | — | — |
| 0 | news | 0.94 [0.71, 1.25] | -0.61 | 1.000 | — | — | — |
| 1 | non-news | 1.29 [0.85, 1.94] | 1.74 | 0.614 | 1.29 [0.68, 2.46] | 1.11 | 0.940 |
| 1 | news | 1.50 [1.13, 2.00] | 4.11 | 0.000 | 1.60 [1.03, 2.49] | 2.97 | 0.030 |
| 2 | non-news | 0.82 [0.54, 1.24] | -1.38 | 0.870 | 0.64 [0.34, 1.21] | -1.97 | 0.382 |
| 2 | news | 0.91 [0.68, 1.20] | -1.00 | 0.985 | 0.60 [0.39, 0.94] | -3.24 | 0.012 |
| 3 | non-news | 0.90 [0.59, 1.35] | -0.77 | 0.998 | 1.09 [0.58, 2.07] | 0.38 | 1.000 |
| 3 | news | 0.72 [0.54, 0.95] | -3.38 | 0.009 | 0.79 [0.51, 1.23] | -1.51 | 0.728 |
| 4 | non-news | 1.06 [0.71, 1.58] | 0.43 | 1.000 | 1.19 [0.63, 2.22] | 0.77 | 0.995 |
| 4 | news | 1.09 [0.82, 1.45] | 0.86 | 0.995 | 1.52 [0.98, 2.37] | 2.67 | 0.074 |
| 5 | non-news | 0.93 [0.57, 1.54] | -0.39 | 1.000 | 0.88 [0.47, 1.64] | -0.58 | 0.999 |
| 5 | news | 0.91 [0.64, 1.29] | -0.79 | 0.998 | 0.83 [0.53, 1.30] | -1.15 | 0.925 |
| 6 | non-news | 1.31 [0.80, 2.12] | 1.57 | 0.748 | 1.40 [0.75, 2.60] | 1.52 | 0.723 |
| 6 | news | 0.69 [0.48, 0.98] | -3.05 | 0.026 | 0.76 [0.48, 1.19] | -1.73 | 0.557 |
| 7 | non-news | 1.31 [0.81, 2.13] | 1.60 | 0.727 | 1.01 [0.55, 1.85] | 0.02 | 1.000 |
| 7 | news | 0.39 [0.28, 0.55] | -7.71 | 0.000 | 0.57 [0.37, 0.89] | -3.55 | 0.004 |
| 8 | non-news | 1.85 [1.14, 3.00] | 3.63 | 0.003 | 1.41 [0.77, 2.59] | 1.59 | 0.671 |
| 8 | news | 0.25 [0.18, 0.36] | -11.22 | 0.000 | 0.64 [0.41, 1.00] | -2.81 | 0.049 |
| 9 | non-news | 1.74 [1.06, 2.86] | 3.18 | 0.017 | 0.94 [0.51, 1.74] | -0.28 | 1.000 |
| 9 | news | 0.45 [0.32, 0.64] | -6.52 | 0.000 | 1.80 [1.16, 2.80] | 3.72 | 0.002 |
| 10 | non-news | 2.88 [1.69, 4.89] | 5.66 | 0.000 | 1.65 [0.86, 3.18] | 2.15 | 0.266 |
| 10 | news | 0.99 [0.69, 1.42] | -0.08 | 1.000 | 2.19 [1.39, 3.43] | 4.87 | 0.000 |
| 11 | non-news | 3.90 [2.25, 6.76] | 7.07 | 0.000 | 1.36 [0.68, 2.71] | 1.24 | 0.888 |
| 11 | news | 1.21 [0.84, 1.73] | 1.48 | 0.813 | 1.22 [0.77, 1.93] | 1.20 | 0.907 |

The joint estimates show why an apparent return to an earlier news level can
coexist with a large relative shortfall. Non-news grows from **4,462.68** reactions
in epoch 4 to **16,394.54** in epoch 11, while joint-model news grows from
**2,361.24** to **2,609.94**. Source: Table H.11,
[p. 31](../../manuscript/manuscript.pdf#page=31).

## Immediate and cumulative news/non-news comparisons

This is Table H.12's complete set of epochs. Immediate RR compares the
news/non-news proportional changes since the previous epoch; cumulative RR
compares the two sectors' relative positions against their respective geometric
baselines from epochs 0–4. Source: Table H.12,
[p. 32](../../manuscript/manuscript.pdf#page=32).

| Epoch | Immediate RR [95% CI] | z | p | Cumulative RR [95% CI] | z | p |
| --- | --- | --- | --- | --- | --- | --- |
| 0 | — | — | — | 0.94 [0.57, 1.56] | -0.32 | 1.000 |
| 1 | 1.24 [0.57, 2.70] | 0.77 | 0.995 | 1.17 [0.71, 1.93] | 0.89 | 0.994 |
| 2 | 0.94 [0.43, 2.05] | -0.21 | 1.000 | 1.10 [0.67, 1.82] | 0.57 | 1.000 |
| 3 | 0.72 [0.33, 1.57] | -1.17 | 0.919 | 0.80 [0.49, 1.31] | -1.28 | 0.914 |
| 4 | 1.28 [0.60, 2.77] | 0.91 | 0.983 | 1.03 [0.63, 1.68] | 0.15 | 1.000 |
| 5 | 0.95 [0.44, 2.03] | -0.20 | 1.000 | 0.97 [0.53, 1.79] | -0.14 | 1.000 |
| 6 | 0.54 [0.25, 1.17] | -2.24 | 0.219 | 0.53 [0.29, 0.96] | -3.06 | 0.026 |
| 7 | 0.57 [0.27, 1.21] | -2.11 | 0.293 | 0.30 [0.16, 0.54] | -5.78 | 0.000 |
| 8 | 0.46 [0.21, 0.97] | -2.94 | 0.034 | 0.14 [0.07, 0.25] | -9.52 | 0.000 |
| 9 | 1.92 [0.90, 4.09] | 2.40 | 0.151 | 0.26 [0.14, 0.48] | -6.34 | 0.000 |
| 10 | 1.32 [0.60, 2.93] | 0.99 | 0.971 | 0.34 [0.18, 0.65] | -4.73 | 0.000 |
| 11 | 0.90 [0.39, 2.05] | -0.37 | 1.000 | 0.31 [0.16, 0.60] | -5.10 | 0.000 |

Only the transition into epoch 8 has an immediate comparison significant at .05
in this table (p = 0.034). Cumulative comparisons are significant from epoch 6
onward, including the recovery epochs. Those results answer different temporal
questions and need not share a first significant epoch. Sources: §2.1,
[p. 5](../../manuscript/manuscript.pdf#page=5); Table H.12,
[p. 32](../../manuscript/manuscript.pdf#page=32).

## Complete focal contrasts from Figure I.9c

“Total” is the within-group ratio for the named numerator and denominator epochs.
“Causal” is that ratio divided by the corresponding non-news ratio, using the
article's terminology. Causal interpretation depends on the assumptions in
[causal comparisons](../methods/causal-comparisons.md). All fifteen rows and
their printed ratio, interval, z and p fields are retained below. Source:
Figure I.9c, [p. 34](../../manuscript/manuscript.pdf#page=34).

| Epoch ratio | Group | Total ratio [95% CI] | z | p | Causal ratio [95% CI] | z | p |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 8 / 4 | non-news | 1.74 [1.08, 2.82] | 2.55 | 0.020 | — | — | — |
| 8 / 4 | news | 0.23 [0.16, 0.33] | -9.22 | 0.000 | 0.13 [0.08, 0.22] | -7.50 | 0.000 |
| 8 / 4 | low | 0.17 [0.09, 0.31] | -6.53 | 0.000 | 0.10 [0.04, 0.22] | -6.70 | 0.000 |
| 8 / 4 | medium | 0.38 [0.20, 0.71] | -3.42 | 0.001 | 0.22 [0.09, 0.50] | -4.27 | 0.000 |
| 8 / 4 | high | 0.20 [0.11, 0.35] | -6.15 | 0.000 | 0.11 [0.05, 0.25] | -6.37 | 0.000 |
| 11 / 8 | non-news | 2.11 [1.25, 3.55] | 3.17 | 0.003 | — | — | — |
| 11 / 8 | news | 4.79 [3.35, 6.84] | 9.69 | 0.000 | 2.27 [1.30, 3.97] | 2.87 | 0.004 |
| 11 / 8 | low | 5.54 [2.97, 10.32] | 6.09 | 0.000 | 2.63 [1.11, 6.24] | 2.63 | 0.024 |
| 11 / 8 | medium | 6.42 [3.35, 12.28] | 6.34 | 0.000 | 3.04 [1.25, 7.39] | 2.96 | 0.009 |
| 11 / 8 | high | 3.09 [1.72, 5.54] | 4.26 | 0.000 | 1.46 [0.63, 3.38] | 1.07 | 0.591 |
| 11 / 4 | non-news | 3.67 [2.31, 5.83] | 5.51 | 0.000 | — | — | — |
| 11 / 4 | news | 1.11 [0.80, 1.52] | 0.62 | 0.536 | 0.30 [0.17, 0.53] | -4.20 | 0.000 |
| 11 / 4 | low | 0.92 [0.53, 1.60] | -0.28 | 0.777 | 0.25 [0.11, 0.60] | -3.76 | 0.000 |
| 11 / 4 | medium | 2.41 [1.35, 4.29] | 2.98 | 0.003 | 0.66 [0.27, 1.60] | -1.12 | 0.558 |
| 11 / 4 | high | 0.61 [0.36, 1.02] | -1.88 | 0.060 | 0.17 [0.07, 0.38] | -5.07 | 0.000 |

Relative to epoch 4, low-quality news is 8% lower in epoch 11 (p = 0.777), medium
is 141% higher (p = 0.003), and high is 39% lower (p = 0.060). The last is marked
with a dagger in Figure 3, not as p < .05. After the non-news comparison, the
corresponding shortfalls are 75%, 34% and 83%; the medium-tier result is not
significant (p = 0.558). Neither nonsignificant result establishes exact recovery
or equivalence. Sources: Figure 3,
[p. 5](../../manuscript/manuscript.pdf#page=5); Appendix I and Figure I.9c,
[pp. 33–34](../../manuscript/manuscript.pdf#page=33).

Appendix K qualifies the interpretation of these quality differences by examining
posting format and medium. Its account belongs alongside the main recovery
results, rather than being reduced to an incidental robustness check; see
[post-format and recovery](post-format-and-recovery.md). Source: Appendix K,
[pp. 36–38](../../manuscript/manuscript.pdf#page=36).
