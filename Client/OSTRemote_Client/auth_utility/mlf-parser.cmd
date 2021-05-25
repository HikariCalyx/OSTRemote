@echo off
setlocal enabledelayedexpansion
set errorflash=0
set PATH=%PATH%;%~dp0\bin
echo %fwfilepath%| sed "s/ /\" \"/g" > %temp%\spacepath.txt
set /p quotefwfp=<%temp%\spacepath.txt
if "%nb0mode%"=="1" set mlffile=%quotefwfp%%mlffile%
if "%qlzmode%"=="1" set mlffile=%quotefwfp%%mlffile%
findstr "^OPTION" %mlffile% | sed "s/OPTION = //g" > %temp%\1.txt
findstr "^BOOT_NAME" %mlffile% | sed "s/BOOT_NAME = //g" > %temp%\2.txt
findstr "^IMAGE_FILE" %mlffile% | sed "s/IMAGE_FILE = //g" > %temp%\3.txt
awk "NR==FNR{a[NR]=$0;nr=NR;}NR>FNR{print a[NR-nr]\",\"$0}" %temp%\1.txt %temp%\2.txt > %temp%\2x.txt
awk "NR==FNR{a[NR]=$0;nr=NR;}NR>FNR{print a[NR-nr]\" \"$0}" %temp%\2x.txt %temp%\3.txt > %temp%\3x.txt
sed -i "s/\"//g" %temp%\3x.txt
sed -i "s/ $//g" %temp%\3x.txt
findstr /V /C:"0x1," /C:"0x800," %temp%\3x.txt > %temp%\4.txt
>nul move %temp%\4.txt %temp%\regular.txt
findstr /C:"0x100000," /C:"0x200000," /C:"0x400000," /C:"0x800000," %temp%\regular.txt > %temp%\servicebootloader.txt
if exist %temp%\5.txt del %temp%\5.txt
for /f "tokens=1* delims= " %%i in ( %temp%\servicebootloader.txt ) do echo %%j >> %temp%\5.txt
findstr zip %temp%\5.txt > %temp%\servicebootloaderzip.txt
del %temp%\5.txt
if exist %temp%\extractedsbl.txt del %temp%\extractedsbl.txt
for /f "tokens=1* delims= " %%i in ( %temp%\servicebootloaderzip.txt ) do zipinfo -1 "%fwfilepath%%%i" >> %temp%\extractedsbl.txt
for /f "tokens=1* delims= " %%i in ( %temp%\servicebootloaderzip.txt ) do unzip -q -P WLBGFIH123 -o "%fwfilepath%%%i" -d %quotefwfp%
if exist %temp%\replacement.txt del %temp%\replacement.txt
awk "NR==FNR{a[NR]=$0;nr=NR;}NR>FNR{print a[NR-nr]\",\"$0}" %temp%\servicebootloaderzip.txt %temp%\extractedsbl.txt | sed "s/ ,/\//g" > %temp%\replacement.txt
for /f %%i in ( %temp%\replacement.txt ) do sed -i "s/%%i/g" %temp%\servicebootloader.txt
:workaround_for_msm8937_device
if "%msm8937value%"=="1" (
findstr /V abootbak %temp%\servicebootloader.txt > %temp%\sbl2.txt
del %temp%\servicebootloader.txt
>nul move %temp%\sbl2.txt %temp%\servicebootloader.txt
)
for /f %%i in ( %temp%\replacement.txt ) do sed -i "s/%%i/g" %temp%\regular.txt
if "%afu%"=="1" (
>%temp%\99.txt set /p=99<nul
if exist %quotefwfp%\systeminfo.img (
copy %quotefwfp%\systeminfo.img %quotefwfp%\systeminfo_b99.img
2>nul dd if=%temp%\99.txt of=%quotefwfp%\systeminfo_b99.img bs=1 seek=21
sed -i "s/systeminfo.img/systeminfo_b99.img/g" %temp%\regular.txt
del %temp%\99.txt
)
if exist %quotefwfp%\fver (
copy %quotefwfp%\fver %quotefwfp%\fver
2>nul dd if=%temp%\99.txt of=%quotefwfp%\fver bs=1 seek=21
sed -i "s/fver/fver_b99/g" %temp%\regular.txt
del %temp%\99.txt
)
)
del %temp%\servicebootloaderzip.txt
del %temp%\replacement.txt
del %temp%\extractedsbl.txt
del sed??????
del %temp%\1.txt
del %temp%\2.txt
del %temp%\3.txt
del %temp%\2x.txt
del %temp%\3x.txt
fb2 oem getBootloaderType 2>&1 | findstr "getBootloaderType bootloader" > %temp%\bldrtype.txt
set /p bldrtype=<%temp%\bldrtype.txt
For /f "tokens=1* delims= " %%A in ( %temp%\bldrtype.txt ) Do set bldrtype=%%B
del %temp%\bldrtype.txt
fb2 oem getSecurityVersion 2>&1 | findstr getSecurityVersion > %temp%\secver.txt
For /f "tokens=1* delims= " %%A in ( %temp%\secver.txt ) Do set secver=%%B
del %temp%\secver.txt
cd /d "%fwfilepath%"
if %bldrtype%==service goto directflash
if "%service_auth%"=="1" call call_auth.cmd
if "%otpdefined%"=="1" if "!otpfail!"=="1" goto eof
for /f "tokens=1* delims=," %%a in ( %temp%\servicebootloader.txt ) do (
set target=%%b
call fbflash.cmd
if "!errorflash!"=="1" goto eof
)
echo %t0039%
if %verbose_mode%==1 (
echo.
fastboot reboot-bootloader
echo.
) else (
fastboot reboot-bootloader 2>nul
)
fb2 oem alive 2>nul
timeout /t 2 /nobreak > nul
echo %t0040%
fb2 oem getBootloaderType 2>&1 | findstr "getBootloaderType bootloader" > %temp%\bldrtype.txt
set /p bldrtype=<%temp%\bldrtype.txt
For /f "tokens=1* delims= " %%A in ( %temp%\bldrtype.txt ) Do set bldrtype=%%B
del %temp%\bldrtype.txt
if %bldrtype%==commercial (
set errorflash=1
goto eof
)
:directflash
echo ,>>%temp%\regular.txt
for /f "tokens=1* delims=," %%a in ( %temp%\regular.txt ) do (
if "!errorflash!"=="1" goto eof
set target=%%b
if %%a==0x1000000000000000 call fbdirect.cmd
if %%a==0x1000000000000004 if %service_auth%==1 call call_auth.cmd
if %%a==0x1000000000000044 if %service_auth%==1 call call_auth.cmd
if "%otpdefined%"=="1" if "!otpfail!"=="1" goto eof
if %%a==0x2 call fbflash.cmd
if %%a==0x4 call fberase.cmd
if %%a==0x40 call fbflash.cmd
if %%a==0x1000 call fbflash.cmd
if %%a==0x40000 call fbflash.cmd
if %%a==0x4000 (
if "!target:~0,8!"=="userdata" (
if %erase%==1 (
call fbflash.cmd
)
) else (
call fbflash.cmd
)
)
if %%a==0x8 if %erase%==1 (
if "%msm8937value%"=="1" (
call fberase.cmd
) else (
if "!target:~0,8!"=="userdata" (
call fbformat.cmd
) else (
call fberase.cmd
) ) )
if %%a==0x100000 call fbflash.cmd
if %%a==0x200000 call fbflash.cmd
if %%a==0x400000 call fbflash.cmd
if %%a==0x800000 call fbflash.cmd
if "%%a"=="" goto endofflash
)
)
:endofflash
echo %t0045%
:eof