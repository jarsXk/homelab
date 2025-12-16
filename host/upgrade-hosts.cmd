@echo off

setlocal enabledelayedexpansion

REM Запрос списка хостов
dialog --ascii-lines --begin 5 5 --checklist "Hosts to upgrade" -1 0 0 ^
   Terra    "terra.internal    (void)" on ^
   Io       "io.internal       (vasilkovo)" on ^
   Europa   "europa.internal   (vasilkovo)" on ^
   Mimas    "mimas.internal    (chanovo)" off ^
   Ariel    "ariel.internal    (yasenevof)" on ^
   Ixion    "ixion.home.arpa   (shodnenskaya4)" off ^
   Makemake "makemake.internal (shodnenskaya5)" on ^
   Proxima  "proxima.external  (web)" on ^
   2> dialogresult.bak
cls

REM Получение и очистка результата
set /p RESULT=<dialogresult.bak
set RESULT=%RESULT:"=%
del dialogresult.bak

REM Запрос паролей
set /P "LINUXUSER=Linux user (lesha): "
if "x%LINUXUSER%" == "x" (
  set LINUXUSER=lesha
)
if not "x%RESULT%" == "xProxima" (
  set /P "LINUXPASS=Linux password (): "
)
set TMPSTR=%RESULT%
if not "x%TMPSTR:Proxima=%" == "x%TMPSTR%" (
  set /P "PROXIMAPASS=Proxima password (): "
)
cls

REM Основной цикл по хостам
for %%G in (%RESULT%) do ( 

  set OMV_UPG=no
  set APT_UPG=no
  set SNAP_UPG=no
  set AUTOREMOVE=no
  set REBOOT=no
  set PASS=?
  set SSHSUDO=?

  echo.
  echo #######################################
  echo ########## Upgrade %%G
  echo #######################################
  echo.

  REM Определение списка команд
  if %%G == Terra (
    set OMV_UPG=yes
    set SNAP_UPG=yes
    set AUTOREMOVE=yes
    set REBOOT=yes
    set DOMAIN=internal

    set PASS=%LINUXPASS%
  )

  if %%G == Io (
    set OMV_UPG=yes
    set SNAP_UPG=yes
    set AUTOREMOVE=yes
    set REBOOT=yes
    set DOMAIN=internal

    set PASS=%LINUXPASS%
  )

  if %%G == Europa (
    set OMV_UPG=yes
    set SNAP_UPG=yes
    set AUTOREMOVE=yes
    set REBOOT=yes
    set DOMAIN=internal

    set PASS=%LINUXPASS%
  )

  if %%G == Mimas (
    set OMV_UPG=yes
    set SNAP_UPG=yes
    set AUTOREMOVE=yes
    set REBOOT=yes
    set DOMAIN=internal

    set PASS=%LINUXPASS%
  )

  if %%G == Ariel (
    set OMV_UPG=yes
    set SNAP_UPG=yes
    set AUTOREMOVE=yes
    set REBOOT=yes
    set DOMAIN=internal

    set PASS=%LINUXPASS%
  )

  if %%G == Ixion (
    set OMV_UPG=yes
    set AUTOREMOVE=yes
    set DOMAIN=home.internal

    set PASS=%LINUXPASS%
  )

  if %%G == Makemake (
    set OMV_UPG=yes
    set SNAP_UPG=yes
    set AUTOREMOVE=yes
    set REBOOT=yes
    set DOMAIN=internal

    set PASS=%LINUXPASS%
  )

  if %%G == Proxima (
    set APT_UPG=yes
    set AUTOREMOVE=yes
    set REBOOT=yes
    set DOMAIN=external

    set PASS=%PROXIMAPASS%
  )

  REM Выполнение команд
  if "x!PASS!" == "x" (
    set SSHSUDO=sudo
  )
  if not "x!PASS!" == "x" (
    set "SSHSUDO=echo !PASS! | sudo -S"
  )

  if !OMV_UPG! == yes (
    ssh -t !LINUXUSER!@%%G.!DOMAIN! "!SSHSUDO! omv-upgrade"
  )
  if !APT_UPG! == yes (
    ssh -t !LINUXUSER!@%%G.!DOMAIN! "!SSHSUDO! apt update && sudo apt upgrade -y"
  )
  if !SNAP_UPG! == yes (
    ssh -t !LINUXUSER!@%%G.!DOMAIN! "!SSHSUDO! snap refresh"
  )
  if !AUTOREMOVE! == yes (
    ssh -t !LINUXUSER!@%%G.!DOMAIN! "!SSHSUDO! apt autoremove -y"
  )
  if !REBOOT! == yes (
    ssh -t !LINUXUSER!@%%G.!DOMAIN! "!SSHSUDO! reboot-if-needed.sh"
  )
)

set LINUXUSER=
set LINUXPASS=
set PROXIMAPASS=
set PASS=
set OMV_UPG=
set APT_UPG=
set SNAP_UPG=
set AUTOREMOVE=
set REBOOT=
set DOMAIN=
set SSHSUDO=

@echo on