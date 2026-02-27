# %% Setup ---------------------------------------------------------------------------

library(reticulate)
library(arrow)
library(lubridate)
library(stringr)
library(dplyr)
library(tidyr)
library(tibble)
library(purrr)
library(glmmTMB)

use_python(normalizePath(R.home("../../bin/python")), required = TRUE)

project <- import("project")
config  <- project$config
paths   <- project$paths
dirpath <- paths$glmm / "both"
dirpath$mkdir(parents = TRUE, exist_ok = TRUE)

COLUMNS <- c(
    "country", "name", "sector", "quality",
    "timestamp", "year", "month", "day", "epoch",
    "reactions"
)

# %% ---------------------------------------------------------------------------------

news <- as.character(paths$dataset) %>%
    read_parquet %>%
    tibble %>%
    left_join(read_parquet(as.character(paths$epochs))) %>%
    mutate(
        year = as.factor(year),
        month = as.factor(month),
        day = as.factor(day),
        timestamp = as_datetime(timestamp, tz = "UTC"),
        epoch = as.factor(epoch),
    ) %>%
    mutate(sector = "news", .after = "country") %>%
    drop_na(epoch) %>%
    select(all_of(COLUMNS))

# %% ----------------------------------------------------------------------------------

nonnews <- as.character(paths$nonnews) %>%
    read_parquet %>%
    tibble %>%
    left_join(read_parquet(as.character(paths$epochs))) %>%
    mutate(
        year = as.factor(year),
        month = as.factor(month),
        day = as.factor(day),
        timestamp = as_datetime(timestamp, tz = "UTC"),
        epoch = as.factor(epoch),
    ) %>%
    mutate(sector = "non-news", .after = "country") %>%
    # Treating 'non-news' as an additional level of the quality factor (alongside
    # low/medium/high) enables direct comparison within the same model. This is the
    # difference-in-differences (DiD) identification strategy: non-news pages serve
    # as the counterfactual, since they share the same platform but should not be
    # directly affected by news-specific algorithm changes.
    mutate(quality = sector) %>%
    drop_na(epoch) %>%
    select(all_of(COLUMNS))

# %% ---------------------------------------------------------------------------------

dataset <- bind_rows(news, nonnews) %>%
    mutate(
        sector    = factor(sector, levels = c("non-news", "news")),
        reactions = as.integer(reactions)
    ) %>%
    arrange(country, name, timestamp)

# %% ---------------------------------------------------------------------------------

get_control <- function(
    optimizer = optim,
    profile = TRUE,
    n_cores = NULL,
    ...
) {
    if (!is.null(n_cores)) {
        n_cores <- min(parallel::detectCores(), n_cores)
        parallel <- rlang::ll(n = n_cores, autopar = n_cores > 1L)
    } else {
        parallel <- rlang::ll(n = 1L, autopar = FALSE)
    }
    control <- rlang::ll(
        optimizer = optimizer,
        profile   = profile,
        parallel  = parallel,
        ...
    )
    do.call(glmmTMBControl, control)
}

# %% Fit quality model --------------------------------------------------------------

# Random effects use sector-nested structure (outlet within sector within country)
# because non-news outlets have systematically different baseline engagement than
# news outlets. The simpler dispersion model (random intercepts only, no epoch
# interaction) reflects that the primary variance heterogeneity is between sectors
# rather than across time periods.
frm  <- reactions ~ 1 + quality * epoch +
    (1 | country:sector:name) + (1 | country:sector:name:epoch) +
    (1 | quality:year:month:day)
dfrm <- ~ 1 + (1 | country:sector:name) + (1 | country:sector:name:epoch)

control <- get_control(
    n_cores = config$parallel$maxcores,
    optArgs = list(method = "CG"),
    optCtrl = list(maxit = 1000),
    profile = FALSE,
)

# %% ---------------------------------------------------------------------------------

time <- system.time(
    glmm <- glmmTMB(
        frm, dataset,
        dispformula = dfrm,
        ziformula = ~0,
        # ziformula = zifrm,
        # family = truncated_nbinom2,
        family = nbinom1,
        control = control
    )
)
print(time)

# %% ---------------------------------------------------------------------------------

saveRDS(glmm, as.character(dirpath / "quality.rds"))
rm(glmm)
gc()

# %% ---------------------------------------------------------------------------------
