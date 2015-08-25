#!/bin/bash

make_directory_structure()
{
echo -e "\033[1;34m*Create directory structure*\033[0m"
rm -rf target/
# FIRMWARE INFORMATION
mkdir -p $1/target$TANGO/firmware
# USER INTERFACE (ACTIONSCRIPT)
mkdir -p $1/target$TANGO/flash
# Contains mouse
mkdir -p $1/target$TANGO/usr/local/etc/cursor
# Contains fonts
mkdir -p $1/target$TANGO/usr/local/etc/fonts
# Contains icons for Karaoke MP3
mkdir -p $1/target$TANGO/usr/local/etc/icons
# for hot-plug network use ifplugd open source
mkdir -p $1/target$TANGO/usr/local/etc/ifplugd
# for hot-plug network use Shell script
mkdir -p $1/target$TANGO/usr/local/etc/net_hotplug
# for samba
mkdir -p $1/target$TANGO/usr/local/etc/samba
# for fix bug play swf, dvd, karaoke mp3
mkdir -p $1/target$TANGO/usr/local/etc/spells
# for WiFi USB driver
mkdir -p $1/target$TANGO/usr/local/etc/wireless
# for resolve DNS
#...
# for Time Zone
#...
# for Real Time Clock
mkdir -p $1/target$TANGO/usr/local/etc/RTC
# for Scan Ports
mkdir -p $1/target$TANGO/usr/local/etc/nmap
# for Certification
mkdir -p $1/target$TANGO/usr/local/etc/ssl
# For LIB of open source
mkdir -p $1/target$TANGO/usr/local/lib

mkdir -p $1/target$TANGO/usr/local/sbin
mkdir -p $1/target$TANGO/usr/local/bin

mkdir -p $1/target$TANGO/usr/local/share/misc
mkdir -p $1/target$TANGO/usr/local/mrua/bin
mkdir -p $1/target$TANGO/usr/local/mrua/MRUA_src/llad/direct/kernel_src
mkdir -p $1/target$TANGO/usr/local/mrua/MRUA_src/llad_smallapps
mkdir -p $1/target$TANGO/usr/local/mrua/MRUA_src/llad_xtest
mkdir -p $1/target$TANGO/usr/local/mrua/MRUA_src/rmchannel/ios_client
mkdir -p $1/target$TANGO/usr/local/mrua/MRUA_src/rmchannel/xos2k_client
mkdir -p $1/target$TANGO/usr/local/mrua/MRUA_src/rua/emhwlib_kernel/kernel_src
mkdir -p $1/target$TANGO/usr/local/dcchd/directfb
mkdir -p $1/target$TANGO/usr/local/dcchd/dcchd/core
mkdir -p $1/target$TANGO/usr/local/dcchd/dcchd/dcchd
mkdir -p $1/target$TANGO/usr/local/dcchd/dcchd/dtv/acap
mkdir -p $1/target$TANGO/usr/local/dcchd/dcchd/dtv/capture
mkdir -p $1/target$TANGO/usr/local/dcchd/dcchd/dtv/network/ipfilter
mkdir -p $1/target$TANGO/usr/local/dcchd/dcchd/dtv/tuner/hardware
mkdir -p $1/target$TANGO/usr/local/dcchd/dcchd/mono
mkdir -p $1/target$TANGO/usr/local/dcchd/dcchd/curacao
mkdir -p $1/target$TANGO/usr/local/dcchd/dcchd/dvdvr
mkdir -p $1/target$TANGO/usr/local/dcchd/clients/flashlite
mkdir -p $1/target$TANGO/usr/local/dcchd/clients/qt/install/
echo -e "\033[1;34m*DONE*\033[0m"
}

copy_to()
{
	cp $1 $2 $3
	if [ "$?" !=  "0" ]; then
		echo -e "\033[1;31m*Copy $2->$3:FAILED*\033[0m"
		echo -e "\033[34m***Failed to make the image, please check again***\033[0m"
		#rm -rf target
		exit 1
	fi
	echo -e "\033[1;30m*Copy $2->$3:DONE*\033[0m"
}
#############################################MAIN starts from here#################################################
#./make_HDApp_image.sh <path_to_HDPlayer> <path_to_dcchd> <path_to_mrua> <path_to_mrua_fw>
echo -e "\033[1;34m***Create by: MDN***\033[0m"
echo -e "\033[1;34m***Now begin to make the Genesis image***\033[0m"
if [ -z $1 ] || [ -z $2 ]; then
	# no parameter passed
	echo -e "\033[31m*Not enough parameters passed*\033[0m"
	echo -e "\033[34m*Usage: ./make_Genesis_image <path_to_source> <path_to_target> \033[0m"
	exit 1
