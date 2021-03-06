::LAR-HELP.BAT Version 0.3
::......................................................................................................................
:: Description:
::   Performs file documentation analysis.
::
:: History:
::   - v0.1 2019-10-15 Initial release including basic documentation
::   - v0.2 2019-11-29 Renamed from LAR-PARSEHELP fo LAR-HELP and using EXT-RETURN function to return -help
::   - v0.3 2019-12-03 Bug with arg1 and arg2 ordering fixed
::
:: Remarks:
::   This script has the premise that the script passed as argument has the same documentation convention as this 
::   script. In other words, the script passed as argument should have a ":::HELP:::" at the end of the script.
::
::   Sample 1: Show this script help
::   > LAR-HELP.BAT /?
::
::   Sample 2: Show another script help
::   > LAR-HELP.BAT "C:\Users\saul.kirienco\Scripts\LAR-WHERE.BAT" /?
::......................................................................................................................
@ECHO OFF
SETLOCAL

:: capture and set internal arguments
SET -arg1=-%~1- 
SET -arg1=%-arg1:"=%
SET -arg2=-%~2- 
SET -arg2=%-arg2:"=%

:: argument to be returned
SET "-help="

IF %-arg1%==-/?- (
    SET -p=%~f0 & CALL :showHelp & SET -help=1
) ELSE IF %-arg2%==-/?- (
    SET -p=%~1  & CALL :showHelp & SET -help=1
) ELSE IF %-arg1%==--v- (
    SET -p=%~f0 & CALL :showVersion & SET -help=1
) ELSE IF %-arg1%==--V- (
    SET -p=%~f0 & CALL :showVersion & SET -help=1
) ELSE IF %-arg2%==--v- (
    SET -p=%~1  & CALL :showVersion & SET -help=1
) ELSE IF %-arg2%==--V- (
    SET -p=%~1  & CALL :showVersion & SET -help=1
)

CALL %~dp0\EXT-RETURN -help -help

ENDLOCAL & GOTO :eof

::......................................................................................................................
:: Shows the documentation
::
:showHelp
    SETLOCAL
    FOR /f "delims=:" %%G IN ('FINDSTR /rbn ":::HELP:::" "%-p%"') DO SET "-s=%%G"
    FOR /f "delims=: skip=%-s% tokens=1*" %%G IN ('FINDSTR /n "^" "%-p%"') DO ECHO+%%H
    ENDLOCAL & GOTO :eof

::......................................................................................................................
:: Shows the version
::
:showVersion
    SETLOCAL
    FOR %%G IN (%-p%) DO SET nameAndExt=%%~nxG
    FOR /f "delims=:" %%G IN ('FINDSTR "^::%nameAndExt%" "%-p%"') DO ECHO. & ECHO %%G
    ENDLOCAL & GOTO :eof
    
::......................................................................................................................
:::HELP:::
::
:: Performs batch file analysis discovering and displaying documentation if any. Documentation should follow the 
:: convention defined at the end of the script.
::
::   LAR-HELP <FilePath> [-v] [/?]
::   FilePath   File path to parse
::   -v         Shows the batch version
::   /?         Shows this help