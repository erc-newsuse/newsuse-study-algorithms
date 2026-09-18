# Evidence map

[Manuscript guide](../README.md) · [Glossary](glossary-and-notation.md) · [Reading notes](reading-notes.md)

This index covers the September 17, 2026 manuscript's main sections, Appendices
A–L, **23 numbered equations**, **12 figures** and **13 numbered tables**.
The long, unnumbered policy table in Appendix L is indexed separately. Page
numbers are physical PDF pages; a range link opens its first page. Summary links
identify the canonical account rather than another independent source.

## Main sections and back matter

| Manuscript location | PDF pages | Purpose | Summary section |
|---|---|---|---|
| Title, authors, date and abstract | [1](../../manuscript/manuscript.pdf#page=1) | Version identity; compressed study claims. | [Source identity](../README.md#source-identity-and-scope); [overview](../overview.md#question-and-motivation). |
| §1 Introduction | [1–2](../../manuscript/manuscript.pdf#page=1) | Gatekeeping motivation, previous work, questions, contributions and headline findings. | [Questions](../overview.md#question-and-motivation); [contributions](../overview.md#claimed-contributions-and-design). |
| §2 Results | [2–5](../../manuscript/manuscript.pdf#page=2) | Descriptive trajectories, changepoints, news-model and quality results. | [Temporal narrative](../results/suppression-and-recovery.md#main-temporal-narrative). |
| §2.1 Comparison With Non-News Pages | [5–6](../../manuscript/manuscript.pdf#page=5) | Relative news/non-news changes and cumulative shortfall. | [Joint-model estimates](../results/suppression-and-recovery.md#joint-model-news-and-non-news-estimates); [causal estimands](../methods/causal-comparisons.md#ratio-of-ratios). |
| §2.2 Alternative Explanations | [6–7](../../manuscript/manuscript.pdf#page=6) | Posting, demand, platform use and format. | [Alternative explanations](../results/alternative-explanations.md#role-in-the-argument); [format mechanism](../results/post-format-and-recovery.md#question-and-proposed-mechanism). |
| §3 Discussion | [7–8](../../manuscript/manuscript.pdf#page=7) | Synthesis, causal interpretation, limitations and future research. | [Authors' causal argument](../interpretation-and-limitations.md#authors-causal-argument); [future research](../interpretation-and-limitations.md#proposed-future-research). |
| §4 Data and Methods | [8–11](../../manuscript/manuscript.pdf#page=8) | Main analytical specification. | [Analytical workflow](../overview.md#analytical-workflow); the method pages indexed below. |
| §4.1 Data | [8](../../manuscript/manuscript.pdf#page=8) | News sample, measurements, quality and imputation. | [Sampling](../data/sampling-and-collection.md#population-and-scope); [imputation](../data/cleaning-and-imputation.md#views-based-imputation). |
| §4.1.1 Non-news data | [8](../../manuscript/manuscript.pdf#page=8) | Comparison sample and collection. | [Non-news pages](../data/sampling-and-collection.md#non-news-comparison-pages). |
| §4.2 Changepoint detection | [8–9](../../manuscript/manuscript.pdf#page=8) | Rationale, preliminary predictions, normalized signals and repeated BEAST runs. | [Signals](../methods/engagement-signals-and-changepoints.md#relative-mean-and-variability-signals). |
| §4.3 Regression modeling strategy | [9](../../manuscript/manuscript.pdf#page=9) | Sampling target, latent effects and typical-day marginalization. | [Generalizability](../interpretation-and-limitations.md#scope-and-generalizability); [marginalization](../methods/marginal-means-and-contrasts.md#the-manuscripts-hybrid-target). |
| §4.3.1 Contrasts | [9–10](../../manuscript/manuscript.pdf#page=9) | Pairwise, sequential and grand-mean contrasts. | [Contrast definitions](../methods/marginal-means-and-contrasts.md#contrast-definitions). |
| §4.3.2 Specification of the models | [10](../../manuscript/manuscript.pdf#page=10) | News/joint formulas, NB1 variance, fitting, equal log-scale weighting and inference. | [Epoch models](../methods/epoch-regression-models.md#news-only-specification); [weighting](../methods/marginal-means-and-contrasts.md#equal-weighting-and-geometric-aggregation). |
| §4.4 Causal effects | [10–11](../../manuscript/manuscript.pdf#page=10) | Ratio-of-ratios estimands, modified baseline and trend tests. | [Causal comparisons](../methods/causal-comparisons.md#three-reference-period-conventions). |
| References [1]–[80] | [11–13](../../manuscript/manuscript.pdf#page=11) | Literature, methods, data and event provenance as cited by the authors. | [Role of cited sources](#role-of-cited-sources). |
| Funding; Acknowledgments; Author contributions; Competing interests; Data and materials availability | [13](../../manuscript/manuscript.pdf#page=13) | Research support, responsibilities, declarations and reported access. | [Access and declarations](../data/sampling-and-collection.md#access-ethics-and-reproducibility-statements). |

## Appendices and their subsections

| Appendix | PDF pages | Purpose | Summary section |
|---|---|---|---|
| A · Data collection | [14–15](../../manuscript/manuscript.pdf#page=14) | Outlet selection and Sotrender/Content Library collection procedures. | [Collection sequence](../data/sampling-and-collection.md#collection-sequence-and-engagement-windows). |
| A.1 · News outlet quality tiers | [15](../../manuscript/manuscript.pdf#page=15) | Aggregated ratings, percentile groups and outlet metadata. | [Quality and metadata](../data/measurement-and-quality.md#quality-ratings-and-other-metadata). |
| B · Data Descriptives | [16–18](../../manuscript/manuscript.pdf#page=16) | Per-page engagement inventory and data handling. | [News inventory](../data/sampling-and-collection.md#news-outlet-inventory); [measurement units](../data/measurement-and-quality.md#units-and-measured-quantities). |
| B.1 · Data cleaning | [17](../../manuscript/manuscript.pdf#page=17) | Duplicate resolution, exclusions and sample totals. | [Cleaning](../data/cleaning-and-imputation.md#news-deduplication-and-exclusions). |
| B.2 · Reactions as a proxy for post visibility | [18](../../manuscript/manuscript.pdf#page=18) | Correlations and views regressions. | [Proxy validation](../data/measurement-and-quality.md#validation-of-reactions-as-a-visibility-proxy). |
| B.2.1 · Imputation of missing reaction counts in Content Library data | [18](../../manuscript/manuscript.pdf#page=18) | Views/outlet/video model for missing reactions. | [Views-based imputation](../data/cleaning-and-imputation.md#views-based-imputation). |
| C · Descriptive statistics | [19–20](../../manuscript/manuscript.pdf#page=19) | Annual tier summaries, outlet variability and heavy tails. | [Descriptive distributions](../data/measurement-and-quality.md#descriptive-distributions-and-weighting). |
| D · Autoregressive linear model for estimating correlations between weekly reaction counts and post counts | [21](../../manuscript/manuscript.pdf#page=21) | Gaussian AR(1) model and correlations derived from slopes. | [Posting-frequency model](../results/alternative-explanations.md#posting-frequency-model). |
| E · Preliminary regression model for predicting reaction counts | [22](../../manuscript/manuscript.pdf#page=22) | NB2 model feeding signal construction; additional imputation statement. | [Preliminary model](../methods/engagement-signals-and-changepoints.md#preliminary-negative-binomial-model); [imputation accounts](reading-notes.md#imputation-accounts). |
| F · Changepoint detection | [23–25](../../manuscript/manuscript.pdf#page=23) | BEAST inputs, settings, run aggregation and peak selection. | [Configuration](../methods/engagement-signals-and-changepoints.md#beast-configuration); [processing](../methods/engagement-signals-and-changepoints.md#repeated-runs-and-post-processing). |
| F.1 · Events Relating to Changepoints | [24–25](../../manuscript/manuscript.pdf#page=24) | Qualitative matching of boundaries and events. | [Event association](epochs-and-policy-context.md#how-events-were-associated-with-boundaries). |
| G · Regression model with epoch effects for news posts | [26–29](../../manuscript/manuscript.pdf#page=26) | Conditional/marginal means, coefficients and news results. | [Mean definitions](../methods/marginal-means-and-contrasts.md#why-the-mean-definition-matters); [news specification](../methods/epoch-regression-models.md#news-only-specification). |
| G.1 · Model validation | [28](../../manuscript/manuscript.pdf#page=28) | Fit of outlet-epoch means and random-effect distributions. | [Validation](../methods/epoch-regression-models.md#validation-described-in-the-article). |
| G.2 · Detailed results | [29](../../manuscript/manuscript.pdf#page=29) | All epochs' news EMMs and contrasts, including tier estimates. | [Overall news table](../results/suppression-and-recovery.md#news-only-means-across-all-epochs); [focal tier means](../results/suppression-and-recovery.md#focal-quality-specific-news-only-means). |
| H · Regression model with epoch effects for news and non-news posts | [30–32](../../manuscript/manuscript.pdf#page=30) | Joint-model fit, coefficients, sector estimates and DiD results. | [Joint specification](../methods/epoch-regression-models.md#joint-news-and-non-news-specification); [joint estimates](../results/suppression-and-recovery.md#joint-model-news-and-non-news-estimates). |
| I · Total news suppression effects by sector and quality tiers | [33–34](../../manuscript/manuscript.pdf#page=33) | Focal 8/4, 11/8 and 11/4 comparisons, within groups and relative to non-news. | [Complete focal contrasts](../results/suppression-and-recovery.md#complete-focal-contrasts-from-figure-i9c). |
| J · Ruling out alternative explanations | [35](../../manuscript/manuscript.pdf#page=35) | Facebook user counts, surveys and ComScore website audiences. | [Off-platform demand](../results/alternative-explanations.md#off-platform-news-demand); [Facebook users](../results/alternative-explanations.md#facebook-user-counts). |
| K · Post Format, Link Posting, and Differential Recovery Across Outlets | [36–38](../../manuscript/manuscript.pdf#page=36) | Link use as an explanation of heterogeneous recovery. | [Format analysis](../results/post-format-and-recovery.md#question-and-proposed-mechanism). |
| K.1 · Temporal dynamics of link posting across quality tiers | [36](../../manuscript/manuscript.pdf#page=36) | Tier-level format trajectories. | [Link-share trajectories](../results/post-format-and-recovery.md#link-share-trajectories). |
| K.2 · Link posting as a predictor of outlet-level recovery | [36–37](../../manuscript/manuscript.pdf#page=36) | Outlet OLS regression, exclusions, coefficients and concurrent measurement. | [Recovery regression](../results/post-format-and-recovery.md#outlet-level-recovery-regression). |
| K.3 · Epoch-specific correlations between link posting and model residuals | [37–38](../../manuscript/manuscript.pdf#page=37) | Timing of Pearson/Spearman associations with bootstrap intervals. | [Residual correlations](../results/post-format-and-recovery.md#epoch-specific-linkresidual-correlations). |
| K.4 · Summary | [38](../../manuscript/manuscript.pdf#page=38) | Interpretation of link use and recovery; incomplete final sentence. | [Timing and main story](../results/post-format-and-recovery.md#timing-and-relation-to-the-main-story); [reading note](reading-notes.md#format-analysis-description). |
| L · Announced Algorithmic Changes | [39–46](../../manuscript/manuscript.pdf#page=39) | Timeline construction and broad catalog of 413 reported changes. | [Policy timeline](epochs-and-policy-context.md#the-broad-policy-timeline). |

## Numbered equations

Equations retain their manuscript identifiers. Additional formulas in this guide
are labeled explanatory when they expand prose or clarify an operation. In
particular, this index does not silently repair Eqs. (4) or (G.4).

| Equation | PDF page | Object defined | Summary section |
|---|---|---|---|
| (1) | [9](../../manuscript/manuscript.pdf#page=9) | Outlet-day expected reactions divided by the outlet empirical mean. | [Relative signals](../methods/engagement-signals-and-changepoints.md#relative-mean-and-variability-signals). |
| (2) | [9](../../manuscript/manuscript.pdf#page=9) | Conditional coefficient of variation. | [Relative signals](../methods/engagement-signals-and-changepoints.md#relative-mean-and-variability-signals). |
| (3) | [9](../../manuscript/manuscript.pdf#page=9) | Log conditional mean with fixed, outlet and time effects. | [Observation-level model](../methods/epoch-regression-models.md#scientific-role-and-observation-level). |
| (4) | [9](../../manuscript/manuscript.pdf#page=9) | Typical-day mean with outlet lognormal correction; inconsistent opening expectation. | [Hybrid target](../methods/marginal-means-and-contrasts.md#the-manuscripts-hybrid-target); [reading note](reading-notes.md#marginalization-equations). |
| (5) | [9](../../manuscript/manuscript.pdf#page=9) | Empirical variance across group-specific outlet effects. | [Hybrid target](../methods/marginal-means-and-contrasts.md#the-manuscripts-hybrid-target). |
| (6) | [9](../../manuscript/manuscript.pdf#page=9) | Difference of log means, equivalently response-scale mean ratio. | [Contrast definitions](../methods/marginal-means-and-contrasts.md#contrast-definitions). |
| (7) | [10](../../manuscript/manuscript.pdf#page=10) | Epoch mean relative to geometric grand mean. | [Contrast definitions](../methods/marginal-means-and-contrasts.md#contrast-definitions). |
| (8) | [10](../../manuscript/manuscript.pdf#page=10) | News-only conditional formula. | [News specification](../methods/epoch-regression-models.md#news-only-specification). |
| (9) | [10](../../manuscript/manuscript.pdf#page=10) | News-only dispersion formula. | [News specification](../methods/epoch-regression-models.md#news-only-specification). |
| (10) | [10](../../manuscript/manuscript.pdf#page=10) | Joint conditional formula. | [Joint specification](../methods/epoch-regression-models.md#joint-news-and-non-news-specification). |
| (11) | [10](../../manuscript/manuscript.pdf#page=10) | Joint dispersion formula. | [Joint specification](../methods/epoch-regression-models.md#joint-news-and-non-news-specification). |
| (12) | [10](../../manuscript/manuscript.pdf#page=10) | News contrast divided by the corresponding non-news contrast. | [Ratio of ratios](../methods/causal-comparisons.md#ratio-of-ratios). |
| (13) | [10](../../manuscript/manuscript.pdf#page=10) | Null of zero sequential log DiD effects. | [Trend assumption and tests](../methods/causal-comparisons.md#equiproportional-trends-assumption). |
| (B.1) | [18](../../manuscript/manuscript.pdf#page=18) | Linear reactions model with views, outlet, interactions and video indicator. | [Views-based imputation](../data/cleaning-and-imputation.md#views-based-imputation). |
| (D.1) | [21](../../manuscript/manuscript.pdf#page=21) | Log reactions versus log posting and quality with AR(1) dependence. | [Posting model](../results/alternative-explanations.md#posting-frequency-model). |
| (D.2) | [21](../../manuscript/manuscript.pdf#page=21) | Quality-specific Gaussian log variance. | [Posting model](../results/alternative-explanations.md#posting-frequency-model). |
| (D.3) | [21](../../manuscript/manuscript.pdf#page=21) | Correlation from group slope and log-variable variances. | [Posting model](../results/alternative-explanations.md#posting-frequency-model). |
| (E.1) | [22](../../manuscript/manuscript.pdf#page=22) | Preliminary NB2 conditional formula. | [Preliminary model](../methods/engagement-signals-and-changepoints.md#preliminary-negative-binomial-model). |
| (E.2) | [22](../../manuscript/manuscript.pdf#page=22) | Preliminary NB2 dispersion formula. | [Preliminary model](../methods/engagement-signals-and-changepoints.md#preliminary-negative-binomial-model). |
| (G.1) | [26](../../manuscript/manuscript.pdf#page=26) | Generic GLMM linear predictor. | [Mean definitions](../methods/marginal-means-and-contrasts.md#why-the-mean-definition-matters). |
| (G.2) | [26](../../manuscript/manuscript.pdf#page=26) | Multiplicative response-scale mean for the log link. | [Mean definitions](../methods/marginal-means-and-contrasts.md#why-the-mean-definition-matters). |
| (G.3) | [26](../../manuscript/manuscript.pdf#page=26) | Conditional mean with random effects set to zero. | [Mean definitions](../methods/marginal-means-and-contrasts.md#why-the-mean-definition-matters). |
| (G.4) | [26](../../manuscript/manuscript.pdf#page=26) | Lognormal random-effect factor and covariance expression. | [Mean definitions](../methods/marginal-means-and-contrasts.md#why-the-mean-definition-matters); [notation note](reading-notes.md#marginalization-equations). |

Other computational formulas with no manuscript equation number are the
negative binomial variance expressions (§4.3.2, p. 10; Appendix E, p. 22),
Appendix F's run-by-week array and smoothing rule (p. 23), and §4.4's quadratic
trend-test statistic (pp. 10–11). They are covered respectively in
[epoch models](../methods/epoch-regression-models.md#news-only-specification),
[preliminary models](../methods/engagement-signals-and-changepoints.md#preliminary-negative-binomial-model),
[probability processing](../methods/engagement-signals-and-changepoints.md#repeated-runs-and-post-processing)
and [trend tests](../methods/causal-comparisons.md#equiproportional-trends-assumption).
The OLS formula in the format summary is an explanatory expression of K.2's
prose, not a newly assigned manuscript equation number.

## Figures

| Figure | PDF page | Panels and purpose | Summary section |
|---|---|---|---|
| 1 | [3](../../manuscript/manuscript.pdf#page=3) | Weekly posting and reactions by group, four-week smoothing and event annotations. | [Main figures](../overview.md#what-each-main-figure-contributes); [temporal narrative](../results/suppression-and-recovery.md#main-temporal-narrative). |
| 2 | [4](../../manuscript/manuscript.pdf#page=4) | a: signal/boundaries/events; b: epoch means and contrasts; c: tier contrasts and omnibus tests. | [Signal output](../methods/engagement-signals-and-changepoints.md#output-and-interpretation); [news results](../results/suppression-and-recovery.md#news-only-means-across-all-epochs). |
| 3 | [5](../../manuscript/manuscript.pdf#page=5) | a: focal suppression/recovery; b: numerical within-group ratios and significance marks. | [Focal comparisons](../results/suppression-and-recovery.md#complete-focal-contrasts-from-figure-i9c); [p-value note](reading-notes.md#focal-comparison-p-values). |
| 4 | [6](../../manuscript/manuscript.pdf#page=6) | News/non-news means and contrasts against the five-epoch baseline. | [Immediate/cumulative results](../results/suppression-and-recovery.md#immediate-and-cumulative-newsnon-news-comparisons). |
| C.5 | [19](../../manuscript/manuscript.pdf#page=19) | a: outlet/year reaction distributions and CCDF; b: annual post means; c: annual outlet totals. | [Descriptive distributions](../data/measurement-and-quality.md#descriptive-distributions-and-weighting). |
| D.6 | [21](../../manuscript/manuscript.pdf#page=21) | Residual autocorrelation under independent errors versus AR(1) dependence. | [Posting model](../results/alternative-explanations.md#posting-frequency-model). |
| G.7 | [28](../../manuscript/manuscript.pdf#page=28) | News-model observed/predicted means and conditional/dispersion random effects. | [Validation](../methods/epoch-regression-models.md#validation-described-in-the-article); [threshold note](reading-notes.md#observation-thresholds). |
| H.8 | [30](../../manuscript/manuscript.pdf#page=30) | Corresponding joint-model validation. | [Validation](../methods/epoch-regression-models.md#validation-described-in-the-article). |
| I.9 | [34](../../manuscript/manuscript.pdf#page=34) | a: means; b: total/causal focal ratios; c: complete numerical table. | [Complete focal table](../results/suppression-and-recovery.md#complete-focal-contrasts-from-figure-i9c). |
| J.10 | [35](../../manuscript/manuscript.pdf#page=35) | a: observed/projected Facebook users; b: normalized audience/reaction trends; c: ComScore properties. | [Audience comparisons](../results/alternative-explanations.md#off-platform-news-demand); [user counts](../results/alternative-explanations.md#facebook-user-counts). |
| K.11 | [36](../../manuscript/manuscript.pdf#page=36) | Tier link-post proportions across epochs. | [Link trajectories](../results/post-format-and-recovery.md#link-share-trajectories). |
| K.12 | [37](../../manuscript/manuscript.pdf#page=37) | Epoch-specific Pearson/Spearman residual associations with bootstrap bands. | [Residual correlations](../results/post-format-and-recovery.md#epoch-specific-linkresidual-correlations). |

## Tables

| Table | PDF page | Contents and retention in this guide | Summary section |
|---|---|---|---|
| A.1 | [15](../../manuscript/manuscript.pdf#page=15) | 40 outlets with tier, score, followers, website traffic and medium. Complete outlet/tier/medium inventory; metadata definitions summarized. | [Outlet inventory](../data/sampling-and-collection.md#news-outlet-inventory); [metadata](../data/measurement-and-quality.md#quality-ratings-and-other-metadata). |
| B.2 | [16](../../manuscript/manuscript.pdf#page=16) | Per-page post counts and reaction/comment/share distribution summaries. All page names retained; table structure and heterogeneity summarized. | [Comparison pages](../data/sampling-and-collection.md#non-news-comparison-pages); [measures](../data/measurement-and-quality.md#units-and-measured-quantities). |
| B.3 | [18](../../manuscript/manuscript.pdf#page=18) | Two views regressions. Complete coefficients, SEs, significance and adjusted R² retained. | [Proxy validation](../data/measurement-and-quality.md#validation-of-reactions-as-a-visibility-proxy). |
| D.4 | [21](../../manuscript/manuscript.pdf#page=21) | AR(1) posting-model coefficients and random component. Structure and relevant estimates retained. | [Posting model](../results/alternative-explanations.md#posting-frequency-model). |
| E.5 | [22](../../manuscript/manuscript.pdf#page=22) | Preliminary NB2 conditional/dispersion coefficients and random effects. Structure, selected coefficients and predictive correlations summarized. | [Preliminary model](../methods/engagement-signals-and-changepoints.md#preliminary-negative-binomial-model). |
| F.6 | [23](../../manuscript/manuscript.pdf#page=23) | BEAST parameters. All printed settings retained. | [BEAST configuration](../methods/engagement-signals-and-changepoints.md#beast-configuration). |
| F.7 | [25](../../manuscript/manuscript.pdf#page=25) | Eleven changepoint groups with proximal events. Complete group calendar and event summaries retained. | [Proximal events](epochs-and-policy-context.md#proximal-events-in-table-f7). |
| G.8 | [27](../../manuscript/manuscript.pdf#page=27) | News-only epoch-model coefficients and random effects. Structure and selected estimates summarized. | [Coefficient tables](../methods/epoch-regression-models.md#coefficient-tables-and-what-they-summarize). |
| G.9 | [29](../../manuscript/manuscript.pdf#page=29) | News EMMs, epoch/grand-mean, sequential and quality contrasts. All 12 overall rows and all nine focal tier rows retained, including means, intervals and contrast tests. | [Overall results](../results/suppression-and-recovery.md#news-only-means-across-all-epochs); [focal means](../results/suppression-and-recovery.md#focal-quality-specific-news-only-means). |
| H.10 | [31](../../manuscript/manuscript.pdf#page=31) | Joint-model coefficients and random effects. Structure, selected estimates and specification ambiguity retained. | [Coefficient tables](../methods/epoch-regression-models.md#coefficient-tables-and-what-they-summarize); [reading note](reading-notes.md#joint-model-specification-and-labels). |
| H.11 | [31](../../manuscript/manuscript.pdf#page=31) | News/non-news EMMs plus baseline and sequential contrasts. All 12 epochs and both sectors retained, with reported intervals and tests. | [Joint estimates](../results/suppression-and-recovery.md#joint-model-news-and-non-news-estimates). |
| H.12 | [32](../../manuscript/manuscript.pdf#page=32) | Immediate and cumulative ratios of ratios. Every row, interval and reported test retained. | [Immediate/cumulative results](../results/suppression-and-recovery.md#immediate-and-cumulative-newsnon-news-comparisons). |
| K.13 | [37](../../manuscript/manuscript.pdf#page=37) | Outlet recovery OLS coefficients. Complete coefficient table and model fit retained. | [Recovery regression](../results/post-format-and-recovery.md#outlet-level-recovery-regression). |
| Appendix L timeline, unnumbered | [40–46](../../manuscript/manuscript.pdf#page=40) | Reported 413-entry catalog; construction, fields, coverage and role summarized without copying its rows. | [Policy timeline](epochs-and-policy-context.md#the-broad-policy-timeline). |

## Central claims and supporting evidence

| Claim or question | Primary support and PDF pages | Canonical explanation |
|---|---|---|
| What does the sample represent? | §§4.1/4.3, [8–9](../../manuscript/manuscript.pdf#page=8); A.1/B.2, [15–16](../../manuscript/manuscript.pdf#page=15). | [Population and scope](../data/sampling-and-collection.md#population-and-scope). |
| Why use reactions as visibility? | B.2/B.3, [18](../../manuscript/manuscript.pdf#page=18). | [Proxy validation](../data/measurement-and-quality.md#validation-of-reactions-as-a-visibility-proxy). |
| How do posts become 12 epochs? | Eqs. (1)–(2), [9](../../manuscript/manuscript.pdf#page=9); E–F, [22–25](../../manuscript/manuscript.pdf#page=22); G.9, [29](../../manuscript/manuscript.pdf#page=29). | [Signal construction](../methods/engagement-signals-and-changepoints.md); [calendar](epochs-and-policy-context.md#epoch-calendar). |
| Why are marginal means not simple pooled means? | Eqs. (4)–(5), [9](../../manuscript/manuscript.pdf#page=9); §4.3.2, [10](../../manuscript/manuscript.pdf#page=10); G.1–G.4, [26](../../manuscript/manuscript.pdf#page=26). | [Marginal means](../methods/marginal-means-and-contrasts.md). |
| 77% suppression, 379% rebound, 11% net change | Figures 2–3, [4–5](../../manuscript/manuscript.pdf#page=4); G.9, [29](../../manuscript/manuscript.pdf#page=29); I.9c, [34](../../manuscript/manuscript.pdf#page=34). | [Headline denominators](../results/suppression-and-recovery.md#main-temporal-narrative); [full focal table](../results/suppression-and-recovery.md#complete-focal-contrasts-from-figure-i9c). |
| 70% overall and 83% high-quality counterfactual shortfalls | §2.1, [5](../../manuscript/manuscript.pdf#page=5); Appendix I/I.9c, [33–34](../../manuscript/manuscript.pdf#page=33). | [Causal ratios](../methods/causal-comparisons.md#interpretation-of-the-reported-effects); [focal estimates](../results/suppression-and-recovery.md#complete-focal-contrasts-from-figure-i9c). |
| Cumulative versus immediate changes | Figure 4, [6](../../manuscript/manuscript.pdf#page=6); Eq. (12)/§4.4, [10–11](../../manuscript/manuscript.pdf#page=10); H.12, [32](../../manuscript/manuscript.pdf#page=32). | [Reference periods](../methods/causal-comparisons.md#three-reference-period-conventions). |
| Does the non-news comparison support causal attribution? | §4.4 and Eq. (13), [10–11](../../manuscript/manuscript.pdf#page=10). | [Trend assumption](../methods/causal-comparisons.md#equiproportional-trends-assumption); [indexing ambiguity](reading-notes.md#trend-test-indexing). |
| Are within-tier changes also between-tier differences? | Figure 2c, [4](../../manuscript/manuscript.pdf#page=4); Figure 3, [5](../../manuscript/manuscript.pdf#page=5). | [Focal tier interpretation](../results/suppression-and-recovery.md#focal-quality-specific-news-only-means). |
| Can posting, audience demand or platform use explain the trajectory? | §2.2, [6–7](../../manuscript/manuscript.pdf#page=6); D.4/D.6, [21](../../manuscript/manuscript.pdf#page=21); J.10, [35](../../manuscript/manuscript.pdf#page=35). | [Alternative explanations](../results/alternative-explanations.md). |
| How does format qualify the quality-related recovery narrative? | K.11–K.13 and K.1–K.4, [36–38](../../manuscript/manuscript.pdf#page=36). | [Format analysis](../results/post-format-and-recovery.md); [interpretive limits](../interpretation-and-limitations.md#what-the-alternative-explanations-establish-in-the-article). |
| Are broader democratic consequences measured? | §3, [7–8](../../manuscript/manuscript.pdf#page=7). | [Measured outcomes and implications](../interpretation-and-limitations.md#measured-recovery-versus-broader-implications). |

## Role of cited sources

The introduction uses platform-use estimates, earlier algorithm studies and
gatekeeping/misinformation literature to motivate the question. Reference [20]
supplies aggregated quality ratings; [21] supplies the potential-outcomes and
DiD framework; [27] supplies BEAST; [45] supplies formula notation; [46] supplies
glmmTMB; [47] supports asymptotic inference; and [67] contextualizes mixed-model
marginalization. Audience sources and the policy-announcement references support
the comparisons and timeline as described in the manuscript. These roles are
summarized from the article's citing passages; no external paper or linked
announcement was consulted to add methods or resolve gaps. Sources: §§1, 4,
[pp. 1–2](../../manuscript/manuscript.pdf#page=1),
[pp. 8–11](../../manuscript/manuscript.pdf#page=8); Appendix G,
[p. 26](../../manuscript/manuscript.pdf#page=26); Appendices J/L,
[p. 35](../../manuscript/manuscript.pdf#page=35),
[p. 39](../../manuscript/manuscript.pdf#page=39).