fi
echo "================================"
echo Path to your source:$1
echo Path to your target:$2
#echo Path to your target:`pwd`
echo "================================"
#cd $2
#make the image folder
make_directory_structure $2
################################################################################
echo -e "\033[1;34m***Copying...***\033[0m"
################################################################################
# FIRMWARE INFORMATION
copy_to -rf $1/firmware/FirmwareInfo.xml $2/target$TANGO/firmware
copy_to -rf $1/firmware/FirmwareInfo.xml.bak $2/target$TANGO/firmware
################################################################################
# FLASH USER INTERFACE
# YouTube application
copy_to -rf $1/flash/application $2/target$TANGO/flash/
copy_to -rf $1/flash/application_flooring.xml $2/target$TANGO/flash/
# language
copy_to -rf $1/flash/en $2/target$TANGO/flash/
copy_to -rf $1/flash/es $2/target$TANGO/flash/
copy_to -rf $1/flash/vi $2/target$TANGO/flash/
# picture
copy_to -rf $1/flash/pic $2/target$TANGO/flash/
copy_to -rf $1/flash/picture $2/target$TANGO/flash/
# for Karaoke book, currently don't use
# copy_to -rf $1/flash/book_patten.xml $2/target$TANGO/flash/
# for RSS
copy_to -rf $1/flash/flooring.xml $2/target$TANGO/flash/
copy_to -rf $1/flash/feedList.xml $2/target$TANGO/flash/
# for system configuration
copy_to -rf $1/flash/config.xml.bak $2/target$TANGO/flash/config.xml
copy_to -rf $1/flash/config.xml.bak $2/target$TANGO/flash/
#for 3G service providers 
copy_to -rf $1/flash/map_country_name.xml $2/target$TANGO/flash/
copy_to -rf $1/flash/serviceproviders.xml $2/target$TANGO/flash/
#for Airchord Flash
#copy_to -rf $1/flash/games $2/target$TANGO/flash/
#copy_to -rf $1/flash/info $2/target$TANGO/flash/
# for user interface
copy_to -rf $1/flash/main.swf $2/target$TANGO/flash/
################################################################################
# ETC
# for mouse
copy_to -rf $1/usr/local/etc/cursor/cursor.png $2/target$TANGO/usr/local/etc/cursor/
# for fonts
copy_to -rf $1/usr/local/etc/fonts/arial.ttf $2/target$TANGO/usr/local/etc/fonts/
copy_to -rf $1/usr/local/etc/fonts/arialbd.ttf $2/target$TANGO/usr/local/etc/fonts/
# for Karaoke MP3
copy_to -rf $1/usr/local/etc/icons/man.png $2/target$TANGO/usr/local/etc/icons/
copy_to -rf $1/usr/local/etc/icons/manwoman.png $2/target$TANGO/usr/local/etc/icons/
copy_to -rf $1/usr/local/etc/icons/woman.png $2/target$TANGO/usr/local/etc/icons/
# for hot-plug network use ifplugd open source
copy_to -rf $1/usr/local/etc/ifplugd/ifplugd.action $2/target$TANGO/usr/local/etc/ifplugd/
copy_to -rf $1/usr/local/etc/ifplugd/ifplugd.conf $2/target$TANGO/usr/local/etc/ifplugd/
# for hot-plug network use Shell script
copy_to -rf $1/usr/local/etc/net_hotplug/nethotplug.sh $2/target$TANGO/usr/local/etc/net_hotplug/
copy_to -rf $1/usr/local/etc/net_hotplug/wifihotplug.sh $2/target$TANGO/usr/local/etc/net_hotplug/
# for samba
copy_to -rf $1/usr/local/etc/samba/smb.conf $2/target$TANGO/usr/local/etc/samba/
# for fix bug play swf, dvd, karaoke mp3
copy_to -rf $1/usr/local/etc/spells/2s.mp4 $2/target$TANGO/usr/local/etc/spells/
copy_to -rf $1/usr/local/etc/spells/2s.srt $2/target$TANGO/usr/local/etc/spells/
copy_to -rf $1/usr/local/etc/spells/login.mp3 $2/target$TANGO/usr/local/etc/spells/
copy_to -rf $1/usr/local/etc/spells/silence.mp3 $2/target$TANGO/usr/local/etc/spells/
copy_to -rf $1/usr/local/etc/spells/Video.avi $2/target$TANGO/usr/local/etc/spells/
copy_to -rf $1/usr/local/etc/spells/photos $2/target$TANGO/usr/local/etc/spells/
# for WiFi USB driver
copy_to -rf $1/usr/local/etc/wireless/parse-iwlist.awk $2/target$TANGO/usr/local/etc/wireless/
copy_to -rf $1/usr/local/etc/wireless/rt5370sta.ko $2/target$TANGO/usr/local/etc/wireless/
copy_to -rf $1/usr/local/etc/wireless/RT2870STA.dat $2/target$TANGO/usr/local/etc/wireless/
# for resolve DNS
copy_to -rf $1/usr/local/etc/nsswitch.conf $2/target$TANGO/usr/local/etc/
# for Time Zone
copy_to -rf $1/usr/local/etc/GMT $2/target$TANGO/usr/local/etc/
# for Real Time Clock
copy_to -rf $1/usr/local/etc/RTC/SetTimeFrRTC.sh $2/target$TANGO/usr/local/etc/RTC/SetTimeFrRTC.sh
copy_to -rf $1/usr/local/etc/USB3G  $2/target$TANGO/usr/local/etc/
copy_to -rf $1/usr/local/etc/udev  $2/target$TANGO/usr/local/etc/
copy_to -rf $1/usr/local/etc/usb_modeswitch  $2/target$TANGO/usr/local/etc/
# for power On/Off board safely
copy_to -rf $1/usr/local/etc/shuttdown.sh $2/target$TANGO/usr/local/etc/

