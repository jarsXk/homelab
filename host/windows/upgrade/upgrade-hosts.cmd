@echo off

setlocal enabledelayedexpansion

REM Запрос списка хостов
dialog --ascii-lines --begin 5 5 --checklist "Hosts to upgrade" -1 0 0 ^
  Terra           "terra.lan     null" off ^
  Moon            ""                   off ^
  "  Mani"        "mani.lan      null" off ^
  "  Luna"        "luna.lan      null" off ^
  "  Selena"      "selena.lan    null" off ^
  "  Hina"        "hina.lan      null" off ^
  "    Phaeton"   "phaeton.lan   null" off ^
  "    MoonAdmin" "moonadmin.lan null" off ^
  "    MoonLoad " "moonload.lan  null" off ^
  "    MoonMedia" "moonmedia.lan null" off ^
  "    MoonDocs"  "moondocs.lan  null" off ^
  "    MoonAI"    "moonai.lan    null" off ^
  "    MoonPrint" "moonprint.lan null" off ^
  "    MoonDNS"   "moondns.lan   null" off ^
  "    MoonProxy" "moonproxy.lan null" off ^
  Inky            "inky.lan      null" off ^
  Io              "io.lan        vasilkovo" off ^
  Europa          "europa.lan    vasilkovo" off ^
  Mimas           "mimas.lan     chanovo" off ^
  Ariel           "ariel.lan     yasenevof" off ^
  Ixion           "ixion.lan     shodnenskaya4" off ^
  Makemake        "makemake.lan  shodnenskaya5" off ^
  Proxima         "proxima.wan   web" off ^
  2> dialogresult.bak
cls
REM Получение и очистка результата
set /p RESULT=<dialogresult.bak
set RESULT=%RESULT:"=%
del dialogresult.bak

set LINUXPASS=
set PROXMOXPASS=
set PROXIMAPASS=

if not "x%RESULT%" == "x" (
REM Запрос паролей
  set /P "LINUXUSER=Linux user (lesha): "
  if "x%LINUXUSER%" == "x" (
    set LINUXUSER=lesha
  )
  set NEEDLINUXPASS=
  set NEEDPROXMOXPASS=
  set NEEDPROXIMAPASS=
  for %%G in (!RESULT!) do (
    if /I "%%G"=="Luna" (
      set NEEDPROXMOXPASS=yes
    ) else if /I "%%G"=="Selena" (
      set NEEDPROXMOXPASS=yes
    ) else if /I "%%G"=="Hina" (
      set NEEDPROXMOXPASS=yes
    ) else if /I "%%G"=="Proxima" (
      set NEEDPROXIMAPASS=yes
    ) else (
      set NEEDLINUXPASS=yes
    )
  )
  if "x!NEEDLINUXPASS!" == "xyes" (
    call :ReadPassword "Linux password ()" LINUXPASS
  )
  if "x!NEEDPROXMOXPASS!" == "xyes" (
    call :ReadPassword "Proxmox password ()" PROXMOXPASS
  )
  if "x!NEEDPROXIMAPASS!" == "xyes" (
    call :ReadPassword "Proxima password ()" PROXIMAPASS
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

  if %%G == Mani (
    set UNI_UPG=yes
    set DOMAIN=lan
    set PASS=%LINUXPASS%
  )

  if %%G == Luna (
    set UNI_UPG=yes
    set DOMAIN=lan
    set PASS=%PROXMOXPASS%
  )

  if %%G == Selena (
    set UNI_UPG=yes
    set DOMAIN=lan
    set PASS=%PROXMOXPASS%
  )

  if %%G == Hina (
    set UNI_UPG=yes
    set DOMAIN=lan
    set PASS=%PROXMOXPASS%
  )

  if %%G == Phaeton (
    set UNI_UPG=yes
    set DOMAIN=lan
    set PASS=%LINUXPASS%
  )

  if %%G == MoonAdmin (
    set UNI_UPG=yes
    set DOMAIN=lan
    set PASS=%LINUXPASS%
  )

  if %%G == MoonLoad (
    set UNI_UPG=yes
    set DOMAIN=lan
    set PASS=%LINUXPASS%
  )

  if %%G == MoonMedia (
    set UNI_UPG=yes
    set DOMAIN=lan
    set PASS=%LINUXPASS%
  )

  if %%G == MoonDocs (
    set UNI_UPG=yes
    set DOMAIN=lan
    set PASS=%LINUXPASS%
  )

  if %%G == MoonAI (
    set UNI_UPG=yes
    set DOMAIN=lan
    set PASS=%LINUXPASS%
  )

  if %%G == MoonPrint (
    set UNI_UPG=yes
    set DOMAIN=lan
    set PASS=%LINUXPASS%
  )

  if %%G == MoonDNS (
    set UNI_UPG=yes
    set DOMAIN=lan
    set PASS=%LINUXPASS%
  )

  if %%G == MoonProxy (
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

  ssh -t !LINUXUSER!@%%G.!DOMAIN! "!SSHSUDO! echo && wget -qO- https://raw.githubusercontent.com/jarsXk/homelab/main/host/linux/distros/debian/upgrade/upgrade-debian.sh | sudo bash"
)

set LINUXUSER=
set LINUXPASS=
set PROXMOXPASS=
set PROXIMAPASS=
set UNI_UPG=
set DOMAIN=
set SSHSUDO=

@echo(
@echo Upgrade finished, press any key
@pause >nul

@echo on
@goto :eof

:ReadPassword
setlocal disabledelayedexpansion
set "PASSWORD_PROMPT=%~1"
for /f "delims=" %%P in ('powershell.exe -NoProfile -Command "$secure = Read-Host -AsSecureString -Prompt $env:PASSWORD_PROMPT; $ptr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($secure); try { [Runtime.InteropServices.Marshal]::PtrToStringBSTR($ptr) } finally { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($ptr) }"') do (
  endlocal & set "%~2=%%P"
)
goto :eof