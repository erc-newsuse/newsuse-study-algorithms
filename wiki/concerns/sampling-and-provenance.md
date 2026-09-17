# Sampling and provenance concerns

[Register](README.md) | [Data contracts](../data-contracts.md) | [Study design](../study-design.md)

## Metadata eligibility

**Classification: potential fragility.**
[make_news.py](../../stages/make_news.py) drops metadata rows missing any of
`name`, `quality`, `type`, `bias`, or `followers`. Grouping by quality excludes
missing group labels, and the later inner merge of outlet averages can remove
posts without matching metadata. Thus even a field absent from the model formula
can control inclusion; see [eligibility](../data-contracts.md#sample-eligibility-and-coverage).

**Limits:** the inspected metadata had no missing values in those five fields
on 2026-09-17. A synthetic missing-quality post was excluded by the grouping and
merge, but that does not establish actual current attrition or selection bias.
**Next check and resolution:** trace counts and unique keys through metadata
filtering, joins, deduplication, missing-reaction exclusion, and epoch eligibility.
Resolve by documenting the intended inclusion criteria and matching observed
attrition to them; change filtering only as a separately justified scientific
decision.

## Coverage and missingness

**Classification: methodological assumption.**
[make_weekly.py](../../stages/make_weekly.py) and
[make_signal.py](../../stages/make_signal.py) average available observations,
while [make_timeseries.py](../../stages/make_timeseries.py) inserts zeros into
internal outlet/week gaps. Consumers therefore use different panels and weights;
see [coverage](../data-contracts.md#sample-eligibility-and-coverage) and
[supporting analyses](../supporting-analyses.md).
The dense-series script's comments describe whole-period interpolation for
AR(1) use, but the implementation retains internal spans and fills engagement
with zeros; the current AR(1) notebook reads sparse weekly files instead.

**Limits:** the dated snapshot contains internal weekly gaps for 10 news and
15 non-news outlets. This does not distinguish inactivity from collection
missingness, prove gaps in the group-level series, or quantify composition effects.
**Next check and resolution:** tabulate contributors and availability by
group/week, consult collection records, and compare common-panel and available-
panel estimands where scientifically justified. Resolve the interpretation only
when zero filling and weighting are supported by the observation process;
otherwise retain the limitation and assess sensitivity in separate work.

## Upstream and manuscript evidence

**Classification: missing evidence.** The [README](../../README.md) still has
a TBA paper citation. The [raw input inventory](../data-contracts.md#inputs-and-tracking)
and ingestion source do not establish the complete sampling frame, quality-rating
procedure, upstream reaction-imputation methodology, all access/licensing terms,
policy source citations, or which exported artifacts support each manuscript
claim. A workbook annotation is evidence of a stored date, not independent
verification of the underlying policy history.

**Limits:** filenames, category labels, and local data access cannot supply these
facts. The computation can be understood without fully reconstructing the study's
provenance; scientific interpretation requires more evidence.
**Next check and resolution:** obtain methodological records, data dictionaries,
authoritative policy references, access terms, and a manuscript-to-output map.
Resolve each gap individually by linking those records and documenting their
relation to the actual inputs and analyses. Do not infer missing methodology.

## ComScore selection

**Classification: confirmed discrepancy.** Comments in
[make_comscore.py](../../stages/make_comscore.py) claim filtering to news outlets,
but the implementation does not read or join news data. It filters on start-date
coverage and performs bounded forward/backward filling, not linear
interpolation. These data feed [alternatives.qmd](../../analyses/alternatives.qmd);
see the [implemented preprocessing](../data-contracts.md#non-news-and-audience-processing).

**Limits:** whether the supplied ComScore file already has the intended outlet
set is unknown; the source discrepancy alone does not establish an actual
sample mismatch or a changed conclusion.
**Next check and resolution:** compare normalized outlet names and intended
population definitions, and confirm filling semantics. Resolve by correcting
the source description if the supplied cohort is intentional, or separately
implementing and validating the intended selection. Check normalization and
contributor counts in the resulting audience comparison.
