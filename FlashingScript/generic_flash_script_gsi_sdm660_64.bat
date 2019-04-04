@echo off
title Flashing script for fih_gsi_sdm660_64 devices
cls
echo.
echo.
echo Initializing...
rem Navigating these partitions
dir /b > list.txt
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
findstr "keymaster64.mbn" list.txt > tmp.txt
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
echo The firmware itself is used for %fwprojectcode:~0,3%.
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
fastboot flash partition_a %partition_sdm660%
if %errorlevel% equ 1 goto errorcritical
fastboot flash xbl_a %xbls_sdm660%
fastboot flash xbl_b %xbls_sdm660%
fastboot flash abl_a %abls_sdm660%
fastboot flash abl_b %abls_sdm660%
fastboot flash tz_a %tz_sdm660%
fastboot flash rpm_a %rpm_sdm660%
fastboot flash hwcfg %hwcfg_sdm660%
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
fastboot oem alive>nul
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
fastboot flash system_b %systemb_sdm660%
fastboot flash bluetooth_a %bluetooth_sdm660%
fastboot flash persist %persist_sdm660%
if "%econfirm%"=="yes" fastboot format userdata
fastboot flash sutinfo %sutinfo_sdm660%
fastboot flash nvdef_a %nvdef_sdm660%
fastboot flash hidden_a %hidden_sdm660%
fastboot flash cda_a %cda_sdm660%
if "%econfirm%"=="yes" fastboot erase ssd
if "%econfirm%"=="yes" fastboot erase misc
if "%econfirm%"=="yes" fastboot erase sti
fastboot flash splash_a %splash_sdm660%
fastboot flash splash2 %splash2_sdm660%
fastboot flash vendor_a %vendor_sdm660%
if "%econfirm%"=="yes" fastboot erase ddr
fastboot flash xbl_a %xbl_sdm660%
fastboot flash xbl_b %xbl_sdm660%
fastboot flash abl_a %abl_sdm660%
fastboot flash abl_b %abl_sdm660%
fastboot oem set_active _a
fastboot oem enable-charger-screen
fastboot flash logfs %logfs_sdm660%
echo Verifying flashing result, please wait...
fastboot flash md4 md4.dat
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

:EOF
