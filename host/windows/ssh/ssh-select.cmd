@echo off

set RESULT=
set USER=%~1
if "x%USER%" == "x" (
  set USER=root
)

dialog --ascii-lines --begin 5 5  --menu "Server to login (user: %USER%)" -1 0 0 ^
   Terra    "terra.internal    (void)" ^
   Io       "io.internal       (vasilkovo)" ^
   Europa   "europa.internal   (vasilkovo)" ^
   Mimas    "mimas.internal    (chanovo)" ^
   Ariel    "ariel.internal    (yasenevof)" ^
   Ixion    "ixion.home.arpa   (shodnenskaya4)" ^
   Makemake "makemake.internal (shodnenskaya5)" ^
   Proxima  "proxima.external  (web)" ^
   2> dialogresult.bak
set /p RESULT=<dialogresult.bak
del dialogresult.bak           
cls

if not "x%RESULT%" == "x" (
  if "%RESULT%" == "Terra" ssh %USER%@terra.internal
  if "%RESULT%" == "Io" ssh %USER%@io.internal
  if "%RESULT%" == "Europa" ssh %USER%@europa.internal
  if "%RESULT%" == "Ariel" ssh %USER%@ariel.internal
  if "%RESULT%" == "Mimas" ssh %USER%@mimas.internal
  if "%RESULT%" == "Ixion" ssh %USER%@ixion.home.arpa
  if "%RESULT%" == "Makemake" ssh %USER%@makemake.internal
  if "%RESULT%" == "Proxima" ssh %USER%@proxima.external
)

@echo on
