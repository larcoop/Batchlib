::EXT-RETURN.BAT Version 3.4
::......................................................................................................................
:: Description:
::   EXT-RETURN.BAT simulates the return concept of a function. In other words, it can safely return any value across 
::   the ENDLOCAL barrier, regardless whether the parent context has delayed expansion enabled or disabled.
::
:: History:
::   v3.0 2019-10-15 Original version got from http://www.dostips.com/forum/viewtopic.php?f=3&t=6496
::   v3.1 2019-10-18 Script renamed from RETURN.BAT to EXT-RETURN.BAT
::   v3.2 2019-10-18 Source code RETURN refactored to EXT-RETURN and documentation customized
::   v3.3 2019-10-21 Some indentation applied on labels and uppercase os commands
::   v3.4 2019-11-28 Cut some of the help docs and put it in remarks
::
:: Remarks:
::   The code is designed to be a stand-alone utility that can be placed in a folder referenced by PATH so it can 
::   easily be called by any script.
::
::   Sample 1: Copy and paste the source code above in a script <NAME>.BAT and call it
::   > @ECHO OFF
::     CALL :foo
::     ECHO value=%value% & ECHO return=%return%
::     GOTO :EOF
::     :foo
::        SETLOCAL
::        SET value=juca pirama & SET return=
::        CALL EXT-RETURN value return
::        ENDLOCAL
::
::   Result should be:
::   > value=
::     return=juca pirama
::
::   Sample 2: Copy and paste the source code above in a script <NAME>.BAT and call it:
::   > @ECHO OFF
::     CALL :foo
::     ECHO value1=%value1% & ECHO value2=%value2%
::     ECHO return1=%return1% & ECHO return2=%return2%
::     GOTO :EOF
::     :foo
::        SETLOCAL
::        SET value1=juca & SET value2=pirama & SET return1= & SET return2=
::        CALL EXT-RETURN "value1 value2" "return1 return2"
::        ENDLOCAL
::
::   Result should be:
::   > value1=
::     value2=
::     return1=juca
::     return2=pirama
::......................................................................................................................
@IF "%~2" EQU "" (GOTO :return.special) ELSE GOTO :return
:::
::: Simulates the return concept of a function.
:::
::: EXT-RETURN.BAT ValueVar ReturnVar [ErrorCode] [-v] [/?]
:::   ValueVar   The name of the local variable containing the return value.
:::   ReturnVar  The name of the variable to receive the return value.
:::   ErrorCode  The returned ERRORLEVEL, defaults to 0 if not specified.
:::   -v         Shows the batch version
:::   /?         Shows this help
:::
::: EXT-RETURN.BAT "ValueVar1 ValueVar2 ..." "ReturnVar1 ReturnVar2 ..." [ErrorCode] [-v] [/?]
:::   Same as before, except the first and second arugments are quoted and space delimited lists of variable names.
:::
::: Note that the total length of all assignments (variable names and values) must be less then 3.8k bytes. No checks 
::: are performed to verify that all assignments fit within the limit. Variable names must not contain space, tab, 
::: comma, semicolon, caret, asterisk, question mark, or exclamation point.
:return  ValueVar  ReturnVar  [ErrorCode]
  :: Safely returns any value(s) across the ENDLOCAL barrier. Default ErrorCode is 0
  SETLOCAL enableDelayedExpansion
  IF NOT DEFINED return.LF CALL :return.init
  IF NOT DEFINED return.CR CALL :return.init
  SET "return.normalCmd="
  SET "return.delayedCmd="
  SET "return.vars=%~2"
  FOR %%a IN (%~1) DO FOR /f "TOKENS=1*" %%b IN ("!return.vars!") DO (
    SET "return.normal=!%%a!"
    IF DEFINED return.normal (
      SET "return.normal=!return.normal:%%=%%3!"
      SET "return.normal=!return.normal:"=%%4!"
      FOR %%C IN ("!return.LF!") DO SET "return.normal=!return.normal:%%~C=%%~1!"
      FOR %%C IN ("!return.CR!") DO SET "return.normal=!return.normal:%%~C=%%2!"
      SET "return.delayed=!return.normal:^=^^^^!"
    ) ELSE SET "return.delayed="
    IF DEFINED return.delayed CALL :return.setDelayed
    SET "return.normalCmd=!return.normalCmd!&SET "%%b=!return.normal!"^!"
    SET "return.delayedCmd=!return.delayedCmd!&SET "%%b=!return.delayed!"^!"
    SET "return.vars=%%c"
  )
  SET "err=%~3"
  IF NOT DEFINED err SET "err=0"
  FOR %%1 IN ("!return.LF!") DO FOR /f "TOKENS=1-3" %%2 IN (^"!return.CR! %% "") DO (
    (GOTO) 2>nul
    (GOTO) 2>nul
    IF "^!^" EQU "^!" (%return.delayedCmd:~1%) ELSE %return.normalCmd:~1%
    IF %err% EQU 0 (CALL ) ELSE IF %err% EQU 1 (call) ELSE cmd /c exit %err%
  )

:return.setDelayed
  SET "return.delayed=%return.delayed:!=^^^!%" !
  exit /b

:return.special
  @IF /i "%~1" EQU "init" GOTO return.init
  @IF "%~1" EQU "/?" (
    FOR /f "TOKENS=* DELIMS=:" %%A IN ('FINDSTR "^:::" "%~f0"') DO @echo(%%A
    exit /b 0
  )
  @IF /i "%~1" EQU "-v" (
    FOR /f "TOKENS=* DELIMS=:" %%A IN ('FINDSTR /rc:"^::EXT-RETURN.BAT Version" "%~f0"') DO @echo %%A
    exit /b 0
  )
  @>&2 echo ERROR: Invalid call to EXT-RETURN.BAT
  @exit /b 1


:return.init  -  Initializes the return.LF and return.CR variables
  SET ^"return.LF=^

  ^" The empty line above is critical - DO NOT REMOVE
  FOR /f %%C IN ('copy /z "%~f0" nul') DO SET "return.CR=%%C"
  exit /b 0