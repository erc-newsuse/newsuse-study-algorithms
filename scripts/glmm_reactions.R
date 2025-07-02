# %% Setup ---------------------------------------------------------------------------

library(reticulate)
library(arrow)
library(dplyr)
library(tibble)
library(tidyr)
library(glmmTMB)

use_condaenv("newsuse-study-algorithms")

project <- import("project")
config  <- project$config
paths   <- project$paths

dirpath <- paths$glmm / "reactions"
dirpath$mkdir(parents = TRUE, exist_ok = TRUE)

# %% Get data ------------------------------------------------------------------------

dataset <- as.character(paths$news) %>%
    read_parquet %>%
    tibble %>%
    mutate(
        quality = factor(quality, levels = c("low", "medium", "high")),
        year = as.factor(year),
        month = as.factor(month),
        day = as.factor(day),
        log_n_posts = log(n_posts),
    )

# %% Define model data ---------------------------------------------------------------

data <- dataset %>%
    # sample_n(10000L, replace = FALSE) %>%
    tibble %>%
    select(key, country, name, quality, year, month, day, log_n_posts, reactions) %>%
    mutate(reactions = as.integer(reactions)) %>%
    drop_na

# %% Define fitting function ---------------------------------------------------------

fitglmm <- function(
    formula,
    data,
    family = nbinom2,
    ziformula = ~1,
    dispformula = ~1,
    control = list(),
    parallel = list(),
    ...
) {
    ncores   <- min(parallel::detectCores(), config$parallel$maxcores)
    parallel <- rlang::ll(n = ncores, autopar = TRUE, !!!parallel)
    control  <- rlang::ll(
        profile = FALSE,
        optArgs = list(method = "CG"),
        optCtrl = list(maxit = 1000L),
        parallel = parallel,
        !!!control
    )
    glmm <- glmmTMB(
        formula, data, family = family,
        ziformula = ziformula, dispformula = dispformula,
        control = do.call(glmmTMBControl, control), ...
    )
    glmm
}

# %% Fit model 0 ---------------------------------------------------------------------

frm <- reactions ~ quality + log_n_posts +
    (1 | country:name) +
    (1 + quality | year:month:day)
zfrm <- ~0
dfrm <- ~quality + log_n_posts +
    (1 | country:name) +
    (1 + quality | year:month:day)
time <- time0 <- system.time(
    glmm <- fitglmm(frm, data, ziformula = zfrm, dispformula = dfrm)
)
print(time)

# %% --------------------------------------------------------------------------------

saveRDS(glmm, as.character(dirpath / "main.rds"))
rm(glmm)
gc()

# %% ---------------------------------------------------------------------------------
