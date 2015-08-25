#! /bin/sh

cd /home/ninhld/ZYNQ/Git/u-boot-xlnx/

#build environment
if [ "$CROSS_COMPILE" = "" ]
then
	export CROSS_COMPILE=arm-xilinx-linux-gnueabi-
	source /opt/Xilinx/14.3/ISE_DS/settings64.sh
fi


make ARCH=arm zynq_zc70x_config  # or make ARCH=arm zynq_zed_config  for ZedBoard
make ARCH=arm

cd ./tools
export PATH=`pwd`:$PATH


1MB = 1024*1024*8 = 0x00800000  [8.388.608(bit) dec]
u-boot start at 0x04000000

#===========================================#
0x0000.0000	fsbl	                        #
						                    #
0x0200.0000	uramdisk	10MB = 0x00A00000   #
		                                    #
0x02A0.0000	devicetree	 6MB = 0x00600000   #
		                                    #
0x0300.0000	kernel	    16MB = 0x01000000   #
		                                    #		
0x0400.0000	U-boot	                        #
                                            #
#===========================================#


#how to use u-boot (default) ( SD boot)
mmcinfo
fatload mmc 0 0x03000000 uImage
fatload mmc 0 0x02A00000 devicetree.dtb
fatload mmc 0 0x02000000 uramdisk.image.gz
bootm 0x03000000 0x02000000 0x02A00000




#test relocated => ok
mmcinfo
fatload mmc 0 0x03100000 uImage
fatload mmc 0 0x02B00000 devicetree.dtb
fatload mmc 0 0x02000000 uramdisk.image.gz
bootm 0x03100000 0x02000000 0x02B00000

# change config before build u-boot in ./u-boot-xlnx/include/configs/zynq_zc70x.h  and ./u-boot-xlnx/include/configs/zynq_common.h
# or ./u-boot-xlnx/include/configs/zynq_zed.h













# ==================================== for ZedBoard u-boot-digilent =====================================================================
cd /home/ninhld/ZedBoard/u-boot-digilent-master/

make ARCH=arm zynq_zed_config
make ARCH=arm































