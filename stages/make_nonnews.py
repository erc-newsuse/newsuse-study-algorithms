# %% ---------------------------------------------------------------------------------

from datetime import date

import joblib
import numpy as np
import pandas as pd
from newsuse.data import DataFrame, sotrender

from project import config, paths

# %% ---------------------------------------------------------------------------------

data = sotrender.read_data(
    paths.raw / "non-news-*.parquet",
    progress=True,
    metadata={"country": r"^.+-(.+)\..+$"},
    keycol="key",
).assign(
    name=lambda df: df["name"].str.strip().str.lower(),
    key=lambda df: "sotrender@" + df["key"].str.removeprefix("sotrender@").map(joblib.hash),
)

# %% ---------------------------------------------------------------------------------

data = (
    pd.concat(
        [
            data,
            DataFrame.from_(paths.raw / "2025.parquet").pipe(
                lambda df: df[df["name"].isin(data["name"].unique())]
            ),
        ]
    )
    .rename(columns={"likes": "reactions"})
    .query(f"author.isin({config.data.author})")
    .reset_index(drop=True)
    .filter(config.data.usecols, axis="columns")
    .sort_values(["name", "timestamp"], ignore_index=True)
)
for col in ["day", "month", "year"]:
    data.insert(
        data.columns.tolist().index("timestamp") + 1,
        col,
        getattr(data["timestamp"].dt, col),
    )

# %% Consistency checks --------------------------------------------------------------

x = data["reactions"].to_numpy()
assert (np.isnan(x) | (x % 1 == 0)).all()

assert data.timestamp.min().date() == date(2016, 1, 1), "Unexpected start date"
assert data.timestamp.max().date() == date(2025, 12, 15), "Unexpected end date"

# %% ---------------------------------------------------------------------------------

data.to_parquet(paths.nonnews)

# %% ----------------------------------------------------------------------------------
