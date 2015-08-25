#! /bin/sh

cd /home/ninhld/ZYNQ/Git/busybox/

if [ "$CROSS_COMPILE" = "" ]
then
	export CROSS_COMPILE=arm-xilinx-linux-gnueabi-
	source /opt/Xilinx/14.3/ISE_DS/settings64.sh
fi 

make ARCH=arm defconfig # set default config
make ARCH=arm menuconfig

make ARCH=arm install  # ./_install directory
