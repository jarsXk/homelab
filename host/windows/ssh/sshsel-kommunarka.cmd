@echo off
cls

echo Server to login (kommunarka):
echo  [1] Terra
echo  [2] Vesta prime
echo  [3]   Vesta docker
echo  [4]   Vesta hplip
echo  [5] Victoria
echo  [q] quit
choice /c 12345q /cs
if %ERRORLEVEL% == 1 ssh lesha@terra.internal
if %ERRORLEVEL% == 2 ssh lesha@vesta.internal
if %ERRORLEVEL% == 3 ssh lesha@vesta-docker.internal
if %ERRORLEVEL% == 4 ssh lesha@vesta-hplip.internal
if %ERRORLEVEL% == 5 ssh root@victoria.internal
if %ERRORLEVEL% == 6 echo Exiting...

@echo on