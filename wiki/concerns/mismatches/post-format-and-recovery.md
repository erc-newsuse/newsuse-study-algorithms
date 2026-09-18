# Post-format and recovery coverage

[Mismatch index](README.md) | [Manuscript Appendix K summary](../../manuscript/results/post-format-and-recovery.md) | [Notebook concern](../reproducibility.md#notebook-execution-and-outlet-spreadsheet)

## Missing substantive analyses

**FORMAT-1 · Missing tracked implementation for an important interpretation.**
Appendix K is the manuscript's principal qualification of the quality-related
recovery narrative. It reports three analyses:

| Reported analysis | Required inputs and calculation | What current tracked code provides |
|---|---|---|
| K.1 / Figure K.11 | Epoch-specific mean link proportions for low, medium, high and non-news. | Outlet-level news type proportions in `glmm-outlets.qmd`, and separate link columns in news/non-news spreadsheet exports; no complete four-group trajectory producer. |
| K.2 / Table K.13 | OLS of log(mean reactions in 11 / mean reactions in 4) on continuous quality, epoch-11 link share and medium; broadcast reference; The New Republic excluded; n = 36. | A focal-epoch list, outlet eligibility check and an 11/4 ratio; no matching OLS fit, continuous-score join, complete sample construction or coefficient-table export. |
| K.3 / Figure K.12 | Within-epoch Pearson/Spearman correlations between link share and log observed-minus-expected outlet means, with bootstrap intervals. | No corresponding residual construction, epoch correlation loop, bootstrap or figure producer. |

Manuscript sources: [pp. 36–38](../../manuscript/manuscript.pdf#page=36).
Code sources: [glmm-outlets.qmd](../../../analyses/glmm-outlets.qmd#L28),
[news outlet export](../../../analyses/glmm-news.qmd#L176),
[non-news outlet export](../../../analyses/glmm-both.qmd#L171).
The negative finding is based on the complete tracked Python/R/Quarto inventory
and inspection of the relevant code; it is not a claim that the authors never
performed the analyses elsewhere.

The gap matters because K.13 reports a non-significant quality coefficient
(p = .131) after adjustment for link share and medium, whereas link share is
significant (p < .001). This supports the article's proposed explanation of
unequal recovery through posting strategy. Reproducing only the main GLMM
contrasts cannot validate that adjusted association or its 36-outlet sample.
The paper's concurrent-measurement caveat must also survive any reconstruction.
Source: [K.2/Table K.13, p. 37](../../manuscript/manuscript.pdf#page=37).

The available `outlets-emm-news.xlsx` schema in the 2026-09-18 snapshot is
`quality, name, epoch, n, reactions, mu_epoch, link`; it has 468 rows and 40
outlet names. The non-news export has 233 rows and 21 names, with an additional
`sector` column. Their `reactions` field is the **observed** mean from
`obs`, despite “emm” in the filenames. The code generating them establishes
that meaning; the filenames do not make them estimated marginal means.
Neither schema supplies continuous quality or primary medium.

Likewise, exported `mu_epoch` is an outlet-epoch random effect. The manuscript's
K.3 residual is a log deviation of an observed outlet mean from an expected
quality/epoch mean. Those quantities should not be equated without a derivation.
The missing analysis has not been reconstructed by assuming that column is its
intended residual.

**Minimal resolution.** Obtain the actual K.1–K.3 code and its input versions,
or implement those analyses as separately authorized work after specifying the
sample, weighting, continuous-score source, residual target and bootstrap
procedure. Reconcile the 40-outlet study sample, eligible focal-epoch sample,
The New Republic exclusion and n = 36. Check every K.13 coefficient, fit
statistic and reported K.3 interval against a provenance-linked export.
Recover the original procedure before treating a newly chosen bootstrap or
residual definition as a faithful reproduction.

## Spreadsheet contract and indexing

**FORMAT-2 · Confirmed missing interface and reproducible execution defect.**
[glmm-outlets.qmd:52](../../../analyses/glmm-outlets.qmd#L51) reads
`data/proc/outlets-emm.xlsx`. The tracked producers write
`outlets-emm-news.xlsx` and `outlets-emm-non-news.xlsx`, respectively, at
[news:197](../../../analyses/glmm-news.qmd#L189) and
[joint:202](../../../analyses/glmm-both.qmd#L190). No producer for the requested
filename was found. That file was also absent locally on 2026-09-18, while
both named sector exports were present. Thus the current local notebook cannot
pass that read as written; a different checkout might contain an untracked file,
which would still need provenance.

There is a second, independent failure in the
[final notebook block](../../../analyses/glmm-outlets.qmd#L89). After merging
type proportions, it groups a **DataFrame** and evaluates:

```python
lambda s: pd.Series([s[8] / s[4], s[11] / s[4], s[11] / s[8]])
```

Epochs are index levels; the remaining columns have names such as `reactions`
and `link`. `s[8]` selects a column labeled 8, not epoch 8. A synthetic frame
with epochs 4, 8 and 11 and those named columns raises **`KeyError: 8`** through
the same grouping expression. The earlier 11/4 expression groups a Series, so
its superficially similar indexing is not evidence that this DataFrame block
works. The earlier unconditional drops of `music`, `reshare` and `status` also
depend on those columns being present.

The notebook plots The New Republic but contains no explicit step removing it
from the stated recovery regression; indeed no such regression follows. Its
eligibility check requires all three focal epochs, but whether that rule
explains the paper's complete sample attrition remains unverified.

**Minimal resolution.** Establish a named producer-consumer contract and select
the intended value columns and epoch rows explicitly. Test the operation on an
outlet with all focal epochs and one lacking an epoch. Fixing the filename or
indexing alone does not supply the missing OLS and bootstrap analyses or resolve
the manuscript comparison. This extends the existing
[spreadsheet concern](../reproducibility.md#notebook-execution-and-outlet-spreadsheet).
