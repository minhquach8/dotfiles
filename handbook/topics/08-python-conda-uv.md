# Python, Conda and uv — Research Environments
<!-- search: python conda uv venv pip environment packages dependencies research reproducibility cuda pytorch -->

Use a separate environment for each research project.
Avoid installing project packages into the system Python
or an unrelated Conda environment.

## Inspect the current environment

| Command | Description |
| --- | --- |
| `python3 --version` | Check Python version |
| `command -v python3` | Locate the Python executable |
| `python3 -m pip --version` | Check pip for this interpreter |
| `conda env list` | List Conda environments |
| `conda info` | Inspect Conda configuration |
| `uv --version` | Check uv version |
| `uv python list` | List Python versions recognised by uv |

The shell prompt may display an active Conda environment.
Confirm the active interpreter before installing packages.

## Conda workflow

| Command | Description |
| --- | --- |
| `conda create -n research python=3.12` | Create a research environment |
| `conda activate research` | Activate the environment |
| `conda deactivate` | Leave the active environment |
| `conda run -n research python --version` | Run Python in a named environment |
| `conda list` | Inspect installed packages |
| `conda env export --from-history` | Show explicitly requested Conda dependencies |

Creating environments and installing packages can require
internet access and disk space.

Export the requested environment dependencies:

~~bash
conda env export --from-history > environment.yml
~~

Review the resulting file before committing it.
For reproducibility, record separately installed pip
packages and any system-level CUDA requirements.

## uv — Virtual environments

uv is installed in the user-local executable directory.

| Command | Description |
| --- | --- |
| `uv venv .venv` | Create a project virtual environment |
| `uv venv --python 3.12 .venv` | Request Python 3.12 |
| `uv pip list --python .venv/bin/python` | Inspect packages in the virtual environment |
| `uv pip install --python .venv/bin/python pytest` | Install pytest in the specified environment |

Use an explicit interpreter target when another Conda
environment is active, to avoid installing into the
wrong environment.

Some uv operations may download a missing Python version.

Activate a uv-created environment when needed:

~~bash
source .venv/bin/activate
~~

Use `deactivate` to leave a standard virtual environment.

## uv — Managed projects

| Command | Description |
| --- | --- |
| `uv init my-project` | Create a new uv-managed project |
| `uv add pytest` | Add a project dependency |
| `uv sync` | Synchronise the project environment |
| `uv run python --version` | Run Python inside the project environment |
| `uv tree` | Inspect the dependency tree |

A uv-managed project normally uses `pyproject.toml`,
`uv.lock` and `.venv`.

`uv run` may automatically update the lockfile and
environment. Inspect project configuration before
using it in an existing repository.

Use one primary environment-management approach per
project unless there is a documented reason to combine
Conda and uv.

## Troubleshooting

| Command | Description |
| --- | --- |
| `python3 -m pip check` | Check installed package dependencies |
| `conda info --envs` | Inspect known Conda environments |
| `uv help` | Open uv command help |
| `python3 -c 'import sys; print(sys.executable)'` | Show the active Python interpreter |

Do not use sudo or system-wide pip installation to
resolve a project dependency issue on a shared server.

Official uv documentation: https://docs.astral.sh/uv/
