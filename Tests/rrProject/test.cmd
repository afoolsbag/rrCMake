@ECHO OFF
CHCP 65001 > NUL
SETLOCAL ENABLEEXTENSIONS
SET script_directory=%~dp0

WHERE /Q cmake ^
        || ECHO The cmake executable not found. ^
        && CALL :pause_if_double_click ^
        && EXIT /B 1

CD "%script_directory%" ^
        || ECHO Change directory to script directory failed. ^
        && CALL :pause_if_double_click ^
        && EXIT /B 2

cmake -S "." -B "build" ^
        || ECHO Run cmake failed. ^
        && CALL :pause_if_double_click ^
        && EXIT /B 3

RMDIR /S /Q "build" ^
        || ECHO Cleanup failed after test. ^
        && CALL :pause_if_double_click ^
        && EXIT /B 4

CALL :pause_if_double_click
EXIT /B 0

:pause_if_double_click
        ECHO %CMDCMDLINE% | FINDSTR /L /B %COMSPEC% > NUL ^
                && PAUSE
        EXIT /B 0
