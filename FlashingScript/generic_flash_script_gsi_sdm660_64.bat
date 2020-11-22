@echo off
title Flashing script for fih_gsi_sdm660_64 devices
cls
echo.
echo.
echo Initializing...
rem Navigating these partitions
dir /b > list.txt
if exist prcsd.hikaricalyx goto otaflashinginitd
if exist modem.img goto otaflashinginitd
if exist payload.bin goto otaflashingbefore
:returnx
findstr "gpt_both0.bin" list.txt > tmp.txt
set /p partition_sdm660=<tmp.txt
findstr "abl.elf" list.txt > tmp.txt
set /p abl_sdm660=<tmp.txt
findstr "xbl.elf" list.txt > tmp.txt
set /p xbl_sdm660=<tmp.txt
findstr "abl_service.elf" list.txt > tmp.txt
set /p abls_sdm660=<tmp.txt
findstr "xbl_service.elf" list.txt > tmp.txt
set /p xbls_sdm660=<tmp.txt
findstr "tz.mbn" list.txt > tmp.txt
set /p tz_sdm660=<tmp.txt
findstr "rpm.mbn" list.txt > tmp.txt
set /p rpm_sdm660=<tmp.txt
findstr "hwcfg.img" list.txt > tmp.txt
set /p hwcfg_sdm660=<tmp.txt
findstr "hyp.mbn" list.txt > tmp.txt
set /p hyp_sdm660=<tmp.txt
findstr "pmic.elf" list.txt > tmp.txt
set /p pmic_sdm660=<tmp.txt
findstr "keymaster.mbn keymaster64.mbn" list.txt > tmp.txt
set /p keymaster_sdm660=<tmp.txt
findstr "cmnlib.mbn" list.txt > tmp.txt
set /p cmnlib_sdm660=<tmp.txt
findstr "cmnlib64.mbn" list.txt > tmp.txt
set /p cmnlib64_sdm660=<tmp.txt
findstr "dspso.bin" list.txt > tmp.txt
set /p dsp_sdm660=<tmp.txt
findstr "devcfg.mbn" list.txt > tmp.txt
set /p devcfg_sdm660=<tmp.txt
findstr "sec.dat" list.txt > tmp.txt
set /p sec_sdm660=<tmp.txt
findstr "mdtpsecapp.mbn" list.txt > tmp.txt
set /p mdtpsecapp_sdm660=<tmp.txt
findstr "storsec.mbn" list.txt > tmp.txt
set /p storsec_sdm660=<tmp.txt
findstr "systeminfo.img" list.txt > tmp.txt
set /p systeminfo_sdm660=<tmp.txt
findstr "NON-HLOS.bin" list.txt > tmp.txt
set /p modem_sdm660=<tmp.txt
findstr "mdtp.img" list.txt > tmp.txt
set /p mdtp_sdm660=<tmp.txt
findstr "boot.img" list.txt > tmp.txt
set /p boot_sdm660=<tmp.txt
findstr "system.img" list.txt > tmp.txt
set /p systema_sdm660=<tmp.txt
echo %systema_sdm660:~0,3% > tmp.txt
set /p fwprojectcode=<tmp.txt
findstr "system_other.img" list.txt > tmp.txt
set /p systemb_sdm660=<tmp.txt
findstr "BTFM.bin" list.txt > tmp.txt
set /p bluetooth_sdm660=<tmp.txt
findstr "persist.img" list.txt > tmp.txt
set /p persist_sdm660=<tmp.txt
findstr "sutinfo.img" list.txt > tmp.txt
set /p sutinfo_sdm660=<tmp.txt
findstr "NV-default.mbn" list.txt > tmp.txt
set /p nvdef_sdm660=<tmp.txt
findstr "hidden.img.ext4" list.txt > tmp.txt
set /p hidden_sdm660=<tmp.txt
findstr "cda.img" list.txt > tmp.txt
set /p cda_sdm660=<tmp.txt
findstr "...-....-...-splash.img" list.txt > tmp.txt
set /p splash_sdm660=<tmp.txt
findstr "multi-splash.img" list.txt > tmp.txt
set /p splash2_sdm660=<tmp.txt
findstr "vendor.img" list.txt > tmp.txt
set /p vendor_sdm660=<tmp.txt
findstr "logfs" list.txt > tmp.txt
set /p logfs_sdm660=<tmp.txt
del list.txt
del tmp.txt
:normal
if "%xconfirm%"=="a" cls
echo.
echo Current flashing mode: stock firmware
echo.
echo Hi there! This script is designed for flashing FIH gsi_sdm660_64 devices
echo back to factory stock without using OST LA.
echo.
echo Made by Hikari Calyx and written for following models:
echo Nokia 6.1 PL2, Nokia 6.1 Plus X6 DRG, Nokia 7 C1N, Nokia 7.1 CTL, Nokia 7 Plus B2N,
echo Sharp Aquos C10 S2 SS2-SAT, Sharp Aquos S3mini SG1, Sharp Aquos S3 HH1-SD1.
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

