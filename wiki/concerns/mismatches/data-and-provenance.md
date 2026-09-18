# Data and provenance mismatches

[Mismatch index](README.md) | [Sampling concerns](../sampling-and-provenance.md) | [Data contracts](../../data-contracts.md)

## Collection and cleaning lineage

**DATA-1 · Missing evidence; confirmed difference in the documented processing
boundary.** Appendix A describes hourly collection, two-week refreshes, a
50-day/outlet check and Content Library supplementation. Appendix B.1 describes
text/timestamp/source deduplication, Sotrender precedence and specific removals.
Sources: [PDF pp. 14–17](../../manuscript/manuscript.pdf#page=14), especially
[B.1, p. 17](../../manuscript/manuscript.pdf#page=17).

The active [news stage](../../../stages/make_news.py#L22) starts from already
supplied Parquet inputs. It merges imputed values on the incoming key, then
hashes `fb_post_id`, with `check` added for certain missing-ID forms, and
deduplicates the regenerated key. It does not implement the manuscript's
normalized-text/timestamp/source index or perform a Content Library collection.
The original ID-based and upstream deduplication steps could coexist; their
different descriptions do not prove that upstream cleaning never happened.
The [DVC news dependencies](../../../dvc.yaml#L17) contain the base news file,
metadata, imputation file and 2025 extension, without a producer for the earlier
collection and cleaning procedures.

The **2026-09-18 footer snapshot** further establishes that the pipeline begins
at a different data boundary: `news-us.parquet` has 5,243,302 rows,
`non-news-us.parquet` 396,580, and `2025.parquet` 574,501. These are not the
manuscript's initial totals of 5,266,854 Sotrender news posts, 646,133 Content
Library posts and 464,103 non-news posts. The supplied news schema already has
`content_library`, `missing_likes` and `check` fields. Final processed totals
match the manuscript; the stages do not provide an attrition bridge from those
earlier totals to the supplied files.

The news base applies the page-author filter at
[line 75](../../../stages/make_news.py#L74), but the
[extension append](../../../stages/make_news.py#L99) does not reapply that filter
or the base key-generation procedure. Final duplicate precedence becomes
`keep="last"`. The [non-news stage](../../../stages/make_nonnews.py#L33), in
contrast, filters authors after concatenation. Explicit event/music/unknown-type
removals and the stated BuzzFeed distinction are not implemented as the complete
B.1 sequence here. An upstream-precleaned extension could make those omissions
harmless; this inspection does not establish retained inappropriate posts.

**Consequences and limits.** Sample provenance, source precedence, imputation
coverage and changing collection rules matter to the before/after comparison.
The paper's non-news attrition arithmetic is also internally inconsistent; see
the [manuscript reading note](../../manuscript/reference/reading-notes.md#non-news-attrition).
Neither equal final counts nor a filename resolves those issues.

**Minimal resolution.** Supply the upstream collection/cleaning producer or a
versioned record-level transformation ledger connecting manuscript totals to
each DVC input. State whether the 2025 extension already satisfies the same
author, type and duplicate rules. Validate keys, source precedence and attrition
at each boundary before changing ingestion. Keep the existing
[metadata eligibility](../sampling-and-provenance.md#metadata-eligibility) and
[coverage concerns](../sampling-and-provenance.md#coverage-and-missingness).

## Two imputation accounts and an unreachable fallback

**DATA-2 · Confirmed execution-path mismatch, plus missing upstream evidence.**
Appendix B.2.1 gives a linear views/outlet/video model for approximately 10% of
Content Library cases. Appendix E says the preliminary NB2 model imputes about
1.1% of missing reactions. The PDF does not explain their relationship.
Sources: [B.2.1, p. 18](../../manuscript/manuscript.pdf#page=18),
[E, p. 22](../../manuscript/manuscript.pdf#page=22).

The actual order is:

1. [make_news.py](../../../stages/make_news.py#L33) reads externally supplied
   `reactions_combined` values from `imputed-reactions.parquet`.
2. It preserves original nonmissing reactions, then uses the imported values
   as fallback, rounds and casts them at [lines 78–87](../../../stages/make_news.py#L78).
3. It appends the extension and **drops every remaining missing reaction** at
   [line 160](../../../stages/make_news.py#L160), before saving `news.parquet`.
4. [glmm_reactions.R](../../../stages/glmm_reactions.R#L21) fits the preliminary
   model to that file; [make_dataset.R](../../../stages/make_dataset.R#L17) reads
   the same file and predicts reactions.
5. The NB2 replacement expression
   `round(if_else(is.na(reactions), reactions_mu, reactions))` exists at
   [make_dataset.R:58](../../../stages/make_dataset.R#L52), but its missing-value
   branch cannot replace any row when its input was produced by the current
   news stage.

This conclusion follows from the active
[news → GLMM → dataset dependencies](../../../dvc.yaml#L17), without fitting a
model. It does not imply that missing reactions were never imputed: imported
values are actively used, and an earlier pipeline could have behaved differently.
The imputation file's 62,559 rows in the inspected footer do not establish its
model, denominator, successful matches or uncertainty treatment.

**Minimal resolution.** Identify which model produced the supplied imputation
file and connect it to B.2.1/E. Reconcile the percentages and input versions.
If NB2 fallback remains part of the intended method, separately redesign and
validate missing-value retention through ingestion; otherwise revise the method
account and remove or clearly identify the obsolete branch in a later code
change. Validate observed-value precedence and count actual replacements by
source. A surviving fallback expression alone is not evidence of executed
imputation.

## Proxy validation and quality-score inputs

**DATA-3 · Missing tracked producers and inputs.** The paper's visibility
argument relies on reactions–views correlations and two regressions in
Table B.3. Table A.1 supplies continuous quality scores and tier assignments;
Appendix K uses the **continuous** score in its recovery regression.
Sources: [A.1, p. 15](../../manuscript/manuscript.pdf#page=15),
[B.3, p. 18](../../manuscript/manuscript.pdf#page=18),
[K.2, pp. 36–37](../../manuscript/manuscript.pdf#page=36).

The tracked stage/notebook inventory contains no producer for the views
validation, the views-based imputation fit or the aggregate quality-rating
construction. The [descriptives notebook's correlations](../../../analyses/descriptives.qmd#L449)
use reactions, comments and shares; they do **not** reproduce the views analysis.
The [metadata loader](../../../stages/make_news.py#L22) imports tier labels,
medium, bias and followers, without rating construction or a continuous score.

The local `metadata.parquet` schema contains exactly `name`, `quality`, `type`,
`bias`, `monthly_views`, and `followers`; the active metadata selection omits
`monthly_views`. Neither that field nor Table A.1's website-traffic column is
post-level Content Library views. The raw schemas inspected for news, the 2025
extension and imported reactions provide no explicit post-view count field.
These are bounded observations about the current inputs, not proof that the
authors never possessed the source measurements.

**Minimal resolution.** Preserve the manuscript explanations already available,
and obtain versioned inputs and producers for Table B.3, Eq. (B.1) and
continuous ratings. Record which posts enter validation, source date/coverage,
missingness and model formulas, then connect generated summaries to the PDF.
For Appendix K, establish an outlet-to-continuous-score table with verified
precision and provenance; do not substitute tier codes for that predictor.
See [Appendix K coverage](post-format-and-recovery.md).
