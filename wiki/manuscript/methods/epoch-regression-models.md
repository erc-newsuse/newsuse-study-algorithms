# Epoch regression models

[Manuscript guide](../README.md) · [Marginal means](marginal-means-and-contrasts.md) · [Causal comparisons](causal-comparisons.md)

## Scientific role and observation level

After detecting epochs, the authors return to **individual posts** and model their
reaction counts. Fixed effects represent systematic differences between quality
tiers and epochs. Random effects represent outlet heterogeneity, outlet-specific
epoch responses and daily fluctuations. This distinguishes the final count models
from the aggregated signals used to find boundaries. Source: §§2 and 4.3,
[p. 3](../../manuscript/manuscript.pdf#page=3),
[pp. 9–10](../../manuscript/manuscript.pdf#page=9).

Equation (3) expresses the generic linear predictor:

$$
\log\widehat y_i
=\mathbf x_i^\top\boldsymbol\beta
+\mathbf z_{i,o}^\top\mathcal B_o
+\mathbf z_{i,t}^\top\mathcal B_t,
\qquad \mathcal B_k\sim N(\mathbf0,\Sigma_k),\ k=o,t. \qquad (3)
$$

Here $i$ indexes a post, $\widehat y_i$ is its conditional mean, $\mathbf x_i$
and $\mathbf z_i$ are design vectors, and the two random-effect collections
represent outlets and time. The negative binomial outcome is not itself
Gaussian; the Gaussian assumption applies to latent random effects. Source:
§4.3, Eq. (3), [p. 9](../../manuscript/manuscript.pdf#page=9).

## News-only specification

The following reproduces Eqs. (8)–(9) in the manuscript's lme4-style notation:

```text
log(mu) ~ quality*epoch
          + (1|outlet) + (1|outlet:epoch)
          + (1+quality|year:month:day)                       (8)
log(phi) ~ quality*epoch
           + (1|outlet) + (1|outlet:epoch)                   (9)
```

The interaction permits epoch changes to differ across the low, medium and high
tiers. An outlet intercept captures persistent differences; an outlet-by-epoch
intercept captures deviations specific to that outlet and interval. Daily
intercepts and quality slopes allow common-day fluctuations to differ by tier.
The dispersion model also varies by quality and epoch, with outlet and
outlet-epoch random effects. Source: §4.3.2, Eqs. (8)–(9),
[p. 10](../../manuscript/manuscript.pdf#page=10).

The final model uses the **linear negative binomial parameterization (NB1)**:

$$
\operatorname{Var}(Y\mid\cdot)=\mu(1+\phi).
$$

Both mean and dispersion are expressed on log scales. Unlike the preliminary
NB2 model's $\mu+\mu^2/\phi$, larger $\phi$ here increases the conditional
variance multiplier. These are different parameterizations despite sharing
the symbol $\phi$. The model is estimated by maximum likelihood using glmmTMB
in R. Source: §4.3.2, [p. 10](../../manuscript/manuscript.pdf#page=10);
Appendix E, [p. 22](../../manuscript/manuscript.pdf#page=22).

## Joint news and non-news specification

The comparison model adds “non-news” as a fourth quality category. The manuscript
says a simpler specification supports stable estimation with the substantially
smaller non-news sample. Its displayed formulas are:

```text
log(mu) ~ quality*epoch
          + (1|outlet) + (1|outlet:epoch)
          + (1|year:month:day)                               (10)
log(phi) ~ (1|outlet) + (1|outlet:epoch)                      (11)
```

This display removes daily quality slopes and the fixed quality-by-epoch
dispersion term. It retains outlet and outlet-epoch effects in both components.
Source: §4.3.2, Eqs. (10)–(11),
[p. 10](../../manuscript/manuscript.pdf#page=10).

Table H.10 instead labels its time grouping `quality:year:month:day`, and its
reference-category label is also internally awkward. Those are differences
within the article, documented in the
[model-specification reading note](../reference/reading-notes.md#joint-model-specification-and-labels).
This summary does not choose a replacement formula. Source: Table H.10,
[p. 31](../../manuscript/manuscript.pdf#page=31).

## Coefficient tables and what they summarize

| Source | Contents | Selected reported values |
|---|---|---|
| Table G.8, news model | Conditional and dispersion fixed effects with b, SE and p; outlet and outlet-epoch SDs; daily SDs and correlations. | Conditional intercept 6.449 (SE 0.354); outlet SD 1.109; outlet-epoch SD 0.629; daily intercept SD 0.121. Dispersion outlet SD 1.146 and outlet-epoch SD 0.723. |
| Table H.10, joint model | Conditional fixed effects and random-effect summaries; dispersion random-effect SDs. | Conditional intercept 6.500 (SE 0.347); outlet SD 1.074; outlet-epoch SD 0.699; reported daily-group SD 0.115. Dispersion outlet SD 1.327 and outlet-epoch SD 0.995. |

Sources: Table G.8, [p. 27](../../manuscript/manuscript.pdf#page=27);
Table H.10, [p. 31](../../manuscript/manuscript.pdf#page=31).

These are model coefficients and latent-effect summaries, not the final
population-level reaction estimates. In particular, exponentiating the fixed
intercept alone does not reproduce the article's heterogeneity-adjusted marginal
means. See [marginal means and contrasts](marginal-means-and-contrasts.md).
Sources: §4.3, Eqs. (4)–(5),
[p. 9](../../manuscript/manuscript.pdf#page=9); Appendix G,
[p. 26](../../manuscript/manuscript.pdf#page=26).

## Validation described in the article

Appendices G.1 and H use four corresponding displays:

| Panel | Diagnostic | Authors' interpretation |
|---|---|---|
| a | Outlet-epoch observed/predicted mean differences relative to observed means. | Mostly small discrepancies indicate faithful reproduction of outlet-epoch expectations. |
| b | Observed and predicted mean reactions by tier and epoch. | Close agreement supports the mean structure. |
| c | Distributions of conditional outlet and outlet-epoch random effects. | Approximately Gaussian, centered distributions support the random components. |
| d | Corresponding dispersion random-effect distributions. | Similar distributional support for the dispersion components. |

The figures annotate average differences of approximately **0.0016** for news
and **0.0057** for the joint model. The manuscript describes these diagnostics as
evidence of good specification. They are assessments of fitted means and latent
effect distributions; the sections do not present held-out prediction as their
validation design. Sources: Figure G.7,
[p. 28](../../manuscript/manuscript.pdf#page=28); Appendix H and Figure H.8,
[p. 30](../../manuscript/manuscript.pdf#page=30).

The news validation prose refers to at least 20 observations, while its caption
describes excluding combinations with fewer than 150; the joint caption says
fewer than 20. The exact news-model inclusion threshold is therefore not
unambiguous in the manuscript. See
[observation thresholds](../reference/reading-notes.md#observation-thresholds).
Sources: [p. 28](../../manuscript/manuscript.pdf#page=28) and
[p. 30](../../manuscript/manuscript.pdf#page=30).

## From fitted models to scientific comparisons

The models supply quality-by-epoch estimates. The article conditions on a typical
day, accounts for outlet heterogeneity, and averages uniformly on the log scale
when forming coarser groups. News/non-news contrasts use the joint model;
news-only and joint estimates must remain labeled separately. Numerical results
and their source tables are collected in
[suppression and recovery](../results/suppression-and-recovery.md).
Sources: §4.3, [pp. 9–10](../../manuscript/manuscript.pdf#page=9);
Tables G.9 and H.11, [p. 29](../../manuscript/manuscript.pdf#page=29),
[p. 31](../../manuscript/manuscript.pdf#page=31).
