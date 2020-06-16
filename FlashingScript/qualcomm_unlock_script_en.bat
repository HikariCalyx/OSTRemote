@echo off
title HMD Bootloader Unlocker
cls
echo.
echo.
echo Hi there! This tool is meant for Unlocking your Nokia HMD
echo minor Sharp Aquos Phone.
echo.
echo This script is written by Hikari Calyx and will usable on:
echo Nokia 2, Nokia 5, Nokia 6, Nokia 6.1,
echo Nokia 6.1 Plus X6, Nokia 7, Nokia 7 Plus, Nokia 8,
echo Sharp Aquos S2 C10, Sharp Aquos S3mini, Sharp Aquos S3
echo.
echo.Your data will be erased once unlocked.
echo.
echo Press any key to proceed.
pause>nul
if not exist fastboot.exe goto errorx
if not exist adbwinapi.dll goto errorx
if not exist adbwinusbapi.dll goto errorx
echo.
echo Please connect your powered off phone or phone that entered Download mode
fastboot oem alive>nul
fastboot devices > tmp.txt
set /p devsn=<tmp.txt
echo %devsn:~0,16% > tmp.txt
set /p devsn=<tmp.txt
fb2 oem getProjectCode 2>&1|findstr getProjectCode>tmp.txt
For /f "tokens=2* delims= " %%A in ( tmp.txt ) Do set actprojectcode=%%A
fb2 oem getSecurityVersion 2>&1|findstr getSecurityVersion>tmp.txt
For /f "tokens=2* delims= " %%A in ( tmp.txt ) Do set secver=%%A
del tmp.txt
:selection
set normallock=0
set criticallock=0
set sel=
set econfirm=
cls
echo.
echo Your Phone's serial number is %devsn:~0,16%.
if "%actprojectcode:~0,3%"=="FRT" echo Model is Nokia 1.
if "%actprojectcode:~0,3%"=="ANT" echo Model is Nokia 1 Plus.
if "%actprojectcode:~0,3%"=="E1M" echo Model is Nokia 2.
if "%actprojectcode:~0,3%"=="E2M" echo Model is Nokia 2.1.
if "%actprojectcode:~0,3%"=="EVW" echo Model is Nokia 2.1 V.
if "%actprojectcode:~0,3%"=="NE1" echo Model is Nokia 3.
if "%actprojectcode:~0,3%"=="ES2" echo Model is Nokia 3.1.
if "%actprojectcode:~0,3%"=="EAG" echo Model is Nokia 3.1 A & C.
if "%actprojectcode:~0,3%"=="ROO" echo Model is Nokia 3.1 Plus.
if "%actprojectcode:~0,3%"=="RHD" echo Model is Nokia 3.1 Plus C.
if "%actprojectcode:~0,3%"=="ND1" echo Model is Nokia 5.
if "%actprojectcode:~0,3%"=="CO2" echo Model is Nokia 5.1.
if "%actprojectcode:~0,3%"=="PDA" echo Model is Nokia 5.1 Plus X5.
if "%actprojectcode:~0,3%"=="D1C" echo Model is Nokia 6.
if "%actprojectcode:~0,3%"=="PLE" echo Model is Nokia 6.
if "%actprojectcode:~0,3%"=="PL2" echo Model is Nokia 6.1.
if "%actprojectcode:~0,3%"=="DRG" echo Model is Nokia 6.1 Plus X6.
if "%actprojectcode:~0,3%"=="C1N" echo Model is Nokia 7.
if "%actprojectcode:~0,3%"=="B2N" echo Model is Nokia 7 Plus.
if "%actprojectcode:~0,3%"=="CTL" echo Model is Nokia 7.1.
if "%actprojectcode:~0,3%"=="TAS" echo Model is Nokia X71.
if "%actprojectcode:~0,3%"=="NB1" echo Model is Nokia 8.
if "%actprojectcode:~0,3%"=="A1N" echo Model is Nokia 8 Sirocco.
if "%actprojectcode:~0,3%"=="PNX" echo Model is Nokia 8.1 X7.
if "%actprojectcode:~0,3%"=="AOP" echo Model is Nokia 9 PureView.
if "%actprojectcode:~0,3%"=="SS2" echo Model is Sharp Aquos S2 C10.
if "%actprojectcode:~0,3%"=="SAT" echo Model is Sharp Aquos S2 SDM660.
if "%actprojectcode:~0,3%"=="SG1" echo Model is Sharp Aquos S3 mini.
if "%actprojectcode:~0,3%"=="HH1" echo Model is Sharp Aquos S3 D10.
if "%actprojectcode:~0,3%"=="SD1" echo Model is Sharp Aquos S3 SDM660.
echo Project Code is %actprojectcode:~0,3%.
if "%actprojectcode:~3,1%"=="1" (
echo.
echo.WARNING: New Security implemented. May need to request downgrade service.
)
if "%secver%"=="0008" (
echo.
echo.WARNING: New Security implemented. This device may unsupported by this tool.
)
echo.
echo.Please choose the feature:
echo. 1. Unlock the bootloader
echo  2. Slot switching
echo  3. Relock the bootloader
echo  4. Reboot to Normal mode and close the tool
echo  5. Power off and close the tool
echo.
set /p sel=Please type in the number and press Enter to proceed.
if "%sel%"=="1" goto no1
if "%sel%"=="2" goto no2
if "%sel%"=="3" goto no3
if "%sel%"=="4" goto no4
if "%sel%"=="5" goto no5
goto selection

