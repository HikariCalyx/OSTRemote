::[Bat To Exe Converter]
::
::fBE1pAF6MU+EWH7eyGoTHChjczSsBCbuV+A+pbi2v7qwlQA/BLEAdpvU1LiXHO0S4UDbc8QrxTRfgM5s
::fBE1pAF6MU+EWH7eyGoTHChjczSsBCbuV+A+pbi2v7qwlQA/BLEAdpvU1LiXHO0Y7xfiZtgu2XRc+A==
::fBE1pAF6MU+EWH7eyGoTHChjczSsBCbuV+A+pbi2v7qwlQA/BLEAdpvU1LiXHO0Y7xfiZtgozn86
::fBE1pAF6MU+EWH7eyGoTHChjczSsBCbuV+A+pbi2v7qwlQA/BLEAdpvU1LiXHPAS80nrdJIS0m9XiM4eQgtBHg==
::fBE1pAF6MU+EWH7eyGoTHChjczSsBCbuV+A+pbi2v7qwlQA/BLEAdpvU1LiXHPUD7kTwcKkg025bnMoYDSRIfEDlfhZU
::fBE1pAF6MU+EWH7eyGoTHChjczSsBCbuV+A+pbi2v7qwlQA/BLEAdpvU1LiXHMEX6HLte7c93zRelMds
::fBE1pAF6MU+EWH7eyGoTHChjczSsBCbuV+A+pbi2v7qwlQA/BLEAdpvU1LiXHMEX6HLte6M+1FtKkYUIABc4
::fBE1pAF6MU+EWH7eyGoTHChjczSsBCbuV+A+pbi2v7qwlQA/BLEAdpvU1LiXHOMK7ULndqk+mysUnMcAbA==
::fBE1pAF6MU+EWH7eyGoTHChjczSsBCbuV+A+pbi2v7qwlQA/BLEAdpvU1LiXHOMK7VLte8dj0nZW+A==
::fBE1pAF6MU+EWH7eyGoTHChjczSsBCbuV+A+pbi2v7qwlQA/BLEAdpvU1LiXHOMK7V+qcZohtg==
::fBE1pAF6MU+EWH7eyGoTHChjczSsBCbuV+A+pbi2v7qwlQA/BLEAdpvU1LiXHOYS+VHmepk5mH9Cnas=
::fBE1pAF6MU+EWH7eyGoTHChjczSsBCbuV+A+pbi2v7qwlQA/BLEAdpvU1LiXHOcW5ED2fJUS0HZbi8MzHxhKdwK/UR86sSBAt3Dl
::fBE1pAF6MU+EWH7eyGoTHChjczSsBCbuV+A+pbi2v7qwlQA/BLEAdpvU1LiXHOke7Rf3fJsqmH9Cnas=
::YAwzoRdxOk+EWAjk
::fBw5plQjdCyDJGyX8VAjFDNdRwWQNUi7Coks4evv+viCsXEbVe4leZ2V07eBQA==
::YAwzuBVtJxjWCl3EqQJgSA==
::ZR4luwNxJguZRRnk
::Yhs/ulQjdF+5
::cxAkpRVqdFKZSDk=
::cBs/ulQjdF+5
::ZR41oxFsdFKZSDk=
::eBoioBt6dFKZSDk=
::cRo6pxp7LAbNWATEpSI=
::egkzugNsPRvcWATEpSI=
::dAsiuh18IRvcCxnZtBJQ
::cRYluBh/LU+EWAnk
::YxY4rhs+aU+IeA==
::cxY6rQJ7JhzQF1fEqQJhZksaHErTaAs=
::ZQ05rAF9IBncCkqN+0xwdVsFAlTMbCXrUtU=
::ZQ05rAF9IAHYFVzEqQIXLRVRXg2BfE22B6YU4eb8r9mEsEQNQKI5d52b6pq2QA==
::eg0/rx1wNQPfEVWB+kM9LVsJDAOHMm6oD7Yj7uT6/OK4sU4PXfIrR5/VwvqLOOVz
::fBEirQZwNQPfEVWB+kM9LVsJDCOkD1SKKI18
::cRolqwZ3JBvQF1fEqQIXLRVRXg2BfE22B6YU4eb8r9mEsEQNQKI5d52b6pq2QA==
::dhA7uBVwLU+EWHGN/0MiIVt3TQibJCuOA7YUiA==
::YQ03rBFzNR3SWATE3Es7KQldDCeDMHKiRoEZ6+Cb
::dhAmsQZ3MwfNWATEphJhcVYGHFbSfCOZT/U04eP6/ePHgUwRTfp/TIrY0vrOAewfqlftcp45xTpondgJHg1delzL
::ZQ0/vhVqMQ3MEVWAtB9wSA==
::Zg8zqx1/OA3MEVWAtB9wSA==
::dhA7pRFwIByZRRnk
::Zh4grVQjdCiDJHGnwHEHFyt6dEnWbT6YS+VRuLjM2Kel8h4iWvYwdoPC5rOLLuUB40bbc5osxXJli8geBQtMQQKldkExsWsi
::YB416Ek+ZG8=
::
::
::978f952a14a936cc963da21a135fa983
@echo off
title Flashing script for PNX
cls
echo.
echo.
echo Initializing...
rem Navigating these partitions
dir /b > list.txt
if exist prcsd.hikaricalyx goto otaflashinginitd
if not exist HCTSW*mlf (
if exist modem.img goto otaflashinginitd
)
if exist payload.bin goto otaflashingbefore
:returnx
findstr "abl.elf" list.txt > tmp.txt
set /p abl_pnx=<tmp.txt
findstr "xbl.elf" list.txt > tmp.txt
set /p xbl_pnx=<tmp.txt
findstr "xbl_config.elf" list.txt > tmp.txt
set /p xblc_pnx=<tmp.txt
findstr "tz.mbn tz.img" list.txt > tmp.txt
set /p tz_pnx=<tmp.txt
findstr "aop.mbn aop.img" list.txt > tmp.txt
set /p aop_pnx=<tmp.txt
findstr "hyp.mbn hyp.img" list.txt > tmp.txt
set /p hyp_pnx=<tmp.txt
findstr "keymaster km4" list.txt > tmp.txt
set /p keymaster_pnx=<tmp.txt
findstr "cmnlib.mbn cmnlib.img" list.txt > tmp.txt
set /p cmnlib_pnx=<tmp.txt
findstr "cmnlib64" list.txt > tmp.txt
set /p cmnlib64_pnx=<tmp.txt
findstr "dsp" list.txt > tmp.txt
set /p dsp_pnx=<tmp.txt
findstr "devcfg" list.txt > tmp.txt
set /p devcfg_pnx=<tmp.txt
findstr "storsec" list.txt > tmp.txt
set /p storsec_pnx=<tmp.txt
findstr "systeminfo.img" list.txt > tmp.txt
set /p systeminfo_pnx=<tmp.txt
findstr "NON-HLOS modem" list.txt > tmp.txt
set /p modem_pnx=<tmp.txt
findstr "vbmeta.img" list.txt > tmp.txt
set /p vbmeta_pnx=<tmp.txt
findstr "boot.img" list.txt > tmp.txt
set /p boot_pnx=<tmp.txt
findstr "system.img" list.txt > tmp.txt
set /p systema_pnx=<tmp.txt
echo %systema_pnx:~0,3% > tmp.txt
findstr "dtbo.img" list.txt > tmp.txt
set /p dtbo_pnx=<tmp.txt
findstr "qup" list.txt > tmp.txt
set /p qupfw_pnx=<tmp.txt
findstr "BTFM.bin bluetooth.img" list.txt > tmp.txt
set /p bluetooth_pnx=<tmp.txt
findstr "persist.img" list.txt > tmp.txt
set /p persist_pnx=<tmp.txt
findstr "sutinfo.img" list.txt > tmp.txt
set /p sutinfo_pnx=<tmp.txt
findstr "NV-default.mbn nvdef" list.txt > tmp.txt
set /p nvdef_pnx=<tmp.txt
findstr "hidden.img" list.txt > tmp.txt
set /p hidden_pnx=<tmp.txt
findstr "cda.img" list.txt > tmp.txt
set /p cda_pnx=<tmp.txt
findstr "...-....-...-splash.img" list.txt > tmp.txt
set /p splash_pnx=<tmp.txt
if exist splash.img set splash_pnx=splash.img
findstr "multi-splash.img" list.txt > tmp.txt
set /p zplash_pnx=<tmp.txt
findstr "vendor.img" list.txt > tmp.txt
set /p vendor_pnx=<tmp.txt
findstr "logfs" list.txt > tmp.txt
set /p logfs_pnx=<tmp.txt
del list.txt
del tmp.txt
:normal
if "%xconfirm%"=="a" cls
echo.
echo Current flashing mode: stock firmware
echo.
echo Hi there! This script is designed for flashing PNX device
echo back to factory stock without using OST LA.
echo.
echo Made by Hikari Calyx and written for following models:
echo Nokia 8.1 and Nokia X7.
echo.
echo Do you wish to erase userdata while flashing?
echo.
echo.Userdata erasing will not erase FRP lock.
echo.
echo.Please type lowercase "yes" to confirm erasing, then press Enter Key to proceed. 
echo.
echo.Otherwise, press Enter Key will skip userdata erasing.
echo.
set /p econfirm=