if not exist fastboot.exe goto errorx
if not exist mke2fs.exe goto errorx
if not exist mke2fs.conf goto errorx
if not exist make_f2fs.exe goto errorx
if not exist adbwinapi.dll goto errorx
if not exist adbwinusbapi.dll goto errorx

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
echo.
echo Flashing critical partitions...
echo.
rem goto otaflashing
fastboot flash partition %partition_sdm660%
if %errorlevel% equ 1 goto errorcritical
fastboot flash xbl_a %xbls_sdm660%
fastboot flash xbl_b %xbls_sdm660%
fastboot flash abl_a %abls_sdm660%
fastboot flash abl_b %abls_sdm660%
fastboot flash tz_a %tz_sdm660%
fastboot flash rpm_a %rpm_sdm660%
fastboot flash hyp_a %hyp_sdm660%
fastboot flash pmic_a %pmic_sdm660%
fastboot flash keymaster_a %keymaster_sdm660%
fastboot flash cmnlib_a %cmnlib_sdm660%
fastboot flash cmnlib64_a %cmnlib64_sdm660%
fastboot flash dsp_a %dsp_sdm660%
fastboot flash devcfg_a %devcfg_sdm660%
fastboot flash sec %sec_sdm660%
fastboot flash mdtpsecapp_a %mdtpsecapp_sdm660%
fastboot flash storsec %storsec_sdm660%
fastboot flash systeminfo_a %systeminfo_sdm660%
fastboot reboot-bootloader
echo.
echo Please wait while phone is rebooting...
echo.
ping 127.0.0.1 -n 2 >nul
fastboot oem alive
:normal2
echo.
echo Flashing non-critical partitions...
echo.
fastboot flash modem_a %modem_sdm660%
if %errorlevel% equ 1 goto errorunlock
fastboot flash mdtp_a %mdtp_sdm660%
fastboot flash boot_a %boot_sdm660%
fastboot erase boot_b
echo.
echo Flashing system partition, please wait...
echo.
fastboot flash system_a %systema_sdm660%
rem goto otaflashing2
fastboot flash system_b %systemb_sdm660%
fastboot flash bluetooth_a %bluetooth_sdm660%
fastboot flash persist %persist_sdm660%
if "%econfirm%"=="yes" fastboot format userdata
fastboot flash sutinfo %sutinfo_sdm660%
fastboot flash hwcfg %hwcfg_sdm660%
fastboot flash nvdef_a %nvdef_sdm660%
fastboot flash hidden_a %hidden_sdm660%
fastboot flash cda_a %cda_sdm660%
if "%econfirm%"=="yes" fastboot erase ssd
if "%econfirm%"=="yes" fastboot erase misc
if "%econfirm%"=="yes" fastboot erase sti
fastboot flash splash_a %splash_sdm660%
fastboot flash splash2 %splash2_sdm660%
if "%vendor_sdm660%"=="" goto nougat1
fastboot flash vendor_a %vendor_sdm660%
:nougat1
if "%econfirm%"=="yes" fastboot erase ddr
fastboot flash xbl_a %xbl_sdm660%
fastboot flash xbl_b %xbl_sdm660%
fastboot flash abl_a %abl_sdm660%
fastboot flash abl_b %abl_sdm660%
fastboot oem set_active _a
fastboot oem enable-charger-screen
if "%logfs_sdm660%"=="" goto nougat2
fastboot flash logfs %logfs_sdm660%
:nougat2
if "%fwprojectcode:~0,3%"=="SS2" goto sharp
if "%fwprojectcode:~0,3%"=="SAT" goto sharp
if "%fwprojectcode:~0,3%"=="HH1" goto sharp
if "%fwprojectcode:~0,3%"=="SD1" goto sharp
if "%fwprojectcode:~0,3%"=="SG1" goto sharp
:aftersharp
if exist md4.dat (
echo.
if exist md4.dat echo Verifying flashing result, please wait...
echo.
fastboot flash md4 md4.dat
)
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
echo ERROR: You didn't perform critical bootloader unlock. Please confirm again.
fastboot reboot
pause>nul
goto EOF

:errorunlock
echo.
echo ERROR: You didn't perform bootloader unlock. Please confirm again.
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
echo Hi there! This script is designed for flashing FIH gsi_sdm660_64 devices
echo back to factory stock without using OST LA.
echo.
echo Made by Hikari Calyx and written for following models:
echo Nokia 6.1 PL2, Nokia 6.1 Plus X6 DRG, Nokia 7 C1N, Nokia 7.1 CTL, Nokia 7 Plus B2N,
echo Sharp Aquos C10 S2 SS2-SAT, Sharp Aquos S3mini SG1, Sharp Aquos S3 HH1-SD1.
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

:sharp
echo.
echo Sharp Aquos Phone flashing detected.
echo.
echo.To ensure the flashing result will pass, the script will also flash every partitions in slot B.
echo.
ping 127.0.0.1 -n 2 >nul
fastboot flash tz_b %tz_sdm660%
fastboot flash rpm_b %rpm_sdm660%
fastboot flash hyp_b %hyp_sdm660%
fastboot flash pmic_b %pmic_sdm660%
fastboot flash keymaster_b %keymaster_sdm660%
fastboot flash cmnlib_b %cmnlib_sdm660%
fastboot flash cmnlib64_b %cmnlib64_sdm660%
fastboot flash dsp_b %dsp_sdm660%
fastboot flash devcfg_b %devcfg_sdm660%
fastboot flash mdtpsecapp_b %mdtpsecapp_sdm660%
fastboot flash systeminfo_b %systeminfo_sdm660%
fastboot flash modem_b %modem_sdm660%
fastboot flash mdtp_b %mdtp_sdm660%
fastboot flash boot_b %boot_sdm660%
fastboot flash bluetooth_b %bluetooth_sdm660%
fastboot flash nvdef_b %nvdef_sdm660%
fastboot flash hidden_b %hidden_sdm660%
fastboot flash cda_b %cda_sdm660%
fastboot flash splash_b %splash_sdm660%
if "%vendor_sdm660%"=="" goto aftersharp
fastboot flash vendor_b %vendor_sdm660%
echo.
goto aftersharp

:EOF
