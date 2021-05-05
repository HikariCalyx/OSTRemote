echo.
if %pretest%==1 echo %t0002%
if %edl_mode%==0 echo %t0003%
fastboot oem alive 2>nul
for /f %%i in ( 'fb2 devices' ) do set psn=%%i
echo.
call auth_utility\prototype_check.cmd
call auth_utility\hmdsw_check.cmd
echo. %t0004%!psn!
fb2 oem getProjectCode 2>&1 | findstr getProjectCode | sed "s/getProjectCode: / %t0006%/g" | findstr /V FAILED
fb2 oem getprojectcode 2>&1 | findstr bootloader | sed "s/(bootloader) / %t0006%/g" | findstr /V FAILED
fb2 oem getSecurityVersion 2>&1 | findstr getSecurityVersion | sed "s/getSecurityVersion: / %t0007%/g" | findstr /V FAILED
fb2 oem getsecurityversion 2>&1 | findstr bootloader | sed "s/(bootloader) / %t0007%/g" | findstr /V FAILED
fb2 oem getBrandCode 2>&1 | findstr /V FAILED | findstr getBrandCode | sed "s/getBrandCode: / %t0026%/g"
if %localized_value%==1 (
fb2 oem getversions 2>&1 | findstr bootloader | sed "s/(bootloader) //g"| sed "s/^model=/ %t0008%/g" | sed "s/^sub_model=/ %t0009%/g" | sed "s/^software version=/ %t0010%/g" | sed "s/^SW model=/ %t0011%/g" | sed "s/^build number=/ %t0012%/g" | sed "s/^hardware version=/ %t0013%/g" | sed "s/^RF band id=/ %t0014%/g" | sed "s/^chip version=/ %t0015%/g" | sed "s/^MCP info=/ %t0016%/g" | sed "s/^MCP version=/ %t0016%/g" | sed "s/^EMMC version=/ %t0017%/g" | sed "s/^UFS version=/ %t0018%/g" | sed "s/none/ %znone%/g"
) else (
fb2 oem getversions 2>&1 | findstr bootloader | sed "s/(bootloader) //g"| sed "s/=/: /g"
)
fb2 getvar secure 2>&1 | findstr secure | sed "s/secure: / %t0019%/g" | sed "s/no/ %no%/g" | sed "s/yes/ %yes%/g"
fb2 getvar current-slot 2>&1 | findstr current-slot | sed "s/current-slot: / %t0020%/g" | findstr /V FAILED
fb2 getvar unlocked 2>&1 | findstr unlocked | sed "s/unlocked: / %t0021%/g" | sed "s/yes/ %yes%/g" | sed "s/no/ %no%/g"
if %localized_value%==1 (
fb2 oem device-info 2>&1 | findstr /V panel | findstr bootloader | sed "s/\t//g" | sed "s/(bootloader) //g" | sed "s/^Device tampered: / %t0022%/g" | sed "s/^Device unlocked: / %t0023%/g" | sed "s/^Device critical unlocked: / %t0024%/g" | sed "s/^Charger screen enabled: / %t0025%/g"  | sed "s/^Verity mode: / %t0027%/g"  | sed "s/true/ %ztrue%/g" | sed "s/false/ %zfalse%/g"
) else (
fb2 oem device-info 2>&1 | findstr /V panel | findstr bootloader | sed "s/\t//g" | sed "s/(bootloader) //g" 
)
if "%psn:~0,2%"=="D1" set msm8937value=1
if "%psn:~0,2%"=="D10" set msm8937value=0
if "%psn:~0,3%"=="E1M" set msm8937value=1
if "%psn:~0,3%"=="E2M" set msm8937value=1
if "%psn:~0,3%"=="EVW" set msm8937value=1
if "%psn:~0,3%"=="VN3" set msm8937value=1
if "%psn:~0,3%"=="PLE" set msm8937value=1
echo.
if %pretest%==1 echo %t0028%
if %pretest%==1 choice /C RHS /M "%ms0001%" /N
if %errorlevel%==1 (
fb2 reboot 2>nul
echo %t0029%
)
if %errorlevel%==2 (
fb2 oem HALT 2>nul
echo %t0030%
)
