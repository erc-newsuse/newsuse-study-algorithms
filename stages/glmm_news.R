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
dirpath <- paths$glmm / "news"
dirpath$mkdir(parents = TRUE, exist_ok = TRUE)

# %% ---------------------------------------------------------------------------------

epochs <- as.character(paths$epochs) %>%
    read_parquet()

dataset <- as.character(paths$dataset) %>%
    read_parquet %>%
    tibble %>%
    left_join(epochs) %>%
    mutate(
        quality = factor(quality, levels = c("low", "medium", "high")),
        ideology = factor(ideology, levels = c("center", "left", "right")),
        media = as.factor(media),
        year = as.factor(year),
        month = as.factor(month),
        day = as.factor(day),
        timestamp = as_datetime(timestamp, tz = "UTC"),
        epoch = as.factor(epoch),
    ) %>%
    drop_na(epoch)

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

# %% Make formula --------------------------------------------------------------------

# Core research question: quality x epoch interaction tests whether the effect of
# Meta's algorithmic changes (captured by epochs) differs across news quality tiers.
# Random intercepts for outlet nested within country account for outlet-level baselines;
# outlet x epoch random interaction captures outlet-specific responses to algorithmic
# changes. Dispersion sub-model with quality x epoch allows variance heterogeneity
# across quality-epoch combinations.
frm     <- reactions ~ 1 + quality * epoch +
    (1 | country:name) + (1 | country:name:epoch) +
    (1 + quality | year:month:day)
dfrm    <- ~quality * epoch +
    (1 | country:name) + (1 | country:name:epoch)
zifrm   <- ~(1 | country:name)
control <- get_control(
    n_cores = config$parallel$maxcores,
    optArgs = list(method = "CG"),
    optCtrl = list(maxit = 1000),
    profile = FALSE,
)

# %% Fit model 0 ---------------------------------------------------------------------

time <- system.time(
    glmm <- glmmTMB(
        frm, dataset,
        dispformula = dfrm,
        ziformula = ~0,
        # ziformula = zifrm,
        # family = truncated_nbinom2,
        # nbinom1 (linear variance: Var = mu(1+alpha)) is used instead of nbinom2 because
        # with the epoch-level model structure, nbinom1 provided better convergence and fit.
        # The choice between nbinom1 and nbinom2 is empirical -- both handle overdispersion
        # but differ in how variance scales with the mean.
        family = nbinom1,
        control = control
    )
)
print(time)

# %% ---------------------------------------------------------------------------------

saveRDS(glmm, as.character(dirpath / "main.rds"))
rm(glmm)
gc()

# %% ---------------------------------------------------------------------------------
