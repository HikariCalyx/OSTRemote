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
set /p actprojectcode=<tmp.txt
del tmp.txt
:selection
set sel=
set econfirm=
cls
echo.
echo Your Phone's serial number is %devsn:~0,16%.
if "%actprojectcode:~0,3%"=="E1M" echo Model is Nokia 2.
if "%actprojectcode:~0,3%"=="D1A" echo Model is Nokia 5.
if "%actprojectcode:~0,3%"=="D1L" echo Model is Nokia 5.
if "%actprojectcode:~0,3%"=="ND1" echo Model is Nokia 5.
if "%actprojectcode:~0,3%"=="D1C" echo Model is Nokia 6.
if "%actprojectcode:~0,3%"=="D1T" echo Model is Nokia 6.
if "%actprojectcode:~0,3%"=="PLE" echo Model is Nokia 6.
if "%actprojectcode:~0,3%"=="PL2" echo Model is Nokia 6.1.
if "%actprojectcode:~0,3%"=="DRG" echo Model is Nokia 6.1 Plus X6.
if "%actprojectcode:~0,3%"=="C1N" echo Model is Nokia 7.
if "%actprojectcode:~0,3%"=="B2N" echo Model is Nokia 7 Plus.
if "%actprojectcode:~0,3%"=="NB1" echo Model is Nokia 8.
if "%actprojectcode:~0,3%"=="SS2" echo Model is Sharp Aquos S2 C10.
if "%actprojectcode:~0,3%"=="SAT" echo Model is Sharp Aquos S2 SDM660.
if "%actprojectcode:~0,3%"=="SG1" echo Model is Sharp Aquos S3 mini.
if "%actprojectcode:~0,3%"=="HH1" echo Model is Sharp Aquos S3.
if "%actprojectcode:~0,3%"=="SD1" echo Model is Sharp Aquos S3 SDM660.
echo Project Code is %actprojectcode:~0,3%.
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
fastboot oem device-info
echo.
if %errorlevel%==1 goto mediatek
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
echo Unlocking, please wait...
fastboot flash unlock %unlockkey%
if "%errorlevel%"=="1" goto errorunlock
fastboot flashing unlock_critical
if "%errorlevel%"=="1" goto trygo
if "%errorlevel%"=="0" set critlock=1
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
fastboot oem alive
fastboot flash unlock %unlockkey%
:trygo
fastboot oem unlock-go
if "%errorlevel%"=="1" goto aunlocked
if "%actprojectcode:~0,3%"=="E1M" goto next4
if "%actprojectcode:~0,3%"=="D1A" goto next4
if "%actprojectcode:~0,3%"=="D1L" goto next4
if "%actprojectcode:~0,3%"=="ND1" goto next4
if "%actprojectcode:~0,3%"=="D1C" goto next4
if "%actprojectcode:~0,3%"=="D1T" goto next4
if "%actprojectcode:~0,3%"=="PLE" goto next4
echo Please look at your phone. Use Volume button to choose "UNLOCK THE BOOTLOADER"
echo or "Yes", then press Power button to proceed.
echo.
echo Press any key there when done.
pause>nul
:next4
echo.
echo Congrats! Now your phone is unlocked. Press any key to exit.
goto EOF

:no2
cls
echo.
fastboot getvar current-slot
echo.
echo Your phone's current slot is shown above. Please type in new
echo slot (a / b) and press Enter key to continue.
echo.
echo Otherwise, press Enter key with nothing typed will return to
echo the menu.
set /p econfirm=
if %econfirm%==A goto next5a
if %econfirm%==B goto next5b
if %econfirm%==a goto next5a
if %econfirm%==b goto next5b
goto selection

:next5a
fastboot oem set_active _a
fastboot --set-active=a
fastboot reboot-bootloader
fastboot getvar current-slot
goto next5c

:next5b
fastboot oem set_active _b
fastboot --set-active=b
fastboot reboot-bootloader
fastboot getvar current-slot
goto next5c

:next5c
echo Please check if slot is switched correctly, then press any key to return.
pause>nul
goto selection

