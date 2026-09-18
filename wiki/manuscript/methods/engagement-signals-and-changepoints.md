# Engagement signals and changepoints

[Manuscript guide](../README.md) · [Epoch calendar](../reference/epochs-and-policy-context.md) · [Final models](epoch-regression-models.md)

## Purpose and inputs

The authors detect changes in news-reaction dynamics before estimating differences
between the resulting periods. They explain that selecting interventions directly
from more than 400 announcements would be difficult: announcements may be
incomplete, rollout may be gradual, and behavioral responses may be delayed.
Instead, they identify temporal breaks from news engagement, then interpret them
against proximal events. Non-news observations supply a subsequent comparison
using those periods. Sources: §4.2,
[pp. 8–9](../../manuscript/manuscript.pdf#page=8); §2.1,
[p. 5](../../manuscript/manuscript.pdf#page=5).

Raw post counts of reactions are heavy-tailed and overdispersed, whereas the
changepoint method works with time series and Gaussian assumptions. The
manuscript therefore describes model-based, aggregated, relative signals rather
than applying BEAST directly to individual post reactions. Sources: §4.2,
[p. 8](../../manuscript/manuscript.pdf#page=8); Appendix C,
[pp. 19–20](../../manuscript/manuscript.pdf#page=19).

## Preliminary negative binomial model

Appendix E specifies the following mean and dispersion formulas in lme4-style
notation, using a negative binomial model with quadratic variance (NB2):

```text
log(mu)  ~ quality + log(n_posts) + (1|outlet)
           + (1+quality|year:month:day)                       (E.1)
log(phi) ~ quality + log(n_posts) + (1|outlet)
           + (1+quality|year:month:day)                       (E.2)
```

$$
\operatorname{Var}(Y\mid\cdot)=\mu+\frac{\mu^2}{\phi}.
$$

Here quality is the outlet tier; outlet has a random intercept; calendar-day
effects include an intercept and quality slopes. The prose describes `n_posts`
as an outlet's average number of posts over the entire studied period, but its
sentence omits the unit after “per”; a more precise rate denominator cannot be
recovered from that sentence. Fitting uses maximum likelihood and R's glmmTMB.
Source: Appendix E, Eqs. (E.1)–(E.2),
[p. 22](../../manuscript/manuscript.pdf#page=22).

Table E.5 reports separate conditional and dispersion coefficients, outlet
standard deviations, and daily random-effect summaries. For orientation, the
conditional intercept is 7.482 (SE 0.322), and the coefficient of log posting
frequency is −0.219 (SE 0.002); its dispersion counterpart is 0.049 (SE 0.001).
The low tier is labeled as the reference. Reported predictive correlations are
Spearman ρ ≈ 0.629 and Pearson r ≈ 0.621 in log–log space. The appendix also
assigns this model an imputation role, whose relation to the views-based model
remains [unclear](../reference/reading-notes.md#imputation-accounts).
Source: Table E.5 and text, [p. 22](../../manuscript/manuscript.pdf#page=22).

## Relative mean and variability signals

Section 4.2 describes predictions for each outlet-day. In Eq. (1), expected
reactions are normalized by the outlet's empirical average reactions:

$$
\widetilde\mu_{i,t}=\frac{\mu_{i,t}}{\bar x_i}. \qquad (1)
$$

Here $i$ identifies an outlet and $t$ a time, unlike the individual-post index
used in later equations. This is relative engagement against the outlet's own
full-period average, not a ratio to the pre-policy period. Equation (2) expresses
conditional dispersion through the coefficient of variation:

$$
v_{i,t}=\frac{\sigma_{i,t}}{\mu_{i,t}}. \qquad (2)
$$

Both are unitless, allowing outlets with very different engagement levels to
contribute comparably. Source: §4.2, Eqs. (1)–(2),
[p. 9](../../manuscript/manuscript.pdf#page=9).

The stated sequence is outlet-day predictions → outlet-specific weekly averages
→ overall weekly averages across outlets → log transformation of the obtained
averages. Weekly aggregation is intended to average out weekend seasonality.
Appendix F specifies equal weight for every outlet with posts in a given week
and a two-component signal of expected reactions and coefficients of variation.
The transformation wording is not fully aligned across those passages; see
[signal-processing notation](../reference/reading-notes.md#signal-processing-description).
Sources: §4.2, [p. 9](../../manuscript/manuscript.pdf#page=9);
Appendix F, [p. 23](../../manuscript/manuscript.pdf#page=23).

## BEAST configuration

The article uses the Bayesian Estimator of Abrupt change, Seasonal change and
Trend, implemented by **Rbeast 1.0.1**, through `beast123`. It states that defaults
were used except for Table F.6's settings. The trend may be piecewise constant
or linear; there is no seasonal component; a separate outlier component handles
large transient fluctuations. Source: Appendix F and Table F.6,
[p. 23](../../manuscript/manuscript.pdf#page=23).

| Option, as printed | Value | Function in the described analysis |
|---|---|---|
| `isRegularOrdered` | false | Ordering setting supplied to BEAST. |
| `whichDimIsTime` | 1 | Time dimension. |
| `deltaTime` | 1/52 | Weekly time resolution on a yearly scale. |
| `season` | none | No seasonal component. |
| `period` | none | No seasonal period supplied. |
| `hasOutlier` | true | Include outlier component. |
| `deseasonalize` | false | No preliminary deseasonalization. |
| `detrend` | false | No preliminary detrending. |
| `trendMinOrder` | 0 | Permit constant segments. |
| `trendMaxOrder` | 1 | Permit linear segments. |
| `trendMinKnotNumber` | 0 | Printed minimum knot parameter. |
| `trendMaxKnotNum` | 30 | At most 30 changepoints. |
| `trendMinSepDist` | 13 | Minimum 13-week separation within BEAST. |

This table transcribes the parameter names as published; it is a manuscript
reference, not a tested software invocation. Source: Table F.6,
[p. 23](../../manuscript/manuscript.pdf#page=23).

## Repeated runs and post-processing

Section 4.2 gives **1,000 runs**, each with a different seed according to Appendix
F. The latter describes the following sequence. Sources: §4.2,
[p. 9](../../manuscript/manuscript.pdf#page=9); Appendix F,
[pp. 23–24](../../manuscript/manuscript.pdf#page=23).

1. Run BEAST $k$ times on the input signal.
2. Extract each run's estimated changepoint posterior at weekly resolution.
3. Group probabilities in a $k\times w$ array $P$, where $p_{i,j}$ is the
   probability for run $i$ and week $j$.
4. Smooth each row using the displayed, unnumbered formula:

   $$
   \widetilde P_{i,j}=1-\prod_{u=j-l}^{j+l}(1-p_{i,u}),\qquad l=2.
   $$

   Boundary weeks use only available neighbors. The authors describe this as
   combining nearby candidate locations into a probability of at least one
   changepoint within ±2 weeks.
5. Average across runs at each week. The printed instruction calls this averaging
   columns of $P$, despite having introduced $\widetilde P$ immediately before;
   retain that [notation ambiguity](../reference/reading-notes.md#signal-processing-description).
6. Find local maxima using Python's `scipy.signal.find_peaks`. Keep peaks at
   height at least $p_{\min}=1/2$, separated by at least $2l=4$ weeks;
   when adjacent candidates violate this separation, retain the higher peak.
7. Use peak positions as changepoint point estimates.
8. Use peak widths as interval estimates of changepoint positions.

The 13-week prior separation and four-week post-processing separation belong to
different steps. The PDF does not specify the exact peak-width evaluation rule,
seed values or a nominal coverage probability for the width intervals. Do not
call those widths 95% credible intervals on the basis of this description.
Source: Appendix F, [pp. 23–24](../../manuscript/manuscript.pdf#page=23).

## Output and interpretation

The resulting 11 boundaries divide the observation period into 12 epochs, with
epoch 0 preceding the first changepoint. Figure 2a displays the relative mean
signal, boundaries and interval bounds; the final regressions analyze individual
posts grouped by epoch. A detected change concerns engagement dynamics, and its
attribution to an announcement is a subsequent qualitative interpretation.
Sources: §2, [p. 3](../../manuscript/manuscript.pdf#page=3); Figure 2a,
[p. 4](../../manuscript/manuscript.pdf#page=4); Appendix F.1,
[pp. 24–25](../../manuscript/manuscript.pdf#page=24).

The exact calendar and event associations are centralized in
[epochs and policy context](../reference/epochs-and-policy-context.md).
