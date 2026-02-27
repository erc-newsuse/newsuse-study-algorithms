# %% Setup -------------------------------------------------------------------------------
library(reticulate)
library(stringr)
library(arrow)
library(dplyr)
library(tibble)
library(glmmTMB)

use_python(normalizePath(R.home("../../bin/python")), required = TRUE)

project <- import("project")
config  <- project$config
paths   <- project$paths

# %% Get data ------------------------------------------------------------------------

dataset <- as.character(paths$news) %>%
    read_parquet %>%
    tibble %>%
    mutate(
        timestamp = lubridate::as_datetime(timestamp, tz="UTC"),
        quality = factor(quality, levels = c("low", "medium", "high")),
        year = as.factor(year),
        month = as.factor(month),
        day = as.factor(day),
    ) %>%
    mutate(log_n_posts = log(n_posts), .after = "n_posts")

# %% Get smooth signals --------------------------------------------------------------

glmm_r  <- readRDS(as.character(paths$glmm / "reactions" / "main.rds"))

# %% ---------------------------------------------------------------------------------

# Extract model-derived summaries that characterize each outlet's engagement distribution:
# - mu (response): predicted mean on the response scale (expected reaction count)
# - link: linear predictor on the log scale (useful for additive comparisons)
# - disp: dispersion parameter k from the NB2 model (controls overdispersion)
# - var: predicted variance, derived from NB2 formula Var = mu + mu^2/k
# - cv: coefficient of variation (sd/mean), a scale-free measure of engagement volatility
reactions_mu      <- predict(glmm_r, dataset, type = "response", allow.new.levels = TRUE)
reactions_link    <- predict(glmm_r, dataset, type = "link", allow.new.levels = TRUE)
reactions_disp    <- predict(glmm_r, dataset, type = "disp", allow.new.levels = TRUE)
reactions_var     <- reactions_mu * (1 + reactions_mu / reactions_disp)
reactions_cv      <- sqrt(reactions_var) / reactions_mu

rm(glmm_r)
gc()

# %% Augment dataset -----------------------------------------------------------------

dataset <- mutate(
    dataset,
    quality       = as.character(quality),
    year          = as.integer(as.character(year)),
    month         = as.integer(as.character(month)),
    day           = as.integer(as.character(day)),
    reactions         = round(if_else(is.na(reactions), reactions_mu, reactions)),
    reactions_mu      = reactions_mu,
    reactions_cv      = reactions_cv,
    reactions_var     = reactions_var,
    reactions_link    = reactions_link,
    reactions_disp    = 1 / reactions_disp,
    # Dividing each outlet's weekly values by its overall predicted mean (reactions_avg)
    # produces relative metrics that enable cross-outlet comparability despite
    # large differences in absolute engagement levels between outlets
    reactions_rel         = reactions / reactions_avg,
    reactions_rel_mu      = reactions_mu / reactions_avg,
    reactions_rel_cv      = reactions_cv,
    reactions_rel_var     = reactions_var / reactions_avg^2,
    reactions_rel_link    = reactions_link - log(reactions_avg),
)

# %% Save augmented dataset ----------------------------------------------------------

write_parquet(
    dataset,
    as.character(paths$dataset),
    compression = "zstd",
    compression_level = 9
)

# %% ---------------------------------------------------------------------------------
