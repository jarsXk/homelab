@echo off
cls

echo Server to login (vasilkovo):
echo  [1] Io
echo  [2] Europa
echo  [q] quit
choice /c 12q /cs
if %ERRORLEVEL% == 1 ssh lesha@io.internal
if %ERRORLEVEL% == 2 ssh lesha@europa.internal
if %ERRORLEVEL% == 3 echo Exiting...

@echo on