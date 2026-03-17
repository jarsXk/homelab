@echo off

setlocal enabledelayedexpansion

REM Запрос списка хостов
dialog --ascii-lines --begin 5 5 --checklist "Hosts to upgrade" -1 0 0 ^
  Terra         "terra.lan    null" on ^
  Moon          "" off ^
  "  Mani"      "mani.lan     null" off ^
  "  Luna"      "lina.lan     null" off ^
  "  Selena"    "selena.lan   null" off ^
  "  Hina"      "hina.lan     null" off ^
  "    Phaeton" "phaeton.lan  null" on ^
  Inky          "inky.lan     null" off ^
  Io            "io.lan       vasilkovo" on ^
  Europa        "europa.lan   vasilkovo" on ^
  Mimas         "mimas.lan    chanovo" off ^
  Ariel         "ariel.lan    yasenevof" on ^
  Ixion         "ixion.lan    shodnenskaya4" off ^
  Makemake      "makemake.lan shodnenskaya5" off ^
  Proxima       "proxima.wan  web" on ^
  2> dialogresult.bak
cls
REM Получение и очистка результата
set /p RESULT=<dialogresult.bak
set RESULT=%RESULT:"=%
del dialogresult.bak

if not "x%RESULT%" == "x" (
REM Запрос паролей
  set /P "LINUXUSER=Linux user (lesha): "
  if "x%LINUXUSER%" == "x" (
    set LINUXUSER=lesha
  )
  if not "x%RESULT%" == "xProxima" (
    set /P "LINUXPASS=Linux password (): "
  )
  set TMPSTR=!RESULT!
  if not "x!TMPST:Proxima=!" == "x!TMPSTR!" (
    set /P "PROXIMAPASS=Proxima password (): "
  )
)
cls

REM Основной цикл по хостам
for %%G in (%RESULT%) do ( 

  set UNI_UPG=no
  set PASS=?
  set SSHSUDO=?

  REM Определение списка команд
  if %%G == Terra (
    set UNI_UPG=yes
    set DOMAIN=lan
    set PASS=%LINUXPASS%
  )

  if %%G == Phaeton (
    set UNI_UPG=yes
    set DOMAIN=lan
    set PASS=%LINUXPASS%
  )

  if %%G == Inky (
    set UNI_UPG=yes
    set DOMAIN=lan
    set PASS=%LINUXPASS%
  )

  if %%G == Io (
    set UNI_UPG=yes
    set DOMAIN=lan
    set PASS=%LINUXPASS%
  )

  if %%G == Europa (
    set UNI_UPG=yes
    set DOMAIN=lan
    set PASS=%LINUXPASS%
  )

  if %%G == Mimas (
    set UNI_UPG=yes
    set DOMAIN=lan
    set PASS=%LINUXPASS%
  )

  if %%G == Ariel (
    set UNI_UPG=yes
    set DOMAIN=lan
    set PASS=%LINUXPASS%
  )

  if %%G == Ixion (
    set UNI_UPG=yes
    set DOMAIN=lan
    set PASS=%LINUXPASS%
  )

  if %%G == Makemake (
    set UNI_UPG=yes
    set DOMAIN=lan
    set PASS=%LINUXPASS%
  )
  
  if %%G == Proxima (
    set UNI_UPG=yes
    set DOMAIN=wan
    set PASS=%PROXIMAPASS%
  )

  REM Выполнение команд
  if "x!PASS!" == "x" (
    set SSHSUDO=sudo
  )
  if not "x!PASS!" == "x" (
    set "SSHSUDO=echo !PASS! | sudo -S"
  )

  ssh -t !LINUXUSER!@%%G.!DOMAIN! "!SSHSUDO! echo && wget -qO- https://raw.githubusercontent.com/jarsXk/homelab/main/host/linux/upgrade/upgrade-debian.sh | sudo bash"
)

set LINUXUSER=
set LINUXPASS=
set PROXIMAPASS=
set UNI_UPG=
set DOMAIN=
set SSHSUDO=

@echo on