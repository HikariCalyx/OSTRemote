fb2 oem getversions 2>&1 | findstr /C:"chip version=MT" >nul
if not %errorlevel%==0 (
goto qcprotocheck
) else (
goto eof
)
:qcprotocheck
fb2 getvar secure 2>&1 | findstr /C:"secure: no" > nul
if %errorlevel%==0 (
echo  [91m=== %t0005% ===[0m
echo.
)
:eof
