@echo off

set repoauthor=anghelos
set reponame=vanier=Lightburn-config

:: Check if repoauthor has been set
IF NOT "%repoauthor%"=="%repoauthor:YOUR GITHUB USERNAME=%" (
    goto:repoauthormissing
)

set remotesource=https://github.com/%repoauthor%/%reponame%.git

:: Check if git is installed
git version >nul 2>&1 || goto :giterror

cd %localappdata%\Lightburn || goto :othererror

IF NOT EXIST ".gitignore" (
    echo .gitignore not found, creating one...
    :: create .gitignore file with some default entries
    echo /backup >> .gitignore
    echo /presets >> .gitignore
    echo *.old >> .gitignore
)

IF NOT EXIST ".git" (
    echo .git folder not found, initializing repository...
    git init || goto :othererror
    git remote add origin %remotesource% || goto :othererror
)

::store current username in a file
IF NOT EXIST "username.txt" (
    echo username.txt not found, creating one...
    echo %USERNAME% > username.txt
)

git add .
git commit -m "Update config with batch shortcut"
git branch -M main
git push -u origin main

ECHO: & ECHO -------------- & ECHO: & ECHO Done! & ECHO: & ECHO -------------- &  ECHO: & PAUSE 

exit /b 0

:giterror
:: Throw error if git is not installed
ECHO: & ECHO -------------- & ECHO: & ECHO You need to install git first! & ECHO: & ECHO You can download it here: https://git-scm.com/download/win & ECHO -------------- &  ECHO: & PAUSE

exit /b 0

:othererror
:: Throw error if something else went wrong
ECHO: & ECHO -------------- & ECHO: & ECHO Something went wrong! See error above. & ECHO: & ECHO -------------- &  ECHO: & PAUSE

exit /b 0

:repoauthormissing
:: Throw error if repoauthor has not been set
ECHO: & ECHO -------------- & ECHO: & ECHO You forgot to set your GitHub username in the script. & ECHO Please change the author and repository names and try again. & ECHO: & ECHO -------------- &  ECHO: & PAUSE