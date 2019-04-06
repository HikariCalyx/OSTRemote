#!/bin/bash
title="Flashing script for NB1 and A1N"
echo "Initializing..."
echo " "
ls > list.txt
partition0_sdm835=`grep "gpt_both0.bin" list.txt`
partition1_sdm835=`grep "gpt_both1.bin" list.txt`
partition2_sdm835=`grep "gpt_both2.bin" list.txt`
partition3_sdm835=`grep "gpt_both3.bin" list.txt`
partition4_sdm835=`grep "gpt_both4.bin" list.txt`
partition5_sdm835=`grep "gpt_both5.bin" list.txt`
abl_sdm835=`grep "abl.elf" list.txt`
xbl_sdm835=`grep "xbl.elf" list.txt`
abls_sdm835=`grep "abl_service.elf" list.txt`
xbls_sdm835=`grep "xbl_service.elf" list.txt`
tz_sdm835=`grep "tz.mbn" list.txt`
rpm_sdm835=`grep "rpm.mbn" list.txt`
hwcfg_sdm835=`grep "hwcfg.img" list.txt`
hyp_sdm835=`grep "hyp.mbn" list.txt`
pmic_sdm835=`grep "pmic.elf" list.txt`
keymaster_sdm835=`grep "keymaster64.mbn" list.txt`
cmnlib_sdm835=`grep "cmnlib.mbn" list.txt`
cmnlib64_sdm835=`grep "cmnlib64.mbn" list.txt`
dsp_sdm835=`grep "dspso.bin" list.txt`
devcfg_sdm835=`grep "devcfg.mbn" list.txt`
sec_sdm835=`grep "sec.dat" list.txt`
mdtpsecapp_sdm835=`grep "mdtpsecapp.mbn" list.txt`
storsec_sdm835=`grep "storsec.mbn" list.txt`
systeminfo_sdm835=`grep "systeminfo.img" list.txt`
modem_sdm835=`grep "NON-HLOS.bin" list.txt`
mdtp_sdm835=`grep "mdtp.img" list.txt`
boot_sdm835=`grep "boot.img" list.txt`
systema_sdm835=`grep "system.img" list.txt`
fwprojectcode=`echo ${systema_sdm835:0:3}`
systemb_sdm835=`grep "system_other.img" list.txt`
bluetooth_sdm835=`grep "BTFM.bin" list.txt`
persist_sdm835=`grep "persist.img" list.txt`
sutinfo_sdm835=`grep "sutinfo.img" list.txt`
nvdef_sdm835=`grep "NV-default.img" list.txt`
hidden_sdm835=`grep "hidden.img.ext4" list.txt`
cda_sdm835=`grep "cda.img" list.txt`
splash_sdm835=`grep "splash.img" test.txt`
splash2_sdm835=`grep "splash2.img" list.txt`
vendor_sdm835=`grep "vendor.img" list.txt`
logfs_sdm835=`grep "logfs" list.txt`
rm list.txt
echo " "
echo "Hi there! This script is designed for flashing your device"
echo "back to factory stock without using OST LA."
echo " "
echo "Made by Hikari Calyx and written for following models:"
echo "Nokia 8 NB1, Nokia 8 Sirocco A1N"
echo " "
echo "Do you wish to erase userdata while flashing?"
echo " "
echo "Userdata erasing will not erase FRP lock."
echo " "
echo "Please type lowercase \"yes\" to confirm erasing, then press Enter Key to proceed. "
echo " "
echo "Otherwise, press Enter Key will skip userdata erasing."
echo " "
read econfirm
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
	echo Your Phone\'s serial number is $devsn and the Project Code is $actprojectcode.
	echo The firmware itself is used for $fwprojectcode.
	    if [[ $actprojectcode != $fwprojectcode ]]; then
	   	    echo "Warning! You're trying to flash firmware that's not made for your device."
	   	    echo "If you don't know what you're doing, please close the window and double check again."
	   	    echo " "
	   	    echo "Press any key to ignore this."
   		    echo " "; read continue
	    fi
	fastboot oem getversions
	echo " "
	fastboot oem device-info
	echo " "

	echo "Please check information above."
	echo "If both \"Device unlocked\" and \"Device critical\" unlocked are"
	echo "indicated as \"true\", press any key to proceed."; read continue
	echo "Flashing critical partitions..."
	echo " "
	fastboot flash partition:0 $partition0_sdm835
	if [[ $? -ne 0 ]]; then 
		echo "ERROR: You didn't perform critical bootloader unlock. Please confirm again."
		fastboot reboot; read continue
		exit
    fi
	fastboot flash partition:1 $partition1_sdm835
	fastboot flash partition:2 $partition2_sdm835
	fastboot flash partition:3 $partition3_sdm835
	fastboot flash partition:4 $partition4_sdm835
	fastboot flash partition:5 $partition5_sdm835
	fastboot flash tz_a $tz_sdm835
	fastboot flash rpm_a $rpm_sdm835
	fastboot flash hyp_a $hyp_sdm835
	fastboot flash pmic_a $pmic_sdm835
	fastboot flash keymaster_a $keymaster_sdm835
	fastboot flash cmnlib_a $cmnlib_sdm835
	fastboot flash cmnlib64_a $cmnlib64_sdm835
	fastboot flash devcfg_a $devcfg_sdm835
	fastboot flash xbl_a $xbls_sdm835
	fastboot flash xbl_b $xbls_sdm835
	fastboot flash abl_a $abls_sdm835
	fastboot flash abl_b $abls_sdm835
	fastboot flash systeminfo_a $systeminfo_sdm835
	fastboot reboot-bootloader
	echo " "
	echo "Please wait while phone is rebooting..."
	echo " "
	fastboot oem alive
	echo " "
	echo Flashing system partition, please wait...
	echo " "
	fastboot flash system_a %systema_sdm835%
	if [[ $? -ne 0 ]]; then 
		echo "ERROR: You didn't perform bootloader unlock. Please confirm again."
		fastboot reboot; read continue
		exit
    fi
	fastboot flash system_b %systemb_sdm835%
	echo " "
	echo Flashing non-critical partitions...
	echo " "
	fastboot flash persist $persist_sdm835
	fastboot flash modem_a $modem_sdm835
	fastboot flash dsp_a $dsp_sdm835
	fastboot flash boot_a $boot_sdm835
	fastboot flash bluetooth_a $bluetooth_sdm835
	fastboot flash mdtp_a $mdtp_sdm835
	fastboot erase boot_b
	fastboot flash logfs $logfs_sdm835
	fastboot flash nvdef_a $nvdef_sdm835
	if [ $econfirm=="yes" ]; then
		fastboot format userdata
	fi
	fastboot flash cda_a $cda_sdm835
	fastboot flash hidden_a $hidden_sdm835
	fastboot flash sutinfo $sutinfo_sdm835
	fastboot flash splash_a $splash_sdm835
	fastboot flash splash2 $splash2_sdm835
	fastboot flash mdtpsecapp_a $mdtpsecapp_sdm835
	fastboot flash storsec $storsec_sdm835
	fastboot flash xbl_a $xbl_sdm835
	fastboot flash xbl_b $xbl_sdm835
	fastboot flash abl_a $abl_sdm835
	fastboot flash abl_b $abl_sdm835
	if [[ $vendor_sdm835 == *"vendor.img" ]; then
		fastboot flash vendor $vendor_sdm835
	fi
	fastboot oem set_active _a
	fastboot oem enable-charger-screen
	fastboot flash logfs $logfs_sdm835
	echo "Verifying flashing result, please wait..."
	fastboot flash md4 md4.dat
	fastboot reboot
	echo "All done! Press any key to exit."
	echo " "
	echo " "; read continue
	exit
