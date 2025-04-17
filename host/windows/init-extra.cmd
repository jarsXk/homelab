@echo off

choice /c YNC /M "Install Obsidian "
if %ERRORLEVEL% == 1 winget install Obsidian.Obsidian
if %ERRORLEVEL% == 3 GOTO END

choice /c YNC /M "Install Steam "
if %ERRORLEVEL% == 1 winget install Valve.Steam
if %ERRORLEVEL% == 3 GOTO END

choice /c YNC /M "Install GitHub Desktop "
if %ERRORLEVEL% == 1 winget install GitHub.GitHubDesktop
if %ERRORLEVEL% == 3 GOTO END

choice /c YNC /M "Install Stellarium "
if %ERRORLEVEL% == 1 winget install winget install Stellarium.Stellarium
if %ERRORLEVEL% == 3 GOTO END

:END

@echo on
