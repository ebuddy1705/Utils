#! /bin/sh

cd /home/ninhld/ZYNQ/Git/linux-xlnx/

#build environment
if [ "$CROSS_COMPILE" = "" ]
then
	export CROSS_COMPILE=arm-xilinx-linux-gnueabi-
	source /opt/Xilinx/14.3/ISE_DS/settings64.sh
fi

#make ARCH=arm xilinx_zynq_defconfig   #set defaul config
make ARCH=arm menuconfig

make ARCH=arm

make ARCH=arm UIMAGE_LOADADDR=0x8000 uImage

# export macros in Makefile
export INSTALL_MOD_PATH=`pwd`/_install
make ARCH=arm modules      
make ARCH=arm modules_install


#create image kernel modules
su
umount ./modules
rm -rf ./modules
rm -rf modules.img

dd if=/dev/zero of=modules.img bs=1M count=8
mkfs.ext2 -F modules.img

chmod go+w modules.img
mkdir ./modules
mount modules.img -o loop ./modules
cp -rf ./_install/lib/modules/* ./modules
chmod go-w modules.img
umount ./modules
exit


#rename zynq-zed.dtb => devicetree.dtb
rm -rf devicetree.dtb 
mv ./arch/arm/boot/dts/zynq-zed.dtb ./devicetree.dtb

# SFTP put dow SD card
sftp root@172.17.67.52
put /home/ninhld/ZYNQ/Git/linux-xlnx/arch/arm/boot/uImage /mnt
put /home/ninhld/ZYNQ/Git/linux-xlnx/modules.img /mnt
put /home/ninhld/ZYNQ/Git/linux-xlnx/devicetree.dtb /mnt



































# ==================================== for ZedBoard linux-digilent =====================================================================
#build environment
if [ "$CROSS_COMPILE" = "" ]
then
	export CROSS_COMPILE=arm-xilinx-linux-gnueabi-
	source /opt/Xilinx/14.3/ISE_DS/settings64.sh
fi

# create kernel image
make ARCH=arm digilent_zed_defconfig # setup default kernel config
make ARCH=arm menuconfig
make ARCH=arm

# export macros in Makefile
export INSTALL_MOD_PATH=`pwd`/_install
make ARCH=arm modules      
make ARCH=arm modules_install

# kernel at arch/arm/boot/zImage

#build devicetree.dtb from digilent-zed.dts
./scripts/dtc/dtc -I dts -O dtb -o ./devicetree.dtb ./digilent-zed.dts


#create image kernel modules
su
umount ./modules
rm -rf ./modules
rm -rf modules.img

dd if=/dev/zero of=modules.img bs=1M count=8
mkfs.ext2 -F modules.img

chmod go+w modules.img
mkdir ./modules
mount modules.img -o loop ./modules
cp -rf ./_install/lib/modules/* ./modules
chmod go-w modules.img
umount ./modules
exit


# sftp put dow SD card
sftp root@172.17.67.52

put /home/ninhld/ZYNQ/Git/linux-xlnx/modules.img /mnt










