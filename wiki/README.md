# Project knowledge base

This wiki explains the NEWSUSE | Algorithms research code and its computational
contracts. [AGENTS.md](../AGENTS.md) contains contributor instructions;
the [repository README](../README.md) provides the overview and quick start.

## Reading paths

| Page | Read it to understand |
|---|---|
| [Study design](study-design.md) | Research questions, comparison groups, policy context, and interpretation boundaries. |
| [Architecture](architecture.md) | Python/R responsibilities, configuration, reticulate, and the external `newsuse` library. |
| [Data contracts](data-contracts.md) | Inputs, provenance, keys, schemas, transformations, and local data snapshots. |
| [DVC pipeline](dvc-pipeline.md) | The 12 active stages, declared DAG, runtime dependencies, and tracking gaps. |
| [Statistical methods](statistical-methods.md) | Model formulas, derived signals, changepoints, epochs, and inferential contrasts. |
| [Supporting analyses](supporting-analyses.md) | Descriptive denominators, Gaussian/AR(1) models, normalized audience comparisons, and their plotting conventions. |
| [Analyses and outputs](analyses-and-outputs.md) | Every Quarto notebook, its prerequisites, and publication artifacts. |
| [Development and reproducibility](development-and-reproducibility.md) | Environment setup, inspection, execution, validation limits, and artifact freshness. |
| [Concerns register](concerns/README.md) | Unresolved discrepancies, assumptions, fragile interfaces, and missing evidence, with next checks and resolution criteria. |

For a first visit, read study design and architecture, then follow the pipeline.
For a data change, start with data contracts and check downstream notebooks.
For a statistical question, read methods together with the notebook computing
the estimate. For a failed command, start with the development guide.
For a questionable result, follow the reference page's concern link and verify
the evidence against source before proposing a computational change.

## Terms used here

| Term | Meaning in this repository |
|---|---|
| Post / `key` | Observation and its cross-file identifier; epoch labels are joined at this level. |
| Outlet / `name` | News outlet or non-news page; grouping also uses country and sometimes sector. |
| Quality | News metadata levels `low`, `medium`, `high`; joint models also include `non-news`. |
| Reactions | Main engagement count, sourced from raw `likes` and supplemented by news imputation. |
| Signal | Country/week summaries of preliminary-model mean and coefficient of variation. |
| Changepoint | Peak selected from aggregated BEAST changepoint probabilities. |
| Epoch | Zero-based interval induced by selected peaks, with eligible post keys attached. |
| Event | Independently maintained political or algorithmic annotation in `events.xlsx`. |
| EMM / DiD | Estimated marginal mean / difference-in-differences contrast; see methods for scales. |

## Evidence and maintenance

The initial review on **2026-09-17** covered tracked source/configuration files,
all 11 Quarto notebooks, raw-data pointers, and available local artifact metadata.
It also inspected the installed `newsuse` v2.3 configuration implementation.
Source links identify evidence behind each topic. These pages document
implemented behavior, not an independent replication of the paper's results.

Code/configuration facts, local artifact observations, and scientific
interpretations are labeled separately where the distinction matters. Snapshot
counts and epoch dates can change after reproduction. The paper citation is
still TBA in the repository; missing methodology or provenance is not supplied
by inference from a filename or comment.

Use [create-wiki](../.github/skills/create-wiki/SKILL.md) and
[update-wiki](../.github/skills/update-wiki/SKILL.md) to maintain these pages;
[agent-context-update](../.github/skills/agent-context-update/SKILL.md) keeps the
broader guidance consistent. Use [investigate](../.github/skills/investigate/SKILL.md)
for read-only diagnosis. Reference pages explain verified behavior, retaining
short caveats that link to detailed entries in `concerns/`. The register
separates confirmed discrepancies, methodological assumptions, potential
fragility, and missing evidence. It is maintained technical documentation, not
a task backlog or session log. See its [entry conventions](concerns/README.md#how-to-read-and-maintain-entries).
Updating a concern record does not authorize a computational fix, and fixing
its description does not establish that the underlying issue is resolved.
