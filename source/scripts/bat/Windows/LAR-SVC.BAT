::LAR-SVC-REM.BAT Version 0.7
::......................................................................................................................
:: Description:
::   Communicates with Service Control Manager interacting with services.
::
:: History:
::   - v0.1 2020-18-08 Initial versioned release with embedded documentation
::   - v0.2 2020-20-08 Added more command options (start, stop and delete)
::   - v0.3 2020-20-08 Renamed from LAR-SVC-REM.BAT to LAR-SVC
::   - v0.4 2020-21-08 Now it can start, stop, delete or search
::   - v0.5 2020-21-08 Now it can install
::   - v0.6 2020-21-08 Delete is now uninstall
::   - v0.7 2020-24-08 Start with parameters
::
:: Remarks:
::   Inspired by
::     -> https://www.robvanderwoude.com/battech_redirection.php
::     -> https://docs.microsoft.com/en-us/windows-server/administration/windows-commands/sc-delete
::     -> https://serverfault.com/questions/17243/starting-stopping-a-service-on-a-remote-server
::     -> https://stackoverflow.com/questions/19730396/remote-sc-openscmanager-query-failed-5-access-denied/30787763
::     -> https://stackoverflow.com/questions/7077325/windows-bat-file-undo-net-use
::     -> https://stackoverflow.com/questions/76074/how-can-i-delete-a-service-in-windows
::     -> https://stackoverflow.com/questions/14691494/check-if-command-was-successful-in-a-batch-file
::     -> https://stackoverflow.com/questions/46323963/batch-pipe-command-output-to-variable-and-compare
::     -> https://stackoverflow.com/questions/6026773/batch-script-with-for-loop-and-pipe
::     -> https://stackoverflow.com/questions/8438511/if-or-if-in-a-windows-batch-file
::     -> https://stackoverflow.com/questions/9799763/was-unexpected-at-this-time-batch-script/47280752
::     -> https://stackoverflow.com/questions/1964192/removing-double-quotes-from-variables-in-batch-file-creates-problems-with-cmd-en
::     -> http://dotnetlearners.com/windowsservice/installing-windows-service-using-sc-exe-in-windows-command-prompt
::     -> https://serverfault.com/questions/143367/how-to-start-a-service-with-certain-start-parameters-on-windows
::     -> https://stackoverflow.com/questions/3663331/when-creating-a-service-with-sc-exe-how-to-pass-in-context-parameters
::
::   Sample 1: LAR-SVC.BAT -service:"TcpWinSvc"
::   Sample 2: LAR-SVC.BAT -service:"TcpWinSvc" -command:"uninstall" -server:"\\INTTRA" -user:"INTRANET\fabio.sistemas" -pass:"XXX"
::   Sample 3: LAR-SVC.BAT -service:"TcpWinSvc" -command:"start" -args:"silent bruteforce"
::......................................................................................................................
@ECHO OFF
SETLOCAL EnableDelayedExpansion

:: default help
CALL LAR-HELP.BAT "%~f0" "%~1" & IF DEFINED -help GOTO :eof

:: parse the arguments
SET -server=& SET -user=& SET -pass=& SET -binPath=& SET -command=& SET -service=
CALL LAR-ARGS-ADD %*
IF NOT DEFINED -server SET -server=\\LOCALHOST
IF NOT DEFINED -user SET -user=NULL
IF NOT DEFINED -pass SET -pass=NULL
IF NOT DEFINED -binPath set -binPath=NULL
IF NOT DEFINED -command SET -command=search
IF NOT DEFINED -args SET "-args= "
IF NOT DEFINED -service ECHO -service=not defined & ENDLOCAL & GOTO :eof

:: security
SET "-security=%-pass% /USER:%-user%"

:: a simple "FOR" can be used in a single line to act as an "OR" condition
FOR %%a in (%-user% %-pass%) DO IF %%a==NULL SET "-security= "

:: connect to a network resource
NET USE %-server%\ADMIN$ %-security% >NUL

:: check if service exists
CALL EXT-OUTPUT.BAT "SC %-server% QUERY state=all | FINDSTR /r /c:""SERVICE_NAME: %-service%""" >NUL

:: run the expected command
IF %out%=="SERVICE_NAME: %-service%" (
    IF %-command%==install (
        ECHO "Service already exists"
    ) ELSE (
        IF %-command%==start (
            SC %-server% START %-service% %-args%
        ) ELSE (
            IF %-command%==stop (
                SC %-server% STOP %-service%
            ) ELSE (
                IF %-command%==uninstall (
                    SC %-server% STOP %-service% >NUL
                    SC %-server% DELETE %-service%
                ) ELSE (
                    IF %-command%==search (
                        ECHO "Service found"
                    ) ELSE (
                        ECHO "Command %-command% not found"
                    )
                )
            ) 
        )
    )    
) ELSE (
    IF %-command%==install (
        SC %-server% CREATE %-service% binPath="%-binPath%"
    ) ELSE (
        ECHO "Service NOT found"
    )
)

:: disconnect from a network resource
NET USE %-server%\ADMIN$ /DELETE >NUL

ENDLOCAL & GOTO :eof
    
::......................................................................................................................
:::HELP:::
::
:: Interact with services: install, start, stop, uninstall or search.
::
::   LAR-SVC.BAT <-service:""> [<-server:"">] [<-user:"">] [<-pass:"">] [<-command:"">] [-v] [/?]
::   -service   The name of the service to be removed
::   -command   (optional, default=search) The command to be executed: install, start, stop, uninstall or search
::   -binPath   (optional) The service full path uset to install it
::   -server    (optional) The server in the form "\\ServerName"
::   -user      (optional) The user name
::   -pass      (optional) The user password
::   -args      (optional) Arguments
::   -v         Shows the batch version
::   /?         Shows this help