# %% ---------------------------------------------------------------------------------

import numpy as np
import pandas as pd
from newsuse.data import DataFrame

from project import paths

# %% ---------------------------------------------------------------------------------

dataset = pd.concat(
    [
        DataFrame.from_(paths.dataset),
        DataFrame.from_(paths.nonnews).assign(quality="non-news"),
    ],
    axis=0,
    ignore_index=True,
).assign(timestamp=lambda df: df["timestamp"].dt.tz_localize(None))
idx = dataset.columns.tolist().index("day")
dataset.insert(idx + 1, "week", dataset["timestamp"].dt.isocalendar().week)
idx = dataset.columns.tolist().index("quality")
dataset.insert(
    idx, "sector", np.where(dataset["quality"].eq("non-news"), "non-news", "news")
)

# %% ---------------------------------------------------------------------------------

timegrid = (
    dataset[["year", "month", "day", "week"]]
    .drop_duplicates()
    .pipe(lambda df: df.sort_values(df.columns.tolist(), ignore_index=True))
    .convert_dtypes(dtype_backend="numpy_nullable")
    .assign(
        week_t=lambda df: df["week"].diff().ne(0).fillna(True).cumsum() - 1,
    )
    .convert_dtypes()
)

# %% ---------------------------------------------------------------------------------

keycols = ["country", "name", "quality"]
datecols = ["year", "month", "day"]
signalcols = [
    "reactions",
    "reactions_mu",
    "reactions_cv",
    "reactions_rel_mu",
    "reactions_rel_cv",
]

weekly = (
    dataset.groupby([*keycols, *datecols], observed=True)
    .agg(
        {
            **dict.fromkeys(["key"], "count"),
            **dict.fromkeys(signalcols, "mean"),
        }
    )
    .rename(columns={"key": "n_posts"})
    .reset_index()
    .merge(timegrid, on=datecols, how="left")
    .groupby([*keycols, "week_t"], observed=True)
    .agg(
        {
            **dict.fromkeys(["year", "month", "day", "week"], "first"),
            "n_posts": "sum",
            **dict.fromkeys(signalcols, "mean"),
        }
    )
    .reset_index()
)

idx = weekly.columns.tolist().index("year")
weekly.insert(idx, "timestamp", pd.to_datetime(weekly[["year", "month", "day"]]))
weekly.drop(columns=["year", "month", "day", "week"], inplace=True)

# %% Correct timestamp ---------------------------------------------------------------

weekly["timestamp"] = weekly["timestamp"].dt.to_period("W").map(lambda p: p.start_time)
weekly = weekly.convert_dtypes()

# %% ---------------------------------------------------------------------------------

nonnews = weekly.query("quality.eq('non-news')").reset_index(drop=True)
weekly = weekly.query("quality.ne('non-news')").reset_index(drop=True)

# %% ---------------------------------------------------------------------------------

weekly.to_(paths.weekly)
nonnews.to_(paths.weekly_nonnews)

# %% --------------------------------------------------------------------------------
