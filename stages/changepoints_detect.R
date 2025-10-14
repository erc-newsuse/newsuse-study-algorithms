# %% ---------------------------------------------------------------------------------

library(arrow)
library(Rbeast)
library(reticulate)
library(dplyr)
library(tidyr)
library(purrr)
library(tibble)
library(stringr)

use_condaenv("newsuse-study-algorithms")

project <- import("project")
config  <- project$config
paths   <- project$paths

# %% ---------------------------------------------------------------------------------

signal <- as.character(paths$signal) %>%
    read_parquet %>%
    tibble

time <- signal$time
signal <- select(signal, -time)

# %% ---------------------------------------------------------------------------------

parse_env <- function(env) {
    nm <- names(env)
    set_names(map(nm, ~env[[.x]]), nm)
}

metadata <- rlang::ll(time = time, !!!parse_env(config$changepoints$beast$metadata))
prior    <- rlang::ll(!!!parse_env(config$changepoints$beast$prior))
mcmc     <- rlang::ll()

# %% ---------------------------------------------------------------------------------

set.seed(config$changepoints$beast$seed)

subsets <- names(config$changepoints$subsets)
seeds   <- sample.int(1e9L, size = config$changepoints$beast$n_runs, replace = FALSE)
results <- lmap(subsets, ~rlang::ll(!!.x := list()))

# %% ---------------------------------------------------------------------------------

for (subset in subsets) {
    env  <- config$changepoints$subsets[[subset]]
    cols <- map_chr(0L:(length(env) - 1L), ~env[[.x]])
    for (i in seq_along(seeds)) {
        .mcmc <- rlang::ll(!!!mcmc, seed = seeds[i])
        output <- beast123(
            signal[, cols],
            metadata = metadata,
            prior = prior,
            mcmc = .mcmc
        )
        detected <- data.frame(
            idx = i,
            date = output$trend$cp,
            prob = output$trend$cpPr
        ) %>%
            drop_na %>%
            arrange(date)
        results[[subset]][[i]] <- detected
    }
    df <- tibble(bind_rows(results[[subset]])) %>%
        mutate(subset = subset, .before = 1L)
    results[[subset]] <- df
}

results <- bind_rows(results)

# %% ---------------------------------------------------------------------------------

write_parquet(
    results, as.character(paths$beast),
    compression = "zstd", compression_level = 9L,
)

# %% ---------------------------------------------------------------------------------
