ifconfig eth0 172.17.67.52 netmask 255.255.255.0
route add default gw 172.17.67.1
echo "nameserver 8.8.8.8" > /etc/resolv.conf









# ifconfig eth0 192.168.168.189 netmask 255.255.255.0
# route add default gw 192.168.168.168
# mount -o nolock 192.168.168.30:/8652_3110_tango /8652_3110_tango
#/etc/init.d/S90ethernet stop
export TANGO=/8671_3110_tango
mount -o remount,ro $TANGO
export EM8XXX_SERVER=":0"
export PATH=$PATH:/usr/local/bin/:$TANGO/usr/local/sbin/:$TANGO/usr/local/bin/:$TANGO/usr/local/dcchd/clients/flashlite/bin:$TANGO/usr/local/etc/nmap
export DFB_CONFIG_DIR=$TANGO/usr/local/dcchd
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$TANGO/usr/local/dcchd/directfb/lib:$TANGO/usr/local/mrua/lib:/lib:$TANGO/usr/local/lib:$TANGO/usr/local/dcchd/clients/flashlite/lib
export ENABLE_DEV_SUPPORT=1
#export ENABLE_COORDINATION=1
#export ENABLE_DEV_SUPPORT="ON"
#export CDROM_DEVICE_NAME=/dev/sr0
#export G_FILENAME_ENCODING=ISO-8859-1
export DEFAULT_FONT="$TANGO/usr/local/etc/fonts/arial.ttf"
export QT_DIR=$TANGO/usr/local/dcchd/clients/qt
export QT_INSTALL_DIR=$TANGO/usr/local/dcchd/clients/qt/install
export DBG_FILE_ENV=$TANGO/usr/local/dcchd/dcchd/dcchd/dcchdlog.cfg
$TANGO/usr/local/etc/RTC/SetTimeFrRTC.sh
mknod /dev/mum0 c 126 0
mknod /dev/em8xxx0 c 127 0
#remember here
ln -sf $TANGO/usr/local/etc/nsswitch.conf /etc/
#for wireless
mkdir -p /etc/Wireless/RT2870STA                                                
cp -f $TANGO/usr/local/etc/wireless/RT2870STA.dat /etc/Wireless/RT2870STA/  
#mknod /dev/ir c 254 0
modprobe irkernel
#ln -sf $TANGO/usr/local/etc/GMT /usr/share/zoneinfo/
#ln -sf $TANGO/usr/etc/zoneinfo /usr/share/
rm -rf /usr/share/zoneinfo/
ln -sf /8671_3110_tango/usr/local/etc/zoneinfo/ /usr/share/zoneinfo
export TZ=America/Los_Angeles
#modprobe sr_mod
cd $TANGO/usr/local/mrua
export LLAD_PARAMS="max_dmapool_memory_size=0x800000 max_dmabuffer_log2_size=19"
source run.env
#modprobe irkernel wait_period=80 max_keys=16 repeat_sends_zero=1
#modprobe irkernel wait_period=1 max_keys=16 repeat_sends_zero=5
ir_major=$(grep -e"[0-9]* ir" /proc/devices | cut -d' ' -f 1)
mknod /dev/ir c ${ir_major} 0
ulimit -S -c 0
if [ -d drmlibs ]; then
	export LD_LIBRARY_PATH=$(pwd)/drmlibs/production/libs:${LD_LIBRARY_PATH}
fi

cd $QT_INSTALL_DIR
if [ -f qt.env ]; then
    source qt.env
    #Plugin
    #export QTWEBKIT_PLUGIN_PATH=$QT_INSTALL_DIR/lib/plugin
    #export QTWEBKIT_PLUGIN_PATH=$QT_INSTALL_DIR/plugin
    #Browser
    export WEBKIT_BROWSER_LIB_PATH=$QT_INSTALL_DIR/lib/QtWebBrowser
    export LD_LIBRARY_PATH=$QT_INSTALL_DIR/lib:$WEBKIT_BROWSER_LIB_PATH:$LD_LIBRARY_PATH
fi

