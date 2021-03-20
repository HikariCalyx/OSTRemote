@echo off
setlocal enabledelayedexpansion
set PATH=%PATH%;%~dp0bin;%~dp0auth_utility
set targetskuid=
set ver=V0.0.0.3a.Windows
set verbose_mode=0
set erase=0
set edl_mode=0
set erase_frp=0
set override=0
set pretest=0
set autoskuid=0
set chngskuid=0
set service_auth=1
set auth_only=0
set disable_fac_mode=0
set device_halt=0
set paramcount=1
set nb0mode=0
set mlffile=0
set localized_value=0
set resultverify=1

For /f "tokens=2* delims= " %%A in ('Reg Query HKLM\System\CurrentControlSet\Control\Nls\Language /v InstallLanguage') Do Set langcode=%%B
IF EXIST Localization\%langcode%.cmd (
call Localization\%langcode%.cmd
) ELSE (
call Localization\0409.cmd
)

title HCTSW Care %t0001%
echo HCTSW Care %t0001% %ver%
echo %copyright%

For /f "tokens=2* delims= " %%A in ('Reg Query "HKLM\Software\Microsoft\Windows NT\CurrentVersion" /v CurrentBuild') Do Set osbuild=%%B
if %osbuild% lss 9600 echo %t0056%
:existing_fastboot_cmd_detection
if not exist %SystemRoot%\WinSxS\*ucrt* goto error_noucrt
fastboot help 2>&1 | findstr slot > nul
if %errorlevel%==1 goto error_fastbootconflict

if "%1"=="" (
echo no prm defined
goto eof
)

:readparam
set cparam=%1
if defined cparam (

::Read NB0
if "%cparam%"=="-n" (
set nb0mode=1
set nb0file=%2
set nb0filepath=%~dp2
if not exist "!nb0file!" goto invalid_fw else shift
)

if "%cparam%"=="--nb0file" (
set nb0mode=1
set nb0file=%2
set nb0filepath=%~dp2
if not exist "!mlffile!" goto invalid_fw else shift
)

::Read MLF
if "%cparam%"=="-m" (
set mlfmode=1
set mlffile=%2
set mlffilepath=%~dp2
if not exist "!mlffile!" goto invalid_fw else shift
)

if "%cparam%"=="--mlffile" (
set mlfmode=1
set mlffile=%2
set mlffilepath=%~dp2
if not exist "!mlffile!" goto invalid_fw else shift
)

::Read SKUID
if "%cparam%"=="-s" (
set chngskuid=1
set targetskuid=%2
if "!targetskuid!"=="" (set autoskuid=1) else shift
if "!targetskuid:~0,1!"=="-" (
set targetskuid=
set autoskuid=1
) else shift
)

if "%cparam%"=="--skuid" (
set chngskuid=1
set targetskuid=%2
if "!targetskuid!"=="" (set autoskuid=1) else shift
if "!targetskuid:~0,1!"=="-" (
set targetskuid=
set autoskuid=1
) else shift
)

::Help Message
if "%cparam%"=="-?" goto help
if "%cparam%"=="-h" goto help
if "%cparam%"=="--help" goto help

::Verbose Mode
if "%cparam%"=="-v" set verbose_mode=1
if "%cparam%"=="--verbose" set verbose_mode=1

::Erase User Data
if "%cparam%"=="-e" set erase=1
if "%cparam%"=="--erase-user-data" set erase=1

::Skip Authentication
if "%cparam%"=="-S" set service_auth=0
if "%cparam%"=="--skip-authentication" set service_auth=0

::Erase FRP
if "%cparam%"=="-f" set erase_frp=1
if "%cparam%"=="--erase_frp" set erase_frp=1

::Erase FRP
if "%cparam%"=="-a" set auth_only=1
if "%cparam%"=="--authentication-only" set auth_only=1

::EDL Mode
if "%cparam%"=="-E" set edl_mode=1
if "%cparam%"=="--edl_mode" set edl_mode=1

::Overrride
if "%cparam%"=="-o" set override=1
if "%cparam%"=="--override" set override=1

::Pretest Only
if "%cparam%"=="-p" set pretest=1
if "%cparam%"=="--pretest" set pretest=1

::Disable Fac Mode
if "%cparam%"=="-D" set disable_fac_mode=1
if "%cparam%"=="--disable-fac-mode" set disable_fac_mode=1

::Halt After Flash Procedure
if "%cparam%"=="-D" set disable_fac_mode=1
if "%cparam%"=="--disable-fac-mode" set disable_fac_mode=1

::Shutdown Device After Flash 
if "%cparam%"=="-H" set device_halt=1
if "%cparam%"=="--halt" set device_halt=1

shift
set /a paramcount=%paramcount%+1
) else (
goto proc_start
)
goto readparam