rem if not exist fastboot.exe goto errorx
rem if not exist mke2fs.exe goto errorx
rem if not exist mke2fs.conf goto errorx
rem if not exist make_f2fs.exe goto errorx
rem if not exist adbwinapi.dll goto errorx
rem if not exist adbwinusbapi.dll goto errorx

echo.
echo Please connect your powered off phone or phone that entered Download mode
fastboot oem alive>nul
fastboot devices > tmp.txt
set /p devsn=<tmp.txt
echo %devsn:~0,16% > tmp.txt
set /p devsn=<tmp.txt
echo %devsn:~0,3% > tmp.txt
set /p actprojectcode=<tmp.txt
del tmp.txt
echo.
echo Your Phone's serial number is %devsn:~0,16% and the Project Code is %actprojectcode:~0,3%.
rem goto pass
echo The firmware itself is used for %fwprojectcode:~0,3%.
echo.
if "%actprojectcode%"=="%fwprojectcode%" goto pass
echo Warning! You're trying to flash firmware that's not made for your device.
echo If you don't know what you're doing, please close the window and double check again.
echo.
echo Press any key to ignore this.
pause>nul
:pass
cls
echo.
echo Your Phone's serial number is %devsn:~0,16% and the Project Code is %actprojectcode:~0,3%.
rem goto otapm2
echo The firmware itself is used for %fwprojectcode:~0,3%.
:otapm2
echo.
fastboot oem getversions
echo.
echo.
fastboot oem device-info
echo.
echo.
echo Please check information above.
echo If both "Device unlocked" and "Device critical unlocked" are
echo indicated as "true", press any key to proceed.
pause>nul
set /p fwver=<%systeminfo_pnx%
if "%fwver:~3,5%"=="PNX-0" set fuseissue=1
if "%fwver:~3,5%"=="PNX-1" set fuseissue=1
if "%fwver:~3,5%"=="PNX-2" set fuseissue=1
if "%fwver:~3,5%"=="PNX-3" set fuseissue=1
echo.
echo %fwver:~3,19%
echo.
pause
if "%fuseissue%"=="1" (
echo.
echo WARNING. Your build may not have patched the fuse issue, thus your phone could not become
echo flashable after nofuse ABL overwritten.
echo If you want to overwrite nofuse ABL, please input "yes" (without quotes) and press enter.
echo Otherwise the script will skip abl flashing procedure.
echo.
set /p fconfirm=
if "%fconfirm%"=="yes" set fuseissue=0
)

