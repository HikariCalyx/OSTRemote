@echo off
if "%nb0mode%"=="1" set fwfile=%fwfilepath%%mlffile%
if "%qlzmode%"=="1" set fwfile=%fwfilepath%%mlffile%
echo %fwfilepath%| bin\sed "s/ /\" \"/g" > %temp%\spacepath.txt
set /p quotefwfp=<%temp%\spacepath.txt
setlocal EnableExtensions
2>nul del %temp%\edl_fail*
set edlcomplete=0
if not exist "%fwfile%" (
echo no > %temp%\edl_fail4
goto EOF
)

::mtk_mode
findstr preloader %fwfile% > nul
if %errorlevel%==0 (
call mtk_sp_flashtool\mtk_edl.cmd
goto EOF
)

::precheck
findstr "FIREHOSE_IMG FIREHORSE_IMG" %fwfile% > nul
if not %errorlevel%==0 (
echo no > %temp%\edl_fail3
goto EOF
)
findstr RAWPROGRAM %fwfile% > nul
if not %errorlevel%==0 (
echo no > %temp%\edl_fail3
goto EOF
)
findstr PATCH %fwfile% > nul
if not %errorlevel%==0 (
echo no > %temp%\edl_fail3
goto EOF
)

::read_firehose_programmer
for /f "tokens=1* delims==" %%i in ( 'findstr "FIREHOSE_IMG FIREHORSE_IMG" %fwfile%' ) do set firehose=%%j
set firehose=%firehose:~2,-1%
for /f "tokens=1* delims==" %%i in ( 'findstr STORAGE %fwfile%' ) do set memorytype=%%j
set memorytype=%memorytype:~1%

::eMMC fetch xml
if "%memorytype%"=="eMMC" (
for /f "tokens=1* delims==" %%i in ( 'findstr RAWPROGRAM0_XML %fwfile%' ) do set rawprogramxml=%%j
set rawprogramxml=!rawprogramxml:~2,-1!
for /f "tokens=1* delims==" %%i in ( 'findstr PATCH0_XML %fwfile%' ) do set patchxml=%%j
set patchxml=!patchxml:~2,-1!
)
::UFS fetch xml
if "%memorytype%"=="UFS" (
setlocal disabledelayedexpansion
2>nul del %temp%\rawprogram.txt
2>nul del %temp%\patch.txt
for /f "tokens=1* delims==" %%i in ('findstr RAWPROGRAM %fwfile%') do echo %%j >> %temp%\rawprogram.txt
sed -i "s/\"//g" %temp%\rawprogram.txt
sed -i "s/ //g" %temp%\rawprogram.txt
sed -i ":a;N;s/\n/,/g;$!ba" %temp%\rawprogram.txt
set /p rawprogramxml=<%temp%\rawprogram.txt
del %temp%\rawprogram.txt
for /f "tokens=1* delims==" %%i in ('findstr PATCH %fwfile%') do echo %%j >> %temp%\patch.txt
sed -i "s/\"//g" %temp%\patch.txt
sed -i "s/ //g" %temp%\patch.txt
sed -i ":a;N;s/\n/,/g;$!ba" %temp%\patch.txt
set /p patchxml=<%temp%\patch.txt
del %temp%\patch.txt
del sed??????
setlocal enabledelayedexpansion
)

if "%verbose_mode%"=="1" (
echo Firehose Programmer: %firehose%
echo rawprogram xml: %rawprogramxml%
echo patch xml: %patchxml%
)

set "HardwareID=VID_05C6&PID_9008"
set "RegistryPath=HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Enum\USB"
set "DeviceFound=0"

for /F "delims=" %%I in ('%SystemRoot%\System32\reg.exe QUERY "%RegistryPath%\%HardwareID%" 2^>nul') do call :GetPort "%%I"

endlocal
if "%edlcomplete%"=="1" echo no > %temp%\edl_fail1
goto :EOF

:GetPort
set "RegistryKey=%~1"
if /I not "%RegistryKey:~0,71%" == "%RegistryPath%\%HardwareID%\" goto :EOF

for /F "skip=2 tokens=1,3" %%A in ('%SystemRoot%\System32\reg.exe QUERY "%~1\Device Parameters" /v PortName 2^>nul') do (
    if /I "%%A" == "PortName" set "SerialPort=%%B" && goto OutputPort
)
goto :EOF

:OutputPort
reg query HKLM\HARDWARE\DEVICEMAP\SERIALCOMM | findstr /E /I /L /C:%SerialPort% >nul
if errorlevel 1 goto :EOF
set "DeviceFound=1"
set "DeviceNumber=%RegistryKey:~-1%"
echo %t0068% %SerialPort%

echo %t0063%
if "%verbose_mode%"=="1" (
QSaharaServer.exe -p \\.\%SerialPort% -s 13:%fwfilepath%\%firehose%
) else (
QSaharaServer.exe -p \\.\%SerialPort% -s 13:%fwfilepath%\%firehose% > nul
)


if not %errorlevel%==0 (
echo no > %temp%\edl_fail1
goto EOF
)
echo %t0064%
if "%verbose_mode%"=="1" (
fh_loader.exe --port=\\.\%SerialPort% --search_path=%fwfilepath% --sendxml=%rawprogramxml% --noprompt --showpercentagecomplete --zlpawarehost=1 --memoryname=%memorytype%
) else (
fh_loader.exe --port=\\.\%SerialPort% --search_path=%fwfilepath% --sendxml=%rawprogramxml% --noprompt --showpercentagecomplete --zlpawarehost=1 --memoryname=%memorytype% | findstr /C:"percent files transferred"
)

if not %errorlevel%==0 (
echo no > %temp%\edl_fail4
goto EOF
)

echo %t0065%
if "%verbose_mode%"=="1" (
fh_loader.exe --port=\\.\%SerialPort% --search_path=%fwfilepath% --sendxml=%patchxml% --noprompt --showpercentagecomplete --zlpawarehost=1 --memoryname=%memorytype%
) else (
fh_loader.exe --port=\\.\%SerialPort% --search_path=%fwfilepath% --sendxml=%patchxml% --noprompt --showpercentagecomplete --zlpawarehost=1 --memoryname=%memorytype% | findstr /C:"percent files transferred"
)
echo %t0066%
fh_loader.exe --port=\\.\%SerialPort% --reset --noprompt > nul

fastboot oem alive 2>nul
set edlcomplete=1
:EOF