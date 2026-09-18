# Policy and publication provenance

[Mismatch index](README.md) | [Epoch/annotation concerns](../epochs-and-annotations.md) | [Reproducibility concerns](../reproducibility.md)

## Event labels, dates and identities

**POLICY-1 · Confirmed differences between the manuscript's event table and the
tracked annotation workbook.** Table F.7 assigns event labels used in interpreting
the detected boundaries. The workbook
[data/aux/events.xlsx](../../../data/aux/events.xlsx) contains the labels,
descriptions and dates read by plotting notebooks. The following comparison
uses the workbook inspected on 2026-09-18; no external policy history was used
to select a preferred version.

| Label | Table F.7, PDF p. 25 | Tracked workbook |
|---|---|---|
| 6a | July 2, 2021: U.S. withdrawal from Afghanistan, a social event. The August 31 news-test expansion is a separate unlabeled row. | August 31, 2021: Facebook expands news-deprioritization tests. |
| 7a | May 24, 2022: expansion of testing; a separate July 19 row reports deployment confirmation. | July 24, 2022: news deprioritization applied globally. |
| 11b | December 5, 2025: Meta AI incorporates real-time news and promotes partner organizations. | December 1, 2025: Meta integrates LLMs into recommendation algorithms. |

Source: [Table F.7, p. 25](../../manuscript/manuscript.pdf#page=25).
Labels 1a, 4a and 9a also differ in precision: F.7 describes undated campaigning,
whereas the workbook assigns election dates. That may be an intentional display
choice; it should be distinguished from the different event identities above.

[changepoints.qmd:116–145](../../../analyses/changepoints.qmd#L116) uses each
row's `Date`, `Type` and label to draw event stars. The
[time-series plot](../../../analyses/timeseries.qmd#L313) also uses event dates.
The [alternative-explanations plot](../../../analyses/alternatives.qmd#L123)
selects a subset of workbook labels, including 7a, but positions annotations
using `Timestamp` rather than `Date`. Therefore mismatched event definitions
can propagate into interpretations and figure annotations even when the saved
statistical boundaries remain unchanged.

**Limits.** This establishes disagreement between two project sources, not the
historical accuracy or causal role of either version. The manuscript has its own
F.1/F.7 numbering and date-order inconsistencies, retained in
[reading notes](../../manuscript/reference/reading-notes.md#changepoint-event-matching).
Neither those notes nor the workbook should silently override the other.

**Minimal resolution.** Define stable event identities separately from display
labels, announcement dates, implementation dates and detected boundaries.
Reconcile each changed row with the manuscript's cited announcement and record
which version each figure uses. Verify the actual coordinates and caption after
any annotation change. Correcting an event label is not evidence that its
associated changepoint was caused by that policy.

## Policy catalog and publication provenance

**POLICY-2 · Missing reproducibility evidence, rather than a requirement that
all announcements be modeled.** Appendix L describes 413 entries covering
January 1, 2016–January 16, 2026, with source links, scope and change categories.
The article uses this catalog for contextual review, not as 413 separate model
terms. Source: [PDF pp. 39–46](../../manuscript/manuscript.pdf#page=39).

The tracked input inventory supplies a **15-row selected-event workbook**, not
the complete catalog. Its columns are `Changepoint`, `timestamp`, `Lower Bound`,
`Upper Bound`, `Event`, `Description`, `Date`, and `Type`; it lacks the complete
source-link, product and geographic-scope fields described for Appendix L.
No full machine-readable catalog or tracked catalog producer was found among
the project inputs and analysis sources. It is reasonable for plots to use a
subset; what remains missing is the reproducible relation between that subset
and the full documented event inventory.

The same distinction applies to manuscript outputs. The
[DVC graph](../../../dvc.yaml) ends with processed tables and model artifacts;
Quarto notebooks separately print tables and save figure components. There is
no complete manifest connecting the PDF's displays and headline numbers to a
source revision, exact input identities, fitted-model version, notebook settings
and exported component. The manuscript's
[data-and-materials statement, p. 13](../../manuscript/manuscript.pdf#page=13)
reports external deposits, but their contents were not inspected here. A linked
deposit is not proof that the current checkout includes every analysis.

**Minimal resolution.** Preserve a structured version of the catalog, including
source references and any selection/mapping to the plotting workbook. Add a
publication manifest that records, for each display or headline contrast:

- its source section and display identifier;
- the producer or explicitly external/upstream procedure;
- input/model identities and relevant parameter revision;
- estimand, group, period, scale and inference settings;
- output identity and any assembly or manual editing step.

The [coverage map](coverage-map.md) provides the initial producer inventory but
does not certify artifact lineage. Existing
[DVC omissions](../reproducibility.md#dvc-declaration-coverage),
[seed scope](../reproducibility.md#random-seed-scope),
[environment](../reproducibility.md#optional-artifacts-and-environment) and
[synchronization concerns](../reproducibility.md#artifact-synchronization)
remain separate requirements. A clean DVC status alone cannot certify manually
rendered or undeclared publication outputs.
