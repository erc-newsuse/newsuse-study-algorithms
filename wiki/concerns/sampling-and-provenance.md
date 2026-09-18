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

**Classification: missing implementation and input provenance, with specific
manuscript–code discrepancies.** The September 17
[manuscript](../manuscript/README.md) now supplies sampling, rating, imputation,
collection/access and policy-source descriptions. These descriptions do not
establish how the repository's imported inputs were produced. The September 18
[data comparison](mismatches/data-and-provenance.md) distinguishes missing
collection/cleaning lineage, absent reactions–views validation and continuous
quality-score inputs, and the preliminary-model imputation path made unreachable
by an earlier missing-reaction exclusion. External imputation remains active.
See also the [full component coverage map](mismatches/coverage-map.md) and
[policy/publication provenance](mismatches/policy-and-publication-provenance.md).

**Limits:** manuscript descriptions are substantive evidence, but not executable
provenance. Matching processed row counts cannot reconcile every upstream
exclusion, prove access rights, or identify the outputs used in the PDF.
Internal manuscript ambiguities remain in its separate
[reading notes](../manuscript/reference/reading-notes.md).
**Next check and resolution:** link input dictionaries, upstream scripts and
collection records to the described procedures and reconcile the imported-data
boundary with the manuscript's raw-data boundary. Identify continuous ratings,
proxy-validation inputs, and a manuscript-to-output manifest. Resolve gaps
individually; do not reconstruct missing methodology from filenames or silently
choose between the manuscript's different imputation accounts.

## ComScore selection

**Classification: confirmed discrepancy.** Comments in
[make_comscore.py](../../stages/make_comscore.py) claim filtering to news outlets,
but the implementation does not read or join news data. It filters on start-date
coverage and performs bounded forward/backward filling, not linear
interpolation. These data feed [alternatives.qmd](../../analyses/alternatives.qmd);
see the [implemented preprocessing](../data-contracts.md#non-news-and-audience-processing).
The [manuscript comparison](mismatches/supporting-analyses.md#audience-comparison-transformations)
also finds different reaction-series smoothing from Figure J.10b's caption;
that transformation issue is distinct from outlet selection.

**Limits:** whether the supplied ComScore file already has the intended outlet
set is unknown; the source discrepancy alone does not establish an actual
sample mismatch or a changed conclusion.
**Next check and resolution:** compare normalized outlet names and intended
population definitions, and confirm filling semantics. Resolve by correcting
the source description if the supplied cohort is intentional, or separately
implementing and validating the intended selection. Check normalization and
contributor counts in the resulting audience comparison.
