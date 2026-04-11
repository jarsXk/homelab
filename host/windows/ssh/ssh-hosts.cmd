@echo off

set RESULT=
set USER=%~1
if "x%USER%" == "x" (
  set USER=root
)

dialog --ascii-lines --begin 5 5  --menu "Server to login (user: %USER%)" -1 0 0 ^
   Terra           "terra.lan     null" ^
   Moon "" ^
   "  Mani"        "mani.lan      null" ^
   "  Luna"        "luna.lan      null" ^
   "  Selena"      "selena.lan    null" ^
   "  Hina"        "              null" ^
   "    Phaeton"   "phaeton.lan   null" ^
   "    MoonAdmin" "moonadmin.lan null" ^
   "    MoonMedia" "moonmedia.lan null" ^
   "    MoonDNS"   "moondns.lan   null" ^
   "    MoonProxy" "moonproxy.lan null" ^
   Inky            "inky.lan      null" ^
   Io              "io.lan        vasilkovo" ^
   Europa          "europa.lan    vasilkovo" ^
   Mimas           "mimas.lan     chanovo" ^
   Ariel           "ariel.lan     yasenevof" ^
   Ixion@yaf       "172.20.13.21  yasenevof" ^
   Makemake@yaf    "172.20.13.22  yasenevof" ^
   Ixion           "ixion.lan     shodnenskaya4" ^
   Makemake        "makemake.lan  shodnenskaya5" ^
   Proxima         "proxima.wan   web" ^
   2> dialogresult.bak
set /p RESULT=<dialogresult.bak
del dialogresult.bak           

set TRIMRESULT=%RESULT: =%
cls

if not "x%TRIMRESULT%" == "x" (
  if "%TRIMRESULT%" == "Terra" ssh %USER%@terra.lan
  if "%TRIMRESULT%" == "Mani" ssh %USER%@mani.lan
  if "%TRIMRESULT%" == "Luna" ssh %USER%@luna.lan
  if "%TRIMRESULT%" == "Selena" ssh %USER%@selena.lan
  if "%TRIMRESULT%" == "Inky" ssh %USER%@inky.lan
  if "%TRIMRESULT%" == "Phaeton" ssh %USER%@phaeton.lan
  if "%TRIMRESULT%" == "MoonAdmin" ssh %USER%@moonadmin.lan
  if "%TRIMRESULT%" == "MoonMedia" ssh %USER%@moonmedia.lan
  if "%TRIMRESULT%" == "MoonDNS" ssh %USER%@moondns.lan
  if "%TRIMRESULT%" == "MoonProxy" ssh %USER%@moonproxy.lan
  if "%TRIMRESULT%" == "Io" ssh %USER%@io.lan
  if "%TRIMRESULT%" == "Europa" ssh %USER%@europa.lan
  if "%TRIMRESULT%" == "Mimas" ssh %USER%@mimas.lan
  if "%TRIMRESULT%" == "Ariel" ssh %USER%@ariel.lan
  if "%TRIMRESULT%" == "Ixion@yaf" ssh %USER%@172.20.13.21
  if "%TRIMRESULT%" == "Makemake@yaf" ssh %USER%@172.20.13.22
  if "%TRIMRESULT%" == "Ixion" ssh %USER%@ixion.lan
  if "%TRIMRESULT%" == "Makemake" ssh %USER%@makemake.lan
  if "%TRIMRESULT%" == "Proxima" ssh %USER%@proxima.wan
)

@echo on
