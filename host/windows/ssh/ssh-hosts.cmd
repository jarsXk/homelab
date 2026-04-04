@echo off

set RESULT=
set USER=%~1
if "x%USER%" == "x" (
  set USER=root
)

dialog --ascii-lines --begin 5 5  --menu "Server to login (user: %USER%)" -1 0 0 ^
   Terra            "terra.lan      null" ^
   Moon "" ^
   "  Mani"         "mani.lan       null" ^
   "  Luna"         "luna.lan       null" ^
   "  Selena"       "selena.lan     null" ^
   "  Hina"         "               null" ^
   "    Phaeton"    "phaeton.lan    null" ^
   "    Moon-Admin" "moon-admin.lan null" ^
   "    Moon-DNS"   "moon-dns.lan   null" ^
   "    Moon-Proxy" "moon-proxy.lan null" ^
   Inky             "inky.lan       null" ^
   Io               "io.lan         vasilkovo" ^
   Europa           "europa.lan     vasilkovo" ^
   Mimas            "mimas.lan      chanovo" ^
   Ariel            "ariel.lan      yasenevof" ^
   Ixion@yaf        "172.20.13.21   yasenevof" ^
   Makemake@yaf     "172.20.13.22   yasenevof" ^
   Ixion            "ixion.lan      shodnenskaya4" ^
   Makemake         "makemake.lan   shodnenskaya5" ^
   Proxima          "proxima.wan    web" ^
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
  if "%TRIMRESULT%" == "Phaeton" ssh %USER%@phaeton.lan
  if "%TRIMRESULT%" == "Moon-Admin" ssh %USER%@moon-admin.lan
  if "%TRIMRESULT%" == "Moon-DNS" ssh %USER%@moon-dns.lan
  if "%TRIMRESULT%" == "Moon-Proxy" ssh %USER%@moon-proxy.lan
  if "%TRIMRESULT%" == "Inky" ssh %USER%@inky.lan
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
