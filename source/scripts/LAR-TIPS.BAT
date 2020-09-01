::LAR-TIPS.BAT Version 0.1
::......................................................................................................................
:: Description:
::   Some tips and tricks related to batch programming.
::
:: History:
::   - v0.1 2019-12-03 Initial versioned release with embedded documentation
::......................................................................................................................
@ECHO OFF
SETLOCAL

:: default help
CALL LAR-HELP.BAT "%~f0" "%~1" & IF DEFINED -help GOTO :eof

ECHO    %%*      - for all command line parameters (excluding the script name itself)
ECHO    %%0      - the command used to call the batch file (could be foo, ..\foo, c:\bats\foo.bat, etc.)
ECHO    %%1      - is the first command line parameter"
ECHO    %%2      - is the second command line parameter, and so on till %9 (and SHIFT can be used for those after the 9th)
ECHO    %%~nx0   - the actual name of the batch file, regardless of calling method (some-batch.bat)
ECHO    %%~dp0   - drive and path to the script (d:\scripts)
ECHO    %%~dpnx0 - is the fully qualified path name of the script (d:\scripts\some-batch.bat)
ECHO    SHIFT   - https://ss64.com/nt/shift.html

REM call LAR-PARSEARGS.BAT -option1:\ -option2:"" -option3:"teste" -flag1: -flag2:
REM call LAR-PARSEHELP.BAT "%~f0"
REM call LAR-PARSEHELP.BAT "D:\batchlib\scripts\LAR-WHERE.BAT" "/?"
REM call LAR-PARSEARGS -x -a:foo -name:"juca pirama" -y

ENDLOCAL & GOTO :eof

::......................................................................................................................
:::HELP:::
::
:: Some tips and tricks related to batch programming.
::
:: LAR-TIPS [-v] [/?]
::   -v        Shows the batch version
::   /?        Help