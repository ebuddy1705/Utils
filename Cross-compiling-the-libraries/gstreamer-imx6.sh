

#===================== CROSS COMPILE ===================================
source setenv.sh

export CFLAGS="-I${FREESCALE}/usr/local/include -I${ROOTFS}/usr/include -I${ROOTFS}/usr/local/include  -mfloat-abi=softfp -mfpu=neon -march=armv7-a -fPIC -O3 -fno-strict-aliasing -fno-optimize-sibling-calls  -g"
export LDFLAGS="-L${FREESCALE}/usr/local/lib -L${ROOTFS}/usr/lib -L${ROOTFS}/usr/local/lib -mfloat-abi=softfp -mfpu=neon -march=armv7-a"
export CPPFLAGS=$CFLAGS
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${FREESCALE}/usr/local/lib
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${FREESCALE}/usr/local/lib/pkgconfig

export LIBS="-L${FREESCALE}/usr/local/lib -lffi"



#libffi-3.2.1
./configure --prefix=${FREESCALE}/usr/local --build=${BUILD} --host=${HOST} 


#zlib-1.2.8
./configure --prefix=${FREESCALE}/usr/local


#orc-0.4.18
./configure --prefix=${FREESCALE}/usr/local --build=${BUILD} --host=${HOST} 


#glib-2.42.1
export LIBFFI_CFLAGS=-I${FREESCALE}/usr/local/lib/libffi-3.2.1/include
export LIBFFI_LIBS="-L${FREESCALE}/usr/local/lib -lffi"

export ZLIB_CFLAGS=-I${FREESCALE}/usr/local/include
export ZLIB_LIBS="-L${FREESCALE}/usr/local/lib -lz"

export glib_cv_stack_grows=no
export glib_cv_uscore=yes
export ac_cv_func_posix_getpwuid_r=yes
export ac_cv_func_posix_getgrgid_r=yes

./configure --prefix=${FREESCALE}/usr/local --build=${BUILD} --host=${HOST}

checking for glib-genmarshal... no
configure: error: Could not find a glib-genmarshal in your PATH
An easy way to resolve this is to install libglib2.0-dev:

yum install glib2 glib2-devel


#libpng-1.6.16
export CFLAGS="-I${FREESCALE}/usr/local/include -mfloat-abi=softfp -march=armv7-a -fPIC -O3 -fno-strict-aliasing -fno-optimize-sibling-calls  -g"
export LDFLAGS="-L${FREESCALE}/usr/local/lib -lz -mfloat-abi=softfp -march=armv7-a"

./configure --prefix=${FREESCALE}/usr/local --build=${BUILD} --host=${HOST}


#gstreamer-1.2.2
./configure --prefix=${FREESCALE}/usr/local --build=${BUILD} --host=${HOST}


#gst-plugins-base-1.2.2
./configure --prefix=${FREESCALE}/usr/local --build=${BUILD} --host=${HOST}


./configure --prefix=${FREESCALE}/usr/local --build=${BUILD} --host=${HOST} --target=${HOST} \
GST_BASE_LIBS=-L${FREESCALE}/usr/local/lib \
GST_CONTROLLER_LIBS=-L${FREESCALE}/usr/local/lib \
GST_CHECK_LIBS=-L${FREESCALE}/usr/local/lib \
GST_LIBS=-L${FREESCALE}/usr/local/lib \
GST_PLUGINS_BASE_LIBS=-L${FREESCALE}/usr/local/lib \
CC=${CROSS_COMPILE}gcc \
--with-pkg-config-path=-L${FREESCALE}/usr/local/lib/pkgconfig \
--with-plugins=playbin





#gst-plugins-good-1.2.2
./configure --prefix=${FREESCALE}/usr/local --build=${BUILD} --host=${HOST}

#gst-plugins-ugly-1.2.2
./configure --prefix=${FREESCALE}/usr/local --build=${BUILD} --host=${HOST}

#gst-plugins-bad-1.2.2 (FAIL !!!)
./configure --prefix=${FREESCALE}/usr/local --build=${BUILD} --host=${HOST}



#gstreamer-imx
export PKG_CONFIG_SYSROOT_DIR=$ROOTFS
export KERNEL_HEADER_PATH=${KROOT}/include

./waf configure --prefix=${FREESCALE}/usr/local --kernel-headers=$KERNEL_HEADER_PATH


#run (minicom) NOT YET
ifconfig eth0 192.168.3.2 netmask 255.255.255.0
mount -o nolock,rsize=1024,wsize=1024 192.168.3.3:/home/ninhld/freescale /home/ninhld/freescale

export FREESCALE=/home/ninhld/freescale
export PATH=$PATH:${FREESCALE}/usr/local/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${FREESCALE}/usr/local/lib:${FREESCALE}/usr/local/gstreamer-1.0
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${FREESCALE}/usr/local/lib/pkgconfig
export GST_PLUGIN_PATH=${FREESCALE}/usr/local/lib/gstreamer-1.0
gst-launch-1.0 playbin uri=file://${FREESCALE}/usr/local/share/mong_cho_anh.wav




