if "%service_auth%"=="0" goto skipauth
:precaution_for_mtk_device
fb2 oem getBootloaderType 2>&1 | findstr service > nul
if "%errorlevel%"=="0" fb2 oem getRootStatus 2>&1 | findstr Disable > nul
if "%errorlevel%"=="0" call call_auth.cmd
:skipauth

if "!target:~0,3!"=="md4" (
if "%resultverify%"=="0" goto eof
echo %t0049%
goto noechox
)
if "!target:~0,3!"=="md5" (
if "%resultverify%"=="0" goto eof
echo %t0049%
goto noechox
)
echo %t0038% "fastboot flash !target!"...
:noechox
if %verbose_mode%==1 (
echo.
if "%msm8937value%"=="1" (
if "!target:~0,6!"=="system" (
fastboot erase !target!
)
)
fastboot flash !target!
if "!errorlevel!"=="1" (
set errorflash=1
echo errorflash>%temp%\eflash2.txt
goto eof
)
echo.
) else (
if "%msm8937value%"=="1" (
if "!target:~0,6!"=="system" (
fastboot erase !target! 2>nul
)
)
fastboot flash !target! 2>&1 | findstr FAILED
if "!errorlevel!"=="0" (
set errorflash=1
echo errorflash>%temp%\eflash2.txt
goto eof
)
)

:eof