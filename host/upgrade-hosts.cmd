@echo off

set UPG_VOID=?
set UPG_VASILKOVO=?
set UPG_CHANOVO=?
set UPG_YASENEVOF=?
set UPG_YASENEVOD=?
set UPG_SHODNENSKAYA4=?
set UPG_SHODNENSKAYA5=?
set UPG_KOMMUNARKAD=?
set UPG_WEB=?
set ASK_LINUXPASS=?
set ASK_PROXIMAPASS=?
set LINUXPASS=?
set PROXIMAPASS=?

echo Location to upgrade:
echo  [1] full           
echo  [2] void (16)
echo  [3] vasilkovo (17)
echo  [4] chanovo (18)
REM echo  [5] yasenevod (19)
echo  [6] yasenevof (20)
echo  [7] shodnenskaya4 (21)
echo  [8] shodnenskaya5 (22)
REM echo  [9] kommunarkad (23)
echo  [0] web
echo  [q] quit
choice /c 1234567890q /cs
if %ERRORLEVEL% == 1 (
    set UPG_VOID=yes
    set UPG_VASILKOVO=yes
    set UPG_CHANOVO=yes
    set UPG_YASENEVOF=yes
    set UPG_YASENEVOD=yes
    set UPG_SHODNENSKAYA4=yes
    set UPG_SHODNENSKAYA5=yes
    set UPG_KOMMUNARKAD=yes
    set UPG_WEB=yes
)
if %ERRORLEVEL% == 2 (
    set UPG_VOID=yes
)
if %ERRORLEVEL% == 3 (
    set UPG_VASILKOVO=yes
)
if %ERRORLEVEL% == 4 (
    set UPG_CHANOVO=yes
)
if %ERRORLEVEL% == 5 (
    echo Not ready
)
if %ERRORLEVEL% == 6 (
    set UPG_YASENEVOF=yes
)
if %ERRORLEVEL% == 7 (
    set UPG_SHODNENSKAYA4=yes
)
if %ERRORLEVEL% == 8 (
    set UPG_SHODNENSKAYA5=yes
)
if %ERRORLEVEL% == 9 (
    echo Not ready
)
if %ERRORLEVEL% == 10 (
    set UPG_WEB=yes
)

if %UPG_VOID%==yes set ASK_LINUXPASS=yes
if %UPG_VASILKOVO%==yes set ASK_LINUXPASS=yes
if %UPG_CHANOVO%==yes set ASK_LINUXPASS=yes
if %UPG_YASENEVOF%==yes set ASK_LINUXPASS=yes
if %UPG_YASENEVOD%==yes set ASK_LINUXPASS=yes
if %UPG_SHODNENSKAYA4%==yes set ASK_LINUXPASS=yes
if %UPG_SHODNENSKAYA5%==yes set ASK_LINUXPASS=yes
if %UPG_KOMMUNARKAD%==yes set ASK_LINUXPASS=yes
if %UPG_WEB%==yes set ASK_PROXIMAPASS=yes

if %ASK_LINUXPASS%==yes set /P "LINUXPASS=Linux password: "
if %ASK_PROXIMAPASS%==yes set /P "PROXIMAPASS=Proxima password: "

if %UPG_VOID%==yes (
    echo.
    echo ##############################################################
    echo #################### Upgrade Terra ###########################
    echo ##############################################################
    echo.
    ssh -t lesha@terra.internal "echo %LINUXPASS% | sudo -S omv-upgrade"
    ssh -t lesha@terra.internal "echo %LINUXPASS% | sudo -S snap refresh" 
    ssh -t lesha@terra.internal "echo %LINUXPASS% | sudo -S reboot-if-needed.sh"

REM    echo.
REM    echo #################### Upgrade Vesta prime #####################
REM    ssh -t lesha@vesta.internal "echo %LINUXPASS% | sudo -S apt update && sudo apt upgrade -y"

REM    echo.
REM    echo #################### Upgrade Vesta docker ####################
REM    ssh -t lesha@vesta-docker.internal "echo %LINUXPASS% | sudo -S apt update && sudo apt upgrade -y"

REM    echo.
REM    echo #################### Upgrade Vesta hplip #####################
REM    ssh -t lesha@vesta-hplip.internal "echo %LINUXPASS% | sudo -S apt update && sudo apt upgrade -y"
)

if %UPG_VASILKOVO%==yes (
    echo.
    echo ##############################################################
    echo #################### Upgrade Io ##############################
    echo ##############################################################
    echo.
    ssh -t lesha@io.internal "echo %LINUXPASS% | sudo -S omv-upgrade"

    echo.
    echo ##############################################################
    echo #################### Upgrade Europa ##########################
    echo ##############################################################
    echo.
    ssh -t lesha@europa.internal "echo %LINUXPASS% | sudo -S omv-upgrade"
    ssh -t lesha@europa.internal "echo %LINUXPASS% | sudo -S snap refresh"
    ssh -t lesha@europa.internal "echo %LINUXPASS% | sudo -S reboot-if-needed.sh"
)

if %UPG_CHANOVO%==yes (
    echo.
    echo ##############################################################
    echo #################### Upgrade Mimas ###########################
    echo ##############################################################
    echo.
    ssh -t lesha@mimas.internal "echo %LINUXPASS% | sudo -S omv-upgrade"
    ssh -t lesha@mimas.internal "echo %LINUXPASS% | sudo -S snap refresh"
    ssh -t lesha@mimas.internal "echo %LINUXPASS% | sudo -S reboot-if-needed.sh"
)

if %UPG_YASENEVOF%==yes (
    echo.
    echo ##############################################################
    echo #################### Upgrade Ariel ###########################
    echo ##############################################################
    echo.
    ssh -t lesha@ariel.internal "echo %LINUXPASS% | sudo -S omv-upgrade"
    ssh -t lesha@ariel.internal "echo %LINUXPASS% | sudo -S snap refresh" 
    ssh -t lesha@ariel.internal "echo %LINUXPASS% | sudo -S reboot-if-needed.sh"
)

REM if %UPG_YASENEVOD%==yes (
REM     echo.
REM )

REM if %UPG_SHODNENSKAYA4%==yes (
REM     echo.
REM     echo ##############################################################
REM     echo #################### Upgrade Ixion ###########################
REM     echo ##############################################################
REM     echo.
REM     ssh -t lesha@ixion.home.arpa "echo %LINUXPASS% | sudo -S omv-upgrade"
REM )

if %UPG_SHODNENSKAYA5%==yes (
    echo.
    echo ##############################################################
    echo #################### Upgrade Makemake ########################
    echo ##############################################################
    echo.
    ssh -t lesha@makemake.internal "echo %LINUXPASS% | sudo -S omv-upgrade"
    ssh -t lesha@makemake.internal "echo %LINUXPASS% | sudo -S snap refresh"
)

REM if %UPG_KOMMUNARKAD%==yes (
REM     echo.
REM )

if %UPG_WEB%==yes (
    echo.
    echo ##############################################################
    echo #################### Upgrade Proxima #########################
    echo ##############################################################
    echo.
    ssh -t lesha@proxima.external "echo %PROXIMAPASS% | sudo -S apt update && sudo apt upgrade -y"
    ssh -t lesha@proxima.external "echo %PROXIMAPASS% | sudo -S reboot-if-needed.sh"
)

set LINUXPASS=?
set PROXIMAPASS=?

@echo on