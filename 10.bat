@echo off
setlocal EnableExtensions EnableDelayedExpansion

:start
call :read_number first "Ievadiet 1mo skaitli: "
call :read_number second "Ievadiet 2tro skaitli: "
cls
echo + prieks Saskaitisanas
echo - prieks Atnemsanas
echo * prieks Reizinasanas
echo / prieks Dalisanas
echo 2 prieks pakape 2
echo.

:choose
set "operation="
set /p "operation=Ievadiet parametru: "
if "!operation!"=="+" goto calculate
if "!operation!"=="-" goto calculate
if "!operation!"=="*" goto calculate
if "!operation!"=="/" goto calculate
if "!operation!"=="2" goto calculate
echo Nederigs parametrs. Izvelieties +, -, *, / vai 2.
goto choose

:calculate
call "%~dp0rekinat.bat" "!first!" "!second!" "!operation!"
if errorlevel 1 goto start
echo.
echo Programma partrauc darbu!!!

:repeat
set "again="
set /p "again=Vai atkartot (y/n)? "
if /i "!again!"=="y" goto start
if /i "!again!"=="n" goto finish
echo Ievadiet y vai n.
goto repeat

:finish
echo Bye!!!
pause
timeout /t 2 /nobreak >nul 2>&1
rem TIMEOUT needs a console; redirected smoke-test input uses the same delay.
if errorlevel 1 ping -n 3 127.0.0.1 >nul
exit /b 0

:read_number
set "%~1="
set /p "%~1=%~2"
set "digits=!%~1!"
if "!digits:~0,1!"=="-" set "digits=!digits:~1!"
if not defined digits goto bad_number
for %%D in (0 1 2 3 4 5 6 7 8 9) do if defined digits set "digits=!digits:%%D=!"
if defined digits goto bad_number
exit /b 0

:bad_number
echo Ievadiet veselu skaitli.
goto read_number

rem Autors: Adams Duckens; programmas virziens: ITIA; grupa: 1.
