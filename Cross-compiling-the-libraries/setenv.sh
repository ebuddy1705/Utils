#!/bin/bash

export SRCROOT=`pwd`
export FRIENDLYARM=/friendlyarm
export CC_PATH=/home/ninhld/mini2440/SDK/FriendlyARM/toolschain/4.4.3
export CROSS_COMPILE=${CC_PATH}/bin/arm-none-linux-gnueabi-
export CC=${CROSS_COMPILE}gcc
export STRIP=${CROSS_COMPILE}strip
export AR=${CROSS_COMPILE}ar
export AS=${CROSS_COMPILE}as
export CXX=${CROSS_COMPILE}g++
export CPP=${CROSS_COMPILE}cpp
export LD=${CROSS_COMPILE}ld
export RANLIB=${CROSS_COMPILE}ranlib
export ARCH=arm
export KROOT=
export ADVBOOT_SOURCE=
export UBOOT_SOURCE=
export ROOTFS=/home/ninhld/mini2440/SDK/rootfs_qtopia_qt4
export LOG=${SRCROOT}/Build.log
export PATH=$PATH:${CC_PATH}/bin
export PLATFORM=
export HOST=arm-none-linux-gnueabi
export BUILD=x86_64

