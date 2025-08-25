@echo off
cls

echo Server to login (void):
echo  [1] Terra
REM echo  [2] Vesta prime
REM echo  [3]   Vesta docker
REM echo  [4]   Vesta hplip
REM echo  [5] Victoria
echo  [q] quit
REM choice /c 12345q /cs
choice /c 1q /cs
if %ERRORLEVEL% == 1 ssh lesha@terra.internal
REM if %ERRORLEVEL% == 2 ssh lesha@vesta.internal
REM if %ERRORLEVEL% == 3 ssh lesha@vesta-docker.internal
REM if %ERRORLEVEL% == 4 ssh lesha@vesta-hplip.internal
REM if %ERRORLEVEL% == 5 ssh root@victoria.internal
if %ERRORLEVEL% == 6 echo Exiting...

@echo on