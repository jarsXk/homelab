@echo off
cls

echo Server to login (kommunarka):
echo  [1] Terra prime
echo  [2]   Terra docker
echo  [3]   Terra nas
REM echo  [4]   Terra old
echo  [4] Vesta prime
echo  [5]   Vesta docker
echo  [6]   Vesta hplip
echo  [7] Victoria
echo  [q] quit
choice /c 1234567q /cs
if %ERRORLEVEL% == 1 ssh lesha@terra.internal
if %ERRORLEVEL% == 2 ssh lesha@terra-docker.internal
if %ERRORLEVEL% == 3 ssh lesha@terra-nas.internal
REM if %ERRORLEVEL% == 4 ssh lesha@terra-old.internal
if %ERRORLEVEL% == 4 ssh lesha@vesta.internal
if %ERRORLEVEL% == 5 ssh lesha@vesta-docker.internal
if %ERRORLEVEL% == 6 ssh lesha@vesta-hplip.internal
if %ERRORLEVEL% == 7 ssh root@victoria.internal
if %ERRORLEVEL% == 8 echo Exiting...

@echo on