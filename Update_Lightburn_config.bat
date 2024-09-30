mode con: cols=60 lines=16
@echo off
echo:
echo Updating Lightburn Config

set repoauthor=YOUR GITHUB USERNAME
set reponame=YOUR GITHUB REPOSITORY NAME

:: Check if repoauthor has been set
IF NOT "%repoauthor%"=="%repoauthor:YOUR GITHUB USERNAME=%" (
    goto:repoauthormissing
)

set remotesource=https://github.com/%repoauthor%/%reponame%.git

:: Check if git is installed
git version >nul 2>&1 || goto :giterror
git clone %remotesource% --quiet || goto:othererror

set source=%CD%/%reponame%
set destination=%localappdata%\Lightburn
set librarydestination=C:\Lightburn_Libraries

robocopy %source% %librarydestination% *.clb /move
robocopy %source% %destination% /move

echo:
echo --------------
echo:
echo Lightburn Config Updated
echo Cleaning up...
timeout /t 1 /nobreak >nul
RD /S /Q %reponame%

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