echo.
echo Flashing critical partitions...
echo.
rem goto otaflashing
fastboot flash aop %aop_pnx%
if %errorlevel% equ 1 goto errorcritical
fastboot flash hyp %hyp_pnx%
fastboot flash keymaster %keymaster_pnx%
fastboot flash cmnlib %cmnlib_pnx%
fastboot flash cmnlib64 %cmnlib64_pnx%
fastboot flash devcfg %devcfg_pnx%
fastboot flash storsec %storsec_pnx%
fastboot flash xbl %xbl_pnx%
fastboot flash xbl_config %xblc_pnx%
fastboot flash tz %tz_pnx%
if "%fuseissue%"=="0" fastboot flash abl %abl_pnx%
echo.
echo Flashing non-critical partitions...
echo.
fastboot flash systeminfo %systeminfo_pnx%
echo.
echo Flashing system partition, please wait...
echo.
fastboot erase system
fastboot erase vendor
fastboot flash system %systema_pnx%
fastboot flash vendor %vendor_pnx%
fastboot flash modem %modem_pnx%
fastboot erase persist
fastboot flash persist %persist_pnx%
fastboot flash boot %boot_pnx%
if "%econfirm%"=="yes" fastboot format userdata
fastboot flash dsp %dsp_pnx%
fastboot flash bluetooth %bluetooth_pnx%
fastboot flash dtbo %dtbo_pnx%
fastboot flash qupfw %qupfw_pnx%
fastboot flash vbmeta %vbmeta_pnx%
fastboot flash logfs %logfs_pnx%
fastboot flash sutinfo %sutinfo_pnx%
fastboot flash splash %splash_pnx%
fastboot flash zplash %zplash_pnx%
fastboot flash nvdef %nvdef_pnx%
fastboot erase hidden
fastboot flash hidden %hidden_pnx%
fastboot flash cda %cda_pnx%
:normal3
fastboot reboot
echo All done! Press any key to exit.
echo.
echo.
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

