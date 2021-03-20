echo.
echo %t0055%
echo.
if "%auth_only%"=="1" goto authonly_mode
:returnX
if %bldrtype%==commercial if %secver%==0001 call sec1-verity.cmd
if %bldrtype%==commercial if %secver%==0004 call sec4-veracity.cmd
if %bldrtype%==commercial if %secver%==0008 call sec8-veracity.cmd
if %bldrtype%==service if %secver%==0001 call sec4-encuid.cmd
if %bldrtype%==service if %secver%==0004 call sec4-encuid.cmd
if %bldrtype%==service if %secver%==0008 call sec8-encuid.cmd
goto eof

:authonly_mode
fb2 oem getBootloaderType 2>&1 | findstr getBootloaderType > %temp%\bldrtype.txt
set /p bldrtype=<%temp%\bldrtype.txt
For /f "tokens=1* delims= " %%A in ( %temp%\bldrtype.txt ) Do set bldrtype=%%B
del %temp%\bldrtype.txt
fb2 oem getSecurityVersion 2>&1 | findstr getSecurityVersion > %temp%\secver.txt
For /f "tokens=1* delims= " %%A in ( %temp%\secver.txt ) Do set secver=%%B
del %temp%\secver.txt
goto returnX

:eof