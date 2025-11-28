@echo off

setlocal enabledelayedexpansion

set LINUXPASS=?
set PROXIMAPASS=?
set PASS=?

REM Запрос списка хостов
dialog --ascii-lines --begin 5 5 --checklist "Hosts to upgrade" -1 0 0 ^
   Terra    "terra.internal    (void)" on ^
   Io       "io.internal       (vasilkovo)" off ^
   Europa   "europa.internal   (vasilkovo)" off ^
   Mimas    "mimas.internal    (chanovo)" off ^
   Ariel    "ariel.internal    (yasenevof)" off ^
   Ixion    "ixion.home.arpa   (shodnenskaya4)" off ^
   Makemake "makemake.internal (shodnenskaya5)" off ^
   Proxima  "proxima.external  (web)" off ^
   2> dialogresult.bak
cls

REM Получение и очистка результата
set /p RESULT=<dialogresult.bak
set RESULT=%RESULT:"=%
del dialogresult.bak

REM Запрос паролей
if not "x%RESULT%" == "xProxima" (
    set /P "LINUXPASS=Linux password: "
)
set TMPSTR=%RESULT%
if not "x%TMPSTR:Proxima=%" == "x%TMPSTR%" (
  set /P "PROXIMAPASS=Proxima password: "
)
cls

REM Основной цикл по хостам
for %%G in (%RESULT%) do (
  echo %%G 

  set OMV_UPG=no
  set APT_UPG=no
  set SNAP_UPG=no
  set AUTOREMOVE=no
  set REBOOT=no
  set PASS=?

  if %%G == Terra (
    set OMV_UPG=yes
    set SNAP_UPG=yes
    set AUTOREMOVE=yes
    set REBOOT=yes

    set PASS=%LINUXPASS%
  )

  echo.
  echo #######################################
  echo ########## Upgrade %%G
  echo #######################################
  echo.
)

set LINUXPASS=?
set PROXIMAPASS=?
set PASS=?

@echo on