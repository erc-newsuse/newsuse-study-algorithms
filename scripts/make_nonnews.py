# %% ---------------------------------------------------------------------------------

import joblib
from newsuse.data import sotrender

from project import config, paths

# %% ---------------------------------------------------------------------------------

data = (
    sotrender.read_data(
        paths.raw / "non-news-*.parquet",
        progress=True,
        metadata={"country": r"^.+-(.+)\..+$"},
        keycol="key",
    )
    .assign(key=lambda df: (df["key"].str.removeprefix("sotrender@").map(joblib.hash)))
    .rename(columns={"likes": "reactions"})
    .query(f"author.isin({config.data.author})")
    .reset_index(drop=True)
    .pipe(lambda df: df[[c for c in df.columns if c in config.data.usecols]])
)
for col in ["day", "month", "year"]:
    data.insert(
        data.columns.tolist().index("timestamp") + 1,
        col,
        getattr(data["timestamp"].dt, col),
    )

# %% ---------------------------------------------------------------------------------

data.to_parquet(paths.nonnews)

# %% ----------------------------------------------------------------------------------