:no1
cls
cls
echo.
echo.Your Phone's serial number is %devsn:~0,16%.
echo Please place unlock key file to the same location of this tool.
echo Acceptable filename:
echo %devsn:~0,16%.bin or unlock.bin or unlock.key
echo.
echo Press any key to continue when finished.
pause>nul
if exist %devsn:~0,16%.bin set unlockkey=%devsn:~0,16%.bin
if exist unlock.bin set unlockkey=unlock.bin
if exist unlock.key set unlockkey=unlock.key
if "%unlockkey%"=="" goto errornokey
echo.
echo Unlock key %unlockkey% found.
echo.Are you sure want to unlock? Type "yes" (without quotes) and 
echo.press Enter key to proceed.
echo.
echo Otherwise, press Enter key with nothing typed will return to
echo the menu.
echo.
echo.
set /p econfirm=
if "%econfirm%"=="yes" goto next1
goto selection

:next1
cls
echo.
if "%errorlevel%"=="1" goto errorunexpect
:UBLK2
fastboot oem alive
echo.
echo Checking current bootloader unlock status...
echo.
fastboot oem device-info 2>&1|>nul findstr /C:"Too many links"
if %errorlevel%==0 goto usbthrottling
fastboot oem device-info 2>&1|findstr unlocked>unlockstate.txt
findstr /C:"Device unlocked" unlockstate.txt|>nul findstr false
if %errorlevel%==1 set normallock=0
findstr /C:"Device critical unlocked" unlockstate.txt|>nul findstr false
if %errorlevel%==1 set criticallock=0
>nul set /a lockcnt=%normallock%+%criticallock%
if %lockcnt%==0 goto next4
if exist unlock.key set unlockkey=unlock.key
echo.
echo Unlocking, please wait...
fastboot flash unlock %unlockkey% 2>stdout.txt
if %errorlevel%==1 goto errorunlock
if %normallock%==1 fastboot oem unlock-go
if %criticallock%==1 fastboot flashing unlock_critical
if "%actprojectcode:~0,3%"=="E1M" goto next2
if "%actprojectcode:~0,3%"=="D1A" goto next2
if "%actprojectcode:~0,3%"=="D1L" goto next2
if "%actprojectcode:~0,3%"=="ND1" goto next2
if "%actprojectcode:~0,3%"=="D1C" goto next2
if "%actprojectcode:~0,3%"=="D1T" goto next2
if "%actprojectcode:~0,3%"=="PLE" goto next2
echo Please look at your phone. Use Volume button to choose "UNLOCK THE BOOTLOADER"
echo or "Yes", then press Power button to proceed.
echo.
echo Press any key there when done.
pause>nul
goto next3
:next2
ping 127.0.0.1>nul
:next3
echo Waiting reboot...
goto UBLK2
:next4
echo.
echo Congrats! Now your phone is unlocked. Press any key to exit.
pause>nul
goto EOF

