# Marginal means and contrasts

[Manuscript guide](../README.md) · [Models](epoch-regression-models.md) · [Numerical results](../results/suppression-and-recovery.md)

## Why the mean definition matters

The article distinguishes a typical outlet/day from an average over heterogeneous
outlets. With a log link, setting all random effects to zero and averaging over
their distribution give different response-scale means. This distinction is
central to the manuscript's “population” reaction estimates. Source: §4.3,
[p. 9](../../manuscript/manuscript.pdf#page=9); Appendix G,
[p. 26](../../manuscript/manuscript.pdf#page=26).

Appendix G starts with the generic GLMM and its log-link form:

$$
\eta(\mu_i)=\mathbf x_i^\top\boldsymbol\beta+
\mathbf z_i^\top\mathcal B,\qquad \mathcal B\sim N(\mathbf0,\Sigma).
\qquad (G.1)
$$

$$
\mu_i=\exp(\mathbf x_i^\top\boldsymbol\beta)
\exp(\mathbf z_i^\top\mathcal B).\qquad (G.2)
$$

Conditioning on the centered random effects at zero gives the “typical case”:

$$
E[\mu_i\mid\mathcal B=0]=\exp(\mathbf x_i^\top\boldsymbol\beta).
\qquad (G.3)
$$

Equation (G.4) instead integrates over the random effects. In **dimensionally
explicit explanatory notation**, writing $v_i$ for the scalar variance of
$\mathbf z_i^\top\mathcal B$, its lognormal-moment argument is:

$$
E_{\mathcal B}[\mu_i]
=\exp(\mathbf x_i^\top\boldsymbol\beta)\exp(v_i/2)
\geq \exp(\mathbf x_i^\top\boldsymbol\beta),
\qquad v_i=\mathbf z_i^\top\Sigma\mathbf z_i.
$$

This explains the intended operation in Eq. (G.4); it is not an exact
transcription of that equation's printed transposes. The display and following
sentence have [notation issues](../reference/reading-notes.md#marginalization-equations).
Source: Eqs. (G.1)–(G.4),
[p. 26](../../manuscript/manuscript.pdf#page=26).

## The manuscript's hybrid target

For the final results, the authors condition on a **typical day** by setting
daily random effects to zero, but marginalize over **outlet heterogeneity**.
They regard daily fluctuations as nuisance variation and the coexistence of
small and large outlets as a substantive property of the news ecosystem. They
also point to small estimated daily-effect variances. Sources: §4.3,
[p. 9](../../manuscript/manuscript.pdf#page=9); Appendix G,
[pp. 26–27](../../manuscript/manuscript.pdf#page=26).

The final expression in Eq. (4) is a group mean multiplied by a lognormal
heterogeneity factor, which can be written with explicit group notation as:

$$
\mu_g=\exp(\mathbf x_g^\top\boldsymbol\beta)
\exp(\sigma_g^2/2).
$$

Equation (4)'s opening line instead writes
$\log\mu_g=E_{B_g}[\mathbf x_g^\top\boldsymbol\beta+B_g]$.
Those operations are not identical for nonzero variance. Retain this difference
between the opening line and final expression; the explanatory formula above
describes the latter and Appendix G's marginalization account. Source: Eq. (4),
[p. 9](../../manuscript/manuscript.pdf#page=9); see the
[reading note](../reference/reading-notes.md#marginalization-equations).

Equation (5) estimates the variance from overall outlet effects within group $g$:

$$
\sigma_g^2\approx\frac{1}{|O(g)|-1}
\left[\sum_{o\in O(g)}b_{o,g}^2
-\frac{1}{|O(g)|}\left(\sum_{o\in O(g)}b_{o,g}\right)^2\right].
\qquad (5)
$$

$O(g)$ is the set of outlets in the group, and $b_{o,g}$ the overall random
effect for outlet $o$ in that group. This is a sample-variance expression on the
latent effect scale. The manuscript supplies no separate formula for propagating
uncertainty in this estimated correction into the reported intervals; that
specific detail remains unspecified. Source: §4.3, Eq. (5),
[p. 9](../../manuscript/manuscript.pdf#page=9).

## Equal weighting and geometric aggregation

When producing estimates coarser than quality-by-epoch groups, the authors
average the more specific linear predictors **uniformly**, ignoring sample-size
differences. Because this averaging occurs on the log scale, response-scale
estimates are geometric means. Section 4.3.2 links this choice to the lack of a
well-defined sampling population. Source: §4.3.2,
[p. 10](../../manuscript/manuscript.pdf#page=10).

For example, the following is an **explanatory expansion** of that rule for an
overall news mean in epoch $e$:

$$
\log\mu_{e,\mathrm{news}}=
\frac{\log\mu_{e,\mathrm{low}}+\log\mu_{e,\mathrm{medium}}
+\log\mu_{e,\mathrm{high}}}{3}.
$$

It is not a pooled arithmetic mean of individual posts, a total reaction count,
or a weighting by the number of outlets in each tier. This same distinction
matters when interpreting grand-mean contrast denominators. Source: §4.3.2,
[p. 10](../../manuscript/manuscript.pdf#page=10).

## Contrast definitions

Equation (6) compares two groups by subtracting their log means:

$$
\log\psi_{i,j}=\log\mu_i-\log\mu_j
\quad\Longrightarrow\quad \psi_{i,j}=\frac{\mu_i}{\mu_j}.
\qquad (6)
$$

The sequential contrast compares an epoch with its predecessor:
$\psi_i^{(s)}=\mu_i/\mu_{i-1}$, as explicitly specified in §4.4. A ratio below
one denotes a decrease in the numerator period; a ratio above one denotes an
increase. Sources: Eq. (6), [p. 9](../../manuscript/manuscript.pdf#page=9);
§§4.3.1 and 4.4, [p. 10](../../manuscript/manuscript.pdf#page=10).

Equation (7) defines an effect-coding contrast against the grand mean:

$$
\log\psi_i^{(e)}=\log\mu_i-\frac1T\sum_{t=1}^{T}\log\mu_t
\quad\Longrightarrow\quad
\psi_i^{(e)}=\frac{\mu_i}{\left(\prod_{t=1}^{T}\mu_t\right)^{1/T}}.
\qquad (7)
$$

The generic equation uses indices 1 through $T$; the article's named epochs are
0–11. These conventions must be translated explicitly when applying the
definition to a named comparison. Quality-versus-grand-mean contrasts similarly
compare a tier to the geometric mean over tiers within an epoch. Figure 2c also
reports omnibus within-epoch F tests. Sources: §4.3.1, Eq. (7),
[p. 10](../../manuscript/manuscript.pdf#page=10); Figure 2c,
[p. 4](../../manuscript/manuscript.pdf#page=4).

| Comparison | Numerator | Denominator | Main use |
|---|---|---|---|
| Sequential | Current epoch mean | Previous epoch mean | Local change between adjacent intervals. |
| Epoch effect coding | Current epoch mean | Geometric mean across all epochs | Relative position within the decade. |
| Quality effect coding | Tier mean in one epoch | Geometric mean across tiers in that epoch | Relative tier advantage. |
| Modified baseline contrast | Current epoch mean | Geometric mean over epochs 0–4 | Cumulative comparison with the pre-policy baseline. |
| Focal contrast | Mean in epoch 8 or 11 | Mean in specified epoch 4 or 8 | Suppression, recovery and net change. |

Sources: Figures 2–4, [pp. 4–6](../../manuscript/manuscript.pdf#page=4);
§§4.3.1–4.4, [p. 10](../../manuscript/manuscript.pdf#page=10);
Figure I.9, [p. 34](../../manuscript/manuscript.pdf#page=34).

## Scale, intervals and significance

Inference is conducted on the log scale and reported results are back-transformed.
Figures use 95% confidence intervals; tables label lower/upper endpoints 2.5%
and 97.5%. Contrast tables additionally report z statistics and p-values, while
Figure 2c uses omnibus F tests. Figure 3 defines † as p < .1, `*` as p < .05,
`**` as p < .01 and `***` as p < .001. The displayed sections do not identify a
general multiplicity-adjustment algorithm, so these summaries do not assign one.
Sources: §4.3.2, [p. 10](../../manuscript/manuscript.pdf#page=10);
Figures 2–3, [pp. 4–5](../../manuscript/manuscript.pdf#page=4);
Tables G.9/H.12 and Figure I.9,
[p. 29](../../manuscript/manuscript.pdf#page=29),
[p. 32](../../manuscript/manuscript.pdf#page=32),
[p. 34](../../manuscript/manuscript.pdf#page=34).

The manuscript illustrates percentage conversion directly: ratio 0.23 means a
77% decrease, and 4.79 means a 379% increase. In general the signed percentage
change is $100(\psi-1)$. A ratio near one with a large p-value means the reported
test does not establish a change; it is not proof of exact equality. Source:
Figure 3 caption, [p. 5](../../manuscript/manuscript.pdf#page=5), with this last
sentence clarifying the interpretation of the reported test.
