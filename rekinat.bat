@echo off
setlocal EnableExtensions EnableDelayedExpansion
set "first=%~1"
set "second=%~2"
set "operation=%~3"
call :decimal first
if errorlevel 1 goto invalid_number
call :decimal second
if errorlevel 1 goto invalid_number

set "result="
if "!operation!"=="+" set /a "result=first+second"
if "!operation!"=="-" set /a "result=first-second"
if "!operation!"=="*" set /a "result=first*second"
if "!operation!"=="/" (
    if !second! equ 0 goto divide_by_zero
    set /a "result=first/second"
)
if "!operation!"=="2" set /a "result=first*first"
if not defined result goto invalid_operation

set "expression=!first!!operation!!second!"
if "!operation!"=="2" set "expression=!first!^2"
echo Rezultats:
echo !expression!=!result!
>>"%~dp0log.txt" echo !expression!=!result!
if errorlevel 1 exit /b 1

set "digits=!result!"
if "!digits:~0,1!"=="-" set "digits=!digits:~1!"
if "!digits:~1,1!"=="" goto not_two_digits
if not "!digits:~2,1!"=="" goto not_two_digits
echo Aprekinatais rezultats ir "!result!"
echo 1. cipars=!digits:~0,1!
echo 2. cipars=!digits:~1,1!
exit /b 0

:not_two_digits
echo Skaitlis nav divciparu
exit /b 0

:divide_by_zero
echo Kluda: dalisana ar nulli.
exit /b 1

:invalid_operation
echo Kluda: nederiga operacija. Izvelieties +, -, *, / vai 2.
exit /b 1

:invalid_number
echo Kluda: ievadiet divus veselus skaitlus 32 bitu diapazona.
exit /b 1

:decimal
set "digits=!%~1!"
set "sign="
if "!digits:~0,1!"=="-" (
    set "sign=-"
    set "digits=!digits:~1!"
)
if not defined digits exit /b 1
set "invalid=!digits!"
for %%D in (0 1 2 3 4 5 6 7 8 9) do set "invalid=!invalid:%%D=!"
if defined invalid exit /b 1

:trim_zero
if "!digits!"=="0" goto decimal_ready
if not "!digits:~0,1!"=="0" goto decimal_ready
set "digits=!digits:~1!"
goto trim_zero

:decimal_ready
if not "!digits:~10,1!"=="" exit /b 1
set "limit=2147483647"
if defined sign set "limit=2147483648"
if not "!digits:~9,1!"=="" if "!digits!" gtr "!limit!" exit /b 1
set /a "%~1=!sign!!digits!" >nul 2>&1
exit /b !errorlevel!

rem Autors: Adams Duckens; programmas virziens: ITIA; grupa: 1.