:no3
cls
fastboot oem device-info
echo.
if %errorlevel%==1 goto mediatek
cls
echo.
echo.CAUTION
echo WE STRONGLY DO NOT RECOMMEND YOU TO RELOCK THE PHONE UNLESS YOU'RE
echo GOING TO REPAIR YOUR PHONE IN WARRANTY.
echo.
echo If you really want to relock, please ensure the firmware must be
echo original stock state, without rooting.
echo.
if "%actprojectcode:~0,3%"=="NB1" goto next6
if "%actprojectcode:~0,3%"=="SS2" goto next6
if "%actprojectcode:~0,3%"=="SAT" goto next6
echo If getProjectCode is shown as %actprojectcode:~0,3%1, you will unable
echo to unlock again.
fb2 oem getProjectCode
:next6
echo.
echo.Are you sure want to relock? Type "yes" (without quotes) and 
echo.press Enter key to proceed.
echo.
echo Otherwise, press Enter key with nothing typed will return to
echo the menu.
echo.
set /p econfirm=
if "%econfirm%"=="yes" goto next7
goto selection

:next7
cls
echo.
echo Relocking, please wait...
fastboot flashing lock_critical
if "%errorlevel%"=="1" goto next9a
if "%errorlevel%"=="0" set critlock=1
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
fastboot oem alive
:next9a
fastboot oem lock-go
if "%errorlevel%"=="1" goto errorlock
if "%actprojectcode:~0,3%"=="E1M" goto next10
if "%actprojectcode:~0,3%"=="D1A" goto next10
if "%actprojectcode:~0,3%"=="D1L" goto next10
if "%actprojectcode:~0,3%"=="ND1" goto next10
if "%actprojectcode:~0,3%"=="D1C" goto next10
if "%actprojectcode:~0,3%"=="D1T" goto next10
if "%actprojectcode:~0,3%"=="PLE" goto next10
echo Please look at your phone. Use Volume button to choose "LOCK THE BOOTLOADER"
echo or "Yes", then press Power button to proceed.
echo.
echo Press any key there when done.
pause>nul
:next10
echo.
echo Relock done. Press any key to exit.
goto EOF

:no4
fastboot reboot
echo.
echo Reboot done. Press any key to exit.
pause>nul
goto EOF

:no5
fastboot oem HALT
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
echo.
echo ERROR: Unlock key verification failed.
echo If getProjectCode is shown as %actprojectcode:~0,3%1, you'll need remote downgrading service.
if "%actprojectcode:~0,3%"=="E1M" echo You can also use old OTA package to downgrade bootloader and unlock again.
if "%actprojectcode:~0,3%"=="D1A" echo You can also use old OTA package to downgrade bootloader and unlock again.
if "%actprojectcode:~0,3%"=="D1L" echo You can also use old OTA package to downgrade bootloader and unlock again.
if "%actprojectcode:~0,3%"=="ND1" echo You can also use old OTA package to downgrade bootloader and unlock again.
if "%actprojectcode:~0,3%"=="D1C" echo You can also use old OTA package to downgrade bootloader and unlock again.
if "%actprojectcode:~0,3%"=="D1T" echo You can also use old OTA package to downgrade bootloader and unlock again.
if "%actprojectcode:~0,3%"=="PLE" echo You can also use old OTA package to downgrade bootloader and unlock again.
if "%actprojectcode:~0,3%"=="PL2" echo You may try to switch your phone to another slot and unlock again.
if "%actprojectcode:~0,3%"=="DRG" echo You may try to switch your phone to another slot and unlock again.
if "%actprojectcode:~0,3%"=="C1N" echo You may try to switch your phone to another slot and unlock again.
if "%actprojectcode:~0,3%"=="B2N" echo You may try to switch your phone to another slot and unlock again.
if "%actprojectcode:~0,3%"=="NB1" echo Please try to request unlock key from official:
if "%actprojectcode:~0,3%"=="NB1" echo https://www.nokia.com/en_int/phones/bootloader
if "%actprojectcode:~0,3%"=="NB1" echo.
echo Otherwise please check if your unlock key is incorrect. Press any key to return to menu.
fb2 oem getProjectCode
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
