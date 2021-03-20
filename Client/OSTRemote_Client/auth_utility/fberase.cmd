echo %t0038% "fastboot erase !target!"...
if %verbose_mode%==1 (
echo.
fastboot erase !target!
echo.
) else (
fastboot erase !target! 2>nul
)