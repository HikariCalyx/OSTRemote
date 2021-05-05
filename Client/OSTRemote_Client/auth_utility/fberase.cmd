if "%service_auth%"=="0" goto skipauth
:precaution_for_mtk_device
fb2 oem getBootloaderType 2>&1 | findstr service > nul
if "%errorlevel%"=="0" fb2 oem getRootStatus 2>&1 | findstr Disable > nul
if "%errorlevel%"=="0" call call_auth.cmd
:skipauth

echo %t0038% "fastboot erase !target!"...
if %verbose_mode%==1 (
echo.
fastboot erase !target!
echo.
) else (
fastboot erase !target! 2>nul
)