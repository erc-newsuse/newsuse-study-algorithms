# %% Setup -------------------------------------------------------------------------------
library(reticulate)
library(stringr)
library(arrow)
library(dplyr)
library(tibble)
library(glmmTMB)

use_condaenv("newsuse-study-algorithms")

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
# glmm_c  <- readRDS(as.character(paths$glmm / "comments" / "0.rds"))

reactions_mu      <- predict(glmm_r, dataset, type = "response", allow.new.levels = TRUE)
reactions_link    <- predict(glmm_r, dataset, type = "link", allow.new.levels = TRUE)
reactions_disp    <- predict(glmm_r, dataset, type = "disp", allow.new.levels = TRUE)
reactions_var     <- reactions_mu * (1 + reactions_mu / reactions_disp)
reactions_cv      <- sqrt(reactions_var) / reactions_mu
# comments_mu   <- predict(glmm_c, dataset, type = "response", allow.new.levels = TRUE)
# comments_link <- predict(glmm_c, dataset, type = "link", allow.new.levels = TRUE)
# comments_disp <- predict(glmm_c, dataset, type = "disp", allow.new.levels = TRUE)
# comments_var  <- comments_mu * (1 + comments_mu / comments_disp)
# comments_cv   <- sqrt(comment_var) / comments_mu

rm(glmm_r)
# rm(glmm_c)
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
    # comments      = if_else(is.na(comments), comments_mu, comments),
    # comments_mu   = comments_mu,
    # comments_cv   = comments_cv,
    # comments_var  = comments_var,
    # comments_link = comments_link,
    # comments_disp = 1 / comments_disp,
    reactions_rel         = reactions / reactions_avg,
    reactions_rel_mu      = reactions_mu / reactions_avg,
    reactions_rel_cv      = reactions_cv,
    reactions_rel_var     = reactions_var / reactions_avg^2,
    reactions_rel_link    = reactions_link - log(reactions_avg),
    # comments_rel      = comments / comments_avg,
    # comments_rel_mu   = comments_mu / comments_avg,
    # comments_rel_cv   = comments_cv,
    # comments_rel_var  = comments_var / comments_avg^2,
    # comments_rel_link = comments_link - log(comments_avg),
)

# %% Save augmented dataset ----------------------------------------------------------

write_parquet(
    dataset,
    as.character(paths$dataset),
    compression = "zstd",
    compression_level = 9
)

# %% ---------------------------------------------------------------------------------