cd $TANGO/usr/local/dcchd/clients/flashlite
source run.env
cd $TANGO/usr/local/dcchd
source trun.env
mkfifo /tmp/nethotplug
mkdir -p /media/USBs/
ln -sf $TANGO/usr/local/dcchd/directfbrc /etc
ln -sf $TANGO/usr/local/dcchd/sigmadfbrc /etc
#for SD card
modprobe sdhci
modprobe sdhci-tangox
modprobe mmc_block

mmc_major=$(cat /proc/devices | grep mmc | cut -d' ' -f 0)
if [ "$mmc_major" = "" ]; then
  echo "no device found [mmc]"
  sleep 1
else
  mknod -m 666 /dev/mmcblk0 b $mmc_major 0
  mknod -m 666 /dev/mmcblk0p1 b $mmc_major 1
  mknod -m 666 /dev/mmcblk0p2 b $mmc_major 2
  mknod -m 666 /dev/mmcblk0p3 b $mmc_major 3
  mknod -m 666 /dev/mmcblk0p4 b $mmc_major 4
  mknod -m 666 /dev/mmcblk0p5 b $mmc_major 5
  mknod -m 666 /dev/mmcblk0p6 b $mmc_major 6

  mknod -m 666 /dev/mmcblk1 b $mmc_major 16
  mknod -m 666 /dev/mmcblk1p1 b $mmc_major 17
  mknod -m 666 /dev/mmcblk1p2 b $mmc_major 18
  mknod -m 666 /dev/mmcblk1p3 b $mmc_major 19
  mknod -m 666 /dev/mmcblk1p4 b $mmc_major 20
  mknod -m 666 /dev/mmcblk1p5 b $mmc_major 21
  mknod -m 666 /dev/mmcblk1p6 b $mmc_major 22

fi

#	mkdir -p /etc/Wireless
#	ln -sf /mnt/acronics/RT2880 /etc/Wireless/RT2880
#	insmod /etc/Wireless/RT2880/rt2880_iNIC.ko mode=sta
modprobe usb-otg
mknod /dev/usb-otg c 300 0

$TANGO/usr/local/sbin/usb_mode_detection
#modprobe tangox-ehci-hcd

modprobe tangox-ehci-hcd
modprobe usb-storage
#modprobe tangox-ohci-hcd
modprobe usbhid
chmod 0666 /dev/input/mice
chmod 0666 /dev/input/event0
chmod 0666 /dev/input/event1
# for Standby mode
modprobe fctrl.ko
echo "0xb54acb04 0xb24d4040 0xbc43e608 0xED12FF00" > /proc/tangoxfreq/ir_table
unload_imat.bash
fw_reload
cd $TANGO/flash
mkdir -p /tmp/subtitles
chmod 777 -R /tmp/subtitles
mkdir -p /media/ISO_DVD
export APP_CONTINUE="1"
ulimit -n 65535
ln -s $TANGO /tango

# for TV turner
mkdir -p /lib/firmware/
cp /tango/usr/local/etc/tuner/dvb-fe-xc5000-1.1.fw /lib/firmware/
cp /tango/usr/local/etc/tuner/dvb-usb-it9135-01.fw /lib/firmware/dvb-usb-it9135-01.f


mkdir -p /dev/dvb/adapter0
mknod /dev/dvb/adapter0/frontend0 c 212 3
mknod /dev/dvb/adapter0/demux0 c 212 4 
mknod /dev/dvb/adapter0/dvr0 c 212 5
mknod /dev/dvb/adapter0/net0 c 212 7

###############
modprobe fuse
mknod /dev/fuse -m 0666 c 10 229
cp -rf $TANGO/usr/local/etc/USB3G/ppp /etc
chmod 777 -R /etc/ppp
cp -rf $TANGO/usr/local/etc/udev /etc/
udevd --daemon
mount -t usbfs usbfs /proc/bus/usb

GENESIS_SELECT="1"
AIRCHORD_SELECT="2"
export SELECT_ENVIRONMENT=$GENESIS_SELECT
mkdir -p /etc/stagecraft-data
ln -sf $TANGO/usr/local/etc/ssl /etc/stagecraft-data/
mkdir -p /etc/pki/tls
ln -sf $TANGO/usr/local/etc/ssl/certs /etc/pki/tls/
cp -f $TANGO/usr/local/etc/system/systemCfg.xml /tmp/
cp -f $TANGO/usr/local/etc/system/runtimeInfo.xml /tmp/
#coordination_process &
