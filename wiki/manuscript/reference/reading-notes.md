# Manuscript reading notes

[Manuscript guide](../README.md) · [Evidence map](evidence-map.md)

These notes preserve ambiguities and internal discrepancies in the September 17,
2026 PDF that matter to understanding the study. The cited displays and passages
were checked visually against the PDF. They are not comparisons with software,
independent result validations, or a list of authorized computational changes.
Each note distinguishes what is printed from what the manuscript alone leaves
undetermined. Ordinary spelling and styling problems are excluded.

## Non-news attrition

**Printed accounts.** Appendix B.1 gives 464,103 raw non-news posts, 187,283
user-to-page posts removed, additional exclusions, and 436,420 final posts.
Source: Appendix B.1, [p. 17](../../manuscript/manuscript.pdf#page=17).

**Reading consequence.** Those counts cannot all describe attrition from the
same raw total: the stated final total is greater than the raw total minus the
stated user-to-page removals. The text does not identify a second denominator,
collection version or corrected count. Preserve the three reported numbers
rather than replacing one by subtraction. The news attrition account also omits
the size of the BuzzFeed-versus-BuzzFeed-News exclusion, so it is not a complete
category-by-category ledger.

Related account: [cleaning and imputation](../data/cleaning-and-imputation.md#non-news-cleaning).

## Imputation accounts

**Printed accounts.** Appendix B.2.1 describes missing reactions in approximately
10% of Content Library cases, imputed with a linear views/outlet/video model.
Appendix E says the preliminary negative binomial model also served to impute
approximately 1.1% of missing reaction counts. Sources:
[p. 18](../../manuscript/manuscript.pdf#page=18) and
[p. 22](../../manuscript/manuscript.pdf#page=22).

**Reading consequence.** Different denominators could explain the percentages,
but the model specifications differ as well. The PDF does not specify whether
these are separate affected subsets, sequential operations, alternative methods,
or an unreconciled description. B.2.1 also combines a pooled model with outlet
interactions and prose saying imputation was performed separately within outlets.
Do not invent an execution sequence or separate-fit procedure from those phrases.

Related account: [imputation](../data/cleaning-and-imputation.md#views-based-imputation).

## Marginalization equations

**Printed accounts.** Equation (4) starts with
$\log\mu_g=E_{B_g}[\mathbf x_g^\top\beta+B_g]$, then proceeds to
$\mu_g=e^{x\beta}E[e^{B_g}]=e^{x\beta}e^{\sigma_g^2/2}$.
Source: §4.3, Eq. (4), [p. 9](../../manuscript/manuscript.pdf#page=9).

**Reading consequence.** For a centered $B_g$, expectation of the linear predictor
does not generate the variance correction; expectation after exponentiation
does. These are different mathematical operations. The final expression and
Appendix G support a response-scale marginalization interpretation, but the first
line should not be silently rewritten as though it stated that operation.

**Related notation.** Equation (G.4) prints the variance expression with transposes
on both design-vector occurrences, and the following prose describes the
lognormal expected value as the half-variance expression without the exponential.
The displayed exponential factor and Eq. (4)'s final line support the intended
lognormal-moment explanation. The guide therefore labels its dimensionally
consistent explanation separately from literal printed notation. Source:
Appendix G, Eq. (G.4) and following sentence,
[p. 26](../../manuscript/manuscript.pdf#page=26).

Related account: [marginal means](../methods/marginal-means-and-contrasts.md#the-manuscripts-hybrid-target).

## Joint-model specification and labels

**Printed accounts.** Equation (10) gives the joint model a daily random intercept
`(1|year:month:day)`. Table H.10 labels the time grouping
`quality:year:month:day`. In that table, the fixed intercept is labeled
“Intercept = low,” but a separate `low` coefficient appears alongside `medium`
and `non-news`, with no separate high-quality coefficient. Sources: §4.3.2,
[p. 10](../../manuscript/manuscript.pdf#page=10); Table H.10,
[p. 31](../../manuscript/manuscript.pdf#page=31).

**Reading consequence.** The daily grouping and reference-category description
are not consistent between the formula and coefficient table. Preserve the
formula and table labels with their own provenance; the PDF alone does not
establish which description should be amended. Do not infer a fitted design
matrix from the inconsistent labels.

Related account: [joint model](../methods/epoch-regression-models.md#joint-news-and-non-news-specification).

## Observation thresholds

**Printed accounts.** Appendix G.1's prose refers to outlet-epoch combinations
with at least 20 observations; Figure G.7's caption says combinations with fewer
than 150 observations were excluded from estimation. Figure H.8's caption uses
fewer than 20. Sources: [p. 28](../../manuscript/manuscript.pdf#page=28) and
[p. 30](../../manuscript/manuscript.pdf#page=30).

**Reading consequence.** The news-model threshold is not uniquely specified, and
the text does not explain whether a diagnostic-display filter differs from an
estimation filter. Retain both values and avoid asserting one exact inclusion
rule from these passages.

Related account: [model validation](../methods/epoch-regression-models.md#validation-described-in-the-article).

## Signal-processing description

**Printed accounts.** Section 4.2 describes averaging outlet-day values into
outlet weeks, averaging across outlets, then log-transforming the obtained
averages. Appendix F refers to log-transformed expected reactions and coefficients
of variation without an equally explicit separate transformation for each
component. In its post-processing steps, the smoothed array is denoted
$\widetilde P$, but step 5 says to average columns of $P$. Sources:
[p. 9](../../manuscript/manuscript.pdf#page=9) and
[p. 23](../../manuscript/manuscript.pdf#page=23).

**Reading consequence.** Follow the main-text sequence as a reported procedure,
but do not claim the PDF supplies an unambiguous transformation specification for
both signals or a fully consistent array notation. The smoothing operation and
its $l=2$ parameter are explicit. Its interpretation as a probability of at least
one change is the authors' interpretation; the passage does not spell out a
joint-probability assumption. Peak widths are called interval estimates without
a coverage level or precise width rule.

Related account: [signals and processing](../methods/engagement-signals-and-changepoints.md#repeated-runs-and-post-processing).

## Changepoint event matching

**Printed accounts.** Appendix F.1 describes the first changepoint as about a week
after an algorithm change, but Table F.7 dates it June 20, 2016 and the friends-
over-pages change June 29. F.1 also calls the October 2022 change “changepoint 8,”
whereas F.7 calls October 10, 2022 changepoint 7 and June 26, 2023 changepoint 8.
Sources: [pp. 24–25](../../manuscript/manuscript.pdf#page=24).

**Reading consequence.** The prose and table disagree on temporal order and an
identifier. The calendar guide transcribes the explicitly tabulated dates and
numbers and links this note; it does not alter the underlying text.

F.1 describes reviewing events within one or two months, but F.7 includes more
distant examples, including May 24 and July 19, 2022 for the October 10 boundary,
and December 5, 2025 for September 22. F.1 also describes the period beginning
at changepoint 7 as the first significant news/non-news decline, while Table
H.12 distinguishes a first significant cumulative result at epoch 6 and a first
significant immediate result at epoch 8. The prose does not clearly identify
which comparison it means. Sources: F.1/F.7,
[pp. 24–25](../../manuscript/manuscript.pdf#page=24); H.12,
[p. 32](../../manuscript/manuscript.pdf#page=32).

Related accounts: [event matching](epochs-and-policy-context.md#how-events-were-associated-with-boundaries),
[immediate and cumulative comparisons](../results/suppression-and-recovery.md#immediate-and-cumulative-newsnon-news-comparisons).

## Trend-test indexing

**Printed accounts.** Section 4.4 defines sequential contrasts using epoch $i$
versus $i-1$, then describes a vector containing five sequential log DiD
estimators indexed 0–4 and a χ²(5) test. Table H.12 has no immediate effect for
epoch 0. Section 4.4 reports χ²(5) ≈ 9.34, p ≈ .096. Sources:
[pp. 10–11](../../manuscript/manuscript.pdf#page=10) and
[p. 32](../../manuscript/manuscript.pdf#page=32).

**Reading consequence.** Epochs 0–4 contain four internal adjacent transitions.
The PDF does not clearly identify the fifth sequential contrast or reconcile
the zero-indexed vector with the table. The reported test result is retained,
but its exact contrast vector cannot be reconstructed uniquely from this account.

Related account: [causal assumptions and tests](../methods/causal-comparisons.md#equiproportional-trends-assumption).

## Focal comparison p-values

**Printed accounts.** Appendix I's prose assigns the non-news 8/4 increase of 74%
p ≈ .048, while Figure I.9c prints **0.020** for ratio 1.74. The medium-tier
8/4 decrease is assigned p ≈ .003 in the prose and **0.001** in I.9c. Figure
3b marks the latter with two stars. Sources: Figure 3,
[p. 5](../../manuscript/manuscript.pdf#page=5); Appendix I and Figure I.9c,
[pp. 33–34](../../manuscript/manuscript.pdf#page=33).

**Reading consequence.** There are conflicting p-value presentations for the
same named comparisons. The PDF does not explain a different testing adjustment
or model source for those differences. The detailed numerical reference labels
its Figure I.9c transcription explicitly and preserves the other values here;
none is certified as the corrected value.

By contrast, Table H.12's epoch-11 cumulative RR of 0.31 and I.9c's 11/4 RR of
0.30 use different baselines. That difference is **not** itself a discrepancy;
see [reference-period conventions](../methods/causal-comparisons.md#three-reference-period-conventions).

Related account: [complete focal contrasts](../results/suppression-and-recovery.md#complete-focal-contrasts-from-figure-i9c).

## Descriptive summary values

**Printed accounts.** Appendix C's prose gives average yearly outlet reaction
totals of **1,975,451 / 1,314,313 / 1,202,049** for low/medium/high tiers.
Figure C.5c's overall row gives **2,455,192 / 1,433,813 / 1,320,154** under
“Reactions (average outlet total).” The caption describes overall values as
averages over years. Source: Appendix C and Figure C.5c,
[p. 19](../../manuscript/manuscript.pdf#page=19).

**Reading consequence.** The prose and the apparent matching table summary
do not supply the same values, and no alternative weighting definition is
provided to reconcile them. Preserve source-specific values and do not merge
them into one unnamed “average.” The broad reported pattern of tier differences
can still be described without selecting a corrected total.

Related account: [descriptive measurements](../data/measurement-and-quality.md#descriptive-distributions-and-weighting).

## Format analysis description

**Sample and rank wording.** Appendix K.2 reports 36 analyzed outlets after
excluding The New Republic but does not enumerate the other eligibility losses
relative to 40. K.1 calls high quality consistently highest in link share, then
says ordering was not fully consistent, and later calls the high tier's final
position a reversal from near-parity. Those sentences should not be converted
into a precise rank-change claim. Source: Appendix K.1–K.2,
[pp. 36–37](../../manuscript/manuscript.pdf#page=36).

**Figure/prose precision.** K.3 says both epoch-0 confidence intervals narrowly
exclude zero, but the overlapping shaded bands in Figure K.12 do not make that
claim unambiguous visually: the upper band reaches or approaches the zero line.
No numerical endpoints for that epoch are supplied. Preserve the prose as a
reported claim and do not digitize exact endpoints from the picture. Source:
Appendix K.3 and Figure K.12,
[p. 37](../../manuscript/manuscript.pdf#page=37).

**Timing and ending.** K.4 calls epoch 9 onward “post-suppression,” although
epoch 9 spans September 2024–March 2025 and thus includes time before the
January 2025 reversal. Its final sentence also ends unfinished after “continues
to penalize.” Do not assign all epoch-9 observations to a post-announcement
period or supply missing concluding text. Source: Appendix K.4,
[p. 38](../../manuscript/manuscript.pdf#page=38); Table G.9,
[p. 29](../../manuscript/manuscript.pdf#page=29).

Related account: [post-format and recovery](../results/post-format-and-recovery.md).
