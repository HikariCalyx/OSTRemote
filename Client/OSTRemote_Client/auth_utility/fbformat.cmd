if "%service_auth%"=="0" goto skipauth
:precaution_for_mtk_device
fb2 oem getBootloaderType 2>&1 | findstr service > nul
if "%errorlevel%"=="0" fb2 oem getRootStatus 2>&1 | findstr Disable > nul
if "%errorlevel%"=="0" call call_auth.cmd
:skipauth

if "!target:~0,8!"=="userdata" (
echo %t0038% "fastboot -w"...
if %verbose_mode%==1 (
echo.
fastboot -w
echo.
) else (
fastboot -w 1>nul 2>nul
)
goto eof
)

echo %t0038% "fastboot format !target!"...
if %verbose_mode%==1 (
echo.
fastboot format !target!
echo.
) else (
fastboot format !target! 1>nul 2>nul
)

:eof