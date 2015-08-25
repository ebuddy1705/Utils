#! /bin/sh

cd /home/ninhld/ZYNQ/Git/ramdisk/

if [ "$CROSS_COMPILE" = "" ]
then
	export CROSS_COMPILE=arm-xilinx-linux-gnueabi-
	source /opt/Xilinx/14.3/ISE_DS/settings64.sh
fi 

#export RAMDISK_DIR=/home/ninhld/ZYNQ/Git/ramdisk/
export STRONGSWAN_INSTALL_DIR=/home/ninhld/ZYNQ/strongswan-5.1.0/_install/

#cd ${RAMDISK_DIR}

dd if=/dev/zero of=ramdisk.image bs=1024 count=24576
mke2fs -F ramdisk.image -L "ramdisk" -b 1024 -m 0
tune2fs ramdisk.image -i 0
chmod a+rwx ramdisk.image

#mount -o loop arm_ramdisk.image ./rootfs
mount -o loop ramdisk.image ./roottmp

cp -rf ./rootfs/* ./roottmp

#add strongswan to rootfs
mkdir -p ./roottmp/usr/local
mkdir -p ./roottmp/usr/lib/systemd/system/

cp -rf ${STRONGSWAN_INSTALL_DIR}/* ./roottmp/usr/local
cp -rf ${STRONGSWAN_INSTALL_DIR}/service/strongswan.service ./roottmp/usr/lib/systemd/system/



umount ./roottmp
umount ./rootfs

gzip ramdisk.image
mkimage -A arm -T ramdisk -C gzip -d ramdisk.image.gz uramdisk.image.gz



#============================ ZedBoard ============================
cd /home/ninhld/ZedBoard/busybox_ramdisk/


if [ "$CROSS_COMPILE" = "" ]
then
	export CROSS_COMPILE=arm-xilinx-linux-gnueabi-
	source /opt/Xilinx/14.3/ISE_DS/settings64.sh
fi 

export STRONGSWAN_INSTALL_DIR=/home/ninhld/ZYNQ/strongswan-5.1.0/_install/
export KERNEL_INSTALL=/home/ninhld/ZedBoard/linux-digilent-master/_install/lib/modules/ 


dd if=/dev/zero of=ramdisk.image bs=1024 count=16384
mke2fs -F ramdisk.image -L "ramdisk" -b 1024 -m 0
tune2fs ramdisk.image -i 0
chmod a+rwx ramdisk.image
mv ramdisk.image ramdisk8M.image


mount -o loop arm_ramdisk8M.image ./rootfstmp
mount -o loop ramdisk8M.image ./rootfs

#add strongswan to rootfs
mkdir -p ./rootfs/usr/local
mkdir -p ./rootfs/usr/lib/systemd/system/
cp -rf ${STRONGSWAN_INSTALL_DIR}/* ./rootfs/usr/local
cp -rf ${STRONGSWAN_INSTALL_DIR}/service/strongswan.service ./rootfs/usr/lib/systemd/system/

#copy all from ./rootfstmp to ./rootfs
cp -rf ./rootfstmp/* ./rootfs

#copy kernel modules
cp -rf ${KERNEL_INSTALL}/* ./rootfs/lib/modules


#umount
umount ./rootfstmp
umount ./rootfs

#gzip
gzip ramdisk8M.image











