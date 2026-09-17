# Epoch and annotation concerns

[Register](README.md) | [Epoch construction](../statistical-methods.md#epoch-construction) | [Notebook map](../analyses-and-outputs.md)

## Calendar conversion and weekly alignment

**Classification: potential fragility.**
[changepoints_postprocess.py](../../stages/changepoints_postprocess.py) constructs
month from fractional year × 12 and day independently from a day offset, then
joins on calendar year plus ISO week. Those two calendar systems differ near
year boundaries. The grid starts at the earliest post timestamp, which can
retain time of day. [Signal construction](../../stages/make_signal.py) and the
[BEAST detector](../../stages/changepoints_detect.R) also assume compatible,
regular time coordinates; current US-only data does not establish multi-country
correctness. See [methods](../statistical-methods.md#beast-detection-and-peak-selection).

**Limits:** no quantified date shift or downstream effect is asserted.
**Next check and resolution:** use synthetic leap-day, month-end, December/January,
and non-midnight values to trace conversion, week joins, and boundary assignment.
Check that detector spacing matches the signal grid. Resolve by specifying and
verifying a consistent calendar mapping, including its supported country/time
range, before generalizing or changing the conversion.

## Run normalization and empty detections

**Classification: potential fragility.** The
[detector](../../stages/changepoints_detect.R) emits candidate rows with a run
index; [postprocessing](../../stages/changepoints_postprocess.py) divides summed
probabilities by the maximum index present in those rows, not directly by the
configured number of runs. A run with no candidates need not leave a row; an
empty or missing final run can therefore affect the denominator. Completely
empty candidate output also needs explicit treatment.

**Limits:** no mismatch in the current candidate artifact has been established.
**Next check and resolution:** test fixtures containing a missing final run,
an empty subset, and no candidates, against the configured run count and
intended zero-probability semantics. Resolve when completed runs and absence
of detections are represented unambiguously in aggregation. See
[probability aggregation](../statistical-methods.md#beast-detection-and-peak-selection).

## Fixed epoch positions

**Classification: potential fragility.** The
[news](../../analyses/glmm-news.qmd), [joint](../../analyses/glmm-both.qmd),
[total](../../analyses/glmm-total.qmd), and [outlet](../../analyses/glmm-outlets.qmd)
notebooks use fixed epoch positions, focal intervals, or last-epoch logic.
Event selections also assume particular `(Changepoint, Event)` rows. The
[reference](../analyses-and-outputs.md#epoch-and-artifact-assumptions) records
these interfaces; newly detected boundaries need not preserve their meaning.

**Limits:** these assumptions may be intentional for the present segmentation.
**Next check and resolution:** map each positional selection to actual epoch
labels, dates, and contrast signs after any segmentation change. Resolve for a
given analysis only when its selections and event annotations match the intended
periods; retain this compatibility requirement for future segmentations.

## Annotation coordinates

**Classification: potential fragility.**
[alternatives.qmd](../../analyses/alternatives.qmd) positions selected labels
using workbook `Timestamp`, while
[timeseries.qmd](../../analyses/timeseries.qmd) and
[changepoints.qmd](../../analyses/changepoints.qmd) use `Date` for event markers.
The alternatives plot can use the final series value when the label's month
is absent and subsequently move text. Several epoch plots extend outer
intervals for display. These are distinct from changing saved epoch boundaries;
see the [figure coordinate map](../analyses-and-outputs.md#figure-coordinates).

**Limits:** this may be deliberate; it is not evidence that all labels are
misplaced or that workbook dates establish a policy's causal effect.
**Next check and resolution:** compare selected workbook rows, saved boundaries,
plot coordinates, and intended captions; verify date support and fallbacks.
Resolve by documenting intentional coordinates or separately changing labels
and captions so event dates and detected boundaries cannot be confused.
