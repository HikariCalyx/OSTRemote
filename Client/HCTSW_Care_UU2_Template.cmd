@echo off
set no_verbose="1>nul 2>nul"
del *.txt 1>nul 2>nul
del *.bin 1>nul 2>nul
set PATH=%PATH%;%~dp0bin
For /f "tokens=2* delims= " %%A in ('Reg Query HKLM\System\CurrentControlSet\Control\Nls\Language /v InstallLanguage') Do Set langcode=%%B
IF EXIST Localization\%langcode%.cmd (
call Localization\%langcode%.cmd
) ELSE (
call Localization\0409.cmd
)
set osarch=x86
if exist %SystemRoot%\WinSxS\amd64* set osarch=amd64
if exist %SystemRoot%\WinSxS\arm64* set osarch=arm64
For /f "tokens=2* delims= " %%A in ('Reg Query "HKLM\Software\Microsoft\Windows NT\CurrentVersion" /v CurrentBuild') Do Set osbuild=%%B
if osbuild lss 9600 echo %t0032%
set version=V1.1.4.0e
if "%1"=="-v" set no_verbose=" "
if "%1"=="--verbose" set no_verbose=" "
if "%1"=="-?" goto help
if "%1"=="-h" goto help
if "%1"=="--help" goto help
if not exist %SystemRoot%\system32\findstr.exe ( copy /y %~dp0bin\findstr7.exe %~dp0bin\findstr.exe )
title HCTSW Care %t0000% %version%
echo %t0001%
:reauth
fb2 oem alive 2>nul
fb2 devices>tmp1.txt
set /p sn=<tmp1.txt
set sn=%sn:~0,16%
del tmp1.txt
echo %t0026a% %sn% %t0026b%
echo.
fb2 oem getBootloaderType 2>&1 | findstr getBootloaderType > bldrtype.txt
set /p bldrtype=<bldrtype.txt
For /f "tokens=1* delims= " %%A in ( bldrtype.txt ) Do set bldrtype=%%B
echo %t0005% %bldrtype%%dot_mark% %no_verbose:~1,-1%
del bldrtype.txt
if %bldrtype%==service goto stage2
fb2 oem getSecurityVersion 2>&1 | findstr getSecurityVersion > secver.txt
set /p secver=<secver.txt
For /f "tokens=1* delims= " %%A in ( secver.txt ) Do set secver=%%B
del secver.txt
echo.
echo %t0035%
echo %t0006% %secver%
if %secver%==0001 call auth_utility\sec1-verity.cmd
if %secver%==0004 call auth_utility\sec4-veracity.cmd
if %secver%==0008 call auth_utility\sec8-veracity.cmd
if "%challenge%"=="pass" echo %t0023%
if "%challenge%"=="fail" goto error_unpass

rem == PLEASE INSERT SERVICE BOOTLOADER IMAGE FLASH CMD ==

rem here're some commands

rem == PLEASE INSERT SERVICE BOOTLOADER IMAGE FLASH CMD ==

fastboot reboot-bootloader %no_verbose:~1,-1%
timeout /t 2 /nobreak %no_verbose:~1,-1%

:stage2
fb2 oem getBootloaderType 2>&1 | findstr getBootloaderType > bldrtype.txt
set /p bldrtype=<bldrtype.txt
For /f "tokens=1* delims= " %%A in ( bldrtype.txt ) Do set bldrtype=%%B
echo %t0005% %bldrtype%%dot_mark% %no_verbose:~1,-1%
if %bldrtype%==commercial goto error_dmgemmc
fb2 oem getSecurityVersion 2>&1 | findstr getSecurityVersion > secver.txt
set /p secver=<secver.txt
For /f "tokens=1* delims= " %%A in ( secver.txt ) Do set secver=%%B
del secver.txt
echo.
echo %t0035%
echo %t0006% %secver%
if %secver%==0001 call auth_utility\sec4-encuid.cmd
if %secver%==0004 call auth_utility\sec4-encuid.cmd
if %secver%==0008 call auth_utility\sec8-encuid.cmd
if "%challenge%"=="pass" echo %t0023%
if "%challenge%"=="fail" echo error_unpass
fastboot oem fih on %no_verbose:~1,-1%
fastboot oem devlock allow_unlock %no_verbose:~1,-1%
fastboot flashing unlock_critical %no_verbose:~1,-1%
if not %errorlevel%==0 goto unlock-go
echo %t0009%
echo %t0010%
:loop1
devcon_%osarch% find USB* | findstr %sn% > nul
if %errorlevel%==0 goto loop1
echo %t0011%
fastboot oem alive 2>nul
fastboot flash encUID encuid.bin %no_verbose:~1,-1%
fastboot oem selectKey service %no_verbose:~1,-1%
fastboot oem doKeyVerify %no_verbose:~1,-1%
fastboot oem allport %no_verbose:~1,-1%
:unlock-go

rem == PLEASE INSERT RETAIL BOOTLOADER IMAGE FLASH CMD ==

rem here're some commands

rem == PLEASE INSERT RETAIL BOOTLOADER IMAGE FLASH CMD ==

fastboot oem fih on %no_verbose:~1,-1%
fastboot oem devlock allow_unlock %no_verbose:~1,-1%
fastboot oem unlock-go %no_verbose:~1,-1%
if not %errorlevel%==0 goto unlocked
echo %t0009%
echo %t0010%
:loop2
devcon_%osarch% find USB* | findstr %sn% > nul
if %errorlevel%==0 goto loop2
echo %t0012%
pause>nul

goto EOF

:error_dmgemmc
echo.
echo %t0013%
echo.
pause>nul
goto EOF

:unlocked
echo.
echo %t0014%
echo.
pause>nul
goto EOF

:help
echo.
echo HCTSW Care %t0000% %version%
echo.
echo %t0015a% %0 %t0015b%
echo.
echo %t0016%
echo.
echo %t0017%
echo %t0018%
echo %t0019%
echo %t0020%
echo.
echo %copyright%
goto EOF

:error_unpass
echo.
echo %t0033%
echo.
pause>nul
fastboot reboot-bootloader 2>nul
echo %t0034%
timeout /t 4 /nobreak > nul
cls
goto reauth

:EOF
