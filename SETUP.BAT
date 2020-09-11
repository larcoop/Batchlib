::SETUP.BAT Version 0.1
::......................................................................................................................
:: Description:
::   Performs file documentation analysis.
::
:: History:
::   - v0.1 2019-12-03 Initial release including basic documentation
::
:: Remarks:
::   Creates the environment variable to batchlib path.
::......................................................................................................................
@ECHO OFF
SETLOCAL

:: default help
CALL %~dp0scripts\LAR-HELP.BAT "%~f0" "%~1" & IF DEFINED -help GOTO :EOF

:: if not yet on the path, add -newvar to -newpath
SET -newvar=%~dp0scripts
ECHO %PATH%|FIND /i "%-newvar:"=%">nul || SET -newpath=%PATH%;%-newvar%

:: check if it has something to persist
IF NOT DEFINED -newpath (
    ECHO Nothing to do.
    ECHO %-newvar% already on PATH
) ELSE (
    ECHO Configuring batchlib.
    %~dp0tools\SetEnv -ua PATH %%%-newvar%%
    ECHO %-newvar% set to PATH
)

PAUSE

ENDLOCAL & GOTO :eof
::......................................................................................................................
:::HELP:::
::
:: Creates the environment variable to batchlib path.
::
::   SETUP [-v] [/?]
::   -v         Shows the batch version
::   /?         Shows this help