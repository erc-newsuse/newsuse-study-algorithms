# Manuscript–implementation mismatches

[Concerns register](../README.md) | [Manuscript guide](../../manuscript/README.md) | [Coverage map](coverage-map.md)

This register compares the **September 17, 2026 manuscript** with the tracked
implementation at commit **`a6abe361e2a5a889d49f2188ace9b0102e4bc982`**, inspected
on **2026-09-18**. It separates confirmed differences, missing implementations,
and unresolved scientific assumptions. A mismatch does not by itself establish
which version should change or whether a published estimate changes.

The source PDF is [wiki/manuscript/manuscript.pdf](../../manuscript/manuscript.pdf),
SHA-256 `cc496d740bfc83540e49b8b7697f60d0eb1da345424666382a50c4ae22673370`.
PDF citations identify physical pages. Code links identify controlling source
lines. The manuscript-only [reading notes](../../manuscript/reference/reading-notes.md)
remain separate: they preserve internal textual conflicts without using code to
choose a corrected version.

## Findings by affected evidence

| Finding | Classification and consequence | Detailed record |
|---|---|---|
| DATA-1 · Collection, cleaning and attrition lineage | Missing upstream evidence; current ingestion is not the complete procedure described in Appendix B.1. | [Data provenance](data-and-provenance.md#collection-and-cleaning-lineage). |
| DATA-2 · Preliminary-model imputation | Confirmed execution-path mismatch: missing reactions are removed before the NB2 fallback can impute them. | [Imputation](data-and-provenance.md#two-imputation-accounts-and-an-unreachable-fallback). |
| DATA-3 · Views validation and quality construction | No tracked producer for Table B.3 or the continuous quality scores used in Appendix K. | [Missing measurements](data-and-provenance.md#proxy-validation-and-quality-score-inputs). |
| SIGNAL-1 · Posting-frequency predictor | Appendix E describes an outlet-period average; the model uses an outlet-day count. | [Preliminary predictor](signals-and-changepoints.md#preliminary-posting-frequency-predictor). |
| SIGNAL-2 · Aggregation and logarithms | Confirmed non-equivalent order of operations; CV is unlogged in code. | [Signal transformation](signals-and-changepoints.md#aggregation-and-log-transformation). |
| SIGNAL-3 · Probability processing | Averaging/smoothing order, window alignment, width and peak restrictions differ from Appendix F. | [BEAST post-processing](signals-and-changepoints.md#probability-processing-and-peak-selection). |
| SIGNAL-4 · Time coordinates | Synthetic dates demonstrate non-monotonic fractional time and a non-inverse calendar conversion. | [Calendar defect](signals-and-changepoints.md#calendar-coordinate-defect). |
| MODEL-1 · Joint daily effects | Code agrees with Table H.10's grouping, but not Eq. (10). | [Joint specification](models-and-inference.md#joint-model-daily-random-effects). |
| MODEL-2 · Coefficient reference label | Table formatter hardcodes “low”; the joint design defaults to “high.” | [Intercept label](models-and-inference.md#joint-model-reference-label). |
| MODEL-3 · Inclusion threshold | Active rule is strictly more than 20, versus manuscript descriptions using 20 and 150. | [Eligibility](models-and-inference.md#outlet-epoch-inclusion-threshold). |
| INFERENCE-1 · Parallel-trends tests | Confirmed wrong covariance object and inclusion of 4→5 in the “before” slice. | [Causal test](models-and-inference.md#parallel-trends-covariance-and-periods). |
| INFERENCE-2 · Adjustment and result provenance | Code specifies multivariate-t adjustment; the paper does not specify its families, and some printed p-values conflict. | [Inference reporting](models-and-inference.md#inference-settings-and-unresolved-p-values). |
| SUPPORT-1 · Posting–reaction correlation | Eq. (D.3)'s response-variance denominator is replaced by a dispersion-component quantity. | [Correlation](supporting-analyses.md#posting-reaction-correlation-denominator). |
| SUPPORT-2 · Average outlet reaction totals | Confirmed extra division by the number of outlets in the candidate Figure C.5c producer. | [Descriptives](supporting-analyses.md#average-outlet-reaction-totals). |
| SUPPORT-3 · Audience comparison | Reaction smoothing differs from Figure J.10's “same way” description; filling and cohort selection are underdocumented. | [Audience series](supporting-analyses.md#audience-comparison-transformations). |
| SUPPORT-4 · Validation variance | NB2-style variance is calculated for NB1 models, but does not feed the displayed mean diagnostics in current source. | [Validation](supporting-analyses.md#validation-variance-and-its-consumers). |
| FORMAT-1 · Appendix K analyses | No complete tracked producer for K.11, K.12 or K.13; the quality-adjusted recovery argument is not reproducible here. | [Appendix K coverage](post-format-and-recovery.md#missing-substantive-analyses). |
| FORMAT-2 · Outlet notebook execution | Missing spreadsheet producer and a reproduced DataFrame indexing error. | [Execution defects](post-format-and-recovery.md#spreadsheet-contract-and-indexing). |
| POLICY-1 · Event identities and dates | Workbook labels 6a, 7a and 11b differ from Table F.7. | [Event matching](policy-and-publication-provenance.md#event-labels-dates-and-identities). |
| POLICY-2 · Full timeline and publication lineage | The 15-row annotation workbook does not supply Appendix L's 413-entry catalog; no complete manuscript export manifest exists. | [Timeline and outputs](policy-and-publication-provenance.md#policy-catalog-and-publication-provenance). |

Segmentation discrepancies affect the inputs to every epoch comparison.
The parallel-trends defect directly concerns the article's stated support for
its identifying assumption. Appendix K's missing analyses concern the main
qualification of the quality-related recovery narrative. These dependencies,
rather than an inferred numerical effect size, explain why they warrant close
attention before interpreting a reproduction as faithful to the manuscript.
See the [coverage map](coverage-map.md) for consumers and areas of agreement.

## Relationship to existing concerns

The established thematic pages retain their stable anchors and general
computational concerns. These mismatch records own the comparison with the PDF;
cross-links avoid maintaining competing accounts of the same defect.

| Existing register page | Update supported by this investigation |
|---|---|
| [Statistical calculations](../statistical-calculations.md) | Strengthen covariance/indexing and correlation evidence; identify the descriptive and diagnostic manuscript consumers. |
| [Epochs and annotations](../epochs-and-annotations.md) | Upgrade the calendar issue with a concrete reproduction; connect event discrepancies and algorithm settings to the paper. |
| [Sampling and provenance](../sampling-and-provenance.md) | Replace the blanket absence-of-manuscript claim with specific unresolved upstream lineage and measurement gaps. |
| [Inference and interpretation](../inference-and-interpretation.md) | Keep correction and segmentation uncertainty as assumptions, and distinguish them from confirmed implementation mismatches. |
| [Reproducibility](../reproducibility.md) | Connect the outlet spreadsheet contract to missing Appendix K computations and incomplete publication provenance. |

The paper now supplies a sampling rationale, quality-rating source, stated
imputation methods, access statements and policy references. Their presence
resolves a **documentation-access gap**, not the provenance of the supplied
inputs or the validity of their implementation. Existing DVC dependency,
optimizer, missingness and stochastic-inference concerns remain relevant even
where there is no direct contradiction with the manuscript.

## Verification boundaries

Checks comprised source tracing, PDF passages, Parquet footer/schema inspection,
small annotation/spreadsheet reads, installed R method inspection, and synthetic
in-memory examples. No stage, model fit or notebook render was executed. The
synthetic `emmeans` example used arbitrary coefficients and identity covariance;
it establishes object and index differences, not revised study p-values.

Local footer counts match the paper's final **5,728,502 news** and **436,420
non-news** posts. That agreement does not establish post identity, cleaning
history, fitted-model freshness or export provenance. Current RDS models were
not loaded or refitted. The [coverage map](coverage-map.md#snapshot-and-reproduction-limits)
records what local observations do establish.

Every entry below provides a bounded resolution criterion. Corrections to code,
refitting, rendering, upstream reconstruction and substantive manuscript changes
remain separate work; this register does not silently designate the paper or the
code as the scientifically preferred specification.
