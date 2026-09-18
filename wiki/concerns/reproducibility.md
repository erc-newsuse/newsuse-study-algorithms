# Reproducibility concerns

[Register](README.md) | [Pipeline](../dvc-pipeline.md) | [Development guide](../development-and-reproducibility.md)

## DVC declaration coverage

**Classification: confirmed discrepancy.** The
[tracking inventory](../dvc-pipeline.md#tracking-boundaries) compares
[dvc.yaml](../../dvc.yaml) with runtime reads/writes: postprocessing has
undeclared post-table inputs, epoch metadata and a diagnostic figure are
undeclared outputs, consumed configuration is incompletely tracked, and
ingestion globs can include files outside the declared US inputs. The shared
configuration bridge and environment are also outside stage dependency coverage.
This affects targeted scheduling, invalidation, restoration, and downstream
notebook prerequisites.

**Limits:** these omissions do not prove current artifacts are stale. Historical
entries in [dvc.lock](../../dvc.lock) are not additional active stages or evidence
that their inputs remain reproducible.
**Next check and resolution:** compare all active stages' actual I/O and consumed
configuration with declarations; propose minimal dependency/output/parameter
updates separately. Resolve omissions after declarations and restoration or
invalidation checks cover the intended inputs and outputs. Do not regenerate
the lockfile or remove historical entries during documentation maintenance.

## Notebook execution and outlet spreadsheet

**Classification: confirmed discrepancy.** Quarto analyses and their outputs
are outside the DVC graph. In particular,
[glmm-news.qmd](../../analyses/glmm-news.qmd) writes `outlets-emm-news.xlsx`,
[glmm-both.qmd](../../analyses/glmm-both.qmd) writes
`outlets-emm-non-news.xlsx`, and
[glmm-outlets.qmd](../../analyses/glmm-outlets.qmd) expects `outlets-emm.xlsx`,
for which no tracked producer was found. Data-dependent `link` columns and
hardcoded outlet examples introduce further fragility when the sample changes.
See [notebook contracts](../analyses-and-outputs.md#notebook-dependencies-beyond-dvc).

The September 18 [Appendix K comparison](mismatches/post-format-and-recovery.md)
also reproduces a `KeyError: 8` in the final grouped ratio calculation: integer
indexing addresses columns although epochs are rows. No complete producer was
found for K.13's OLS regression or K.12's correlation/bootstrap analysis. Current
exports contain observed reaction means, so their EMM filenames alone do not
establish compatibility with every manuscript predictor or outcome.

**Limits:** the expected `outlets-emm.xlsx` was absent in the September 18
snapshot; other untracked or historical work may exist elsewhere. Renaming a
current export would not repair the indexing or supply the missing analyses.
Directory-wide rendering is not a verified build.
**Next check and resolution:** specify the intended producer, schema, sector
coverage, and execution order. Resolve by verifying a producer-consumer contract
and named-notebook prerequisites, including epoch metadata and sample-dependent
columns. Do not silently rename or combine spreadsheets to make the read succeed.

## Random-seed scope

**Classification: potential fragility.** The
[seed table](../statistical-methods.md#optimizers-and-random-seeds) distinguishes
BEAST seeds, notebook inference seeds, and plotting jitter. The joint and
time-series notebooks set multivariate-t inference options without an explicit
R seed. A seed in another notebook does not govern their independent sessions.

**Limits:** source inspection establishes seed placement, not numerical
variation or bit-for-bit reproducibility. Versions, numerical integration,
call order, threads, and platform can also matter.
**Next check and resolution:** trace the installed inference integration path
and compare repeated isolated summaries of the same fitted object. Resolve by
documenting tolerances and stochastic scope and, if needed, adding appropriately
placed seeds in a separate computation change. Preserve distinctions between
inference and cosmetic randomness.

## Preliminary optimizer description

**Classification: confirmed discrepancy.**
[glmm_reactions.R](../../stages/glmm_reactions.R) passes `method = "CG"` in
`optArgs` but does not set `optimizer`, despite its conjugate-gradient comment.
On 2026-09-17, constructing the control object with installed glmmTMB 1.1.10
confirmed default `nlminb`; no model was fitted. The final
[news](../../stages/glmm_news.R) and [joint](../../stages/glmm_both.R) stages
explicitly select `optim`. See [optimizer controls](../statistical-methods.md#optimizers-and-random-seeds).

**Limits:** the constructed default is evidence of current control behavior,
not proof of the environment or optimizer used for an existing RDS. Effects of
the extra control arguments, convergence, and numerical impact remain unverified.
**Next check and resolution:** inspect stored fit calls/diagnostics and installed
control handling; confirm intended optimization. Resolve by aligning descriptions
with intended actual controls and validating any separately authorized control
change through convergence and estimate comparisons.

## Optional artifacts and environment

**Classification: missing evidence.** The
[input inventory](../data-contracts.md#inputs-and-tracking) identifies local
content/classification files without current DVC pointers or active producers.
The [Makefile](../../Makefile), [environment.yaml](../../environment.yaml), and
[pyproject.toml](../../pyproject.toml) do not constitute a complete environment
lock; Quarto is not declared in those package manifests. The tracked DVC config
does not supply a shared remote or data access rights.

**Limits:** local availability does not establish fresh-checkout reproducibility,
and an executable absent from the inspected Conda bin may exist elsewhere.
**Next check and resolution:** identify required versus optional artifacts,
their producers/access instructions, and an environment/toolchain manifest.
Resolve particular gaps with reproducible provenance and a separately authorized
clean-environment check; do not install dependencies or reconstruct historical
classification workflows as an incidental documentation task.

## Artifact synchronization

**Classification: missing evidence.** The
[historical freshness record](../development-and-reproducibility.md#review-snapshot-and-freshness)
states that DVC stage/DAG inspection succeeded but status encountered an active
pipeline lock. Local row counts, epoch dates, models, workbook annotations, and
notebook exports were not certified as one synchronized run. This is not a claim
that the same process is still running.

**Limits:** neither an existing artifact nor a later clean DVC status would
alone establish agreement of all undeclared inputs and notebook outputs.
The September 18 [manuscript comparison](mismatches/coverage-map.md#snapshot-and-reproduction-limits)
checked current artifact metadata but did not load fitted models or establish
an export-to-PDF manifest. It does not supersede the historical lock observation
with a claim that current artifacts are synchronized.
**Next check and resolution:** once existing work permits inspection, match source
and parameter revisions, DVC identities, fitted-model inputs, epoch metadata,
annotations, and export provenance. Resolve for a specified snapshot with that
evidence; leave historical observations dated. Never delete a live process lock
or reset existing DVC edits to obtain a status result.
