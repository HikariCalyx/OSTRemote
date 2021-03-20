echo %t0038% "fastboot format !target!"...
if %verbose_mode%==1 (
echo.
fastboot format !target!
echo.
) else (
fastboot format !target! 1>nul 2>nul
)