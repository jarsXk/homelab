@echo off

dialog --ascii-lines --begin 5 5  --menu "Server to login" -1 0 0 ^
   Terra    "terra.internal    (void)" ^
   Io       "io.internal       (vasilkovo)" ^
   Europa   "europa.internal   (vasilkovo)" ^
   Mimas    "mimas.internal    (chanovo)" ^
   Ariel    "ariel.internal    (yasenevof)" ^
   Ixion    "ixion.home.arpa   (shodnenskaya4)" ^
   Makemake "makemake.internal (shodnenskaya5)" ^
   Proxima  "proxima.external  (web)" ^
   2> dialogresult.bak
set /p RESULT=<dialogresult.bak
del dialogresult.bak           
cls

if %RESULT% == Terra ssh lesha@terra.internal
if %RESULT% == Io ssh lesha@io.internal
if %RESULT% == Europa ssh lesha@europa.internal
if %RESULT% == Ariel ssh lesha@ariel.internal
if %RESULT% == Mimas ssh lesha@mimas.internal
if %RESULT% == Ixion ssh lesha@ixion.home.arpa
if %RESULT% == Makemake ssh lesha@makemake.internal
if %RESULT% == Proxima ssh lesha@proxima.external

@echo on