:proc_start
if "%pretest%"=="1" (
call pretest.cmd
goto eof
)

if "%nb0mode%"=="1" (
set fwmode=NB0
set fwfile=%nb0file%
set fwfilepath=%nb0filepath%
if "%mlfmode%"=="1" goto invalid_prm
)

if "%mlfmode%"=="1" (
set fwmode=MLF
set fwfile=%mlffile%
set fwfilepath=%mlffilepath%
if "%nb0mode%"=="1" goto invalid_prm
)

if %verbose_mode%==1 (
echo %s0001%%fwmode%
echo %s0002%%fwfile%
echo %s0003%%fwfilepath%
)
if "%autoskuid%"=="1" echo %t0050%

if %service_auth%==0 (
set chngskuid=0
set erase_frp=0
)

if "%auth_only%"=="1" echo %t0061%
call pretest.cmd
if "%auth_only%"=="1" (
call call_auth.cmd
goto eof
)
if %override%==0 call safety_check.cmd else set insecure=0
if %service_auth%==1 if %erase_frp%==1 call frpwarning.cmd
if %skipfrp%==1 goto eof
if %insecure%==1 goto eof
call mlf-parser.cmd
if %service_auth%==0 (
if exist %temp%\eflash.txt goto error_notunlocked
)
if %autoskuid%==1 call autoskuid.cmd
if %chngskuid%==1 (
echo %t0046% %targetskuid%...
if %verbose_mode%==1 (
fb2 oem CustomerSKUID set %targetskuid%
) else (
2>nul fb2 oem CustomerSKUID set %targetskuid%
)
)
if "%erase_frp%"=="1" (
echo %t0060%
if "%verbose_mode%"=="1" (
fastboot erase frp
) else (
fastboot erase frp 2>&1 | findstr FAILED
)
)
if "%device_halt%"=="1" (
echo %t0030%
if "%verbose_mode%"=="1" (
fb2 oem HALT
) else (
fb2 oem HALT 2>nul
)
) else (
echo %t0029%
if "%verbose_mode%"=="1" (
fb2 reboot
) else (
fb2 reboot 2>nul
)
)

goto eof

:help
echo.
echo %h0001a% %0 %h0001b%
echo.
echo %h0002%
echo %h0003%
echo %h0004%
echo %h0005a%
echo %h0005b%
rem echo %h0006%
rem echo %h0005b%
echo %h0007%
echo %h0008a%
echo %h0008b%
echo %h0009%
echo %h0010a%
echo %h0010b%
rem echo %h0011%
rem echo %h0012%
echo %h0013%
echo %h0014a%
echo %h0014b%
echo %h0014c%
echo %h0015a%
echo %h0015b%
echo %h0016%
echo %h0017a%
echo %h0017b%
rem echo %h0018a%
rem echo %h0018b%
rem echo %h0019a%
rem echo %h0018b%
rem echo %h0020a%
rem echo %h0018b%
rem echo %h0021a%
rem echo %h0018b%
rem echo %h0022a%
rem echo %h0022b%
echo.
echo %ex0001%
echo.
echo %ex0002a%
echo.	%0 %ex0002b%
echo.
rem echo %ex0003a%
rem echo.	%0 %ex0003b%
echo.
rem echo %ex0004a%
rem echo %ex0004b%
echo %ex0005a%
echo.	%0 %ex0005b%
echo.
goto eof

:invalid_prm
echo.
echo %t0036%
goto eof

:invalid_fw
echo.
echo %t0037%
goto eof

:error_notunlocked
echo.
echo %t0052%
del %temp%\eflash.txt
goto eof

:error_noucrt
echo.
echo %t0057%
goto eof

:error_fastbootconflict
echo.
echo %t0058%
echo.
where fastboot
goto eof

:eof