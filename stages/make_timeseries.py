"""DVC stage 'timeseries'. Creates a dense, contiguous weekly time series by
computing a full cross-product of (outlet x week) and filling gaps via
interpolation. This guarantees every outlet has an observation for every week
in the study period, which is required for time series modeling.
Output: data/proc/timeseries.parquet.
"""
# %% ---------------------------------------------------------------------------------

import numpy as np
import pandas as pd
from newsuse.data import DataFrame

from project import paths

KEYCOLS = ["country", "name", "sector", "quality"]
TIMECOLS = ["week_t", "timestamp"]
SIGNALCOLS = ["n_posts", "reactions"]

# %% Get data ------------------------------------------------------------------------

weekly = pd.concat(
    [
        DataFrame.from_(paths.weekly),
        DataFrame.from_(paths.weekly_nonnews),
    ],
    axis=0,
    ignore_index=True,
)

idx = weekly.columns.tolist().index("quality")
weekly.insert(idx, "sector", np.where(weekly["quality"] == "non-news", "non-news", "news"))

weekly = weekly[[*KEYCOLS, *TIMECOLS, *SIGNALCOLS]]

# %% ---------------------------------------------------------------------------------

# Sparse-to-dense strategy: real-world posting data has gaps (outlets skip weeks);
# the cross-product of all outlets x all weeks creates the complete grid, and
# missing values are then interpolated to ensure contiguous series for
# downstream AR(1) models.
accounts = weekly[KEYCOLS].drop_duplicates(ignore_index=True)
timegrid = (
    weekly[["timestamp"]]
    .sort_values("timestamp")
    .drop_duplicates(ignore_index=True)[1:-1]
    .reset_index(drop=True)
    .pipe(lambda df: accounts.merge(df, how="cross"))
)

# %% Define timeseries ---------------------------------------------------------------

timeseries = (
    timegrid.merge(weekly, how="left", on=[*KEYCOLS, "timestamp"])
    .groupby(KEYCOLS, observed=True)[KEYCOLS + TIMECOLS + SIGNALCOLS]
    .apply(
        lambda gdf: gdf.assign(
            week_t=lambda df: (
                df["week_t"].interpolate(
                    limit_direction="both",
                    limit_area="inside",
                )
            )
        ),
    )
    .dropna(subset="week_t", ignore_index=True)
    .assign(
        week_t=lambda df: df["week_t"].astype(int),
        n_posts=lambda df: df["n_posts"].fillna(0).astype(int),
        reactions=lambda df: df["reactions"].fillna(0),
    )
    .sort_values([*KEYCOLS, *TIMECOLS], ignore_index=True)
    .convert_dtypes()
)

assert timeseries.notnull().all().all(), "'timeseries' cannot contain missing values"
assert (
    timeseries.groupby(KEYCOLS)["week_t"]
    .apply(lambda s: s.diff().dropna().eq(1).all())
    .all()
), "some timeseries are not week-contiguous"

# %% Save timeseries -----------------------------------------------------------------

timeseries.to_(paths.timeseries)

# %% ---------------------------------------------------------------------------------
