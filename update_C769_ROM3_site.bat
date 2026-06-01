@echo off
SET /P Message=Enter git C769-ROM3 commit comment:
title C769-ROM3: compile html, save to repo folder, update GitHub repo and website

@REM --- Robust paths: always run from THIS script's own folder ---
@REM %~dp0 is this .bat's own drive+path (the Jupyter Book + git repo root), with a
@REM trailing backslash, so the script works no matter where it is launched from.
cd /d "%~dp0"

@REM Require uv (https://docs.astral.sh/uv/). The Python build env is defined by
@REM pyproject.toml + uv.lock in this folder; uv creates/uses a local .venv for it.
where uv >nul 2>&1
if errorlevel 1 (
  echo.
  echo *** 'uv' not found on PATH. Install it ^(https://docs.astral.sh/uv/^) then re-run. Aborting. ***
  pause
  exit /b 1
)

@REM Prepare the build environment (creates/updates .venv from pyproject.toml + uv.lock)
uv sync
if errorlevel 1 (
  echo.
  echo *** uv sync failed - could not prepare the Python build environment. Aborting. ***
  pause
  exit /b 1
)

@REM Sync with GitHub FIRST so the later push can't be rejected. --autostash tucks any
@REM uncommitted edits aside during the pull and re-applies them; --rebase keeps history
@REM linear. If it can't complete (e.g., a merge conflict), stop before building/publishing.
git pull --rebase --autostash
if errorlevel 1 (
  echo.
  echo *** git pull failed ^(likely a merge conflict^). Resolve it, then re-run. Aborting. ***
  pause
  exit /b 1
)

@REM Remove local-history folders so they aren't built or committed
FOR /d /r . %%d IN (.history) DO @IF EXIST "%%d" rd /s /q "%%d"

@REM Build the Jupyter Book in the uv environment (current folder is the book root)
uv run jupyter-book build .
if errorlevel 1 (
  echo.
  echo *** Jupyter Book build FAILED - nothing will be committed or published. Fix the errors above and re-run. Aborting. ***
  pause
  exit /b 1
)
echo "Compiled %~dp0"

@REM Commit + push source to GitHub (main), then publish _build/html to gh-pages
git add -A
git commit -m "%Message%"
echo "Commited..."
git push
echo "Pushed..."
uv run ghp-import -n -p -f _build/html
echo "Imported to git page..."
start https://ashejim.github.io/C769-ROM3/intro_ROM3.html
echo "Gitpage may take a few minutes to update. END"
pause


@REM ===== OLD update bat (kept for reference) =====
@REM prev I kept working files in a separate folder than the repo folder.
@REM @echo off
@REM SET /P Message=Enter git C769-ROM3 commit comment:
@REM title C769-ROM3: compile html, save to repo folder, update GitHub repo and website
@REM FOR /d /r . %%d IN (.history) DO @IF EXIST "%%d" rd /s /q "%%d"
@REM jupyter-book build "..\C769-ROM3\"
@REM xcopy /s /e /h /i /y "..\C769-ROM3" "..\github_book_repo\C769-ROM3"
@REM cd "..\github_book_repo\C769-ROM3"
@REM git add ./*
@REM git commit -m "%Message%"
@REM git push
@REM ghp-import -n -p -f _build/html
@REM start https://ashejim.github.io/C769-ROM3/intro_ROM3.html
