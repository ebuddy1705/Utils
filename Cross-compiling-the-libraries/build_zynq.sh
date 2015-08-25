#! /bin/sh

#=======================================================================
#run Xilinx Tools
#build environment
#=======================================================================
export CROSS_COMPILE=arm-xilinx-linux-gnueabi-
export ARCH=arm
source /opt/Xilinx/14.3/ISE_DS/settings64.sh


xps &
xsdk &
ise &
planAhead &

#=======================================================================
#build u-boot.elf
#=======================================================================
tar -xzf u-boot-xlnx.tar.gz

export CROSS_COMPILE=arm-xilinx-linux-gnueabi-
export ARCH=arm
source /opt/Xilinx/14.3/ISE_DS/settings64.sh

cd /path/to/u-boot-xlnx

make ARCH=arm zynq_zed_config
make ARCH=arm # u-boot file in /path/to/u-boot-xlnx, change u-boot => u-boot.elf

#=======================================================================
#build kernel (uImage, modules.img)
#=======================================================================
tar -xzf linux-xlnx.tar.gz

export CROSS_COMPILE=arm-xilinx-linux-gnueabi-
export ARCH=arm
source /opt/Xilinx/14.3/ISE_DS/settings64.sh

cd /home/ninhld/ZYNQ/Git/linux-xlnx

make ARCH=arm xilinx_zynq_defconfig
make ARCH=arm menuconfig
make ARCH=arm
make ARCH=arm UIMAGE_LOADADDR=0x8000 uImage  #/path/to/linux-xlnx/arch/arm/boot

rm -rf module_install
mkdir module_install
export INSTALL_MOD_PATH=`pwd`/module_install
make ARCH=arm modules
make ARCH=arm modules_install
#--start copy centic_crypton and test app
cp -rf /home/ninhld/ZYNQ/Git/centic-crypto-driver/centic-crypto.ko ./module_install/lib/modules/3.13.0-xilinx-dirty/kernel/crypto
cp -rf /home/ninhld/ZYNQ/Git/centic-crypto-driver/TestApp/testctcrypto ./module_install/lib/modules/3.13.0-xilinx-dirty/kernel/crypto
#--stop copy



rm -rf modules.img
dd if=/dev/zero of=modules.img bs=1M count=8
mkfs.ext2 -F modules.img
chmod go+w modules.img
mkdir ./modules
su
mount modules.img -o loop ./modules
cp -rf ./module_install/lib/modules/* ./modules

#--start copy centic_crypton and test app
cp -rf /home/ninhld/ZYNQ/Git/centic-crypto-driver/centic-crypto.ko ./modules/3.13.0-xilinx-dirty/kernel/crypto
cp -rf /home/ninhld/ZYNQ/Git/centic-crypto-driver/TestApp/testctcrypto ./modules/3.13.0-xilinx-dirty/kernel/crypto
#--stop copy

umount ./modules
exit
chmod go-w modules.img


#=======================================================================
#rootfs
#=======================================================================
gunzip ramdisk.image.gz
chmod u+rwx ramdisk.image
mkdir tmp_mnt

su
mount -o loop ramdisk.image tmp_mnt/
#...change here
umount tmp_mnt/
exit
gzip ramdisk.image

#create u- header to work with u-boot
mkimage -A arm -T ramdisk -C gzip -d ramdisk.image.gz uramdisk.image.gz















#=======================================================================
# nfs
#=======================================================================
#on host 
ifconfig p1p1:0 192.168.4.2 netmask 255.255.255.0
service nfs start

#on zynq target
ifconfig eth0:0 192.168.4.1 netmask 255.255.255.0
mount -o nolock 192.168.4.2:/home/ninhld/ZedBoard/nfs /nfs

#=======================================================================
# sftp
#=======================================================================
sftp root@172.17.67.91
password: root
put /home/ninhld/ZedBoard/IPSEC_CRYPTON_DMA/hardware/BOOT/BOOT.BIN /mnt
put /home/ninhld/ZYNQ/Git/linux-xlnx/modules.img /mnt/
put /home/ninhld/ZYNQ/Git/linux-xlnx/arch/arm/boot/uImage /mnt/

#=======================================================================
# git
#=======================================================================
git clone git@172.17.67.18:centic-crypto-driver.git

#=======================================================================
#network and firewall on host
#=======================================================================
systemctl stop firewalld.service
rm '/etc/systemd/system/dbus-org.fedoraproject.FirewallD1.service'
rm '/etc/systemd/system/basic.target.wants/firewalld.service'


service network restart
ip link show

#set new ip on the same interface 
ifconfig eth0:0 192.168.4.1 netmask 255.255.255.0   (zynq target)
ifconfig p1p1:0 192.168.4.2 netmask 255.255.255.0   (host       )




#=======================================================================
#build centic-crypto driver
#=======================================================================
export CROSS_COMPILE=arm-xilinx-linux-gnueabi-
export ARCH=arm
source /opt/Xilinx/14.3/ISE_DS/settings64.sh

cd /home/ninhld/ZYNQ/Git
make clean_centic_crypto_driver
make centic_crypto_driver




export CROSS_COMPILE=arm-xilinx-linux-gnueabi-
export ARCH=arm
source /opt/Xilinx/14.3/ISE_DS/settings64.sh


cd /home/ninhld/ZYNQ/Git/linux-xlnx
./scripts/dtc/dtc -I dts -O dtb -o /home/ninhld/workspaceXilinxSDK/device-tree_bsp_0/ps7_cortexa9_0/libsrc/device-tree_v0_00_x/devicetree.dtb /home/ninhld/workspaceXilinxSDK/device-tree_bsp_0/ps7_cortexa9_0/libsrc/device-tree_v0_00_x/xilinx.dts

cd /home/ninhld/workspaceXilinxSDK/device-tree_bsp_0/ps7_cortexa9_0/libsrc/device-tree_v0_00_x
