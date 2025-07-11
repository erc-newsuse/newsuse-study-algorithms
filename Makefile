.PHONY: help init clean clean-build clean-misc lint mypy test cov-run cov-report coverage list-deps build

help:
	@echo "init - initialize environment and version control"
	@echo "clean - clean non-persistent files"
	@echo "clean-build - remove build artifacts"
	@echo "clean-misc - remove various Python file artifacts"
	@echo "lint - run linter."
	@echo "mypy - run type checker."
	@echo "test - run unit tests"
	@echo "cov-run - run tests and calculate coverage statistics"
	@echo "cov-report - display test coverage statistics"
	@echo "coverage - run tests and display coverage statistics"
	@echo "list-deps - list explicit dependencies of the project"

init:
	git init
	pip install -e .[dev]
	pre-commit install
	mkdir -p data/raw
	mkdir -p data/proc
	mkdir -p data/remote
	mkdir -p scripts
	dvc init --force
	dvc remote add  --default algorithms ${PWD}/data/remote --local --force
	R -e 'remotes::install_version("glmmTMB", version = "1.1.10", repos = "http://cran.us.r-project.org", upgrade = "never")'
	R -e 'remotes::install_version("Rbeast", version = "1.0.1", repos = "http://cran.us.r-project.org", upgrade = "never")'

clean: clean-build clean-misc

clean-build:
	rm -fr build/
	rm -fr dist/
	rm -fr *.egg-info

clean-misc:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '.benchmarks' -exec rm -rf {} +
	find . -name '.pytest-cache' -exec rm -rf {} +
	find . -name '.pytest_cache' -exec rm -rf {} +
	find . -name '__pycache__' -exec rm -rf {} +
	find . -name '.ruff_cache' -exec rm -rf {} +

lint:
	ruff check project

mypy:
	mypy project

test:
	pytest

cov-run:
	coverage run
cov-report:
	coverage report

coverage: cov-run cov-report

list-deps:
	find project tests -name "*.py" -exec cat {} + | grep "^import \| import " | grep -v "\"\|'" | grep -v "\(import\|from\) \+\." | sed 's/^\s*import\s*//g' | sed 's/\s*import.*//g' | sed 's/\s*from\s*//g' | grep -v "\..*" | sort | uniq

build:
	python -m build
	twine check dist/*