# for Scan Ports
copy_to -rf $1/usr/local/etc/nmap/* $2/target$TANGO/usr/local/etc/nmap

# for certifications
copy_to -rf $1/usr/local/etc/ssl/* $2/target$TANGO/usr/local/etc/ssl

################################################################################
# For LIB of open source
copy_to -rf $1/usr/local/lib $2/target$TANGO/usr/local/
################################################################################
#SBIN
# Genesis project
copy_to -rf $1/usr/local/sbin/coordination_process $2/target$TANGO/usr/local/sbin/
copy_to -rf $1/usr/local/sbin/genesis $2/target$TANGO/usr/local/sbin/
copy_to -rf $1/usr/local/sbin/update_firmware $2/target$TANGO/usr/local/sbin/
copy_to -rf $1/usr/local/sbin/usb_mode_detection $2/target$TANGO/usr/local/sbin/
# ifplugd open source
copy_to -rf $1/usr/local/sbin/ifplugd $2/target$TANGO/usr/local/sbin/
copy_to -rf $1/usr/local/sbin/ifplugstatus $2/target$TANGO/usr/local/sbin/
# for mount shared local network
copy_to -rf $1/usr/local/sbin/mount.cifs $2/target$TANGO/usr/local/sbin/
copy_to -rf $1/usr/local/sbin/umount.cifs $2/target$TANGO/usr/local/sbin/
# For wireless tools
copy_to -rf $1/usr/local/sbin/ifrename $2/target$TANGO/usr/local/sbin/
copy_to -rf $1/usr/local/sbin/iwgetid $2/target$TANGO/usr/local/sbin/
copy_to -rf $1/usr/local/sbin/iwevent $2/target$TANGO/usr/local/sbin/
copy_to -rf $1/usr/local/sbin/iwspy $2/target$TANGO/usr/local/sbin/
copy_to -rf $1/usr/local/sbin/iwpriv $2/target$TANGO/usr/local/sbin/
copy_to -rf $1/usr/local/sbin/iwlist $2/target$TANGO/usr/local/sbin/
copy_to -rf $1/usr/local/sbin/iwconfig $2/target$TANGO/usr/local/sbin/
copy_to -rf $1/usr/local/sbin/fuse-zip $2/target$TANGO/usr/local/sbin/

copy_to -rf $1/usr/local/sbin/pppd $2/target$TANGO/usr/local/sbin/
copy_to -rf $1/usr/local/sbin/chat $2/target$TANGO/usr/local/sbin/
copy_to -rf $1/usr/local/sbin/pppdump $2/target$TANGO/usr/local/sbin/
copy_to -rf $1/usr/local/sbin/pppstats $2/target$TANGO/usr/local/sbin/
copy_to -rf $1/usr/local/sbin/usb_modeswitch $2/target$TANGO/usr/local/sbin/
copy_to -rf $1/usr/local/sbin/usb_modeswitch_dispatcher $2/target$TANGO/usr/local/sbin/
#$TANGO/sigma_sdk/cs_rootfs_1.2.19/package/udev/udev-114/udevd $TANGO/usr/local/sbin/
copy_to -rf $1/usr/local/sbin/udevd $2/target$TANGO/usr/local/sbin/

copy_to -rf $1/usr/local/sbin/curl $2/target$TANGO/usr/local/sbin/

################################################################################
#BIN
copy_to -rf $1/usr/local/bin/iconv $2/target$TANGO/usr/local/bin/
copy_to -rf $1/usr/local/bin/file $2/target$TANGO/usr/local/bin/
################################################################################
#SHARE
copy_to -rf $1/usr/local/share/misc/magic.mgc $2/target$TANGO/usr/local/share/misc/
################################################################################
#MRUAFW
copy_to -rf $1/usr/local/mruafw $2/target$TANGO/usr/local/
################################################################################
#MRUA
copy_to -rf $1/usr/local/mrua/bin/example_outports $2/target$TANGO/usr/local/mrua/bin
copy_to -rf $1/usr/local/mrua/bin/xkc $2/target$TANGO/usr/local/mrua/bin
copy_to -rf $1/usr/local/mrua/bin/check_dsp.bash $2/target$TANGO/usr/local/mrua/bin
copy_to -rf $1/usr/local/mrua/bin/fw_reload_t3.bash $2/target$TANGO/usr/local/mrua/bin
copy_to -rf $1/usr/local/mrua/bin/unload_imat.bash $2/target$TANGO/usr/local/mrua/bin
copy_to -rf $1/usr/local/mrua/bin/which_chip.bash $2/target$TANGO/usr/local/mrua/bin
copy_to -rf $1/usr/local/mrua/bin/xlu_load_t3.bash $2/target$TANGO/usr/local/mrua/bin
copy_to -rf $1/usr/local/mrua/bin/xlu_unload_t3.bash $2/target$TANGO/usr/local/mrua/bin
copy_to -rf $1/usr/local/mrua/bin/enable_realvideo.bash $2/target$TANGO/usr/local/mrua/bin
copy_to -rf $1/usr/local/mrua/hosttools $2/target$TANGO/usr/local/mrua/
copy_to -rf $1/usr/local/mrua/lib $2/target$TANGO/usr/local/mrua/
copy_to -rf $1/usr/local/mrua/modules $2/target$TANGO/usr/local/mrua/
copy_to -rf $1/usr/local/mrua/MRUA_src/llad/direct/kernel_src/llad.ko $2/target$TANGO/usr/local/mrua/MRUA_src/llad/direct/kernel_src/
copy_to -rf $1/usr/local/mrua/MRUA_src/llad_smallapps/bw $2/target$TANGO/usr/local/mrua/MRUA_src/llad_smallapps/
copy_to -rf $1/usr/local/mrua/MRUA_src/llad_smallapps/gbus_fill $2/target$TANGO/usr/local/mrua/MRUA_src/llad_smallapps/
copy_to -rf $1/usr/local/mrua/MRUA_src/llad_smallapps/gbus_read_bin_to_file $2/target$TANGO/usr/local/mrua/MRUA_src/llad_smallapps/
copy_to -rf $1/usr/local/mrua/MRUA_src/llad_smallapps/gbus_read_uint16 $2/target$TANGO/usr/local/mrua/MRUA_src/llad_smallapps/
copy_to -rf $1/usr/local/mrua/MRUA_src/llad_smallapps/gbus_read_uint32 $2/target$TANGO/usr/local/mrua/MRUA_src/llad_smallapps/
copy_to -rf $1/usr/local/mrua/MRUA_src/llad_smallapps/gbus_read_uint32_to_file $2/target$TANGO/usr/local/mrua/MRUA_src/llad_smallapps/
copy_to -rf $1/usr/local/mrua/MRUA_src/llad_smallapps/gbus_read_uint8 $2/target$TANGO/usr/local/mrua/MRUA_src/llad_smallapps/
copy_to -rf $1/usr/local/mrua/MRUA_src/llad_smallapps/gbus_write_bin_from_file $2/target$TANGO/usr/local/mrua/MRUA_src/llad_smallapps/
copy_to -rf $1/usr/local/mrua/MRUA_src/llad_smallapps/gbus_write_uint16 $2/target$TANGO/usr/local/mrua/MRUA_src/llad_smallapps/
copy_to -rf $1/usr/local/mrua/MRUA_src/llad_smallapps/gbus_write_uint32 $2/target$TANGO/usr/local/mrua/MRUA_src/llad_smallapps/
copy_to -rf $1/usr/local/mrua/MRUA_src/llad_smallapps/gbus_write_uint32_from_file $2/target$TANGO/usr/local/mrua/MRUA_src/llad_smallapps/
copy_to -rf $1/usr/local/mrua/MRUA_src/llad_smallapps/gbus_write_uint8 $2/target$TANGO/usr/local/mrua/MRUA_src/llad_smallapps/
copy_to -rf $1/usr/local/mrua/MRUA_src/llad_smallapps/llad_get_config $2/target$TANGO/usr/local/mrua/MRUA_src/llad_smallapps/
copy_to -rf $1/usr/local/mrua/MRUA_src/llad_xtest/rmmalloc $2/target$TANGO/usr/local/mrua/MRUA_src/llad_xtest
copy_to -rf $1/usr/local/mrua/MRUA_src/llad_xtest/rmfree $2/target$TANGO/usr/local/mrua/MRUA_src/llad_xtest
copy_to -rf $1/usr/local/mrua/MRUA_src/rmchannel/ios_client/ikc $2/target$TANGO/usr/local/mrua/MRUA_src/rmchannel/ios_client
copy_to -rf $1/usr/local/mrua/MRUA_src/rmchannel/xos2k_client/xkc $2/target$TANGO/usr/local/mrua/MRUA_src/rmchannel/xos2k_client
copy_to -rf $1/usr/local/mrua/MRUA_src/rua/emhwlib_kernel/kernel_src/em8xxx.ko $2/target$TANGO/usr/local/mrua/MRUA_src/rua/emhwlib_kernel/kernel_src
copy_to -rf $1/usr/local/mrua/MRUA_src/rua/emhwlib_kernel/kernel_src/em8xxxalsa.ko $2/target$TANGO/usr/local/mrua/MRUA_src/rua/emhwlib_kernel/kernel_src
copy_to -rf $1/usr/local/mrua/MRUA_src/rua/emhwlib_kernel/kernel_src/em8xxxfb.ko $2/target$TANGO/usr/local/mrua/MRUA_src/rua/emhwlib_kernel/kernel_src
copy_to -rf $1/usr/local/mrua/MRUA_src/rua/emhwlib_kernel/kernel_src/em8xxxoss.ko $2/target$TANGO/usr/local/mrua/MRUA_src/rua/emhwlib_kernel/kernel_src
copy_to -rf $1/usr/local/mrua/run.env $2/target$TANGO/usr/local/mrua/
################################################################################
# DCCHD
copy_to -rf $1/usr/local/dcchd/directfb/lib $2/target$TANGO/usr/local/dcchd/directfb/
copy_to -rf $1/usr/local/dcchd/dcchd/core/libdcchd_core.so $2/target$TANGO/usr/local/dcchd/dcchd/core/
copy_to -rf $1/usr/local/dcchd/dcchd/dcchd/libdcchd.so $2/target$TANGO/usr/local/dcchd/dcchd/dcchd/
copy_to -rf $1/usr/local/dcchd/dcchd/dtv/acap/libdcchd_acap.so $2/target$TANGO/usr/local/dcchd/dcchd/dtv/acap/
copy_to -rf $1/usr/local/dcchd/dcchd/dtv/capture/libdcchd_cap.so $2/target$TANGO/usr/local/dcchd/dcchd/dtv/capture/
copy_to -rf $1/usr/local/dcchd/dcchd/dtv/network/ipfilter/.tmp_versions $2/target$TANGO/usr/local/dcchd/dcchd/dtv/network/ipfilter/
copy_to -rf $1/usr/local/dcchd/dcchd/dtv/network/ipfilter/ipfilter.ko $2/target$TANGO/usr/local/dcchd/dcchd/dtv/network/ipfilter/
copy_to -rf $1/usr/local/dcchd/dcchd/dtv/network/libdcchd_mcast.so $2/target$TANGO/usr/local/dcchd/dcchd/dtv/network/
copy_to -rf $1/usr/local/dcchd/dcchd/dtv/tuner/libdcchd_tuner.so $2/target$TANGO/usr/local/dcchd/dcchd/dtv/tuner/
copy_to -rf $1/usr/local/dcchd/dcchd/dtv/libdcchd_dtv.so $2/target$TANGO/usr/local/dcchd/dcchd/dtv/
copy_to -rf $1/usr/local/dcchd/dcchd/mono/libdcchd_lpb.so $2/target$TANGO/usr/local/dcchd/dcchd/mono/

# RED PACKAGE: DVD
NO_RED=`echo $RMCFLAGS | grep -i "\-DNO_RED_SUPPORT"`
if [ "$NO_RED" = "" ]; then
    copy_to -rf $1/usr/local/dcchd/dcchd/curacao/libdcchd_dvd.so $2/target$TANGO/usr/local/dcchd/dcchd/curacao/
    copy_to -rf $1/usr/local/dcchd/dcchd/curacao/lib $2/target$TANGO/usr/local/dcchd/dcchd/curacao/
    copy_to -rf $1/usr/local/dcchd/dcchd/dvdvr/libdcchd_dvdvr.so $2/target$TANGO/usr/local/dcchd/dcchd/dvdvr/
fi

copy_to -rf $1/usr/local/dcchd/directfbrc $2/target$TANGO/usr/local/dcchd
copy_to -rf $1/usr/local/dcchd/sigmadfbrc $2/target$TANGO/usr/local/dcchd
copy_to -rf $1/usr/local/dcchd/shared.env $2/target$TANGO/usr/local/dcchd
copy_to -rf $1/usr/local/dcchd/trun.env $2/target$TANGO/usr/local/dcchd

copy_to -rf $1/usr/local/dcchd/dcchd/dcchd/dcchdlog.cfg $2/target$TANGO/usr/local/dcchd/dcchd/dcchd/

################################################################################
# FLASHLITE
copy_to -rf $1/usr/local/dcchd/clients/flashlite/lib $2/target$TANGO/usr/local/dcchd/clients/flashlite/
copy_to -rf $1/usr/local/dcchd/clients/flashlite/run.env $2/target$TANGO/usr/local/dcchd/clients/flashlite/
#copy_to -rf $1/usr/local/dcchd/clients/qt/install/* $2/target$TANGO/usr/local/dcchd/clients/qt/install/
################################################################################
#GENESIS's script
#copy_to -rf $1/genesis.sh $2/target$TANGO/
copy_to -rf $HD_MEDIA_PLAYER/scripts/genesis.sh $2/target$TANGO/
copy_to -rf $HD_MEDIA_PLAYER/scripts/parse-iwlist.awk $2/target$TANGO/usr/local/etc/wireless/
echo -e "\033[1;31m***Copying...DONE***\033[0m"
echo -e "\033[1;34m***Image generated successully***\033[0m"
echo -e "\033[1;31m                               \033[0m"
echo -e "\033[1;31m           \\\\\\\\\\\\\\\\\\|/////         \033[0m"
echo -e "\033[1;31m            \\\\\\\ ~ ~ //          \033[0m"
echo -e "\033[1;31m            (/ @ @ /)          \033[0m"
echo -e "\033[1;31m----------oOOo-(_)-oOOo--------\033[0m"
echo -e "\033[1;31m                               \033[0m"
echo -e "\033[1;31m                               \033[0m"
echo -e "\033[1;31m        oooO                   \033[0m"
echo -e "\033[1;31m       (   )   Oooo            \033[0m"
echo -e "\033[1;31m--------\ (----(   )-----------\033[0m"
echo -e "\033[1;31m         \_)    ) /            \033[0m"
echo -e "\033[1;31mNguyen Duy My  (_/             \033[0m"
echo -e "\033[1;31m                               \033[0m"







