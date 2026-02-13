@echo off

set RESULT=
set USER=%~1
if "x%USER%" == "x" (
  set USER=root
)

dialog --ascii-lines --begin 5 5  --menu "Server to login (user: %USER%)" -1 0 0 ^
   Terra       "terra.internal        S null" ^
   "  Phaeton" "phaeton.internal    V S null" ^
   Inky        "inky.internal         D null" ^
   Io          "io.internal           S vasilkovo" ^
   Europa      "europa.internal       S vasilkovo" ^
   Mimas       "mimas.internal        S chanovo" ^
   Ariel       "ariel.internal        S yasenevof" ^
   Ixion       "ixion.local           S shodnenskaya4" ^
   (old)Ixion  "ixion.home.arpa       S shodnenskaya4" ^
   Makemake    "makemake.internal     S shodnenskaya5" ^
   Proxima     "proxima.external      S web" ^
   2> dialogresult.bak
set /p RESULT=<dialogresult.bak
del dialogresult.bak           

FOR /F "tokens=*" %%A IN ("%RESULT%") DO (
    SET "TRIMRESULT=%%A"
)
cls

if not "x%TRIMRESULT%" == "x" (
  if "%TRIMRESULT%" == "Terra" ssh %USER%@terra.internal
  if "%TRIMRESULT%" == "Phaeton" ssh %USER%@phaeton.internal
  if "%TRIMRESULT%" == "Inky" ssh %USER%@inky.internal
  if "%TRIMRESULT%" == "Io" ssh %USER%@io.internal
  if "%TRIMRESULT%" == "Europa" ssh %USER%@europa.internal
  if "%TRIMRESULT%" == "Ariel" ssh %USER%@ariel.internal
  if "%TRIMRESULT%" == "Mimas" ssh %USER%@mimas.internal
  if "%TRIMRESULT%" == "Ixion" ssh %USER%@ixion.local
  if "%TRIMRESULT%" == "(old)Ixion" ssh %USER%@192.168.21.7
  if "%TRIMRESULT%" == "Makemake" ssh %USER%@makemake.internal
  if "%TRIMRESULT%" == "Proxima" ssh %USER%@proxima.external
)

@echo on
