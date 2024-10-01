mode con: cols=60 lines=16
@echo off
echo:
echo Updating Lightburn Config...


set repoauthor=anghelos
set reponame=vanier-lightburn-config

:: Check if repoauthor has been set
IF NOT "%repoauthor%"=="%repoauthor:YOUR GITHUB USERNAME=%" (
    goto:repoauthormissing
)

set remotesource=https://github.com/%repoauthor%/%reponame%.git

:: Check if git is installed
git version >nul 2>&1 || goto :giterror
git clone %remotesource% --quiet || goto:othererror



:: get contents of username.txt
set /p oldusername=<%reponame%\username.txt

::remove spaces from oldusername
set oldusername=%oldusername: =%

echo: & echo --------------- & echo: & echo Got files, replacing instances of %oldusername% with %username% in prefs.ini file...

:: Replace all instances of previous username with new one in prefs.ini file
start /b /wait powershell -Command "(gc %reponame%\prefs.ini) -replace '%oldusername%', '%USERNAME%' | Out-File -encoding UTF8 %reponame%\prefs.ini"

echo:
echo --------------
echo:
echo Done, moving files to Lightburn folder...

set source=%CD%/%reponame%
set destination=%localappdata%\Lightburn

robocopy %source% %destination% /move /NFL /NDL /NJH /NJS /NC

echo --------------
echo:
echo Lightburn Config Updated
echo Cleaning up...
timeout /t 3 /nobreak >nul
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