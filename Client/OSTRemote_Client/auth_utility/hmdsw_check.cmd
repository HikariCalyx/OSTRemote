fb2 oem getsecurityversion 2>&1 | findstr FAILED > nul
if not %errorlevel%==0 (
echo  [93m=== %t0077% ===[0m
echo.
echo hmdsw > %temp%\hmdsw_flag
)
:eof
