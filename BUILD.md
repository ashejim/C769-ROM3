# Building & Publishing the C769-ROM3 Site

This repo builds with [Jupyter Book](https://jupyterbook.org/) inside a
[uv](https://docs.astral.sh/uv/)-managed Python environment. The environment is
defined by `pyproject.toml` + `uv.lock` (both committed), so it reproduces
identically on any machine — no manual Python or pip setup.

## One-time, per machine

Install **uv**: <https://docs.astral.sh/uv/getting-started/installation/>
(Windows: `winget install astral-sh.uv`, or the install script on that page.)

That is the only prerequisite. You do **not** install Python or the packages by
hand — uv fetches the pinned Python (3.12) and all dependencies for you.

## Build & publish

Run the deploy script from this folder:

    update_C769_ROM3_site.bat

It prepares the env (`uv sync`), pulls latest from GitHub, builds the book
(`uv run jupyter-book build .`), commits + pushes the source to `main`, then
publishes `_build/html` to the `gh-pages` branch (`uv run ghp-import ...`).

Build only, no publish:

    uv run jupyter-book build .

## Using this in your other local clones

After `git pull` in any other clone of this repo the same process works:
`pyproject.toml`, `uv.lock`, `.python-version`, and the `.bat` all come with the
pull. Run the `.bat` (or `uv sync` once) and uv recreates the local `.venv` from
the lock file. The `.venv` is **not** committed (it is in `.gitignore`); uv rebuilds
it per machine.

Per-machine prerequisites: **uv installed** + internet access for the first `uv sync`.

## Do I need a requirements.txt?

No. With uv the dependencies live in **`pyproject.toml`** and are pinned in
**`uv.lock`** — those are the "requirement files." To add or upgrade a package:

    uv add <package>        # updates pyproject.toml + uv.lock; commit both

If some other tool insists on a classic requirements file, you can export one:

    uv export --format requirements-txt --no-hashes -o requirements.txt

(The old commented-out `requirements.txt` in `course_webpages/` is legacy and unused.)

## Python version

Pinned to 3.12 via `.python-version` (Jupyter Book / Sphinx do not yet fully
support 3.14). uv fetches 3.12 automatically on any machine that lacks it.
