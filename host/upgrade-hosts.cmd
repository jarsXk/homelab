@echo off

setlocal enabledelayedexpansion

REM Запрос списка хостов
dialog --ascii-lines --begin 5 5 --checklist "Hosts to upgrade" -1 0 0 ^
  Terra     "terra.internal      S void" on ^
    Phaeton "phaeton.internal  V S void" on ^
  Inky      "inky.internal       D void" off ^
  Io        "io.internal         S vasilkovo" on ^
  Europa    "europa.internal     S vasilkovo" on ^
  Mimas     "mimas.internal      S chanovo" off ^
  Ariel     "ariel.internal      S yasenevof" on ^
  Ixion     "ixion.home.arpa     S shodnenskaya4" off ^
  Makemake  "makemake.internal   S shodnenskaya5" on ^
  Proxima   "proxima.external    S web" on ^
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

  set UNI_UPG=no
  set PASS=?
  set SSHSUDO=?

  REM Определение списка команд
  if %%G == Terra (
    set UNI_UPG=yes
    set DOMAIN=internal
    set PASS=%LINUXPASS%
  )

  if %%G == Phaeton (
    set UNI_UPG=yes
    set DOMAIN=internal
    set PASS=%LINUXPASS%
  )

  if %%G == Inky (
    set UNI_UPG=yes
    set DOMAIN=internal
    set PASS=%LINUXPASS%
  )

  if %%G == Io (
    set UNI_UPG=yes
    set DOMAIN=internal
    set PASS=%LINUXPASS%
  )

  if %%G == Europa (
    set UNI_UPG=yes
    set DOMAIN=internal
    set PASS=%LINUXPASS%
  )

  if %%G == Mimas (
    set UNI_UPG=yes
    set DOMAIN=internal
    set PASS=%LINUXPASS%
  )

  if %%G == Ariel (
    set UNI_UPG=yes
    set DOMAIN=internal
    set PASS=%LINUXPASS%
  )

  if %%G == Ixion (
    set UNI_UPG=yes
    set DOMAIN=home.internal
    set PASS=%LINUXPASS%
  )

  if %%G == Makemake (
    set UNI_UPG=yes
    set DOMAIN=internal
    set PASS=%LINUXPASS%
  )

  if %%G == Inky (
    set UNI_UPG=yes
    set DOMAIN=internal
    set PASS=%LINUXPASS%
  )
  
  if %%G == Proxima (
    set UNI_UPG=yes
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

  ssh -t !LINUXUSER!@%%G.!DOMAIN! "!SSHSUDO! echo && wget -qO- https://raw.githubusercontent.com/jarsXk/homelab/main/host/linux/upgrade/upgrade-debian.sh | sudo bash"
)

set LINUXUSER=
set LINUXPASS=
set PROXIMAPASS=
set UNI_UPG=
set DOMAIN=
set SSHSUDO=

@echo on