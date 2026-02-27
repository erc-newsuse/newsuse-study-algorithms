"""Bridge package providing unified configuration for both Python and R stages.

Loads all parameters from ``params.yaml`` via DVC's parameter API and resolves
the path DSL (``@ref/subpath`` references) into concrete filesystem paths.
R stages access these same objects through ``reticulate::import("project")``,
ensuring a single source of truth for configuration across both languages.
"""

from pathlib import Path

import dvc.api
import dvc.config
from newsuse.config import Config

from .__about__ import __version__

__all__ = ("__version__", "config", "paths")

root = Path(__file__).parent.parent
# dvc.api.params_show() reads params.yaml (with DVC interpolation and
# ${eval:...} expressions resolved). Config.resolve() recursively processes
# 'make!:' factory directives, instantiating objects like Paths and cycler.
config = Config(dvc.api.params_show()).resolve()
# Pop 'paths' from config (so it doesn't pollute the parameter namespace) and
# construct a Paths object rooted at the project directory. The resulting
# object provides pathlib.Path-like attribute access (e.g. paths.news,
# paths.epochs) resolved from the @ref/subpath DSL in params.yaml.
paths = config.pop("paths")(root=root)
