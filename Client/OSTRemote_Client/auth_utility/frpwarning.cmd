set skipfrp=0
echo.
echo %t0059%
echo.
echo %z0004%
echo %z0005%
echo %z0006%
echo %z0007%
echo %z0008%
echo.
choice /c yn /m "%z0009%" /n
if "%errorlevel%"=="1" goto eof
set skipfrp=1
:eof