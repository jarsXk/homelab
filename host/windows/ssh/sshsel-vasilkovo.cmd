@echo off
cls

echo Server to login (vasilkovo):
echo  [1] Io
echo  [2] Europa
echo  [3]   Europa docker
echo  [q] quit
choice /c 123q /cs
if %ERRORLEVEL% == 1 ssh lesha@io.internal
if %ERRORLEVEL% == 2 ssh lesha@europa.internal
if %ERRORLEVEL% == 3 ssh lesha@europa-docker.internal
if %ERRORLEVEL% == 4 echo Exiting...

@echo on