:no2
cls
echo.
fastboot getvar current-slot 2>%temp%\cslot.txt
set /p cslot=<%temp%\cslot.txt
del %temp%\cslot.txt
if "%cslot%"=="current-slot: " (
echo ERROR: This device is A-only device.
echo Press any key to return to the menu.
pause>nul
goto selection
)
if "%cslot%"=="current-slot: a" (
fastboot --set-active=b
fastboot reboot-bootloader
) else (
fastboot --set-active=a
fastboot reboot-bootloader
)
echo Please check if slot is switched correctly, then press any key to return.
pause>nul
goto selection

:no3
cls
echo.
echo.CAUTION
echo WE STRONGLY DO NOT RECOMMEND YOU TO RELOCK THE PHONE UNLESS YOU'RE
echo GOING TO REPAIR YOUR PHONE IN WARRANTY.
echo.
echo If you really want to relock, please ensure the firmware must be
echo original stock state, without rooting.
echo.
if "%actprojectcode%%secver%"=="NB110004" goto next6
if "%actprojectcode:~3,1%"=="1" (
echo You will unable to unlock again after relocked.
)
:next6
echo.
echo.Are you sure want to relock? Type "yes" (without quotes) and 
echo.press Enter key to proceed.
echo.
echo Otherwise, press Enter key with nothing typed will return to
echo the menu.
echo.
set /p econfirm=
if "%econfirm%"=="yes" goto RBLK2
goto selection

:RBLK2
echo.
echo Checking current bootloader unlock status...
echo.
fastboot oem device-info 2>&1|>nul findstr /C:"Too many links"
if %errorlevel%==0 goto usbthrottling
fastboot oem device-info 2>&1|findstr unlocked>unlockstate.txt
findstr /C:"Device unlocked" unlockstate.txt|>nul findstr true
if %errorlevel%==1 set normallock=1
findstr /C:"Device critical unlocked" unlockstate.txt|>nul findstr true
if %errorlevel%==1 set criticallock=1
>nul set /a lockcnt=%normallock%+%criticallock%
if %lockcnt%==2 goto next10
echo.
echo Relocking, please wait...
if %normallock%==0 fastboot flashing lock
if %criticallock%==0 fastboot flashing lock_critical
if "%actprojectcode:~0,3%"=="E1M" goto next8
if "%actprojectcode:~0,3%"=="D1A" goto next8
if "%actprojectcode:~0,3%"=="D1L" goto next8
if "%actprojectcode:~0,3%"=="ND1" goto next8
if "%actprojectcode:~0,3%"=="D1C" goto next8
if "%actprojectcode:~0,3%"=="D1T" goto next8
if "%actprojectcode:~0,3%"=="PLE" goto next8
echo Please look at your phone. Use Volume button to choose "LOCK THE BOOTLOADER"
echo or "Yes", then press Power button to proceed.
echo.
echo Press any key there when done.
pause>nul
goto next9
:next8
ping 127.0.0.1>nul
:next9
echo Waiting reboot...
goto RBLK2
:next10
echo.
echo Your phone is already locked. Press any key to exit.
pause>nul
goto EOF

:no4
fastboot reboot 2>nul
echo.
echo Reboot done. Press any key to exit.
pause>nul
goto EOF

:no5
fastboot oem HALT 2>nul
echo.
echo Now pull the USB cable will power off your phone. Press any key to exit.
pause>nul
goto EOF

