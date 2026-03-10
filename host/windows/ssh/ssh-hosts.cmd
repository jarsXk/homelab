@echo off

set RESULT=
set USER=%~1
if "x%USER%" == "x" (
  set USER=root
)

dialog --ascii-lines --begin 5 5  --menu "Server to login (user: %USER%)" -1 0 0 ^
   Terra         "terra.local       null" ^
   Moon "" ^
   "  Hina"      "hina.local        null" ^
   "  Luna"      "luna.local        null" ^
   "  Selena"    "selena.local      null" ^
   "    Phaeton" "phaeton.local     null" ^
   Inky          "inky.local        null" ^
   Io            "io.local          vasilkovo" ^
   Europa        "europa.local      vasilkovo" ^
   Mimas         "mimas.internal    chanovo" ^
   Ariel         "ariel.local       yasenevof" ^
   Ixion         "ixion.local       shodnenskaya4" ^
   (old)Ixion    "ixion.home.arpa   shodnenskaya4" ^
   Makemake      "makemake.internal shodnenskaya5" ^
   Proxima       "proxima.ecto      web" ^
   2> dialogresult.bak
set /p RESULT=<dialogresult.bak
del dialogresult.bak           

set TRIMRESULT=%RESULT: =%
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