:errorcritical
echo.
echo ERROR: You didn't perform critical bootloader unlock, or the ABL has fuse issue. Please confirm again.
fastboot reboot
pause>nul
goto EOF

:errorunlock
echo.
echo ERROR: You didn't perform bootloader unlock, or the ABL has fuse issue. Please confirm again.
fastboot reboot
pause>nul
goto EOF

:otaflashingbefore
echo.
echo payload.bin detected.
echo.
echo You'll need to use Payload Dumper to dump the payload file.
echo.
echo The payload dumper can be downloaded from following URL:
echo.
echo https://gist.github.com/ius/42bd02a5df2226633a342ab7a9c60f15
echo.
echo You must put payload_dumper.py and update_metadata2_pb2.py to the same directory
echo of this script.
echo.
echo.To use payload dumper, you must have Python 3 installed.
echo.
echo Please type lowercase "yes" to confirm, then press Enter Key to proceed. 
echo.
echo Otherwise press Enter Key with nothing typed will ignore the payload.bin.
echo.
set /p econfirm=
if "%econfirm%"=="yes" goto startdump
set xconfirm=a
goto returnx
:startdump
set econfirm=
if exist payload_dumper.exe goto pdumperexe
pip3 install protobuf
if %errorlevel% equ 9009 goto nopython
if not exist payload_dumper.py goto errornoscript
if not exist update_metadata_pb2.py goto errornoscript
python payload_dumper.py payload.bin
if %errorlevel% neq 0 goto errorscript2
goto otaflashinginitd

:errornopython
echo.
echo ERROR: Your PC doesn't have Python 3 installed. Therefore the payload dumping will be skipped.
echo.
pause
cls
goto returnx

:pdumperexe
echo.
payload_dumper payload.bin
if %errorlevel% neq 0 goto errorscript2
set xconfirm=1
goto otaflashinginitd

:errornoscript
echo.
echo ERROR: You didn't put both scripts to the same directory of this script.
echo Therefore the payload dumping will be skipped.
echo.
pause
cls
goto returnx

