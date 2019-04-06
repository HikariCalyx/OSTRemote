title="Flashing script for fih_gsi_sdm660_64 devices"
echo "Initializing..."
echo " "
ls > list.txt
partition_sdm660=`grep "gpt_both0.bin" list.txt`
abl_sdm660=`grep "abl.elf" list.txt`
xbl_sdm660=`grep "xbl.elf" list.txt`
abls_sdm660=`grep "abl_service.elf" list.txt`
xbls_sdm660=`grep "xbl_service.elf" list.txt`
tz_sdm660=`grep "tz.mbn" list.txt`
rpm_sdm660=`grep "rpm.mbn" list.txt`
hwcfg_sdm660=`grep "hwcfg.img" list.txt`
hyp_sdm660=`grep "hyp.mbn" list.txt`
pmic_sdm660=`grep "pmic.elf" list.txt`
keymaster_sdm660=`grep "keymaster64.mbn" list.txt`
cmnlib_sdm660=`grep "cmnlib.mbn" list.txt`
cmnlib64_sdm660=`grep "cmnlib64.mbn" list.txt`
dsp_sdm660=`grep "dspso.bin" list.txt`
devcfg_sdm660=`grep "devcfg.mbn" list.txt`
sec_sdm660=`grep "sec.dat" list.txt`
mdtpsecapp_sdm660=`grep "mdtpsecapp.mbn" list.txt`
storsec_sdm660=`grep "storsec.mbn" list.txt`
systeminfo_sdm660=`grep "systeminfo.img" list.txt`
modem_sdm660=`grep "NON-HLOS.bin" list.txt`
mdtp_sdm660=`grep "mdtp.img" list.txt`
boot_sdm660=`grep "boot.img" list.txt`
systema_sdm660=`grep "system.img" list.txt`
fwprojectcode=`echo ${systema_sdm660:0:3}`
systemb_sdm660=`grep "system_other.img" list.txt`
bluetooth_sdm660=`grep "BTFM.bin" list.txt`
persist_sdm660=`grep "persist.img" list.txt`
sutinfo_sdm660=`grep "sutinfo.img" list.txt`
nvdef_sdm660=`grep "NV-default.img" list.txt`
hidden_sdm660=`grep "hidden.img.ext4" list.txt`
cda_sdm660=`grep "cda.img" list.txt`
splash_sdm660=`grep "[^multi]-splash.img" test.txt`
splash2_sdm660=`grep "multi-splash.img" list.txt`
vendor_sdm660=`grep "vendor.img" list.txt`
logfs_sdm660=`grep "logfs" list.txt`
rm list.txt
echo " "
echo "Hi there! This script is designed for flashing FIH gsi_sdm660_64 devices"
echo "back to factory stock without using OST LA."
echo " "
echo "Made by Hikari Calyx and written for following models:"
echo "Nokia 6.1 PL2, Nokia 6.1 Plus X6 DRG, Nokia 7 C1N, Nokia 7.1 CTL, Nokia 7 Plus B2N,"
echo "Sharp Aquos C10 S2 SS2-SAT, Sharp Aquos S3mini SG1, Sharp Aquos S3 HH1-SD1."
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
	fastboot flash partition $partition_sdm660
	if [[ $? -ne 0 ]]; then 
		echo "ERROR: You didn't perform critical bootloader unlock. Please confirm again."
		fastboot reboot; read continue
		exit
    fi
	fastboot flash xbl_a $xbls_sdm660
	fastboot flash xbl_b $xbls_sdm660
	fastboot flash abl_a $abls_sdm660
	fastboot flash abl_b $abls_sdm660
	fastboot flash tz_a $tz_sdm660
	fastboot flash rpm_a $rpm_sdm660
	fastboot flash hwcfg $hwcfg_sdm660
	fastboot flash hyp_a $hyp_sdm660
	fastboot flash pmic_a $pmic_sdm660
	fastboot flash keymaster_a $keymaster_sdm660
	fastboot flash cmnlib_a $cmnlib_sdm660
	fastboot flash cmnlib64_a $cmnlib64_sdm660
	fastboot flash dsp_a $dsp_sdm660
	fastboot flash devcfg_a $devcfg_sdm660
	fastboot flash sec $sec_sdm660
	fastboot flash mdtpsecapp_a $mdtpsecapp_sdm660
	fastboot flash storsec $storsec_sdm660
	fastboot flash systeminfo_a $systeminfo_sdm660
	fastboot reboot-bootloader
	echo " "
	echo "Please wait while phone is rebooting..."
	echo " "
	fastboot oem alive
	echo " "
	echo Flashing non-critical partitions...
	echo " "
	fastboot flash modem_a $modem_sdm660
	if [[ $? -ne 0 ]]; then 
		echo "ERROR: You didn't perform bootloader unlock. Please confirm again."
		fastboot reboot; read continue
		exit
    fi
	fastboot flash mdtp_a $mdtp_sdm660
	fastboot flash boot_a $boot_sdm660
	fastboot erase boot_b
	echo " "
	echo Flashing system partition, please wait...
	echo " "
	fastboot flash system_a $systema_sdm660
	fastboot flash system_b $systemb_sdm660
	fastboot flash bluetooth_a $bluetooth_sdm660
	fastboot flash persist $persist_sdm660
	if [ $econfirm=="yes" ]; then
		fastboot format userdata
	fi
	fastboot flash sutinfo $sutinfo_sdm660
	fastboot flash nvdef_a $nvdef_sdm660
	fastboot flash hidden_a $hidden_sdm660
	fastboot flash cda_a $cda_sdm660
	if [ $econfirm=="yes" ]; then
		fastboot erase ssd
		fastboot erase misc
		fastboot erase sti
	fi
	fastboot flash splash_a $splash_sdm660
	fastboot flash splash2 $splash2_sdm660
	fastboot flash vendor_a $vendor_sdm660
	if [ $econfirm=="yes" ]; then
		fastboot erase ddr
	fi
	fastboot flash xbl_a $xbl_sdm660
	fastboot flash xbl_b $xbl_sdm660
	fastboot flash abl_a $abl_sdm660
	fastboot flash abl_b $abl_sdm660
	fastboot oem set_active _a
	fastboot oem enable-charger-screen
	fastboot flash logfs $logfs_sdm660
	echo "Verifying flashing result, please wait..."
	fastboot flash md4 md4.dat
	fastboot reboot
	echo "All done! Press any key to exit."
	echo " "
	echo " "; read continue
	exit
