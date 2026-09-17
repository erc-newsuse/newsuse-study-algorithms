# Study design and interpretation

[Wiki index](README.md) | [Methods](statistical-methods.md) | [Data](data-contracts.md)

## Research purpose

The project studies how Facebook news-feed changes coincide with changes in
engagement and posting by media organizations, and whether those changes differ
by news quality and from non-news pages. The implementation combines a long
baseline, a period described as the "War on News", and subsequent observations.
News ingestion asserts coverage from 2016-01-01 through 2025-12-16; non-news ends
on 2025-12-15. These dates describe the current data contract, not availability
of every outlet on every day.

Sources: [README](../README.md), [news ingestion](../stages/make_news.py),
[non-news ingestion](../stages/make_nonnews.py).

The central outcome is reactions per post. Comments, shares, posting volume,
post type, audience statistics, and platform-user counts support descriptive
and alternative-explanation analyses. Quality is an outlet metadata label,
with levels `low`, `medium`, and `high`; the joint model includes `non-news`
as a fourth quality category. This is not a post-level quality classifier.
Metadata also supplies ideology, media type, and followers, but their presence
does not mean they enter every fitted formula.

## How the analysis answers the questions

1. Build post-level news and non-news datasets, including the 2025 extension.
2. Fit a preliminary news model to estimate engagement mean and variability.
3. Aggregate predictions into weekly signals and detect structural changes
   with repeated Bayesian BEAST runs.
4. Assign posts to the resulting epochs and retain eligible outlet/epoch groups.
5. Fit news-only and joint news/non-news models for epoch and quality effects.
6. Use Quarto notebooks for marginal means, contrasts, diagnostics, contextual
   plots, and publication tables.

See the [pipeline](dvc-pipeline.md) for executable dependencies and
[methods](statistical-methods.md) for formulas. Changepoints are estimated from
news signals; non-news pages receive those same time boundaries for comparison.

## Policy dates and estimated boundaries

[events.xlsx](../data/aux/events.xlsx) is a Git-tracked, manually maintained
annotation table. It contains event descriptions and dates, plus changepoint
numbers, timestamps, and bounds. It is read by notebooks, not used by the active
pipeline to estimate changepoints or assign epochs.

For example, the table labels 2021-02-10 as the announcement/testing start of
news and political-content deprioritization, and 2025-01-07 as the announcement
of its end. In the reviewed local epoch metadata, nearby boundaries fall on
2021-03-01 and 2025-03-10. These are different kinds of dates: an annotation is
not a model estimate, and a nearby detected break does not establish causation.
These policy descriptions report the repository's annotations; the workbook
does not provide primary-source citations for independently verifying them.

[glmm-both.qmd](../analyses/glmm-both.qmd) and
[glmm-total.qmd](../analyses/glmm-total.qmd) set `START_WAR = 5`, `END_WAR = 10`,
and `LAST_EPOCH = 11`. Baseline comparisons use epochs 0–4; selected total-effect
comparisons use epochs 4, 8, and 11. These are code-level conventions tied to a
particular segmentation. Re-estimating epochs requires checking their meaning,
contrast weights, and alignment with the annotation workbook.

## Comparisons and causal interpretation

The joint model treats non-news pages as the comparison group. Its notebooks
compare relative changes in news engagement with relative changes in non-news
engagement. With a log link, the reported interaction contrast on the response
scale is a ratio of ratios, rather than an additive difference of counts.

A causal interpretation requires a defensible counterfactual: absent the
news-specific intervention, news and non-news engagement would have followed
appropriate equiproportional trends. Differential shocks, changing page
composition, measurement changes, and policy effects on the comparison group
can challenge that interpretation. The code labels some estimates "causal";
the label is not proof. A failure to reject a pre-period test also does not prove
the assumption. The implemented parallel-trends calculation has an unresolved
covariance-selection issue described in [methods](statistical-methods.md#interpretation-and-review-points).

[alternatives.qmd](../analyses/alternatives.qmd) compares engagement trends with
ComScore audiences and Statista Facebook user counts.
[timeseries.qmd](../analyses/timeseries.qmd) examines posting/engagement
relationships and temporal dependence. These analyses provide context; they
do not automatically eliminate all alternative explanations.

## What the repository does not establish

The paper reference remains TBA. The tracked material does not fully document
the outlet sampling frame, rating procedure behind quality labels, upstream
reaction-imputation procedure, or all data-access terms. Describe these as
provenance gaps rather than guessing from category names. The wiki does not
independently validate effect sizes or publication conclusions.
