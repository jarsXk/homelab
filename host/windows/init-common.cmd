@echo off

winget upgrade --all
winget install CPUID.HWMonitor
winget install MiniTool.PartitionWizard.Free
winget install FireDaemon.OpenSSL
winget install FarManager.FarManager
winget install dotPDN.PaintDotNet
winget install gerardog.gsudo
winget install SergeyMoskalev.CarambaSwitcher
winget install AOMEI.Backupper.Standard
winget install Fastfetch-cli.Fastfetch
mkdir C:\Users\fedrr\Home
curl ^
    -H "Accept: application/vnd.github.v3.raw" ^
    -o C:\Software\fastfetch-cmd.cmd ^
    -L ^
    https://api.github.com/repos/jarsXk/homelab/contents/host/fastfetch-cmd.cmd
winget install Rufus.Rufus
winget install Balena.Etcher
winget install namazso.OpenHashTab

curl ^
    -o mediatab_setup.exe ^
    -L ^
    https://mediatab.mediaarea.net/MediaTab%20v1.4.1%20Setup.exe
mediatab_setup.exe
del mediatab_setup.exe

mkdir C:\Software\
curl ^
    -H "Accept: application/vnd.github.v3.raw" ^
    -o C:\Software\sshsel-kommunarka.cmd ^
    -L ^
    https://api.github.com/repos/jarsXk/homelab/contents/host/windows/ssh/sshsel-kommunarka.cmd
curl ^
    -H "Accept: application/vnd.github.v3.raw" ^
    -o C:\Software\sshsel-vasilkovo.cmd ^
    -L ^
    https://api.github.com/repos/jarsXk/homelab/contents/host/windows/ssh/sshsel-vasilkovo.cmd

curl ^
    -H "Accept: application/vnd.github.v3.raw" ^
    -o C:\Users\fedrr\AppData\Local\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json ^
    -L ^
    https://api.github.com/repos/jarsXk/homelab/contents/host/windows/terminal/settings.json

@echo on
