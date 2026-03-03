@echo off

set RESULT=
set USER=%~1
if "x%USER%" == "x" (
  set USER=root
)

dialog --ascii-lines --begin 5 5  --menu "Server to login (user: %USER%)" -1 0 0 ^
   Terra       "terra.local         S null" ^
   "  Phaeton" "phaeton.local     V S null" ^
   Moon        "" ^
   "  Hina"    "hina.local          S null" ^
   "  Luna"    "luna.local          S null" ^
   "  Selena"  "selena.local        S null" ^
   Inky        "inky.local          D null" ^
   Io          "io.local            S vasilkovo" ^
   Europa      "europa.local        S vasilkovo" ^
   Mimas       "mimas.internal      S chanovo" ^
   Ariel       "ariel.local         S yasenevof" ^
   Ixion       "ixion.local         S shodnenskaya4" ^
   (old)Ixion  "ixion.home.arpa     S shodnenskaya4" ^
   Makemake    "makemake.internal   S shodnenskaya5" ^
   Proxima     "proxima.ecto        S web" ^
   2> dialogresult.bak
set /p RESULT=<dialogresult.bak
del dialogresult.bak           

FOR /F "tokens=*" %%A IN ("%RESULT%") DO (
    SET "TRIMRESULT=%%A"
)
cls

if not "x%TRIMRESULT%" == "x" (
  if "%TRIMRESULT%" == "Terra" ssh %USER%@terra.local
  if "%TRIMRESULT%" == "Phaeton" ssh %USER%@phaeton.local
  if "%TRIMRESULT%" == "Hina" ssh %USER%@hina.local
  if "%TRIMRESULT%" == "Luna" ssh %USER%@luna.local
  if "%TRIMRESULT%" == "Selena" ssh %USER%@selena.local
  if "%TRIMRESULT%" == "Inky" ssh %USER%@inky.local
  if "%TRIMRESULT%" == "Io" ssh %USER%@io.local
  if "%TRIMRESULT%" == "Europa" ssh %USER%@europa.local
  if "%TRIMRESULT%" == "Ariel" ssh %USER%@ariel.local
  if "%TRIMRESULT%" == "Mimas" ssh %USER%@mimas.internal
  if "%TRIMRESULT%" == "Ixion" ssh %USER%@ixion.local
  if "%TRIMRESULT%" == "(old)Ixion" ssh %USER%@192.168.21.7
  if "%TRIMRESULT%" == "Makemake" ssh %USER%@makemake.internal
  if "%TRIMRESULT%" == "Proxima" ssh %USER%@proxima.ecto
)

@echo on
