@echo off
setlocal EnableExtensions EnableDelayedExpansion
set "work=%TEMP%\DatZB005 smoke %RANDOM%-%RANDOM%"
mkdir "%work%" || exit /b 1
copy /y "%~dp010.bat" "%work%\10.bat" >nul || exit /b 1
copy /y "%~dp0rekinat.bat" "%work%\rekinat.bat" >nul || exit /b 1
pushd "%work%" || exit /b 1
set /a passed=0
type nul >expected-log.txt

call :calculate 3 4 "+" "3+4=7" none || goto fail
call :calculate 20 8 "-" "20-8=12" 1 2 || goto fail
call :calculate 3 4 "*" "3*4=12" 1 2 || goto fail
call :calculate 24 2 "/" "24/2=12" 1 2 || goto fail
call :calculate 3 99 "2" "3^2=9" none || goto fail
call :calculate 0 0 "+" "0+0=0" none || goto fail
call :calculate 8 1 "+" "8+1=9" none || goto fail
call :calculate 9 1 "+" "9+1=10" 1 0 || goto fail
call :calculate 98 1 "+" "98+1=99" 9 9 || goto fail
call :calculate 99 1 "+" "99+1=100" none || goto fail
call :calculate -11 1 "+" "-11+1=-10" 1 0 || goto fail
call :calculate -100 1 "+" "-100+1=-99" 9 9 || goto fail
call :calculate -99 -1 "+" "-99+-1=-100" none || goto fail
call :calculate -7 2 "/" "-7/2=-3" none || goto fail
call :calculate 0008 -0002 "+" "8+-2=6" none || goto fail
call :calculate -4 99 "2" "-4^2=16" 1 6 || goto fail
call :calculate 2147483647 0 "+" "2147483647+0=2147483647" none || goto fail
call :calculate -2147483648 0 "+" "-2147483648+0=-2147483648" none || goto fail

call :reject 3 0 "/" "Kluda: dalisana ar nulli." || goto fail
call :reject 3 -0000 "/" "Kluda: dalisana ar nulli." || goto fail
call :reject 3 4 "bad" "Kluda: nederiga operacija." || goto fail
call :reject "" 4 "+" "Kluda: ievadiet divus veselus skaitlus" || goto fail
call :reject 3 abc "+" "Kluda: ievadiet divus veselus skaitlus" || goto fail
call :reject 3 "1+2" "+" "Kluda: ievadiet divus veselus skaitlus" || goto fail
call :reject 2147483648 0 "+" "Kluda: ievadiet divus veselus skaitlus" || goto fail

rem Drive the real menu: invalid numbers, invalid choices, repeat, then exit.
>input.txt (
    echo abc
    echo 4
    echo.
    echo 5
    echo invalid
    echo.
    echo +
    echo invalid
    echo Y
    echo 3
    echo 4
    echo *
    echo N
    echo x
)
mkdir caller || goto fail
pushd caller || goto fail
cmd /d /c call "..\10.bat" <"..\input.txt" >"..\output.txt" 2>&1
set "status=!errorlevel!"
popd
if not "!status!"=="0" goto fail
for %%S in ("Ievadiet veselu skaitli." "Nederigs parametrs." "Ievadiet y vai n." "4+5=9" "1. cipars=1" "2. cipars=2" "Programma partrauc darbu!!!" "Bye!!!") do (
    findstr /l /c:%%S output.txt >nul || goto fail
)
findstr /l /c:"3*4=12" output.txt >nul || goto fail
>>expected-log.txt echo 4+5=9
>>expected-log.txt echo 3*4=12
fc /b expected-log.txt log.txt >nul || goto fail
if exist caller\log.txt goto fail
set /a passed+=1

rem A calculation error returns to the first prompt, without logging it.
>input.txt (
    echo 3
    echo 0
    echo /
    echo 8
    echo 2
    echo /
    echo n
    echo x
)
cmd /d /c call "10.bat" <input.txt >output.txt 2>&1
if errorlevel 1 goto fail
findstr /l /c:"Kluda: dalisana ar nulli." output.txt >nul || goto fail
findstr /l /c:"8/2=4" output.txt >nul || goto fail
>>expected-log.txt echo 8/2=4
fc /b expected-log.txt log.txt >nul || goto fail
set /a passed+=1

echo PASS: !passed! smoke cases.
popd
rmdir /s /q "%work%"
exit /b 0

:calculate
set "expected=%~4"
call "rekinat.bat" "%~1" "%~2" "%~3" >output.txt 2>&1
if errorlevel 1 exit /b 1
findstr /l /x /c:"!expected!" output.txt >nul || exit /b 1
>>expected-log.txt echo !expected!
fc /b expected-log.txt log.txt >nul || exit /b 1
if "%~5"=="none" (
    findstr /l /x /c:"Skaitlis nav divciparu" output.txt >nul || exit /b 1
    findstr /l /c:"cipars=" output.txt >nul && exit /b 1
) else (
    findstr /l /x /c:"1. cipars=%~5" output.txt >nul || exit /b 1
    findstr /l /x /c:"2. cipars=%~6" output.txt >nul || exit /b 1
    findstr /l /c:"Skaitlis nav divciparu" output.txt >nul && exit /b 1
)
set /a passed+=1
exit /b 0

:reject
call "rekinat.bat" "%~1" "%~2" "%~3" >output.txt 2>&1
if not errorlevel 1 exit /b 1
findstr /l /c:"%~4" output.txt >nul || exit /b 1
fc /b expected-log.txt log.txt >nul || exit /b 1
set /a passed+=1
exit /b 0

:fail
echo FAIL after !passed! smoke cases. Output:
if exist output.txt type output.txt
echo Test files kept at: %work%
popd
exit /b 1
