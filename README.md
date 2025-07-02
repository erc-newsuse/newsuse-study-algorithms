# NEWSUSE | Algorithms

Analysis of the impact of news feed algorithms' changes on Facebook on user engagement and posting patterns of media organizations.

This is companion repository for the paper:

    Changes to the Facebook Algorithm Decreased News Engagement Between 2021-2024

## Repository Setup

### Prerequisites

- [Conda](https://docs.anaconda.com/getting-started/) or [Miniconda](https://docs.anaconda.com/miniconda/)
- [Git](https://git-scm.com/)
- [DVC (Data Version Control)](https://dvc.org/)
- [Quarto](https://quarto.org/) for rendering analysis notebooks

### Initial Setup

1. **Clone the repository**

```bash
git clone git+ssh://git@github.com/erc-newsuse/newsuse-study-algorithms.git
cd newsuse-study-algorithms
```

2. **Create and activate the Conda environment**

```bash
conda env create -f environment.yaml
conda activate newsuse-study-algorithms
```

3. **Initialize the project**

```bash
make init
```

4. **Configure DVC and fetch raw data**

The raw data files are tracked by DVC but not stored in the Git repository. You will need to either:

- Contact the study authors to obtain access to the DVC remote storage, or
- Place the required raw data files in the `data/raw/` directory manually

Required raw data files:
- `data/raw/news-us.parquet` - News articles data
- `data/raw/non-news-us.parquet` - Non-news content data
- `data/raw/metadata.parquet` - Metadata for content
- `data/raw/imputed-reactions.parquet` - Imputed reactions for a small number of posts with missing data
- `data/raw/comscore.parquet` - ComScore audience metrics (monthly unique visitors)

If you have access to the DVC remote:

```bash
dvc pull
```

## Running the Data Processing Pipeline

The project uses DVC to orchestrate the data processing and modeling pipeline. All main scripts are configured as DVC stages and should be executed using DVC commands.

### Inspect the Pipeline Structure

To view the pipeline structure and dependencies, you can use:

```bash
dvc stage list
```

Or to visualize the full directed acyclic graph (DAG):

```bash
dvc dag
```

### Execute the Complete Pipeline

To run the entire pipeline from raw data to final models:

```bash
dvc repro
```

### Execute Specific Pipeline Stages

You can also run individual stages or groups of stages:

```bash
# Process news data
dvc repro news

# Process non-news data
dvc repro non-news

# Process ComScore data
dvc repro comscore

# Create main dataset
dvc repro dataset

# Generate weekly aggregations
dvc repro weekly

# Detect changepoints
dvc repro changepoints-detect
dvc repro changepoints-postprocess

# Run statistical models
dvc repro glmm-news
dvc repro glmm-both
```

### Pipeline Overview

The DVC pipeline consists of the following main stages:

1. **Data production**
   - `news`: Process news articles (`scripts/make_news.py`)
   - `non-news`: Process non-news content (`scripts/make_nonnews.py`)
   - `comscore`: Process ComScore data (`scripts/make_comscore.py`)
   - `glmm`: Initial GLMM models (`scripts/glmm_reactions.R`)
   - `dataset`: Create final analysis dataset (`scripts/make_dataset.R`)

2. **Construction of Time Series**
   - `weekly`: Create weekly aggregations (`scripts/make_weekly.py`)
   - `signal`: Generate signal data (`scripts/make_signal.py`)
   - `timeseries`: Create time series data (`scripts/make_timeseries.py`)

3. **Changepoint Detection**
   - `changepoints-detect`: Detect changepoints using BEAST (`scripts/changepoints_detect.R`)
   - `changepoints-postprocess`: Post-process changepoint results (`scripts/changepoints_postprocess.py`)

4. **Statistical Modeling**
   - `glmm-news`: News-specific GLMM (`scripts/glmm_news.R`)
   - `glmm-both`: Combined news and non-news GLMM (`scripts/glmm_both.R`)


## Running the Analyses

The analysis notebooks are implemented as Quarto documents in the `analyses/` folder. These are not part of the DVC pipeline and must be executed manually after the data processing pipeline is complete.

### Prerequisites for Analyses

Ensure the DVC pipeline has been executed successfully:

```bash
dvc status
```

All stages should show as "up to date" or "Data and pipelines are up to date!".

### Execute Individual Analysis Notebooks

Navigate to the analyses directory and render specific notebooks:

```bash
cd analyses

# Descriptive statistics
quarto render descriptives.qmd

# Time series analysis
quarto render timeseries.qmd

# Analysis ruling out alternative explanations
quarto render alternatives.qmd

# Changepoint analysis
quarto render changepoints.qmd

# GLMM results for news data
quarto render glmm-news.qmd

# GLMM results for combined data
quarto render glmm-both.qmd

# Model coefficient tables
quarto render model-tables.qmd
```

### Execute All Analysis Notebooks

To render all analysis notebooks:

```bash
cd analyses
quarto render
```

### Validation Analyses

Additional validation analyses are available in the `analyses/validation/` subdirectory:

```bash
cd analyses/validation
quarto render glmm-news.qmd
quarto render glmm-both.qmd
```

## Project Structure

- `data/raw/` - Raw data files (DVC-tracked, not in Git)
- `data/proc/` - Processed data files (generated by pipeline)
- `scripts/` - Data processing and modeling scripts
- `analyses/` - Quarto analysis notebooks
- `models/` - Fitted statistical models
- `figures/` - Generated plots and visualizations
- `project/` - Python package source code


## Troubleshooting

### DVC Issues

If you encounter DVC-related errors:

```bash
# Check DVC status
dvc status

# Check DVC configuration
dvc config --list

# Force reproduction of a specific stage
dvc repro --force <stage-name>
```

### R Issues

If R packages fail to install or load:

```bash
# Activate the environment and install missing R packages
conda activate newsuse-study-algorithms
R -e "install.packages('package_name', repos='https://cran.r-project.org')"
```

### Python Issues

For Python package issues:

```bash
# Update the environment
conda env update -f environment.yaml

# Or install specific packages
pip install package_name
```
