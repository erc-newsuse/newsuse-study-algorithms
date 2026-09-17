# Concerns and verification limits

[Wiki index](../README.md) | [Agent guidance](../../AGENTS.md)

This register consolidates unresolved discrepancies, assumptions, fragile
interfaces, and missing evidence. The main wiki explains how the project works;
these pages explain what still needs verification. Inclusion is not a claim of
numerical harm or authorization to change a scientific calculation.

| Topic | Questions and affected computations |
|---|---|
| [Statistical calculations](statistical-calculations.md) | Descriptive denominators, time-series summaries, parallel-trends covariance, validation variance, supplementary contrasts. |
| [Epochs and annotations](epochs-and-annotations.md) | Calendar conversion, run normalization, fixed epoch positions, event and display coordinates. |
| [Sampling and provenance](sampling-and-provenance.md) | Inclusion, coverage, missingness, upstream methods, audience selection. |
| [Inference and interpretation](inference-and-interpretation.md) | Correction uncertainty, selected epochs, counterfactual assumptions, diagnostic interpretation. |
| [Reproducibility](reproducibility.md) | DVC declarations, notebook interfaces, seeds, optimizers, optional inputs, artifact synchronization. |

## How to read and maintain entries

Each entry states its classification, source evidence and consumers, limits of
the evidence, and a next check with resolution criteria. Classifications mean:

- **Confirmed discrepancy:** an observed mismatch between calculations,
  interfaces, or descriptions; its numerical impact can remain unknown.
- **Methodological assumption:** an implemented choice whose interpretation or
  adequacy requires scientific justification.
- **Potential fragility:** behavior depends on inputs or conditions that can
  change; it is not necessarily failing on the inspected data.
- **Missing evidence:** the available sources do not establish the needed fact.

All entries are unresolved unless explicitly supported by resolution evidence.
Source and bounded-check evidence was reviewed on **2026-09-17**. Local counts
and installed-package behavior are dated observations, not permanent contracts;
see [freshness limits](../development-and-reproducibility.md#review-snapshot-and-freshness).

Keep descriptive heading anchors stable. Reference pages retain short caveats
and links here; entries link back to their technical explanation. Update an
entry when its evidence changes. A resolution must explain what was established,
link the supporting source/check, and state any remaining limit; correcting
prose alone does not resolve a computational discrepancy. Do not invent effect
sizes, attach priorities without evidence, or turn this register into an
assignment list, session log, or implementation commitment.

Use the [wiki update skill](../../.github/skills/update-wiki/SKILL.md) when
documentation maintenance is requested. The
[investigate skill](../../.github/skills/investigate/SKILL.md) may read these
entries but only reports findings; it does not edit the register.
