# %% ---------------------------------------------------------------------------------

import pandas as pd
from newsuse.data import DataFrame

from project import config, paths

# %% ---------------------------------------------------------------------------------

data = DataFrame.from_(paths.raw / "comscore.parquet")

timegrid = (
    pd.date_range(start=data["date"].min(), end=data["date"].max(), freq="MS")
    .to_frame()
    .rename(columns={0: "date"})
    .assign(date=lambda df: df["date"].dt.date)
)

data = (
    DataFrame({"name": data["name"].unique()})
    .assign(date=lambda df: [timegrid["date"]] * len(df))
    .explode("date")
    .merge(data, on=["name", "date"], how="left")
    .sort_values(["name", "date"], ignore_index=True)
    .assign(date=lambda df: pd.to_datetime(df["date"]))
    .convert_dtypes()
    .assign(date=lambda df: df["date"].dt.date)
)

# %% ---------------------------------------------------------------------------------

comscore = (
    data.groupby("name")[["name", "date", "comscore"]]
    .apply(
        lambda df: (
            # Filter out outlets with data starting later than mid 2016
            df.assign(
                delta=lambda d: (
                    pd.Timestamp(d["date"][d["comscore"].notnull()].min())
                    - pd.Timestamp("2016-01-01")
                ).total_seconds()
                / (60 * 60 * 24 * 31)
            )
        ),
    )
    .query("delta <= 6")
    .reset_index(drop=True)
    .drop(columns="delta")
    .set_index(["date"])
    .groupby("name")
    .apply(
        lambda s: (
            s.ffill(limit=config.comscore.imputation.limit).bfill(
                limit=config.comscore.imputation.limit
            )
        ),
        include_groups=False,
    )
    .reset_index(drop=False)
)
assert (
    comscore.dropna().groupby("name")["date"].first().eq(pd.Timestamp("2016-01-01")).all()
), "Some outlets have data starting later than 2016-01-01."

# %% ---------------------------------------------------------------------------------

comscore.to_(paths.comscore)

# %% ---------------------------------------------------------------------------------