:errorscript2
echo.
echo ERROR: The script didn't process the payload.bin well.
echo Therefore the payload dumping will be skipped.
echo.
pause
cls
goto returnx

:otaflashinginitd
if exist flashit.cmd del /q flashit.cmd
echo.
echo Processed payload.bin image files found. 
echo.
:otaflashinginit
echo Current flashing mode: payload as fastboot images
echo.
echo Hi there! This script is designed for flashing FIH PNX device
echo back to factory stock without using OST LA.
echo.
echo Made by Hikari Calyx and written for following models:
echo Nokia X7 and Nokia 8.1.
echo.
echo Please choose a slot you wish to flash. ( a / b )
echo.
:reselectslot
set /p cslot=
if %cslot%==A set wslot=a&goto chosenx
if %cslot%==B set wslot=b&goto chosenx
if %cslot%==a set wslot=a&goto chosenx
if %cslot%==b set wslot=b&goto chosenx
echo.
echo Incorrect slot, please type again. ( a / b )
echo.
goto reselectslot
:chosenx
echo.
echo Generating flashing script...
echo.
dir /b *.img > list.txt
for /f "delims=." %%i in (list.txt) do set "%%i=%%i.img"&echo fastboot flash %%i_%wslot% %%i.img>>flashit.cmd
del list.txt
if not exist vendor.img.ext4 ren system.img system.img.ext4
if not exist vendor.img.ext4 ren vendor.img vendor.img.ext4
if not exist system.img echo Converting system image to sparse, please wait...
if not exist system.img img2simg system.img.ext4 system.img
if not exist vendor.img echo Converting vendor image to sparse, please wait...
if not exist vendor.img img2simg vendor.img.ext4 vendor.img
echo DO NOT DELETE ME > prcsd.hikaricalyx
goto reflash

:reflash
cls
echo.
echo The payload.bin is already processed.
echo.
echo Please connect your powered off phone or phone that entered Fastboot mode
fastboot oem alive
cls
fastboot devices > tmp.txt
set /p devsn=<tmp.txt
echo %devsn:~0,16% > tmp.txt
set /p devsn=<tmp.txt
echo %devsn:~0,3% > tmp.txt
set /p actprojectcode=<tmp.txt
del tmp.txt
echo.
echo Your Phone's serial number is %devsn:~0,16% and the Project Code is %actprojectcode:~0,3%.
echo.
echo Do you wish to erase userdata while flashing?
echo.
echo.Userdata erasing will not erase FRP lock.
echo.
echo.Please type lowercase "yes" to confirm erasing, then press Enter Key to proceed. 
echo.
echo.Otherwise, press Enter Key will skip userdata erasing.
echo.
set /p econfirm=
cls
echo.
echo Your Phone's serial number is %devsn:~0,16% and the Project Code is %actprojectcode:~0,3%.
echo.
fastboot oem getversions
echo.
fastboot oem device-info
echo.
echo Please check information above.
echo If your phone is unlocked, press any key to proceed.
pause>nul
echo.
echo Flashing, please wait...
echo.
call flashit.cmd
if %errorlevel% equ 1 goto errorunlock
if "%econfirm%"=="yes" goto erasing
:flashdone
set econfirm=
echo.
echo.Flashing done. 
echo.
echo Do you want to switch to slot %cslot% right now?
echo.
echo.Please type lowercase "yes" to confirm switching, then press Enter Key to proceed. 
echo.
echo.Otherwise, press Enter Key will only reboot your phone.
echo.
set /p econfirm=
if "%econfirm%"=="yes" fastboot --set-active=%wslot%
if "%econfirm%"=="yes" fastboot --set-active=_%wslot%
fastboot reboot
echo.
echo All done. Press any key to exit.
echo.
pause>nul
goto EOF

:erasing
echo.
echo Erasing userdata...
echo.
fastboot format userdata
fastboot erase ssd
fastboot erase misc
fastboot erase sti
fastboot erase ddr
goto flashdone


:EOF
