# %% ---------------------------------------------------------------------------------

import numpy as np
from newsuse.data import DataFrame

from project import config, paths

# %% ---------------------------------------------------------------------------------

weekly = DataFrame.from_(paths.weekly)

# %% ---------------------------------------------------------------------------------

cols = ["reactions_mu", "reactions_rel_mu", "reactions_cv", "reactions_rel_cv"]
signal = (
    weekly.assign(
        reactions_mu=lambda df: np.log(df["reactions_mu"]),
        reactions_rel_mu=lambda df: np.log(df["reactions_rel_mu"]),
    )
    .groupby([*config.signal.groups, "week_t"])
    .agg(
        {
            "timestamp": "first",
            "n_posts": "mean",
            **dict.fromkeys(cols, "mean"),
        }
    )
    .assign(timestamp=lambda df: df["timestamp"].dt.date)
    .reset_index()[1:-1]  # ignore first and last week as they may be incomplete
    .reset_index(drop=True)
)

signal.insert(
    signal.columns.get_loc("timestamp") + 1,
    "time",
    signal["timestamp"].pipe(
        lambda s: (s.dt.year.add(s.dt.isocalendar().week.div(52).add(0.5 / 52)))
    ),
)

# %% ---------------------------------------------------------------------------------

signal.to_(paths.signal)

# %% ---------------------------------------------------------------------------------
