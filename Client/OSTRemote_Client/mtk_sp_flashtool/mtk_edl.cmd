@echo off

::precheck

findstr scatter %fwfile% > nul
if not %errorlevel%==0 (
echo no > %temp%\edl_fail3
goto EOF
)
findstr preloader %fwfile% > nul
if not %errorlevel%==0 (
echo no > %temp%\edl_fail3
goto EOF
)
findstr DA_FILE %fwfile% > nul
if not %errorlevel%==0 set defaultda=1
)

::read_download_agent
for /f "tokens=1* delims==" %%i in ( 'findstr "DA_FILE" %fwfile%' ) do set dafile=%%j
set dafile=%dafile:~2,-1%
echo %dafile% | findstr ".zip\>" > nul
if %errorlevel%==0 (
bin\zipinfo -1 "%fwfilepath%%dafile%" > %temp%\actualda.txt
unzip -q -P WLBGFIH123 -o "%fwfilepath%%dafile%" -d %quotefwfp%
set /p dafile=<%temp%\actualda.txt
del %temp%\actualda.txt
)
if "%defaultda%"=="1" set dafile=MTK_AllInOne_DA.bin
::scatter_file
for /f "tokens=1* delims==" %%i in ( 'findstr "scatter.txt" %fwfile%' ) do set scatterfile=%%j
set scatterfile=!scatterfile:~2,-1!

if "%verbose_mode%"=="1" (
echo.
echo %t0082%%dafile%
echo %t0083%%scatterfile%
echo.
)

if not exist mtk_sp_flashtool\flash_tool.exe (
echo no > %temp%\edl_fail2
echo.
goto EOF
)

if "%defaultda%"=="1" (
set dapath=
) else (
set dapath=%quotefwfp%
)

echo %t0084%
echo %t0085%

echo mtk_sp_flashtool\flash_tool -c download -d "%quotefwfp%%dafile%" -s "%quotefwfp%%scatterfile%" -b > %temp%\spcall.cmd
if "%verbose_mode%"=="1" (
echo.
type %temp%\spcall.cmd
echo.
)
if "%verbose_mode%"=="1" echo pause >> %temp%\spcall.cmd
echo exit >> %temp%\spcall.cmd
start "%t0086%" /wait %temp%\spcall.cmd
del %temp%\spcall.cmd

fastboot oem alive 2>nul
set edlcomplete=1
:EOF