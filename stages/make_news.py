# %% ---------------------------------------------------------------------------------

import numpy as np
from newsuse.data import DataFrame, sotrender

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
    sotrender.read_data(
        paths.raw / "news-*.parquet",
        progress=True,
        metadata={"country": r"^.+-(.+)\..+$"},
        keycol="key",
    )
    .assign(key=lambda df: df["key"].str.removeprefix("sotrender@"))
    .query(f"author.isin({config.author})")
    .reset_index(drop=True)
    .merge(metadata, on="name", how="left")
    .rename(columns={"likes": "reactions"})
    .merge(imputed, how="left", on="key")
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

# %% Postprocess ---------------------------------------------------------------------

data.insert(2, "quality", data.pop("quality"))
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

# %%

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

# %% Consistency checks --------------------------------------------------------------

x = data["reactions"].to_numpy()
assert (np.isnan(x) | (x % 1 == 0)).all()

# %% Save data -----------------------------------------------------------------------

data.to_(paths.news)
counts.to_(paths.counts)

# %% ---------------------------------------------------------------------------------
