@echo off
SET /P Message=Enter git C769-ROM3 commit comment:
title C769-ROM3: compile html, save to repo folder, update GitHub repo and website
@REM Assuming we are in the C769 general folder
FOR /d /r . %%d IN (.history) DO @IF EXIST "%%d" rd /s /q "%%d"
jupyter-book build "..\C769-ROM3\"
echo "Compiling local ..\C769-ROM3 ..."
@REM xcopy /s /e /h /i /y "..\C769-ROM3" "..\github_book_repo\C769-ROM3"
@REM echo "Copied local book to ..\jupyter-books\github_book_repo\C769-ROM3"
cd "..\github_book_repo\C769-ROM3" 
git add ./*
git commit -m "%Message%"
echo "Commited..."
git push
echo "Pushed..."
ghp-import -n -p -f _build/html
echo "Imported to git page..."
start https://ashejim.github.io/C769-ROM3/intro_ROM3.html
echo "Gitpage may take a few minutes to update. END"
cd cd ..\..\C769-ROM3\upo   


@REM OLD update bat. prev I kept working files in separate folder than than the repo folder.

@REM @echo off
@REM SET /P Message=Enter git C769-ROM3 commit comment:
@REM title C769-ROM3: compile html, save to repo folder, update GitHub repo and website
@REM @REM Assuming we are in the C769 general folder
@REM FOR /d /r . %%d IN (.history) DO @IF EXIST "%%d" rd /s /q "%%d"
@REM jupyter-book build "..\C769-ROM3\"
@REM echo "Compiling local ..\jupyter-books\C769-ROM3 ..."
@REM xcopy /s /e /h /i /y "..\C769-ROM3" "..\github_book_repo\C769-ROM3"
@REM echo "Copied local book to ..\jupyter-books\github_book_repo\C769-ROM3"
@REM cd "..\github_book_repo\C769-ROM3" 
@REM git add ./*
@REM git commit -m "%Message%"
@REM echo "Commited..."
@REM git push
@REM echo "Pushed..."
@REM ghp-import -n -p -f _build/html
@REM echo "Imported to git page..."
@REM start https://ashejim.github.io/C769-ROM3/intro_ROM3.html
@REM echo "Gitpage may take a few minutes to update. END"
@REM cd cd ..\..\C769-ROM3\upo   