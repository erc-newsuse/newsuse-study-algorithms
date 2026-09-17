# Data contracts and provenance

[Wiki index](README.md) | [Pipeline](dvc-pipeline.md) | [Methods](statistical-methods.md)

## Inputs and tracking

Raw Facebook exports are attributed to Sotrender in the [README](../README.md).
The active pipeline consumes six raw Parquet files; a seventh DVC pointer tracks
the Statista workbook used by a notebook. The annotation workbook is stored in
Git. Large raw data and generated artifacts are generally ignored by Git.

| Input under `data/` | Required fields / role | Tracking evidence |
|---|---|---|
| `raw/news-us.parquet` | Original `key`, `fb_post_id`, `check`, `name`, date/hour, author/type, `likes`, comments, shares, individual reactions, URL. Base news export. | [DVC pointer](../data/raw/news-us.parquet.dvc) |
| `raw/non-news-us.parquet` | `key`, name, date/hour, author/type, `likes`, other engagement counts, URL. Base comparison-page export. | [DVC pointer](../data/raw/non-news-us.parquet.dvc) |
| `raw/metadata.parquet` | `name`, `quality`, `type`, `bias`, `followers` selected by ingestion; local schema also includes `monthly_views`. | [DVC pointer](../data/raw/metadata.parquet.dvc) |
| `raw/imputed-reactions.parquet` | `key`, `reactions_combined` selected by ingestion. Upstream procedure is not implemented here. | [DVC pointer](../data/raw/imputed-reactions.parquet.dvc) |
| `raw/2025.parquet` | Shared extension with `key`, name, timestamp, author/type, `likes`, engagement counts, and export-specific fields. | [DVC pointer](../data/raw/2025.parquet.dvc) |
| `raw/comscore.parquet` | Outlet `name`, monthly `date`, `comscore` audience value. | [DVC pointer](../data/raw/comscore.parquet.dvc) |
| `raw/statista-facebook-users.xlsx` | `year`, `users`, consumed by `alternatives.qmd`. | [DVC pointer](../data/raw/statista-facebook-users.xlsx.dvc) |
| `aux/events.xlsx` | `Changepoint`, `timestamp`, `Lower Bound`, `Upper Bound`, `Event`, `Description`, `Date`, `Type`. Contextual annotations. | [Git-tracked workbook](../data/aux/events.xlsx) |

`content-news-us.parquet` and `content-non-news-us.parquet` were present locally
but have no tracked `.dvc` pointers and are not active stage inputs. Their
schemas contain post keys and text/link fields. Likewise, local `text.parquet`,
`cls-political.parquet`, and `cls-negativity.parquet` are historical/auxiliary
artifacts, not outputs of the current DAG. The `ml` section of
[params.yaml](../params.yaml) and historical label stages in
[dvc.lock](../dvc.lock) do not establish a current reproducible classification
workflow. The corresponding script names are ignored by
[stages/.gitignore](../stages/.gitignore) and absent from the tracked sources.

