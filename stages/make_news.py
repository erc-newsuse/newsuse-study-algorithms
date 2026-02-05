# %% ---------------------------------------------------------------------------------

from datetime import date

import joblib
import numpy as np
import pandas as pd
from newsuse.data import DataFrame

from project import config, paths

config = config.data

# %% Read and preprocess data --------------------------------------------------------

metadata = (
    DataFrame.from_(
        paths.raw / "metadata.parquet",
        columns=["name", "quality", "type", "bias", "followers"],
    )
    .rename(columns={"type": "media", "bias": "ideology"})
    .dropna(ignore_index=True)
)

# %% --------------------------------------------------------------------------------

imputed = DataFrame.from_(
    paths.raw / "imputed-reactions.parquet", columns=["key", config.imputation.target]
).dropna()

# %% ---------------------------------------------------------------------------------

data = (
    pd.concat(
        {
            p.name.split(".")[0].split("-")[-1]: DataFrame.from_(p)
            for p in paths.raw.glob("news-*.parquet")
        }
    )
    .reset_index(level=0, names="country")
    .reset_index(drop=True)
    .merge(imputed, how="left", on="key")
    .assign(key=lambda df: df["fb_post_id"].str.strip())
    .assign(
        key=lambda df: "sotrender@"
        + np.where(
            df["key"].str.startswith("NA_") | df["key"].str.endswith("_NA"),
            (df["key"] + "__" + df["check"]).map(joblib.hash),
            df["key"].map(joblib.hash),
        )
    )
    .drop_duplicates(subset="key", ignore_index=True)
    .set_index("key", verify_integrity=True)
    .reset_index()
    .rename(columns={"date": "timestamp"})
    .assign(
        timestamp=lambda df: pd.to_datetime(df["timestamp"] + " " + df["hour"], utc=True)
    )
)

# %% ---------------------------------------------------------------------------------

data = (
    data.query(f"author.isin({config.author})")
    .reset_index(drop=True)
    .merge(metadata, on="name", how="left")
    .rename(columns={"likes": "reactions"})
    .assign(
        reactions=lambda df: (
            df[config.imputation.source]
            .combine_first(df.pop(config.imputation.target))
            .round()
            .astype("int64[pyarrow]")
        )
    )[config.usecols]
)

assert data["key"].is_unique

# %% Add 2025 data ----------------------------------------------------------------

with pd.option_context("future.no_silent_downcasting", True):
    data = (
        pd.concat(
            [
                data,
                DataFrame.from_(paths.raw / "2025.parquet")
                .rename(columns={"likes": "reactions"})
                .drop(columns=["ini", "link_title", "content_type"])
                .pipe(lambda df: df[df.name.isin(data.name.unique())]),
            ]
        )
        .groupby(["name"])
        .apply(
            lambda df: df.assign(
                **{
                    col: df[col].ffill()
                    for col in ["country", "quality", "media", "ideology", "followers"]
                }
            ),
            include_groups=False,
        )
        .reset_index(drop=False)
        .assign(timestamp=lambda df: pd.to_datetime(df["timestamp"], utc=True))
        .convert_dtypes()
    )

# %% Postprocess ---------------------------------------------------------------------

idx = data.columns.tolist().index("timestamp") + 1
data.insert(idx, "day", data.timestamp.dt.day)
data.insert(idx, "month", data.timestamp.dt.month)
data.insert(idx, "year", data.timestamp.dt.year)

counts = (
    data.groupby(["country", "quality", "name", "year", "month", "day"])
    .size()
    .reset_index()
    .rename(columns={0: "n_posts"})
)
keys = counts.columns.tolist()[:-1]

# %% ---------------------------------------------------------------------------------

data = data.merge(counts, on=keys, how="left")
idx = data.columns.tolist().index("reactions")
data.insert(idx, "n_posts", data.pop("n_posts"))
data.insert(idx + 1, "log_n_posts", np.log(data["n_posts"]))

# %% ---------------------------------------------------------------------------------

keys = ["country", "quality", "name"]
avg = data.groupby(keys)[["reactions", "comments", "shares"]].mean()
avg.columns = [f"{c}_avg" for c in avg.columns]
avg = avg.reset_index(keys).reset_index(drop=True)

data = data.merge(avg, on=keys)

# %% ---------------------------------------------------------------------------------

data = data[data["reactions"].notnull()].reset_index(drop=True)
data = data.sort_values(["name", "timestamp"], ignore_index=True)

# %% Consistency checks --------------------------------------------------------------

x = data["reactions"].to_numpy()
assert (np.isnan(x) | (x % 1 == 0)).all()

assert data.timestamp.min().date() == date(2016, 1, 1), "Unexpected start date"
assert data.timestamp.max().date() == date(2025, 12, 16), "Unexpected end date"

# %% Save data -----------------------------------------------------------------------

data.to_(paths.news)
counts.to_(paths.counts)

# %% ---------------------------------------------------------------------------------
