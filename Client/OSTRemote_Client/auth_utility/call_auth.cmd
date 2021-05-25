echo.
echo %t0055%
echo.
:authonly_mode
fb2 oem alive 2>nul

:Workaround for MTK devices
:Need to wait few seconds to ensure USB traffic become stable
if "%psn:~0,3%"=="NE1" set mtkdev=1
if "%psn:~0,3%"=="FRT" set mtkdev=1
if "%psn:~0,3%"=="ES2" set mtkdev=1
if "%psn:~0,3%"=="CO2" set mtkdev=1
if "%psn:~0,3%"=="PDA" set mtkdev=1
if "%psn:~0,3%"=="ROO" set mtkdev=1
if "%psn:~0,3%"=="ANT" set mtkdev=1
if "%psn:~0,3%"=="012" set mtkdev=1
if "%mtkdev%"=="1" timeout /t 2 /nobreak > nul

fb2 oem getBootloaderType 2>&1 | findstr "getBootloaderType bootloader" | findstr /V FAILED > %temp%\bldrtype.txt
set /p bldrtype=<%temp%\bldrtype.txt
For /f "tokens=1* delims= " %%A in ( %temp%\bldrtype.txt ) Do set bldrtype=%%B
del %temp%\bldrtype.txt
fb2 oem getSecurityVersion 2>&1 | findstr "getSecurityVersion bootloader" | findstr /V FAILED > %temp%\secver.txt
For /f "tokens=1* delims= " %%A in ( %temp%\secver.txt ) Do set secver=%%B
del %temp%\secver.txt

:sec1
fb2 oem getProjectCode 2>&1 | findstr FAILED > nul
if "%errorlevel%"=="0" set secver=0001

:returnX
if %bldrtype%==commercial if %secver%==0001 call sec1-verity.cmd
if %bldrtype%==commercial if %secver%==0004 if %otpdefined%==1 (call sec4-veracity1.cmd) else (call sec4-veracity.cmd)
if %bldrtype%==commercial if %secver%==0008 if %otpdefined%==1 (call sec8-veracity1.cmd) else (call sec8-veracity.cmd)
if %bldrtype%==service if %secver%==0001 if %otpdefined%==1 (call sec4-encuid1.cmd) else (call sec4-encuid.cmd)
if %bldrtype%==service if %secver%==0004 if %otpdefined%==1 (call sec4-encuid1.cmd) else (call sec4-encuid.cmd)
if %bldrtype%==service if %secver%==0008 if %otpdefined%==1 (call sec4-veracity1.cmd) else (call sec4-veracity.cmd)
if "%otpfail%"=="1" echo fail > %temp%\otpfail_flag
goto eof

:eof