@echo off

set UPG_KOMMUNARKA=?
set UPG_VASILKOVO=?
set UPG_CHANOVO=?
set UPG_SHODNENSKAYA4=?
set UPG_SHODNENSKAYA5=?
set UPG_WEB=?
set ASK_LINUXPASS=?
set ASK_PROXIMAPASS=?
set LINUXPASS=?
set PROXIMAPASS=?

echo Location to upgrade:
echo  [1] full           
echo  [2] kommunarka (16)
echo  [3] vasilkovo (17)
echo  [4] chanovo (18)
REM echo  [5] yasenevof (19)
REM echo  [6] yasenevod (20)
echo  [7] shodnenskaya4 (21)
echo  [8] shodnenskaya5 (22)
REM echo  [9] kommunarkad (23)
echo  [0] web
echo  [q] quit
choice /c 1234567890q /cs
if %ERRORLEVEL% == 1 (
    set UPG_KOMMUNARKA=yes
    set UPG_VASILKOVO=yes
    set UPG_CHANOVO=yes
    set UPG_SHODNENSKAYA4=yes
    set UPG_SHODNENSKAYA5=yes
    set UPG_WEB=yes
)
if %ERRORLEVEL% == 2 (
    set UPG_KOMMUNARKA=yes
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
    echo Not ready
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

if %UPG_KOMMUNARKA%==yes set ASK_LINUXPASS=yes
if %UPG_VASILKOVO%==yes set ASK_LINUXPASS=yes
if %UPG_CHANOVO%==yes set ASK_LINUXPASS=yes
if %UPG_SHODNENSKAYA4%==yes set ASK_LINUXPASS=yes
if %UPG_SHODNENSKAYA5%==yes set ASK_LINUXPASS=yes
if %UPG_WEB%==yes set ASK_PROXIMAPASS=yes

if %ASK_LINUXPASS%==yes set /P "LINUXPASS=Linux password: "
if %ASK_PROXIMAPASS%==yes set /P "PROXIMAPASS=Proxima password: "

if %UPG_KOMMUNARKA%==yes (
    echo.
    echo #################### Upgrade Terra prime  ####################
    ssh -t lesha@terra.internal "echo %LINUXPASS% | sudo -S apt update && sudo apt upgrade -y"

    echo.
    echo #################### Upgrade Terra nas #######################
    ssh -t lesha@terra-nas.internal "echo %LINUXPASS% | sudo -S apt update && sudo apt upgrade -y"

    echo.
    echo #################### Upgrade Terra docker ####################
    ssh -t lesha@terra-docker.internal "echo %LINUXPASS% | sudo -S apt update && sudo apt upgrade -y"

    echo.
    echo #################### Upgrade Terra old #######################
    ssh -t lesha@terra-old.internal "echo %LINUXPASS% | sudo -S omv-upgrade"

    echo.
    echo #################### Upgrade Vesta prime #####################
    ssh -t lesha@vesta.internal "echo %LINUXPASS% | sudo -S apt update && sudo apt upgrade -y"

    echo.
    echo #################### Upgrade Vesta docker ####################
    ssh -t lesha@vesta-docker.internal "echo %LINUXPASS% | sudo -S apt update && sudo apt upgrade -y"

    echo.
    echo #################### Upgrade Vesta hplip #####################
    ssh -t lesha@vesta-hplip.internal "echo %LINUXPASS% | sudo -S apt update && sudo apt upgrade -y"
)

if %UPG_VASILKOVO%==yes (
    echo.
    echo #################### Upgrade Io ##############################
    ssh -t lesha@io.internal "echo %LINUXPASS% | sudo -S omv-upgrade"

    echo.
    echo #################### Upgrade Europa ##########################
    ssh -t lesha@europa.internal "echo %LINUXPASS% | sudo -S armbian-upgrade"

    echo.
    echo #################### Upgrade Europa docker ###################
    ssh -t lesha@europa-docker.internal "echo %LINUXPASS% | sudo -S apt update && sudo apt upgrade -y"
)

if %UPG_CHANOVO%==yes (
    echo.
    echo #################### Upgrade Mimas ###########################
    ssh -t lesha@mimas.home.arpa "echo %LINUXPASS% | sudo -S omv-upgrade"
)

if %UPG_SHODNENSKAYA4%==yes (
    echo.
    echo #################### Upgrade Ixion ###########################
    ssh -t lesha@ixion.home.arpa "echo %LINUXPASS% | sudo -S omv-upgrade"
)

if %UPG_SHODNENSKAYA5%==yes (
    echo.
    echo #################### Upgrade Makemake ###########################
    ssh -t lesha@makemake.home.arpa "echo %LINUXPASS% | sudo -S omv-upgrade"
)

if %UPG_WEB%==yes (
    echo.
    echo #################### Upgrade Proxima #########################
    ssh -t lesha@proxima.external "echo %PROXIMAPASS% | sudo -S apt update && sudo apt upgrade -y"
)

set LINUXPASS=?
set PROXIMAPASS=?

@echo on