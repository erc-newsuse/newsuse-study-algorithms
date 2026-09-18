# Glossary and notation

[Manuscript guide](../README.md) · [Evidence map](evidence-map.md)

## Scientific vocabulary and units

These definitions follow the manuscript's usage. The linked topic pages provide
the detailed arguments and source citations.

| Term | Meaning here | Source and detailed account |
|---|---|---|
| Visibility | Opportunity for a post to be seen; inferred primarily through reactions, not observed for every post. | Appendix B.2, [p. 18](../../manuscript/manuscript.pdf#page=18); [measurement](../data/measurement-and-quality.md). |
| Reactions | Main post-level engagement count. | §4.1, [p. 8](../../manuscript/manuscript.pdf#page=8). |
| Views | Post display count in the Content Library subset; distinct from Table A.1's website-traffic column. | Appendices A.1/B.2, [pp. 15–18](../../manuscript/manuscript.pdf#page=15). |
| News outlet | One of the 40 selected U.S. news organizations. | Appendix A, [pp. 14–15](../../manuscript/manuscript.pdf#page=14); [inventory](../data/sampling-and-collection.md#news-outlet-inventory). |
| Non-news page | One of 21 comparison accounts, mainly sports, retail, restaurants and entertainment. | §4.1.1/Table B.2, [p. 8](../../manuscript/manuscript.pdf#page=8), [p. 16](../../manuscript/manuscript.pdf#page=16). |
| Quality tier | Low, medium or high outlet-level group from percentile-split aggregate ratings. | Appendix A.1, [p. 15](../../manuscript/manuscript.pdf#page=15). |
| Continuous quality | Underlying 0–1 score, used in Appendix K's OLS model. | Appendix K.2, [pp. 36–37](../../manuscript/manuscript.pdf#page=36). |
| “Untrustworthy” | Narrative term commonly used for the low-quality tier, not a separately measured post-level category. | §§1–2, [pp. 1–5](../../manuscript/manuscript.pdf#page=1). |
| Primary medium | Broadcast, print or purely online outlet category. | Table A.1, [p. 15](../../manuscript/manuscript.pdf#page=15). |
| Link proportion | Share of posts classified as links within an outlet/epoch or aggregated group. | Appendix K, [pp. 36–38](../../manuscript/manuscript.pdf#page=36). |
| Signal | Aggregated model-based time series used to detect engagement changes. | §4.2, [p. 9](../../manuscript/manuscript.pdf#page=9); [signals](../methods/engagement-signals-and-changepoints.md). |
| Changepoint | Estimated boundary between intervals with different engagement dynamics. | §2/Appendix F, [p. 3](../../manuscript/manuscript.pdf#page=3), [pp. 23–24](../../manuscript/manuscript.pdf#page=23). |
| Epoch | One of 12 intervals defined by the 11 detected boundaries; numbered 0–11. | Table G.9, [p. 29](../../manuscript/manuscript.pdf#page=29); [calendar](epochs-and-policy-context.md#epoch-calendar). |
| Policy event | Announced change or contextual event associated qualitatively with a boundary. | Appendix F.1, [pp. 24–25](../../manuscript/manuscript.pdf#page=24). |
| “War on News” | Article's name for the sequence of civic/news deprioritization policies announced in February 2021 and reversed in January 2025. | §§1–2, [pp. 1–5](../../manuscript/manuscript.pdf#page=1). |
| EMM | Estimated marginal mean; the article uses typical-day conditioning plus outlet heterogeneity adjustment. | §4.3/Appendix G, [p. 9](../../manuscript/manuscript.pdf#page=9), [p. 26](../../manuscript/manuscript.pdf#page=26). |
| Effect coding | Comparison with a geometric grand mean on the response scale. | Eq. (7), [p. 10](../../manuscript/manuscript.pdf#page=10). |
| Sequential contrast | Current epoch relative to the previous epoch. | §4.4, [p. 10](../../manuscript/manuscript.pdf#page=10). |
| DiD / difference-in-differences | Difference of log changes, reported as a ratio of ratios. | Eq. (12), [p. 10](../../manuscript/manuscript.pdf#page=10); [causal comparisons](../methods/causal-comparisons.md). |
| Equiproportional trends | Equal proportional changes, equivalently parallel changes on the log scale. | §4.4, [pp. 10–11](../../manuscript/manuscript.pdf#page=10). |
| Cumulative causal effect | News/non-news comparison relative to each sector's geometric baseline over epochs 0–4. | §4.4/Table H.12, [p. 10](../../manuscript/manuscript.pdf#page=10), [p. 32](../../manuscript/manuscript.pdf#page=32). |
| Total effect | In Appendix I, a specified within-group 8/4, 11/8 or 11/4 reaction ratio. | Figure I.9c, [p. 34](../../manuscript/manuscript.pdf#page=34). |

## Mathematical symbols

The article reuses symbols between sections. Their meaning must be inferred from
the local equation, not carried unchanged from one model to another.

| Symbol | Local meaning | Source |
|---|---|---|
| $i,t$ in Eqs. (1)–(2) | Outlet and time. | [p. 9](../../manuscript/manuscript.pdf#page=9). |
| $\mu_{i,t}$ | Conditional expected reactions for an outlet-day. | Eq. (1), [p. 9](../../manuscript/manuscript.pdf#page=9). |
| $\bar x_i$ | Outlet's empirical average reactions, normalization denominator. | Eq. (1), [p. 9](../../manuscript/manuscript.pdf#page=9). |
| $\widetilde\mu_{i,t}$ | Relative mean, $\mu_{i,t}/\bar x_i$. | Eq. (1), [p. 9](../../manuscript/manuscript.pdf#page=9). |
| $\sigma_{i,t},v_{i,t}$ | Conditional reaction SD and coefficient of variation. | Eq. (2), [p. 9](../../manuscript/manuscript.pdf#page=9). |
| $i$ in Eq. (3), (B.1), (G.1) | Individual observation/post index. | [p. 9](../../manuscript/manuscript.pdf#page=9), [p. 18](../../manuscript/manuscript.pdf#page=18), [p. 26](../../manuscript/manuscript.pdf#page=26). |
| $\widehat y_i,\mu_i$ | Conditional mean of reactions; not a simulated count. | Eq. (3), [p. 9](../../manuscript/manuscript.pdf#page=9). |
| $\mathbf x_i,\boldsymbol\beta$ | Fixed-effect design vector and coefficients. | Eq. (3)/(G.1), [p. 9](../../manuscript/manuscript.pdf#page=9), [p. 26](../../manuscript/manuscript.pdf#page=26). |
| $\mathbf z_i,\mathcal B,\Sigma$ | Random-effect design vector, centered Gaussian effect vector and covariance. | Appendix G, [p. 26](../../manuscript/manuscript.pdf#page=26). |
| $\mathcal B_o,\mathcal B_t$ | Outlet and time random-effect collections. | Eq. (3), [p. 9](../../manuscript/manuscript.pdf#page=9). |
| $g,O(g),b_{o,g}$ | Group, its outlets, and an outlet's overall random effect in that group. | Eqs. (4)–(5), [p. 9](../../manuscript/manuscript.pdf#page=9). |
| $\sigma_g^2$ in Eq. (5) | Across-outlet variance of latent effects for the mean correction. | [p. 9](../../manuscript/manuscript.pdf#page=9). |
| $\phi$ in Appendix E | NB2 dispersion, with variance $\mu+\mu^2/\phi$. | [p. 22](../../manuscript/manuscript.pdf#page=22). |
| $\phi$ in §4.3.2 | NB1 dispersion, with variance $\mu(1+\phi)$. | [p. 10](../../manuscript/manuscript.pdf#page=10). |
| $\sigma^2$ in Eq. (D.2) | Gaussian error variance, modeled by quality. | [p. 21](../../manuscript/manuscript.pdf#page=21). |
| $\phi$ in Table D.4 | AR(1) correlation coefficient, reported as ≈0.983. | [p. 21](../../manuscript/manuscript.pdf#page=21). |
| $\psi_{i,j}$ | Ratio of mean reactions in group/epoch $i$ to $j$. | Eq. (6), [p. 9](../../manuscript/manuscript.pdf#page=9). |
| $\psi_i^{(s)},\psi_i^{(e)}$ | Sequential and effect-coding contrasts. | Eqs. (6)–(7)/§4.4, [pp. 9–10](../../manuscript/manuscript.pdf#page=9). |
| $T$ in Eq. (7) | Number of entries in a generic grand mean. | [p. 10](../../manuscript/manuscript.pdf#page=10). |
| $T=4$ in cumulative-baseline prose | Last index in the five epochs 0–4, not a divisor of four. | §4.4, [p. 10](../../manuscript/manuscript.pdf#page=10). |
| $\tau_i$ | News contrast divided by its non-news counterpart. | Eq. (12), [p. 10](../../manuscript/manuscript.pdf#page=10). |
| $\boldsymbol\tau,\Sigma,T$ in trend test | Vector of log DiD estimates, its covariance and the quadratic test statistic. | Eq. (13) and text, [pp. 10–11](../../manuscript/manuscript.pdf#page=10). |
| $P,p_{i,j},\widetilde P$ | Run-by-week posterior array, entries and smoothed array. Here $i$ indexes a run. | Appendix F, [p. 23](../../manuscript/manuscript.pdf#page=23). |
| $k,w,l,p_{\min}$ | BEAST runs, number of weeks, smoothing half-width and peak-height threshold. | Appendix F, [pp. 23–24](../../manuscript/manuscript.pdf#page=23). |
| $X,Y,\beta_g,V(\cdot\mid g)$ in D.3 | Posting, reactions, group log–log slope and group variance. | [p. 21](../../manuscript/manuscript.pdf#page=21). |
| $\eta$ | Link function; logarithmic for the negative binomial models. | Eq. (G.1), [p. 26](../../manuscript/manuscript.pdf#page=26). |

## Statistical and computational abbreviations

| Abbreviation | Meaning and role | Source |
|---|---|---|
| GLMM | Generalized linear mixed model; individual-post reaction modeling. | §4.3/Appendix G, [pp. 9–10](../../manuscript/manuscript.pdf#page=9), [p. 26](../../manuscript/manuscript.pdf#page=26). |
| NB1 / NB2 | Shorthand in this guide for the manuscript's linear/quadratic negative binomial variance parameterizations. | §4.3.2/Appendix E, [p. 10](../../manuscript/manuscript.pdf#page=10), [p. 22](../../manuscript/manuscript.pdf#page=22). |
| MLE | Maximum likelihood estimation. | §4.3.2, [p. 10](../../manuscript/manuscript.pdf#page=10). |
| BEAST | Bayesian Estimator of Abrupt change, Seasonal change and Trend. | Appendix F, [p. 23](../../manuscript/manuscript.pdf#page=23). |
| MCMC | Markov Chain Monte Carlo; source of BEAST run-to-run stochastic variation. | §4.2, [p. 9](../../manuscript/manuscript.pdf#page=9). |
| AR(1) | First-order autoregressive dependence in the weekly model. | Appendix D, [p. 21](../../manuscript/manuscript.pdf#page=21). |
| OLS | Ordinary least squares; outlet-level recovery regression. | Appendix K.2, [p. 36](../../manuscript/manuscript.pdf#page=36). |
| CCDF | Complementary cumulative distribution function; reaction-tail visualization. | Figure C.5, [p. 19](../../manuscript/manuscript.pdf#page=19). |
| SD / SE / CI / IQR | Standard deviation, standard error, confidence interval, interquartile range; distinct descriptive or inferential quantities. | Tables B.2/G.9/K.13, [p. 16](../../manuscript/manuscript.pdf#page=16), [p. 29](../../manuscript/manuscript.pdf#page=29), [p. 37](../../manuscript/manuscript.pdf#page=37). |
| RR | “Ratio of rates” in Table H.12; a ratio of reaction-mean ratios in this comparison. | [p. 32](../../manuscript/manuscript.pdf#page=32). |
| pp | Percentage points, used for link-share changes; distinct from percent relative change. | Appendix K.1, [p. 36](../../manuscript/manuscript.pdf#page=36). |

For exact equations and caveats, follow the topic pages and
[reading notes](reading-notes.md). This glossary does not resolve ambiguous
notation by treating similarly named quantities as interchangeable.
