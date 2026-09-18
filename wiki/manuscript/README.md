# Manuscript reference guide

[Main wiki](../README.md) · [Overview](overview.md) · [Evidence map](reference/evidence-map.md)

This guide summarizes **Changes to Facebook’s algorithms decreased news
visibility, especially of high quality news, by 77%: Evidence from a decade of
platform data**, by **Szymon Talaga, Erin Wertz, Dominik Batorski and Magdalena
Wojcieszak**, dated **September 17, 2026**. Talaga and Wertz are identified as
equal contributors. Source: title page and abstract,
[PDF p. 1](../manuscript/manuscript.pdf#page=1).

## Source identity and scope

| Item | Value |
|---|---|
| Sole substantive source | [Local manuscript PDF](../manuscript/manuscript.pdf) |
| Source location | `wiki/manuscript/manuscript.pdf` (singular directory) |
| Document length | 46 PDF pages |
| SHA-256 | `cc496d740bfc83540e49b8b7697f60d0eb1da345424666382a50c4ae22673370` |
| Version date printed in manuscript | September 17, 2026 |
| Reference-set location | `wiki/manuscripts/` (plural directory) |

The fingerprint identifies the exact local bytes summarized here. The PDF remains
at its existing location and is ignored by version control; these links require
that local file to be available. Page locators refer to physical PDF pages 1–46,
which coincide with the manuscript pagination after its title page. Links include
`#page=` fragments, with visible numbers for viewers that ignore those fragments.

The 17 documents cover the article's argument, data, mathematics, statistical
models, reported computational procedures, results and interpretation. They do
not compare the article with project code, reproduce estimates, verify external
citations, or resolve manuscript ambiguities using outside evidence. Cited
literature is described only in the role assigned to it by the manuscript.

## Document map and canonical topics

| Document | Canonical content |
|---|---|
| [Overview](overview.md) | Questions, contributions, central findings, workflow and main figures. |
| [Interpretation and limitations](interpretation-and-limitations.md) | Authors' causal argument, generalizability, proxy limits and broader implications. |
| [Sampling and collection](data/sampling-and-collection.md) | Collection windows, source access, all 40 outlets and all 21 comparison pages. |
| [Measurement and quality](data/measurement-and-quality.md) | Units, quality ratings, metadata, reactions–views validation and descriptive distributions. |
| [Cleaning and imputation](data/cleaning-and-imputation.md) | Duplicates, exclusions, attrition and both reported imputation accounts. |
| [Engagement signals and changepoints](methods/engagement-signals-and-changepoints.md) | Preliminary NB2 model, transformations, BEAST parameters and probability processing. |
| [Epoch regression models](methods/epoch-regression-models.md) | News-only/joint NB1 specifications, estimation and validation. |
| [Marginal means and contrasts](methods/marginal-means-and-contrasts.md) | Typical-day target, outlet variance correction, weighting and contrast scales. |
| [Causal comparisons](methods/causal-comparisons.md) | Ratio-of-ratios estimands, baseline choices and equiproportional trends. |
| [Suppression and recovery](results/suppression-and-recovery.md) | Complete retained epoch/focal numerical tables and their interpretation. |
| [Alternative explanations](results/alternative-explanations.md) | AR(1) posting model, website audiences, Facebook users and survey context. |
| [Post-format and recovery](results/post-format-and-recovery.md) | Link trajectories, outlet recovery regression and residual correlations. |
| [Epochs and policy context](reference/epochs-and-policy-context.md) | All 12 epochs, boundary/event matches and the 413-entry timeline's role. |
| [Evidence map](reference/evidence-map.md) | Every section, appendix, numbered equation, figure and table; central-claim lookup. |
| [Glossary and notation](reference/glossary-and-notation.md) | Scientific terms, units, indices, model parameters and reused symbols. |
| [Reading notes](reference/reading-notes.md) | Visually checked textual ambiguities and internal inconsistencies. |

Detailed accounts live in their canonical pages. Other pages provide orientation
and cross-links; the evidence map points back to the underlying PDF. The reading
notes concern this manuscript version alone and are separate from the repository's
concerns register.

## Suggested reading routes

1. **Scientific orientation:** [overview](overview.md) →
   [suppression and recovery](results/suppression-and-recovery.md) →
   [alternative explanations](results/alternative-explanations.md) →
   [post-format analysis](results/post-format-and-recovery.md) →
   [interpretation](interpretation-and-limitations.md).
2. **Methods and reconstruction:** [sampling](data/sampling-and-collection.md) →
   [measurement](data/measurement-and-quality.md) →
   [cleaning](data/cleaning-and-imputation.md) →
   [signals](methods/engagement-signals-and-changepoints.md) →
   [epoch models](methods/epoch-regression-models.md) →
   [marginal means](methods/marginal-means-and-contrasts.md) →
   [causal comparisons](methods/causal-comparisons.md), with
   [reading notes](reference/reading-notes.md) alongside.
3. **Numerical interpretation:** [epoch calendar](reference/epochs-and-policy-context.md#epoch-calendar) →
   [reference-period conventions](methods/causal-comparisons.md#three-reference-period-conventions) →
   [headline comparisons](results/suppression-and-recovery.md#main-temporal-narrative) →
   [complete focal contrasts](results/suppression-and-recovery.md#complete-focal-contrasts-from-figure-i9c).
   Consult [notation](reference/glossary-and-notation.md) for local symbol meanings
   and the [evidence map](reference/evidence-map.md) for any specific display.

## Reporting conventions

- **Reported findings** reproduce the manuscript's estimates and tests, with the
  model, outcome, group, time comparison, reference quantity and scale identified.
  Tables G.9, H.11, H.12 and Figure I.9c remain distinct sources.
- **Authors' interpretations** are attributed, particularly causal claims and
  extrapolations from reactions to visibility or wider social consequences.
- **Explanatory derivations** are labeled and retain the original equation
  numbering when discussing a numbered equation. They do not silently amend the
  printed mathematics or specify an undocumented implementation choice.
- **Ambiguities** preserve the conflicting passages and what the PDF leaves
  undecidable. These are reading aids, not resolved scientific findings.
- **Precision and uncertainty** follow the cited display. Printed p = 0.000
  means rounded output, not an exactly zero probability. Missing intervals,
  covariance matrices, adjustment procedures or algorithm settings are not filled
  in from convention. Percentage interpretations do not imply extra precision.

The central distinction is between a news group's change against its own earlier
level and its change relative to non-news growth. This explains why the article
can report recovery to roughly the earlier level and a substantial remaining
counterfactual shortfall at the same time. Sources: §4.4 and Appendix I,
[pp. 10–11](../manuscript/manuscript.pdf#page=10),
[pp. 33–34](../manuscript/manuscript.pdf#page=33).
