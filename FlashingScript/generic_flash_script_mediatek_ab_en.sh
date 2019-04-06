#!/bin/bash
title="Flashing script for MediaTek AB devices"
echo "Initializing..."
echo " "
ls > list.txt
lk_mtkab=`grep "lk.img" list.txt`
tee_mtkab=`grep "tee.img" list.txt`
odmdtbo_mtkab=`grep "odmdtbo.img" list.txt`
logo_mtkab=`grep "logo.bin" list.txt`
spmfw_mtkab=`grep "spmfw.img" list.txt`
scp_mtkab=`grep "scp.img" list.txt`
sspm_mtkab=`grep "sspm.img" list.txt`
cv1_mtkab=`grep "cam_vpu1.img" list.txt`
cv2_mtkab=`grep "cam_vpu2.img" list.txt`
cv3_mtkab=`grep "cam_vpu3.img" list.txt`
preloader_mtkab=`grep "preloader" list.txt`
systema_mtkab=`grep "system.img" list.txt`
fwprojectcode=`echo ${systema_mtkab:0:3}`
systemb_mtkab=`grep "system_other.img" list.txt`
vendor_mtkab=`grep "vendor.img" list.txt`
boot_mtkab=`grep "boot.img" list.txt`
ud_mtkab=`grep "userdata.img" list.txt`
md1img_mtkab=`grep "md1img.img" list.txt`
sutinfo_mtkab=`grep "sutinfo.img" list.txt`
cda_mtkab=`grep "cda.img" list.txt`
systeminfo_mtkab=`grep "systeminfo.img" list.txt`
vbm_mtkab=`grep "vbmeta.img" list.txt`
rm list.txt
echo " "
echo "Hi there! This script is designed for flashing FIH MediaTek AB devices"
echo "back to factory stock without using OST LA."
echo " "
echo "Made by Hikari Calyx and written for following models:"
echo "Nokia 3.1 ES2, Nokia 3.1 Plus ROO, Nokia 5.1 CO2, Nokia 5.1 Plus X5 PDA."
echo " "
echo "Userdata must be erased due to the limitation of MediaTek."
echo " "
echo "If you agree, press any key to proceed."
echo " "
read continue
echo " "
fastboot_ins=$(which fastboot)
if [ -z $fastboot_ins ]; then
  echo " "
  echo "ERROR: You didn't place required Google Platform Tools executable here."
  echo " "
  echo "Please download it from following URL:"
  echo " "
  echo "https://developer.android.com/studio/releases/platform-tools"
  echo " "
  exit
fi
	echo "Please connect your powered off phone or phone that entered Download mode"
	fastboot oem alive
	devsn=`fastboot devices`
	devsn=`echo ${devsn:0:16}`
	actprojectcode=`echo ${devsn:0:3}`
	echo " "
		if [ $devsn=="0123456789ABCDEF" ]; then
			echo "WARNING: Serial Number is missing, we can not guarantee the firmware is"
			echo "designed for your phone."
			echo The firmware itself is used for $fwprojectcode.
		else
			echo Your Phone\'s serial number is $devsn and the Project Code is $actprojectcode.
			echo The firmware itself is used for $fwprojectcode.
				if [[ $actprojectcode != $fwprojectcode ]]; then
					echo "Warning! You're trying to flash firmware that's not made for your device."
					echo "If you don't know what you're doing, please close the window and double check again."
					echo " "
					echo "Press any key to ignore this."
					echo " "; read continue
				fi
		fi
	fastboot oem getversions
	echo " "
	fastboot getvar unlocked
	echo " "

	echo "Please check information above."
	echo "If \"Unlocked\" is indicated as \"yes\", press any key to proceed."; read continue
	echo "Flashing critical partitions..."
	echo " "
	fastboot flash lk_a $lk_mtkab
	if [[ $? -ne 0 ]]; then 
		echo "ERROR: You didn't perform bootloader unlock. Please confirm again."
		fastboot reboot; read continue
		exit
    fi
	fastboot flash lk_b $lk_mtkab
	fastboot flash tee_a $tee_mtkab
	fastboot flash odmdtbo_a $odmdtbo_mtkab
	fastboot flash odmdtbo_b $odmdtbo_mtkab
	fastboot flash logo_a $logo_mtkab
	fastboot flash spmfw_a $spmfw_mtkab
	fastboot flash scp_a $scp_mtkab
	fastboot flash sspm_a $sspm_mtkab
	if [ $cv1_mtkab!="" ]; then
		fastboot flash cam_vpu1_a $cv1_mtkab
		fastboot flash cam_vpu2_a $cv2_mtkab
		fastboot flash cam_vpu3_a $cv3_mtkab
	fi
	fastboot oem set_active:a
	fastboot flash preloader_a $preloader_mtkab
	fastboot flash preloader_b $preloader_mtkab
	echo " "
	echo Flashing system partition, please wait...
	echo " "
	fastboot flash system_a $systema_mtkab
	fastboot flash system_b $systemb_mtkab
	fastboot flash vendor_a $vendor_mtkab
	fastboot flash boot_a $boot_mtkab
	fastboot erase boot_b
	fastboot flash userdata $ud_mtkab
	fastboot flash md1img_a $md1img_mtkab
	fastboot flash sutinfo $sutinfo_mtkab
	fastboot flash cda_a $cda_mtkab
	fastboot flash systeminfo_a $systeminfo_mtkab
	if [ $vbm_mtkab!="" ]; then
		fastboot flash vbmeta_a $vbm_mtkab
	fi
	echo Verifying flashing result, please wait...
	if [ -f md4.dat ]; then
		fastboot flash md4 md4.dat
	fi
	if [ -f md5.dat ]; then
		fastboot flash md5 md5.dat
	fi
	fastboot reboot
	echo "All done! Press any key to exit."
	echo " "
	echo " "; read continue
	exit
