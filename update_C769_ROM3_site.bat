@echo off
SET /P Message=Enter git C769-ROM3 commit comment:
title C769-ROM3: compile html, save to repo folder, update GitHub repo and website
@REM Assuming we are in the C769 general folder
FOR /d /r . %%d IN (.history) DO @IF EXIST "%%d" rd /s /q "%%d"
jupyter-book build "..\C769-ROM3\"
echo "Compiling local ..\jupyter-books\C769-ROM3 ..."
xcopy /s /e /h /i /y "..\C769-ROM3" "..\github_book_repo\C769-ROM3"
echo "Copied local book to ..\jupyter-books\github_book_repo\C769-ROM3"
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
cd cd ..\..\C769-ROM3\