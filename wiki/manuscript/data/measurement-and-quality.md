# Measurement and outlet quality

[Manuscript guide](../README.md) · [Sample](sampling-and-collection.md) · [Notation](../reference/glossary-and-notation.md)

## Units and measured quantities

The main outcome is the **number of reactions received by an individual Facebook
post**. The article uses reactions as a proxy for visibility, while explicitly
recognizing that reacting is only one part of exposure. Its primary models do
not directly estimate impressions, unique exposed users, reading, political
knowledge or susceptibility to misinformation. Sources: §4.1,
[p. 8](../../manuscript/manuscript.pdf#page=8); §3,
[pp. 7–8](../../manuscript/manuscript.pdf#page=7).

| Quantity or unit | Role in the manuscript |
|---|---|
| Post | Individual outcome observation in the negative binomial models. |
| Outlet/page | News organization or non-news account; unit of metadata and persistent heterogeneity. |
| Outlet-day | Level at which preliminary conditional engagement summaries are described. |
| Outlet-week | Intermediate aggregation for temporal signals and posting comparisons. |
| Epoch | Interval between detected changepoints; exposure to a calendar interval, not a directly observed algorithm assignment. |
| Reactions | Main engagement count and visibility proxy. |
| Views | Available for a Content Library subset; supports proxy validation and reaction imputation. |
| Comments and shares | Descriptive context; comments also enter a proxy-validation comparison. Shares have substantial missingness or incompleteness. |
| Post count | Content-supply measure, distinct from reactions per post. |
| Post type | Status, video, link or photo in the main description; used especially in Appendix K. |
| Unique website visitors | ComScore audience measure outside Facebook, used in an alternative-explanation analysis. |

Sources: §§4.1–4.3, [pp. 8–10](../../manuscript/manuscript.pdf#page=8);
Appendices B, D, J and K,
[pp. 16–18](../../manuscript/manuscript.pdf#page=16),
[p. 21](../../manuscript/manuscript.pdf#page=21),
[pp. 35–38](../../manuscript/manuscript.pdf#page=35).

## Quality ratings and other metadata

Appendix A.1 attributes quality scores to Lin et al., manuscript reference (20).
It describes an aggregate of five rating sources: Ad Fontes Media, Media
Bias/Fact Check, the Iffy Index, and the systems in references (48) and (49).
Scores range from 0 to 1, with larger values indicating higher outlet quality.
A percentile split forms near-equal low, medium and high tiers. The exact
unrounded cutpoints and tie rule are not specified in the prose. Rounded scores
in Table A.1 must not be used to invent them. Source: Appendix A.1 and Table A.1,
[p. 15](../../manuscript/manuscript.pdf#page=15).

The manuscript sometimes calls low-quality sources “untrustworthy.” For these
summaries, that term refers to its assigned tier rather than a separate
post-level misinformation classification. Table A.1 includes outlets on both
political sides in that tier. Appendix K also uses the continuous quality score,
which is a different predictor from the categorical tier used in the epoch
models. Sources: §§1–2, [pp. 1–5](../../manuscript/manuscript.pdf#page=1);
Table A.1, [p. 15](../../manuscript/manuscript.pdf#page=15);
Appendix K.2, [pp. 36–37](../../manuscript/manuscript.pdf#page=36).

Table A.1 additionally reports primary medium, ideological ratings, website
traffic and Facebook followers. Its Ad Fontes bias scale runs from −100 to 100;
its numeric MBFC scale runs from −10 to 10; lower values indicate more left-wing
positions. Some MBFC entries are textual labels. Similarweb website visits refer
to March 2025, and Facebook followers were observed on April 28, 2025. Despite
the table's “Views” column heading, its footnote identifies those values as
monthly website visits; they are not the post-view observations used in Appendix
B.2. Source: Table A.1 and footnotes,
[p. 15](../../manuscript/manuscript.pdf#page=15).

## Validation of reactions as a visibility proxy

On the subset with view data, the reported correlation between views and reactions
is **r = 0.791**, compared with **r = 0.424** between views and comments. The
authors then fit two linear regressions with views as the dependent variable.
Source: Appendix B.2, [p. 18](../../manuscript/manuscript.pdf#page=18).

| Table B.3 quantity | Reactions only | Reactions and comments |
|---|---:|---:|
| Intercept (SE) | 54,740 (966.7) | 48,610 (994.6) |
| Reactions coefficient (SE) | 50.62 (0.052) | 49.50 (0.065) |
| Comments coefficient (SE) | — | 24.24 (0.851) |
| Adjusted R² | 0.6263 | 0.6290 |

Source: Table B.3, [p. 18](../../manuscript/manuscript.pdf#page=18).

The manuscript interprets the first model as explaining approximately 62.6% of
view variance, with 50.62 additional predicted views per reaction. It reports
p < 0.001 for that slope and for comments in the second model. Adding comments
raises adjusted R² by only 0.0027. The authors therefore favor reactions as a
parsimonious visibility proxy. This validates an association in the available
subset; the discussion still identifies direct impression data as desirable.
Sources: Appendix B.2, [p. 18](../../manuscript/manuscript.pdf#page=18);
§3, [p. 7](../../manuscript/manuscript.pdf#page=7).

The regression direction here is **views from reactions**. The missing-value
model predicts **reactions from views**, with outlet and video predictors; see
[cleaning and imputation](cleaning-and-imputation.md#views-based-imputation).
These models answer different questions. Source: Appendix B.2.1,
[p. 18](../../manuscript/manuscript.pdf#page=18).

## Descriptive distributions and weighting

Table B.2 gives each page's post count and the mean, standard deviation, median
and interquartile range of reactions, comments and shares. Figure C.5a shows
outlet distributions of posting and average reactions, alongside empirical
complementary cumulative reaction distributions. The authors emphasize strong
overdispersion, heavy tails and large outlet differences, particularly among
low-quality outlets. This motivates modeling outlet heterogeneity rather than
treating a pooled post mean as a general ecosystem summary. Sources: Table B.2,
[p. 16](../../manuscript/manuscript.pdf#page=16); Appendix C,
[pp. 19–20](../../manuscript/manuscript.pdf#page=19).

| Figure C.5b overall row | Low | Medium | High | Non-news |
|---|---:|---:|---:|---:|
| Posts, total | 1,317,473 | 1,620,116 | 2,790,913 | 436,420 |
| Reactions, average | 3,278 | 1,455 | 946 | 5,278 |

Source: Figure C.5b, [p. 19](../../manuscript/manuscript.pdf#page=19).

The reported descriptive pattern is that high-quality outlets publish more, while
low-quality outlets receive more reactions per post. Non-news pages publish much
less frequently but attract higher average reactions. Figure C.5c offers annual
outlet-total summaries, and its caption describes the overall row as an average
over years. These descriptives should not be substituted for the model-based,
equally weighted log-scale estimates in the results. Appendix C's prose and
Figure C.5c also give conflicting outlet-total reaction summaries; see the
[reading note](../reference/reading-notes.md#descriptive-summary-values).
Sources: Appendix C and Figure C.5,
[pp. 19–20](../../manuscript/manuscript.pdf#page=19); §4.3.2,
[p. 10](../../manuscript/manuscript.pdf#page=10).
