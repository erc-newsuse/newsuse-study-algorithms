# %% ---------------------------------------------------------------------------------

from calendar import isleap
from datetime import timedelta

import matplotlib as mpl
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from newsuse.data import DataFrame
from scipy import signal

from project import config, paths

figpath = paths.figures / "changepoints"
figpath.mkdir(parents=True, exist_ok=True)

# %% Get and preprocess raw data -----------------------------------------------------

raw = (
    DataFrame.from_(paths.beast)
    .groupby(["subset", "idx", "date"])["prob"]
    .apply(lambda s: 1 - (1 - s).prod())
    .reset_index()
    .pipe(
        lambda df: df.sort_values(["subset", "idx", "date"], ignore_index=True)
        .assign(year=lambda df: df["date"].astype(int))
        .assign(
            month=lambda df: (np.modf(df["date"])[0] * 12).astype(int) + 1,
            day=lambda df: (
                pd.to_datetime(df[["year"]].assign(month=1, day=1))
                + (np.modf(df["date"])[0] * 365 + df["year"].map(isleap))
                .astype(int)
                .map(timedelta)
            ).dt.day,
        )
        .assign(timestamp=lambda df: pd.to_datetime(df[["year", "month", "day"]]))
        .assign(week=lambda df: df["timestamp"].dt.isocalendar().week)
    )
)

dataset = DataFrame.from_(paths.dataset).assign(
    timestamp=lambda df: df["timestamp"].dt.tz_localize(None)
)
tstart = dataset["timestamp"].min()
tstop = dataset["timestamp"].max()
nruns = max(raw["idx"])

# %% Make time grid ------------------------------------------------------------------

timegrid = (
    DataFrame({"timestamp": pd.date_range(tstart, tstop)})
    .assign(
        year=lambda df: df["timestamp"].dt.year,
        week=lambda df: df["timestamp"].dt.isocalendar().week,
    )
    .assign(time=lambda df: ((df["week"] != df["week"].shift(1)).cumsum().bfill()))
    .drop_duplicates(["year", "week"], ignore_index=True)
)

# %% Prepare changepoints grid -------------------------------------------------------

changepoints = (
    raw.groupby("subset")
    .apply(
        lambda df: df.sort_values(["idx", "date"], ignore_index=True)
        .drop(columns=["date", "month", "day", "timestamp"])
        .merge(timegrid, on=["year", "week"], how="left")
        .groupby(["idx", "time"])["prob"]
        .apply(lambda p: 1 - np.prod(1 - p))
        .reset_index()
        .groupby(["time"])["prob"]
        .sum()
        .reset_index()
        .pipe(lambda df: timegrid.merge(df, on="time", how="left"))
        .fillna({"prob": 0.0})
        .set_index("timestamp")["prob"]
        .pipe(lambda s: s / raw["idx"].max()),
        include_groups=False,
    )
    .T
)

# %% Raw changepoints data -----------------------------------------------------------

data = changepoints.transform(
    lambda s: (
        s.rolling(window=round(config.changepoints.timescale))
        .apply(lambda p: 1 - np.prod(1 - p))
        .bfill()
    )
)

# %% Compute peaks data --------------------------------------------------------------

peaksdata = {}
for col in data:
    tsdata = data[col]
    time = tsdata.index
    peaks, props = signal.find_peaks(tsdata, **config.changepoints.peaks)
    width, _, left, right = signal.peak_widths(tsdata, peaks)
    pdata = DataFrame(
        {
            "height": tsdata.iloc[peaks],
            "width": width,
            "left": time[np.round(left).astype(int)],
            "right": time[np.round(right).astype(int)] + pd.Timedelta(days=6),
        }
    )
    peaksdata[col] = pdata

peaksdata = pd.concat(peaksdata, names=["subset"]).reset_index()

# %% ---------------------------------------------------------------------------------

gpeaks = peaksdata.groupby("subset")
nrows = len(gpeaks)
fig, axes = plt.subplots(nrows=nrows, figsize=(7, 2 * nrows))

