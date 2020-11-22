@echo off
title Flashing script for AOP
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
set /p abl_aop=<tmp.txt
findstr "xbl.elf" list.txt > tmp.txt
set /p xbl_aop=<tmp.txt
findstr "xbl_config.elf" list.txt > tmp.txt
set /p xblc_aop=<tmp.txt
findstr "tz.mbn tz.img" list.txt > tmp.txt
set /p tz_aop=<tmp.txt
findstr "aop.mbn aop.img" list.txt > tmp.txt
set /p aop_aop=<tmp.txt
findstr "hyp.mbn hyp.img" list.txt > tmp.txt
set /p hyp_aop=<tmp.txt
findstr "keymaster km4" list.txt > tmp.txt
set /p keymaster_aop=<tmp.txt
findstr "cmnlib.mbn cmnlib.img" list.txt > tmp.txt
set /p cmnlib_aop=<tmp.txt
findstr "cmnlib64" list.txt > tmp.txt
set /p cmnlib64_aop=<tmp.txt
findstr "dsp" list.txt > tmp.txt
set /p dsp_aop=<tmp.txt
findstr "devcfg" list.txt > tmp.txt
set /p devcfg_aop=<tmp.txt
findstr "storsec" list.txt > tmp.txt
set /p storsec_aop=<tmp.txt
findstr "systeminfo.img" list.txt > tmp.txt
set /p systeminfo_aop=<tmp.txt
findstr "NON-HLOS modem" list.txt > tmp.txt
set /p modem_aop=<tmp.txt
findstr "vbmeta.img" list.txt > tmp.txt
set /p vbmeta_aop=<tmp.txt
findstr "boot.img" list.txt > tmp.txt
set /p boot_aop=<tmp.txt
findstr "system.img" list.txt > tmp.txt
set /p systema_aop=<tmp.txt
findstr "dtbo.img" list.txt > tmp.txt
set /p dtbo_aop=<tmp.txt
findstr "imagefv ImageFv" list.txt > tmp.txt
set /p ifv_aop=<tmp.txt
findstr "sec.dat" list.txt > tmp.txt
set /p sec_aop=<tmp.txt
findstr "qup" list.txt > tmp.txt
set /p qupfw_aop=<tmp.txt
findstr "BTFM.bin bluetooth.img" list.txt > tmp.txt
set /p bluetooth_aop=<tmp.txt
findstr "persist.img" list.txt > tmp.txt
set /p persist_aop=<tmp.txt
findstr "sutinfo.img" list.txt > tmp.txt
set /p sutinfo_aop=<tmp.txt
findstr "NV-default.mbn nvdef" list.txt > tmp.txt
set /p nvdef_aop=<tmp.txt
findstr "hidden.img" list.txt > tmp.txt
set /p hidden_aop=<tmp.txt
findstr "cda.img" list.txt > tmp.txt
set /p cda_aop=<tmp.txt
findstr "...-....-...-splash.img" list.txt > tmp.txt
set /p splash_aop=<tmp.txt
if exist splash.img set splash_aop=splash.img
findstr "multi-splash.img" list.txt > tmp.txt
set /p zplash_aop=<tmp.txt
findstr "vendor.img" list.txt > tmp.txt
set /p vendor_aop=<tmp.txt
findstr "logfs" list.txt > tmp.txt
set /p logfs_aop=<tmp.txt
del list.txt
del tmp.txt
:normal
if "%xconfirm%"=="a" cls
echo.
echo Current flashing mode: stock firmware
echo.
echo Hi there! This script is designed for flashing AOP device
echo back to factory stock without using OST LA.
echo.
echo Made by Hikari Calyx and written for following model:
echo Nokia 9 PureView.
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
set /p fwver=<%systeminfo_aop%
set fwprojectcode=%fwver:~4,3%
echo.
echo Your Phone's serial number is %devsn:~0,16% and the Project Code is %actprojectcode:~0,3%.
rem goto pass
echo The firmware itself is used for %fwprojectcode:~0,3%.
echo.
if "%actprojectcode:~0,3%"=="%fwprojectcode:~0,3%" goto pass
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
if "%fwver:~0,10%"=="MLF,HCTSW_" (
echo The firmware you're going to flash is %fwver:~4,25%.
) else (
echo The firmware you're going to flash is %fwver:~4,19%.
)
echo.
echo Please check information above.
echo If both "Device unlocked" and "Device critical unlocked" are
echo indicated as "true", press any key to proceed.
pause>nul
if "%fwver:~4,5%"=="AOP-0" set fuseissue=1
if "%fwver:~4,5%"=="AOP-1" set fuseissue=1
if "%fwver:~4,5%"=="AOP-2" set fuseissue=1
if "%fwver:~4,5%"=="AOP-3" set fuseissue=1
if "%fwver:~4,5%"=="AOP-4" set fuseissue=1
echo.
echo.
if "%fuseissue%"=="1" (
echo.
echo WARNING. Your build may not have patched the fuse issue, thus your phone could not become
echo flashable after nofuse ABL overwritten.
echo "If you want to overwrite nofuse ABL, please input yes and press enter."
echo Otherwise the script will skip abl flashing procedure.
echo.
set /p fconfirm=
if "%fconfirm%"=="yes" set fuseissue=0
)

echo.
echo Flashing critical partitions...
echo.
rem goto otaflashing
fastboot flash aop %aop_aop%
if %errorlevel% equ 1 goto errorcritical
fastboot flash hyp %hyp_aop%
fastboot flash keymaster %keymaster_aop%
fastboot flash cmnlib %cmnlib_aop%
fastboot flash cmnlib64 %cmnlib64_aop%
fastboot flash devcfg %devcfg_aop%
fastboot flash sec %sec_aop%
fastboot flash storsec %storsec_aop%
fastboot flash ImageFv %ifv_aop%
fastboot flash xbl %xbl_aop%
fastboot flash xbl_config %xblc_aop%
fastboot flash tz %tz_aop%
if "%fuseissue%"=="0" fastboot flash abl %abl_aop%
echo.
echo Flashing non-critical partitions...
echo.
fastboot flash systeminfo %systeminfo_aop%
echo.
echo Flashing system partition, please wait...
echo.
fastboot erase system
fastboot erase vendor
fastboot flash system %systema_aop%
fastboot flash vendor %vendor_aop%
fastboot flash modem %modem_aop%
fastboot erase persist
fastboot flash persist %persist_aop%
fastboot flash boot %boot_aop%
if "%econfirm%"=="yes" fastboot format userdata
fastboot flash dsp %dsp_aop%
fastboot flash bluetooth %bluetooth_aop%
fastboot flash dtbo %dtbo_aop%
fastboot flash qupfw %qupfw_aop%
fastboot flash vbmeta %vbmeta_aop%
fastboot flash logfs %logfs_aop%
fastboot flash sutinfo %sutinfo_aop%
fastboot flash splash %splash_aop%
fastboot flash zplash %zplash_aop%
fastboot flash nvdef %nvdef_aop%
fastboot erase hidden
fastboot flash hidden %hidden_aop%
fastboot flash cda %cda_aop%
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
echo Hi there! This script is designed for flashing FIH AOP device
echo back to factory stock without using OST LA.
echo.
echo Made by Hikari Calyx and written for following model:
echo Nokia 9 PureView.
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
if not exist system.img.ext4 ren system.img system.img.ext4
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
