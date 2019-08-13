@echo off
title Flashing script for MediaTek AB devices
cls
echo.
echo.
echo Initializing...
rem Navigating these partitions
dir /b > list.txt
findstr "lk.img" list.txt > tmp.txt
set /p lk_mtkab=<tmp.txt
findstr "tee.img" list.txt > tmp.txt
set /p tee_mtkab=<tmp.txt
findstr "odmdtbo.img" list.txt > tmp.txt
set /p odmdtbo_mtkab=<tmp.txt
findstr "logo.bin" list.txt > tmp.txt
set /p logo_mtkab=<tmp.txt
findstr "spmfw.img" list.txt > tmp.txt
set /p spmfw_mtkab=<tmp.txt
findstr "scp.img" list.txt > tmp.txt
set /p scp_mtkab=<tmp.txt
findstr "sspm.img" list.txt > tmp.txt
set /p sspm_mtkab=<tmp.txt
findstr "cam_vpu1.img" list.txt > tmp.txt
set /p cv1_mtkab=<tmp.txt
findstr "cam_vpu2.img" list.txt > tmp.txt
set /p cv2_mtkab=<tmp.txt
findstr "cam_vpu3.img" list.txt > tmp.txt
set /p cv3_mtkab=<tmp.txt
findstr "preloader" list.txt > tmp.txt
set /p preloader_mtkab=<tmp.txt
findstr "system.img" list.txt > tmp.txt
set /p systema_mtkab=<tmp.txt
echo %systema_mtkab:~0,3% > tmp.txt
set /p fwprojectcode=<tmp.txt
findstr "system_other.img" list.txt > tmp.txt
set /p systemb_mtkab=<tmp.txt
findstr "vendor.img" list.txt > tmp.txt
set /p vendor_mtkab=<tmp.txt
findstr "boot.img" list.txt > tmp.txt
set /p boot_mtkab=<tmp.txt
findstr "userdata.img" list.txt > tmp.txt
set /p ud_mtkab=<tmp.txt
findstr "md1img.img" list.txt > tmp.txt
set /p md1img_mtkab=<tmp.txt
findstr "md1arm7.img" list.txt > tmp.txt
set /p md1arm7_mtkab=<tmp.txt
findstr "md1dsp.img" list.txt > tmp.txt
set /p md1dsp_mtkab=<tmp.txt
findstr "sutinfo.img" list.txt > tmp.txt
set /p sutinfo_mtkab=<tmp.txt
findstr "cda.img" list.txt > tmp.txt
set /p cda_mtkab=<tmp.txt
findstr "systeminfo.img" list.txt > tmp.txt
set /p systeminfo_mtkab=<tmp.txt
findstr "vbmeta.img" list.txt > tmp.txt
set /p vbm_mtkab=<tmp.txt
del list.txt
del tmp.txt
echo.
echo Hi there! This script is designed for flashing FIH MediaTek A/B devices
echo back to factory stock without using OST LA.
echo.
echo Made by Hikari Calyx and written for following models:
echo Nokia 3.1 ES2, Nokia 3.1 Plus ROO, Nokia 5.1 CO2, Nokia 5.1 Plus X5 PDA.
echo.
echo.Userdata must be erased due to the limitation of MediaTek.
echo.
echo If you agree, press any key to proceed.
pause>nul
if not exist fastboot.exe goto errorx
if not exist adbwinapi.dll goto errorx
if not exist adbwinusbapi.dll goto errorx

echo.
echo Please connect your powered off phone or phone that entered Fastboot mode
fastboot oem alive>nul
fastboot devices > tmp.txt
set /p devsn=<tmp.txt
echo %devsn:~0,16% > tmp.txt
set /p devsn=<tmp.txt
echo %devsn:~0,3% > tmp.txt
set /p actprojectcode=<tmp.txt
del tmp.txt
if "%devsn%"=="0123456789ABCDEF" goto snmissing
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
:retx
fastboot oem getversions
echo.
fastboot getvar unlocked
echo.
echo Please check information above.
echo.
echo If "Unlocked" is indicated as "yes", press any key to proceed.
pause>nul
echo.
echo Flashing partitions...
echo.
fastboot flash lk_a %lk_mtkab%
if %errorlevel% equ 1 goto errorunlock
fastboot flash lk_b %lk_mtkab%
fastboot flash tee_a %tee_mtkab%
fastboot flash odmdtbo_a %odmdtbo_mtkab%
fastboot flash odmdtbo_b %odmdtbo_mtkab%
fastboot flash logo_a %logo_mtkab%
fastboot flash spmfw_a %spmfw_mtkab%
fastboot flash scp_a %scp_mtkab%
fastboot flash sspm_a %sspm_mtkab%
if "%cv1_mtkab%"=="" goto nocv
fastboot flash cam_vpu1_a %cv1_mtkab%
fastboot flash cam_vpu2_a %cv2_mtkab%
fastboot flash cam_vpu3_a %cv3_mtkab%
:nocv
fastboot oem set_active:a
fastboot flash preloader_a %preloader_mtkab%
fastboot flash preloader_b %preloader_mtkab%
echo.
echo Flashing system partition, please wait...
echo.
fastboot flash system_a %systema_mtkab%
fastboot flash system_b %systemb_mtkab%
fastboot flash vendor_a %vendor_mtkab%
fastboot flash boot_a %boot_mtkab%
fastboot erase boot_b
fastboot flash userdata %ud_mtkab%
if "%md1arm7_mtkab%"=="" goto nomd1a
fastboot flash md1arm7_a %md1arm7_mtkab%
fastboot flash md1dsp_a %md1dsp_mtkab%
:nomd1a
fastboot flash md1img_a %md1img_mtkab%
fastboot flash sutinfo %sutinfo_mtkab%
fastboot flash cda_a %cda_mtkab%
fastboot flash systeminfo_a %systeminfo_mtkab%
if "%vbm_mtkab%"=="" goto novbm
fastboot flash vbmeta_a %vbm_mtkab%
:novbm
echo Verifying flashing result, please wait...
if exist md4.dat fastboot flash md4 md4.dat
if exist md5.dat fastboot flash md5 md5.dat
fastboot erase frp
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

:snmissing
echo.WARNING: Serial Number is missing, we can not guarantee the firmware is
echo.designed for your phone.
echo The firmware itself is used for %fwprojectcode:~0,3%.
goto retx

:errorunlock
echo.
echo ERROR: You didn't perform bootloader unlock. Please confirm again.
fastboot reboot
pause>nul
goto EOF

:EOF
