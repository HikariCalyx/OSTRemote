echo %t0038% "fastboot !target!"...
if %verbose_mode%==1 (
echo.
fastboot !target!
echo.
if "!target:~0,6!"=="reboot" timeout /t 5 /nobreak
fb2 oem alive 2>nul
) else (
fastboot !target! 2>nul
if "!target:~0,6!"=="reboot" timeout /t 5 /nobreak >nul
fb2 oem alive 2>nul
)
