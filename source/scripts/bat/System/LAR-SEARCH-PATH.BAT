::LAR-SEARCH-PATH.BAT Version 0.1
::......................................................................................................................
:: Description:
::   A handy little batch file that will search everything in your PATH for the first occurance of a file.
::
:: History:
::   - v0.1 2019-12-02 Initial versioned release with embedded documentation
::
:: Remarks:
::   The magical little bit is the %%~dp$PATH:i in the FOR loop. %%~dp will expand the next variable to
::   the drive letter and path only. The $PATH:i searches the path for the first occurance of %%i which 
::   is the filename that is passed into the FOR loop. 
::
::   Inspired by https://stackoverflow.com/questions/638301/discover-from-a-batch-file-where-is-java-installed.
::
::   Sample: LAR-SEARCH-PATH java.exe
::......................................................................................................................
@ECHO OFF
SETLOCAL EnableDelayedExpansion

:: default help
CALL LAR-HELP.BAT "%~f0" "%~1" & IF DEFINED -help GOTO :EOF

:: check for empty argument
IF "%~1" EQU "" ECHO. & ECHO filename cannot be empty & ENDLOCAL & GOTO :eof

:: inspect the path
FOR %%i IN (%1) DO (
    SET p=%%~dp$PATH:i
    IF "!p!"=="" (
        ECHO %1 not found
    ) ELSE (
        ECHO !p!%1
    )
)

ENDLOCAL & GOTO :eof
    
::......................................................................................................................
:::HELP:::
::
:: Searches everything in your PATH for the first occurance of a file.
::
::   LAR-SEARCH-PATH FileName [-v] [/?]
::   FileName   The name of the file to be searched
::   -v         Shows the batch version
::   /?         Shows this help