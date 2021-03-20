if "!target:~0,3!"=="md4" (
echo %t0049%
goto noechox
)
if "!target:~0,3!"=="md5" (
echo %t0049%
goto noechox
)
echo %t0038% "fastboot flash !target!"...
:noechox
if %verbose_mode%==1 (
echo.
fastboot flash !target!
if "!errorlevel!"=="1" (
set errorflash=1
echo errorflash>%temp%\eflash.txt
goto eof
)
echo.
) else (
fastboot flash !target! 2>&1 | findstr FAILED
if "!errorlevel!"=="0" (
set errorflash=1
echo errorflash>%temp%\eflash.txt
goto eof
)
)

:eof