:errorx
echo.
echo ERROR: You didn't place required Google Platform Tools executable here.
echo.
echo Please download it from following URL:
echo.
echo https://developer.android.com/studio/releases/platform-tools
pause>nul
goto EOF

:errornokey
echo ERROR: You didn't place the unlock key to required location.
echo Press any key to return to menu.
echo.
pause>nul
goto selection

:errorunlock
findstr /C:"Too many links" goto usbthrottling
if %errorlevel%==0 goto usbthrottling
echo.
echo ERROR: Unlock key verification failed.
if "%actprojectcode%%secver%"=="SS210004" echo You have messed up the bootloader. Disassemble the phone and utilize EDL.
if "%actprojectcode%%secver%"=="HH110004" echo You have messed up the bootloader. Disassemble the phone and utilize EDL.
if "%actprojectcode%%secver%"=="HH610004" echo You have messed up the bootloader. Disassemble the phone and utilize EDL.
if "%actprojectcode%%secver%"=="SD110004" echo You have messed up the bootloader. Disassemble the phone and utilize EDL.
if "%actprojectcode%%secver%"=="SG110004" echo You have messed up the bootloader. Disassemble the phone and utilize EDL.
if "%actprojectcode%%secver%"=="SAT10004" echo You have messed up the bootloader. Disassemble the phone and utilize EDL.
if "%actprojectcode%%secver%"=="SS20001" echo Please update your phone to Android 8 before you use the unlock key.
if "%actprojectcode%%secver%"=="SAT0001" echo Please update your phone to Android 8 before you use the unlock key.
if "%actprojectcode%%secver%"=="PLE10004" echo You can use old OTA package for downgrading before you attempt to unlock.
if "%actprojectcode%%secver%"=="D1C10004" echo You can use old OTA package for downgrading before you attempt to unlock.
if "%actprojectcode%%secver%"=="ND110004" echo You can use old OTA package for downgrading before you attempt to unlock.
if "%actprojectcode%%secver%"=="E1M10004" echo You can use old OTA package for downgrading before you attempt to unlock.
if "%actprojectcode%%secver%"=="PL210004" echo Please request remote unlock service directly from Hikari Calyx Tech.
if "%actprojectcode%%secver%"=="DRG10004" echo Please request remote unlock service directly from Hikari Calyx Tech.
if "%actprojectcode%%secver%"=="C1N10004" echo Please request remote unlock service directly from Hikari Calyx Tech.
if "%actprojectcode%%secver%"=="B2N10004" echo Please request remote unlock service directly from Hikari Calyx Tech.
if "%actprojectcode%%secver%"=="NB110004" echo Please try to request unlock key from official:
if "%actprojectcode%%secver%"=="NB110004" echo https://www.nokia.com/en_int/phones/bootloader
if "%actprojectcode%%secver%"=="NB110004" echo.
echo Otherwise please check if your unlock key is incorrect. Press any key to return to menu.
fb2 oem getProjectCode
pause>nul
goto selection

:errorusbthrottling
echo.
echo WARNING: USB port is throttling.
echo.
echo This means the USB controller of your PC seems incompatible
echo to your phone.
echo.
echo.This is known issue on Sharp phones, but we're not sure about
echo known incompatible USB controllers.
echo.
echo.Please try use another PC to unlock this phone.
echo.Change the driver will not fix the problem.
echo.
echo.Press any key to return to menu.
pause>nul
goto selection

:aunlocked
if "%critlock%"=="1" goto next4
echo.
echo ERROR: Your phone already has unlocked bootloader.
echo.
fastboot oem device-info
echo.
echo Press any key to return to menu.
echo.
pause>nul
goto selection

:errorlock
if "%critlock%"=="1" goto next10
echo.
echo ERROR: Your phone already has locked bootloader.
echo.
fastboot oem device-info
echo.
echo Press any key to return to menu.
echo.
pause>nul
goto selection

:mediatek
echo.
echo ERROR: You're attempting to perform this on MediaTek-SOC phone.
echo.
echo Press any key to return to menu.
echo.
pause>nul
goto selection

:EOF