Do not assume `dvc pull` supplies optional content files. The repository does
not document all collection, rating, imputation, or licensing details; obtaining
the files and understanding their upstream provenance are separate concerns.
See [upstream evidence](concerns/sampling-and-provenance.md#upstream-and-manuscript-evidence)
and [optional artifact availability](concerns/reproducibility.md#optional-artifacts-and-environment).

## News ingestion and identity

[make_news.py](../stages/make_news.py) reads complete rows from the selected
metadata columns, renaming `type` to `media` and `bias` to `ideology`. It reads
nonmissing imputed key/value pairs and concatenates `news-*.parquet`, deriving
country from the filename. DVC currently declares only the US base file.

The imputation join uses the **original raw `key` before key regeneration**.
The new identifier is `sotrender@` plus `joblib.hash` of the stripped
`fb_post_id`. If the ID starts with `NA_` or ends with `_NA`, the hash input is
that ID concatenated with `__` and `check`. Despite a nearby comment, this
code does not hash a `(name, timestamp, type)` tuple. Initial deduplication keeps
the first occurrence of the new key; uniqueness is checked.

The base export is filtered to configured authors (currently `page`) and
left-joined to metadata by `name`. Raw `likes` becomes `reactions`. Original
nonmissing values win over `reactions_combined`; values are rounded and cast to
nullable Arrow integers. Other reaction types, comments, and shares are not
substituted for this main outcome by the active stage.

The 2025 extension is restricted to names already present, appended with its
existing keys, and given forward-filled country, quality, media, ideology, and
followers within each name. This fill follows concatenation order before final
timestamp sorting; it is not a dated metadata lookup. The extension does not
repeat the base-export author filter or key hashing. After append, duplicate
keys keep the **last** occurrence. Do not assume the extension follows the base
ingestion path simply because they share an output.

Daily `n_posts` counts are grouped by country, quality, name, year, month, day;
`log_n_posts` is their natural log. `reactions_avg`, `comments_avg`, and
`shares_avg` are observed means grouped by country, quality, name over the
combined data. These counts/averages are computed before the final exclusion of
rows with missing reactions. The final news table asserts unique keys, integral
nonmissing reactions, and the exact current date endpoints.

## Sample eligibility and coverage

In [make_news.py](../stages/make_news.py), metadata completeness means nonmissing
`name`, `quality`, `type`, `bias`, and `followers`: `.dropna()` acts on all five
selected columns before metadata is joined to posts. Daily counts and outlet
averages group by quality, with pandas' default exclusion of missing group
labels. The average-table merge uses the default inner join, so posts without
matching quality metadata can disappear there, before the explicit final
missing-reaction filter. Even metadata fields absent from a model formula can
therefore affect inclusion. This is a source-level rule, not a measured
attrition count; see [metadata eligibility](concerns/sampling-and-provenance.md#metadata-eligibility).

Other eligibility steps remain distinct: base author filtering, extension
restriction to existing names, deduplication, missing-reaction exclusion, and
later outlet/epoch groups with strictly more than 20 posts. A complete attrition
account must follow post keys across those steps instead of subtracting unrelated
artifact row counts. The extension's separate path is described above.

The [weekly stage](../stages/make_weekly.py) records observed outlet/weeks.
Outlets need not start and end together or have all internal weeks. Signal and
notebook averages use available contributors; changes can reflect both within-
outlet values and panel composition. The [dense-series stage](../stages/make_timeseries.py)
fills internal outlet gaps with zero counts/reactions after week-index
interpolation, without extending every outlet across the full study period.
The [supporting analyses](supporting-analyses.md) identify which representation
each notebook consumes. An absent weekly observation does not itself establish
zero activity or a collection failure; see
[missingness assumptions](concerns/sampling-and-provenance.md#coverage-and-missingness).

## Non-news and audience processing

[make_nonnews.py](../stages/make_nonnews.py) delegates base-export parsing to
`newsuse.data.sotrender.read_data`, extracts country from filenames, strips and
lowercases names, and hashes the reader's key after removing `sotrender@`.
It appends extension rows for existing names, renames `likes`, and applies the
author filter to the combined data. Missing country is filled with `us`, final
duplicates keep the last key, and records are sorted. Missing news-specific
metadata columns are omitted by column filtering, not fabricated. Assertions
check keys, integral reactions, and endpoints 2016-01-01 and 2025-12-15.

[make_comscore.py](../stages/make_comscore.py) constructs an outlet/month grid
between the raw minimum and maximum dates. It retains outlets whose first
observed value is within six approximate 31-day months of 2016-01-01, then
forward-fills and backward-fills each series with a limit of six entries per
pass. This is bounded filling, not linear interpolation. The two passes can
fill more than six missing positions in total. An assertion checks that retained
nonmissing series begin on 2016-01-01. Contrary to its comments, the script never
reads the news data or filters against its outlet set.
The [selection concern](concerns/sampling-and-provenance.md#comscore-selection)
separates that source discrepancy from the unverified composition of the input.

## Processed tables

Paths are defined in [params.yaml](../params.yaml); producers and tracking are
listed in the [pipeline reference](dvc-pipeline.md). The following are essential
interfaces, not exhaustive schemas or claims that every constraint is enforced.

| Artifact under `data/proc/` | Grain / key | Important fields and meaning |
|---|---|---|
| `news.parquet` | News post / unique `key` | Outlet metadata, timestamp/calendar fields, reactions/comments/shares, daily counts, observed outlet averages. |
| `counts.parquet` | Country/quality/name/day | Daily `n_posts` computed before final missing-reaction exclusion. |
| `non-news.parquet` | Non-news post / unique `key` | Country/name/time/type/author and engagement; no inherent news quality tier. |
| `dataset.parquet` | News post / `key` | News fields plus preliminary-model `reactions_mu`, `link`, `var`, `cv`, reciprocal `disp`, and relative versions. |
| `weekly.parquet`, `weekly-non-news.parquet` | Country/name/quality/`week_t` | Monday timestamp, summed post counts, daily-then-weekly mean engagement. Model-derived fields are unavailable for non-news. |
| `signal.parquet` | Configured groups/`week_t` | Timestamp, fractional `time`, outlet-average weekly post count, logged mean signals and unlogged CV signals. |
| `beast.parquet` | Detected candidate per subset/run | `subset`, run `idx`, fractional-year `date`, `prob`; multiple candidates per run. |
| `changepoints.parquet` | Selected peak per subset | `timestamp`, `height`, `width`, `left`, `right`; widths are peak-shape measures. |
| `epochs.parquet` | Eligible post / unique `key` | `epoch`, `epoch_t` (weeks since boundary); includes both sectors. |
| `epoch-meta.parquet` | Row position is epoch number | `start`, `mid`, `end`; no explicit epoch column. |
| `timeseries.parquet` | Country/name/sector/quality/week | Contiguous within retained outlet spans; missing internal counts and reactions become zero. |
| `comscore.parquet` | Name/month | Filled monthly audience values; residual missing values can remain. |

Epoch joins in R use common columns implicitly (`left_join` without `by`);
with the current epoch schema this means `key`. Adding columns can therefore
change join semantics. The post-to-epoch map intentionally excludes groups
with 20 or fewer posts. Missing epoch labels in model input are dropped.

## Time and language boundaries

News ingestion parses timestamps with UTC; the R augmentation writes UTC
microsecond timestamps, while the inspected Python news output uses nanoseconds.
The inspected non-news timestamps are timezone-naive. Weekly aggregation and
epoch assignment explicitly remove timezone information; weekly timestamps
are normalized to Monday. Preserve these conventions across joins and do not
silently shift dates while changing storage precision or timezone handling.

R converts quality and calendar fields into factors for modeling, then returns
calendar fields to integers in `dataset.parquet`. Names and post keys are
strings. Some local outputs include an incidental `level_1` column from pandas
group operations; it is not the identity key and should not become a new join
contract. Nullable numeric fields cross Arrow, pandas, and R representations.

## Observed local snapshot

Metadata inspection on **2026-09-17**, without rerunning stages, found:

| Artifact | Rows |
|---|---:|
| Raw news / raw non-news | 5,243,302 / 396,580 |
| Raw 2025 extension | 574,501 |
| Raw metadata / imputed reactions | 40 / 62,559 |
| Processed news / augmented dataset | 5,728,502 each |
| Processed non-news | 436,420 |
| News weekly / non-news weekly | 20,415 / 9,875 |
| Signal / BEAST candidates | 519 / 37,378 |
| Peaks / epoch metadata | 22 across two subsets / 12 epochs |
| Eligible epoch keys / dense time series | 6,164,797 / 30,920 |

Read-only inspection of `data/proc/weekly.parquet` and
`data/proc/weekly-non-news.parquet` on the same date found 40 news outlets
(14 high, 13 medium, 13 low quality) and 21 non-news pages. Ten news outlets and
15 non-news pages had missing internal `week_t` values between their own minimum
and maximum week indices; start/end coverage also differed. These counts use
distinct country/name pairs and do not imply gaps in every group-level series.
The five metadata columns selected by ingestion had no missing values in the
inspected `data/raw/metadata.parquet`. None of these observations proves that
all raw posts survive ingestion or that missing weeks represent inactivity.

These values are observations, not regression-test expectations. A DVC run was
active during the review, so they do not certify a single synchronized snapshot
of every artifact. See [freshness limits](development-and-reproducibility.md#review-snapshot-and-freshness).
