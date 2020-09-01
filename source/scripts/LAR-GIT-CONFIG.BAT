::LAR-GIT-CONFIG.BAT Version 0.1
::......................................................................................................................
:: Description:
::   Create git configurations.
::
:: History:
::   - v0.1 2019-12-03 Initial versioned release with embedded documentation
::......................................................................................................................
@ECHO OFF
SETLOCAL

:: default help
CALL LAR-HELP.BAT "%~f0" "%~1" & IF DEFINED -help GOTO :eof

FOR %%I IN ("%~dp0\..") DO SET "-liblargit=%%~fI\libraries\.largit"

:: parse the arguments
CALL LAR-ARGS-ADD %*
IF NOT DEFINED -name SET "-name=not defined"
IF NOT DEFINED -email SET "-email=not defined"

:: default variables
SET -largit=%HOMEDRIVE%%HOMEPATH%\.largit
SET -gitconfig=%HOMEDRIVE%%HOMEPATH%\.gitconfig

:: delete old configurations
RMDIR /S /Q %-largit% 2>nul
DEL %-gitconfig% 2>nul

:: create a new configurations
MKDIR %-largit%
XCOPY /S /Q %-liblargit% %-largit%>nul
TYPE NUL>%-gitconfig%

:: get current encoding and then change it
FOR /f "tokens=2 delims=:." %%x IN ('chcp') DO SET cp=%%x
CHCP 65001 >nul

:: write the content of the file
ECHO [core]>> %-gitconfig%
ECHO 	autocrlf = false>> %-gitconfig%
ECHO 	symlinks = true>> %-gitconfig%
ECHO [user]>> %-gitconfig%
ECHO 	name = %-name%>> %-gitconfig%
ECHO 	email = %-email%>> %-gitconfig%
ECHO [alias]>> %-gitconfig%
ECHO 	super = !$HOMEDRIVE$HOMEPATH/.largit/super.sh>> %-gitconfig%
ECHO 	getter = !$HOMEDRIVE$HOMEPATH/.largit/getter.sh>> %-gitconfig%
ECHO 	lister = !$HOMEDRIVE$HOMEPATH/.largit/lister.sh>> %-gitconfig%
ECHO 	sender = !$HOMEDRIVE$HOMEPATH/.largit/sender.sh>> %-gitconfig%
ECHO 	updater = !$HOMEDRIVE$HOMEPATH/.largit/updater.sh>> %-gitconfig%
ECHO 	checker = !$HOMEDRIVE$HOMEPATH/.largit/checker.sh>> %-gitconfig%
ECHO 	temper = !$HOMEDRIVE$HOMEPATH/.largit/temper.sh>> %-gitconfig%
ECHO 	stater = !$HOMEDRIVE$HOMEPATH/.largit/stater.sh>> %-gitconfig%
ECHO 	wisher = !$HOMEDRIVE$HOMEPATH/.largit/wisher.sh>> %-gitconfig%

:: set old encoding
CHCP %cp%>nul

ENDLOCAL & GOTO :eof

::......................................................................................................................
:::HELP:::
::
:: Create git configurations.
::
:: LAR-GIT-CONFIG <-name:""> <-email:""> [-v] [/?]
::   -name     The name of the user
::   -email    The email of the user
::   -v        Shows the batch version
::   /?        Help
::
:: Sample: 
::    LAR-GIT-CONFIG -name:"Juca Pirama" -email:"jucapirama@lar.ind.br"