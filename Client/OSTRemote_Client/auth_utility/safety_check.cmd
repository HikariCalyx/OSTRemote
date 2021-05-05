@echo off
set fverfile=unspecified
fb2 oem getversions 2>&1 | findstr software > %temp%\swver.txt
for /f "tokens=1* delims==" %%i in ( %temp%\swver.txt ) do set cswver=%%j
del "%temp%\swver.txt"
if exist "%fwfilepath%systeminfo.img" set fverfile="%fwfilepath%systeminfo.img"
if exist "%fwfilepath%fver" set fverfile="%fwfilepath%fver"
SET fverfile="%fverfile%"
SET fverfile=%fverfile:"=%
if "%fverfile%"=="unspecified" goto insecure_nosysteminfo
)
findstr MLF "%fverfile%" > %temp%\fver.txt
set /p fver= < %temp%\fver.txt
del %temp%\fver.txt
set fver=%fver:~4,19%

::General Rules
fb2 oem battery getcapacity 2>&1 | findstr Cap > %temp%\bcap.txt
for /f "tokens=1* delims==" %%i in ( %temp%\bcap.txt ) do set cbatterycap=%%j
echo  %t0071% %cbatterycap%
::Project Code Mismatch
if not "%fver:~0,3%"=="%cswver:~0,3%" goto insecure_prjcodemismatch
::MTK Insecure Downgrade
if "%fver:~0,3%"=="NE1" goto mtk_downgradecheck
if "%fver:~0,3%"=="FRT" goto mtk_downgradecheck
if "%fver:~0,3%"=="ES2" goto mtk_downgradecheck
if "%fver:~0,3%"=="CO2" goto mtk_downgradecheck
if "%fver:~0,3%"=="PDA" goto mtk_downgradecheck
if "%fver:~0,3%"=="ROO" goto mtk_downgradecheck
if "%fver:~0,3%"=="ANT" goto mtk_downgradecheck
goto skip_mtkcheck1
:mtk_downgradecheck
if "%fver:~4,1%" lss "%cswver:~4,1%" goto insecure_mtkdowngrade
:skip_mtkcheck1
if "%fver:~0,3%"=="ROO" goto mtk_upgradecheck
if "%fver:~0,3%"=="ANT" goto mtk_upgradecheck
goto skip_mtkcheck2
:mtk_upgradecheck
if "%fver:~0,3%"=="ROO" if "%cswver:~4,1%"==1 ( if "%fver:~4,1%" gtr "%cswver:~4,1%" ( goto insecure_mtkupgrade ) )
if "%fver:~0,3%"=="ANT" if "%cswver:~4,1%"==0 ( if "%fver:~4,1%" gtr "%cswver:~4,1%" ( goto insecure_mtkupgrade ) )
:skip_mtkcheck2
::PNX Oreo Downgrade Insecure
if "%fver:~0,3%"=="PNX" if "%cswver:~4,1%" geq "4" if "%fver:~4,1%"=="1" goto insecure_pnxdowngrade
::Insecure Downgrade
if "%erase%"=="0" if "%cswver:~4,3%" gtr "%fver:~4,3%" goto insecure_downgrade
::BatteryCheck
echo.
if %cbatterycap% lss 41 goto insecure_lowbattery
::Safety Passed
echo %t0031%
set insecure=0
goto eof

:insecure_nosysteminfo
echo %t0032%
echo %override_notice%
set insecure=1
goto eof

:insecure_prjcodemismatch
echo %t0033a%%cswver:~0,3%
echo %t0033b%%fver:~0,3%
echo %t0033c%
echo %override_notice%
set insecure=1
goto eof

:insecure_mtkdowngrade
echo %t0034%
echo %override_notice%
set insecure=1
goto eof

:insecure_mtkupgrade
echo %t0044%
echo %override_notice%
set insecure=1
goto eof

:insecure_downgrade
echo %t0051%
echo %override_notice%
set insecure=1
goto eof

:insecure_pnxdowngrade
echo %t0035%
echo %override_notice%
set insecure=1
goto eof

:insecure_lowbattery
echo %t0072%
echo %override_notice%
set insecure=1
goto eof

:eof