# Manuscript-to-implementation coverage

[Mismatch index](README.md) | [Manuscript evidence map](../../manuscript/reference/evidence-map.md) | [Notebook map](../../analyses-and-outputs.md)

This map identifies the candidate computational home for each analytical part
of the article. **Present** means the source implements the broad analysis;
it does not certify that an existing artifact or PDF number came from that
revision. **Partial** and **missing** identify what a reproduction would still
need. The detailed records explain discrepancies and their verification limits.

## Analytical coverage

| Manuscript component | Candidate source or supplied input | Coverage and concern |
|---|---|---|
| §4.1 / Appendix A: collection and selection; Table A.1 | External raw files and [news ingestion](../../../stages/make_news.py). | Partial: metadata consumption exists; collection, ratings and earlier cleaning producers are absent. [DATA-1/3](data-and-provenance.md). |
| Appendix B.1: duplicates and attrition | [News](../../../stages/make_news.py) and [non-news](../../../stages/make_nonnews.py) stages. | Partial: downstream keys/filters exist; no complete manuscript-to-input ledger. [DATA-1](data-and-provenance.md#collection-and-cleaning-lineage). |
| Appendix B.2 / Table B.3: reactions–views validation | No matching tracked producer. | Missing; reactions/comments/shares correlations are not views validation. [DATA-3](data-and-provenance.md#proxy-validation-and-quality-score-inputs). |
| Appendix B.2.1 / Eq. (B.1): reaction imputation | Supplied `imputed-reactions.parquet`; [ingestion fallback](../../../stages/make_news.py#L78). | Consumption present; generating model/provenance missing. [DATA-2](data-and-provenance.md#two-imputation-accounts-and-an-unreachable-fallback). |
| Table B.2 and Figure C.5: descriptives | [descriptives.qmd](../../../analyses/descriptives.qmd). | Present, with outlet-total double division and output-lineage limits. [SUPPORT-2](supporting-analyses.md#average-outlet-reaction-totals). |
| Figure 1: weekly posting/reactions | [timeseries.qmd](../../../analyses/timeseries.qmd#L239). | Present; available-outlet weighting and rolling/endpoint choices matter. [Existing supporting reference](../../supporting-analyses.md#posting-and-engagement-time-series). |
| Appendix D / D.1–D.3 / D.4 / D.6: posting correlations | [timeseries.qmd](../../../analyses/timeseries.qmd#L130). | Model present; named correlation denominator differs, and ACF scope needs care. [SUPPORT-1](supporting-analyses.md#posting-reaction-correlation-denominator). |
| Appendix E / E.1–E.2 / E.5: preliminary NB2 | [glmm_reactions.R](../../../stages/glmm_reactions.R), [make_dataset.R](../../../stages/make_dataset.R), [model tables](../../../analyses/model-tables.qmd). | Present; posting predictor differs and active NB2 imputation branch is unreachable. [SIGNAL-1](signals-and-changepoints.md#preliminary-posting-frequency-predictor), [DATA-2](data-and-provenance.md#two-imputation-accounts-and-an-unreachable-fallback). |
| §4.2 / Eqs. (1)–(2): signal | [Weekly](../../../stages/make_weekly.py) and [signal](../../../stages/make_signal.py) stages. | Present; log/aggregation order differs. [SIGNAL-2](signals-and-changepoints.md#aggregation-and-log-transformation). |
| Appendix F / F.6: BEAST | [Detector](../../../stages/changepoints_detect.R), [parameters](../../../params.yaml#L95). | Broad settings agree; extra subset and explicit seeds are code details. Post-processing differences remain. |
| Appendix F: probability processing, boundaries, Figure 2a | [Post-processing](../../../stages/changepoints_postprocess.py), [plot notebook](../../../analyses/changepoints.qmd). | Present but materially different algorithm and defective calendar mapping. [SIGNAL-3/4](signals-and-changepoints.md#probability-processing-and-peak-selection). |
| Table F.7: policy/social event matching | [Selected-event workbook](../../../data/aux/events.xlsx), annotation consumers. | Partial with conflicting event identities/dates. [POLICY-1](policy-and-publication-provenance.md#event-labels-dates-and-identities). |
| Eqs. (3), (8)–(9); G.8 | [News model](../../../stages/glmm_news.R), [coefficient tables](../../../analyses/model-tables.qmd). | Broad formula and family agree; sampling threshold needs reconciliation. [MODEL-3](models-and-inference.md#outlet-epoch-inclusion-threshold). |
| Eqs. (10)–(11); H.10 | [Joint model](../../../stages/glmm_both.R), [coefficient tables](../../../analyses/model-tables.qmd). | Present; daily grouping conflicts with Eq. (10), and reference label is hardcoded incorrectly. [MODEL-1/2](models-and-inference.md#joint-model-daily-random-effects). |
| Eqs. (4)–(7), (G.1)–(G.4); Figure 2b–c; G.9 | [News inference](../../../analyses/glmm-news.qmd). | Core correction and contrast calculations present; uncertainty remains conditional. [Inference record](models-and-inference.md#inference-settings-and-unresolved-p-values). |
| Figure 4; Eq. (12); H.11–H.12 | [Joint inference](../../../analyses/glmm-both.qmd). | Baseline and ratio-of-ratios construction present; requires joint-fit provenance and valid causal assumptions. |
| Eq. (13): equiproportional-trends tests | [Parallel-trends block](../../../analyses/glmm-both.qmd#L774). | Present but uses wrong covariance and crosses onset in the pre-period slice. [INFERENCE-1](models-and-inference.md#parallel-trends-covariance-and-periods). |
| Figure 3 / Appendix I / Figure I.9; 77%, 379%, 11%, 70%, 83% | [Focal total-effects notebook](../../../analyses/glmm-total.qmd). | Correct focal epoch definitions are present; numerical export provenance and differing p-values remain unresolved. [INFERENCE-2](models-and-inference.md#inference-settings-and-unresolved-p-values). |
| G.7 / H.8: diagnostics | [News](../../../analyses/validation/glmm-news.qmd) and [joint](../../../analyses/validation/glmm-both.qmd) validation. | Mean diagnostics present; an unused variance calculation has the wrong family. [SUPPORT-4](supporting-analyses.md#validation-variance-and-its-consumers). |
| Appendix J / J.10: audiences and platform users | [ComScore stage](../../../stages/make_comscore.py), [alternatives notebook](../../../analyses/alternatives.qmd). | Present; reaction smoothing differs from the caption, filling/cohort rules need reporting. [SUPPORT-3](supporting-analyses.md#audience-comparison-transformations). |
| Appendix K / K.11–K.13: format and adjusted recovery | [Partial outlet notebook](../../../analyses/glmm-outlets.qmd). | Substantive analyses missing; interface and indexing defects also prevent execution. [FORMAT-1/2](post-format-and-recovery.md). |
| Appendix L: 413-entry timeline | PDF and 15-row selected-event workbook. | Full structured catalog/producer missing from the inspected project inventory. [POLICY-2](policy-and-publication-provenance.md#policy-catalog-and-publication-provenance). |

PDF locators for every section, numbered equation, figure and table are in the
[manuscript evidence map](../../manuscript/reference/evidence-map.md). Specific
mismatch records cite both PDF pages and controlling source lines directly.

## Agreements that should be preserved

The final processed row counts agree with the article. The news-only NB1
conditional/dispersion formulas broadly agree with Eqs. (8)–(9), and the
preliminary NB2 variance is implemented as stated. Mean normalization divides
by observed outlet averages. The typical-day/outlet-heterogeneity construction
matches the intended final expression of Eq. (4); the malformed opening
expectation is a manuscript notation issue, not evidence of a different
implemented operation. Sources:
[make_dataset.R](../../../stages/make_dataset.R#L41),
[glmm_news.R](../../../stages/glmm_news.R#L73),
[news inference](../../../analyses/glmm-news.qmd#L155),
[PDF pp. 9–10, 22, 26](../../manuscript/manuscript.pdf#page=9).

The joint cumulative baseline is the equal-weight geometric mean over epochs
0–4, while focal net change uses epoch 4 alone. Their difference is intentional.
The high-quality 11/4 within-tier change and the high-quality/non-news ratio of
ratios also have different estimands and significance. Preserve these distinctions
when comparing outputs; do not convert them into false mismatch reports.
Sources: [baseline code](../../../analyses/glmm-both.qmd#L268),
[focal code](../../../analyses/glmm-total.qmd#L197),
[PDF pp. 32–34](../../manuscript/manuscript.pdf#page=32).

## Snapshot and reproduction limits

The following **2026-09-18 local observations** were obtained without loading
whole post tables or fitting models:

| Check | Observation | What it does not establish |
|---|---|---|
| Parquet footers | News and augmented dataset: 5,728,502 rows each; non-news: 436,420; epoch keys: 6,164,797; epoch metadata: 12 rows; BEAST candidates: 37,378. | Row identity, correct eligibility, saved boundary dates or common-run provenance. |
| Raw input schemas | Imported reactions exist; explicit post-view and continuous quality-score inputs are not in the active inspected schemas. | Absence from all upstream or external author materials. |
| Selected-event workbook | 15 rows, with the event differences recorded separately. | Historical truth or causal attribution. |
| Outlet exports | Two named sector spreadsheets exist; `outlets-emm.xlsx` does not. | Freshness relative to current models or a complete Appendix K analysis. |
| Synthetic examples | Noncommuting transforms, calendar failure, wrong covariance/index mapping, double division, threshold semantics and DataFrame indexing reproduced. | Changes to study estimates, intervals or conclusions. |
| Installed R methods | glmmTMB 1.1.10 and emmeans 1.11.2.8 inspected without fitting. | The exact historical environment used for the manuscript. |

No pipeline stage, notebook render, model refit, external source check or
publication-output rebuild was performed. Existing model files were not loaded.
Documentation changes do not resolve any underlying calculation. Resolution
requires a specific verified source/input/model/output chain and appropriately
scoped numerical checks where the affected claim depends on computation.
