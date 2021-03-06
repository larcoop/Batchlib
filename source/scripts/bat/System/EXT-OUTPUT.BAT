::EXT-OUTPUT.BAT Version 1.1
::......................................................................................................................
:: Description:
::   EXT-OUTPUT.BAT is a batch macro for simple capturing of command outputs, a bit like the behaviour of the bash shell.
::
:: History:
::   v1.0 2020-08-19 Original version got from https://stackoverflow.com/questions/2323292/assign-output-of-a-program-to-a-variable-using-a-ms-batch-file/54425285#54425285
::   v1.1 2019-08-19 Source code refactored and documentation customized
::
:: Remarks:
::   The usage of the macro is simple and looks like 
::   > %$set% VAR=application arg1 arg2
::
::   And it works even with pipes
::   > %$set% allDrives="wmic logicaldisk get name /value | findstr "Name""
:: 
::   If you want to iterate results in the caller
::   > for %%a in (%out%) do ( 
::   >    echo %%a
::   > )
:: 
::   Inspired by
::     -> https://stackoverflow.com/questions/28597379/what-does-1-do-in-this-batch-file
::......................................................................................................................
@ECHO OFF
SETLOCAL DisableDelayedExpansion

:: replace double quotes
SET -arg=%1
SET -arg=%-arg:""="%

:: macro for capturing command outputs
CALL:initMacro

:: call the script
%$set% script=%-arg%
CALL :setValues script

:: pass the values outside SETLOCAL barries
SET in=%wOut%& SET out=""
IF NOT DEFINED in SET in=NULL
CALL EXT-RETURN in out

GOTO :exit

:exit
    EXIT /b

:setValues
    SETLOCAL EnableDelayedExpansion
    SET wIn=& SET wOut=
    FOR /L %%n in (0 1 !%~1.max!) do (
        SET wIn=!wIn!"!%~1[%%n]!" 
    )
    CALL EXT-RETURN wIn wOut
    GOTO:eof

:initMacro
IF "!!"=="" (
    ECHO ERROR: Delayed Expansion must be disabled while defining macros
    (GOTO) 2>nul
    (GOTO) 2>nul
)
(SET LF=^
%=empty=%
)
(SET \n=^^^
%=empty=%
)

SET $set=FOR /L %%N in (1 1 2) DO IF %%N==2 ( %\n%
    SETLOCAL EnableDelayedExpansion                                 %\n%
    FOR /f "tokens=1,* delims== " %%1 in ("!argv!") DO (            %\n%
        ENDLOCAL                                                    %\n%
        ENDLOCAL                                                    %\n%
        SET "%%~1.Len=0"                                            %\n%
        SET "%%~1="                                                 %\n%
        if "!!"=="" (                                               %\n%
            %= Used if delayed expansion is enabled =%              %\n%
                SETLOCAL DisableDelayedExpansion                    %\n%
                FOR /F "delims=" %%O in ('"%%~2 | findstr /N ^^"') DO ( %\n%
                if "!!" NEQ "" (                                    %\n%
                    ENDLOCAL                                        %\n%
                    )                                               %\n%
                SETLOCAL DisableDelayedExpansion                    %\n%
                SET "line=%%O"                                      %\n%
                SETLOCAL EnableDelayedExpansion                     %\n%
                SET pathExt=:                                       %\n%
                SET path=;                                          %\n%
                SET "line=!line:^=^^!"                              %\n%
                SET "line=!line:"=q"^""!"                           %\n%
                call SET "line=%%line:^!=q""^!%%"                   %\n%
                SET "line=!line:q""=^!"                             %\n%
                SET "line="!line:*:=!""                             %\n%
                FOR /F %%C in ("!%%~1.Len!") DO (                   %\n%
                    FOR /F "delims=" %%L in ("!line!") DO (         %\n%
                        ENDLOCAL                                    %\n%
                        ENDLOCAL                                    %\n%
                        SET "%%~1[%%C]=%%~L" !                      %\n%
                        if %%C == 0 (                               %\n%
                            SET "%%~1=%%~L" !                       %\n%
                        ) ELSE (                                    %\n%
                            SET "%%~1=!%%~1!!LF!%%~L" !             %\n%
                        )                                           %\n%
                    )                                               %\n%
                    SET /a %%~1.Len+=1                              %\n%
                )                                                   %\n%
            )                                                       %\n%
        ) ELSE (                                                    %\n%
            %= Used if delayed expansion is disabled =%             %\n%
            FOR /F "delims=" %%O in ('"%%~2 | findstr /N ^^"') DO ( %\n%
                SETLOCAL DisableDelayedExpansion                    %\n%
                SET "line=%%O"                                      %\n%
                SETLOCAL EnableDelayedExpansion                     %\n%
                SET "line="!line:*:=!""                             %\n%
                FOR /F %%C in ("!%%~1.Len!") DO (                   %\n%
                    FOR /F "delims=" %%L in ("!line!") DO (         %\n%
                        ENDLOCAL                                    %\n%
                        ENDLOCAL                                    %\n%
                        SET "%%~1[%%C]=%%~L"                        %\n%
                    )                                               %\n%
                    SET /a %%~1.Len+=1                              %\n%
                )                                                   %\n%
            )                                                       %\n%
        )                                                           %\n%
        SET /a %%~1.Max=%%~1.Len-1                                  %\n%
)                                                                   %\n%
    ) ELSE SETLOCAL DisableDelayedExpansion^&SET argv=

GOTO :eof