for ax, gdf in zip(axes.flat, gpeaks, strict=True):
    subset, gdf = gdf
    col = subset
    tsdata = data[col]
    time = tsdata.index
    pdata = peaksdata.query(f"subset == '{subset}'").set_index("timestamp")
    ax.plot(time, tsdata)
    ax.scatter(pdata.index, pdata["height"], color="red", zorder=99)
    ax.axhline(config.changepoints.peaks.height, ls="--", color="k")
    for _, row in pdata.iterrows():
        ax.axvspan(*row[["left", "right"]], color="black", alpha=0.2, zorder=95)

    ax.set_ylim(-0.02, 1.02)
    ax.yaxis.set_major_formatter(mpl.ticker.PercentFormatter(1.0, decimals=0))
    name, *metrics = col.split("-")
    metrics = ", ".join(metrics)
    title = f"{name.title()} [{metrics}]"
    ax.set_title(title)

fig.supylabel("Average posterior probability")
fig.tight_layout()
fig.savefig(figpath / "posterior.pdf")


# %% Make epochs ---------------------------------------------------------------------

cdf = peaksdata.query(f"subset.eq('{config.changepoints.use}')").reset_index(drop=True)

# %% ---------------------------------------------------------------------------------

cols = ["key", "country", "name", "timestamp"]

epochs = pd.concat(
    [
        DataFrame.from_(paths.dataset, columns=cols),
        DataFrame.from_(paths.nonnews, columns=cols),
    ],
    ignore_index=True,
).assign(
    timestamp=lambda df: df["timestamp"].dt.tz_localize(None),
    epoch=0,
    epoch_start=lambda df: df["timestamp"].min(),
)
for ts in cdf["timestamp"]:
    mask = epochs["timestamp"] >= ts
    epochs.loc[mask, "epoch"] += 1  # type: ignore
    epochs.loc[mask, "epoch_start"] = ts

epochs["epoch_t"] = (
    (epochs["timestamp"] - epochs["epoch_start"]).dt.total_seconds().div(60 * 60 * 24 * 7)
)

counts = epochs.groupby(["country", "name", "epoch"]).size().reset_index(name="n_posts")

epochs = (
    epochs.merge(counts, on=["country", "name", "epoch"], how="left")
    .query(f"n_posts > {config.epochs.min_posts}")
    .reset_index(drop=True)
)

assert epochs.key.is_unique, "keys are not unique in 'epochs' data."
assert (
    epochs.groupby(["country", "name", "epoch"])["key"]
    .nunique()
    .ge(config.epochs.min_posts)
    .all()
), f"there are epochs with less than {config.epochs.min_posts} posts"

epochs = epochs[["key", "epoch", "epoch_t"]]

# %% Epoch meta ----------------------------------------------------------------------

epochmeta = DataFrame(
    {
        "start": [dataset["timestamp"].min(), *cdf["timestamp"]],
        "end": [*cdf["timestamp"], dataset["timestamp"].max()],
    }
)
epochmeta.insert(1, "mid", epochmeta[["start", "end"]].mean(axis=1))

# %% ---------------------------------------------------------------------------------

(
    peaksdata.query(f"subset == '{config.changepoints.use}'")
    .reset_index(drop=True)
    .assign(changepoint=lambda df: df.index + 1)[
        ["changepoint", "timestamp", "left", "right"]
    ]
    .style.format(
        {
            "timestamp": lambda ts: ts.strftime("%Y-%m-%d"),
            "left": lambda ts: ts.strftime("%Y-%m-%d"),
            "right": lambda ts: ts.strftime("%Y-%m-%d"),
        }
    )
    .hide(axis="index")
    .pipe(
        lambda df: print(
            df.to_latex(
                label="tab:changepoints",
                position="htb",
                hrules=True,
                column_format="lcccc",
                caption="Changepoint dates for the selected subset.",
            )
        )
    )
)

# %% Save changepoint peaks ----------------------------------------------------------

peaksdata.to_(paths.changepoints)
epochs.to_(paths.epochs)
epochmeta.to_(paths.epochmeta)

# %% ---------------------------------------------------------------------------------
