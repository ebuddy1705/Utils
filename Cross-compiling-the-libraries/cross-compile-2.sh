#=======================================================================
# Cross compiler
#=======================================================================
tar –zxvf arm-linux-gcc-4.4.3.tar.gz

source setenv.sh
"
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
"

echo DISPLAY=:0.0
#=======================================================================
# FTP setup
#=======================================================================
ftp 192.168.1.230
username: plg
password: plg



#=======================================================================
# telnet setup
#=======================================================================
telnet 192.168.1.230
username: plg
password: plg




#=======================================================================
# initial NFS setup
#=======================================================================
#host init
systemctl stop firewalld.service
service nfs restart
ifconfig em1:0 192.168.1.100 netmask 255.255.255.0
minicom 

#target init
udhcpc
date 110216042014

ifconfig eth0:0 192.168.1.230 netmask 255.255.255.0
route add default gw 192.168.1.230
mount -o nolock,rsize=1024,wsize=1024 192.168.1.100:/friendlyarm /friendlyarm


#=======================================================================
# set time
#=======================================================================
#ntpdate pool.ntp.org
date 110216042014
#or date 030613252012  #03=March, 06=Day, 13=Hour, 25=Min, 2014=Year






#=======================================================================
# Linux kernel
#=======================================================================

tar –xvzf   linux-2.6.32.2.tar.gz
cd linux-2.6.32.2
cp config_mini2440_p35  .config
export ARCH=arm
make menuconfig
make zImage
=> linux-2.6.32.2/arch/arm/boot

export INSTALL_MOD_PATH=${FRIENDLYARM}
make modules
make modules_install
=> ${FRIENDLYARM}/lib/modules




#=======================================================================
# /friendlyarm/tslib
#=======================================================================
./autogen.sh
./configure --prefix=${FRIENDLYARM}/usr/local --host=${HOST}

#=======================================================================
# build QT (touch screen is not OK)
#=======================================================================
#edit $HOME/qt-everywhere-opensource-src-4.7.2/mkspecs/qws/linux-arm-g++/qmake.conf

include(../../common/g++.conf)
include(../../common/linux.conf)
include(../../common/qws.conf)

# modifications to g++.conf
QMAKE_CC                = arm-none-linux-gnueabi-gcc
QMAKE_CXX               = arm-none-linux-gnueabi-g++
QMAKE_LINK              = arm-none-linux-gnueabi-g++
QMAKE_LINK_SHLIB        = arm-none-linux-gnueabi-g++

# modifications to linux.conf
QMAKE_AR                = arm-none-linux-gnueabi-ar cqs
QMAKE_OBJCOPY           = arm-none-linux-gnueabi-objcopy
QMAKE_STRIP             = arm-none-linux-gnueabi-strip
QMAKE_INCDIR     		+= /friendlyarm/usr/local/include
QMAKE_LIBDIR     		+= /friendlyarm/usr/local/lib

load(qt_config)




cd qt-everywhere-opensource-src-4.7.2
./configure --prefix=${FRIENDLYARM}/usr/local -embedded arm -xplatform qws/linux-arm-g++ -qt-mouse-tslib -little-endian -no-qt3support -fast -no-largefile -qt-sql-sqlite -nomake tools -nomake demos -nomake examples -no-webkit -no-multimedia -no-javascript-jit
make 
make install



export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${FRIENDLYARM}/usr/local/lib                
export QWS_MOUSE_PROTO=tslib:/dev/input/event0
export TSLIB_CALIBFILE=/etc/pointercal        
export TSLIB_CONFFILE=/friendlyarm/tslib/etc/ts.conf  
export TSLIB_CONSOLEDEVICE=none               
export TSLIB_FBDEVICE=/dev/fb0              
export TSLIB_PLUGINDIR=/friendlyarm/tslib/lib/ts
export TSLIB_TSDEVICE=/dev/input/event0
export TSLIB_TSEVENTTYPE=INPUT
export QWS_KEYBOARD=TTY:/dev/tty1 




export QTDIR=/usr/local/Trolltech/QtEmbedded-4.8.5-arm
export LD_LIBRARY_PATH=$QTDIR/lib                    
export TSLIB_CONSOLEDEVICE=none                      
export TSLIB_FBDEVICE=/dev/fb0                       
export TSLIB_TSDEVICE=/dev/touchscreen-1wire         
export TSLIB_CALIBFILE=/etc/pointercal               
export TSLIB_CONFFILE=/usr/local/etc/ts.conf                                       
#export QWS_DISPLAY="LinuxFb:mmWidth135:mmHeight155"  
export QWS_MOUSE_PROTO="tslib:/dev/input/event0"     
export TSLIB_PLUGINDIR=/usr/lib/ts


search:
./configure -embedded arm -xplatform qws/linux-arm-g++ -prefix /usr/local/Qt -qt-mouse-tslib -little-endian -no-webkit -no-qt3support -no-cups -no-largefile -optimized-qmake -no-openssl -nomake tools -qt-sql-sqlite -no-3dnow -system-zlib -qt-gif -qt-libtiff -qt-libpng -qt-libmng -qt-libjpeg -no-opengl -gtkstyle -no-openvg -no-xshape -no-xsync -no-xrandr -qt-freetype -qt-gfx-linuxfb -qt-kbd-tty -qt-kbd-linuxinput -qt-mouse-tslib -qt-mouse-linuxinput


//embedded247
./configure --prefix=${FRIENDLYARM}/usr/local -embedded arm -xplatform qws/linux-arm-g++ -qt-mouse-tslib -little-endian -no-qt3support -fast -no-largefile -qt-sql-sqlite -nomake tools -nomake demos -nomake examples -no-webkit -no-multimedia -no-javascript-jit -qt-freetype -qt-gfx-linuxfb -qt-kbd-tty -qt-kbd-linuxinput -qt-mouse-tslib -qt-mouse-linuxinput




#build QT 5.3.2
./configure \
  -release \
  -no-opengl \
  -no-xcb \
  -optimized-qmake \
  -no-pch \
  -xplatform /home/ninhld/Documents/mini2440/lib/qt-everywhere-opensource-src-5.3.2/qtbase/mkspecs/linux-arm-gnueabi-g++ \
  -prefix ${FRIENDLYARM}/usr/local
  
 
For each module:


$ cd qt-everywhere-opensource-src-5.0.2
for module in qtimageformats qtjsbackend qtsvg qtxmlpatterns qtdeclarative \
  qtgraphicaleffects qtmultimedia qtquick1 qtscript qtwebkit-examples qtwebsockets qtwebkit; do
cd ../$module
/friendlyarm/qte/bin/qmake
make
sudo make install
done
  
  
  Ok, I solved the problem with the help of a guy from the #qt IRC channel.
It seems that the module qtwebkit isn’t built while compiling Qt. To compile qtwebkit change into directory qtwebkit:
cd <qt path>/qtwebkit
Create/configure Makefile:
../qtbase/bin/qmake
Compile qtwebkit:
make
  
  

# Run qt app
export QTDIR=/friendlyarm/qte
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${QTDIR}/lib/pkgconfig
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${QTDIR}/lib



#=======================================================================
# build Directfb  ok
#=======================================================================

# build libpng1.6.0 ok
./configure --prefix=${FRIENDLYARM}/usr/local --build=${BUILD} --host=${HOST}



# build freetype2.4 ok
./configure --prefix=${FRIENDLYARM}/usr/local --build=${BUILD} --host=${HOST}

#DirectFb
Building System Modules:
  Linux FBDev support       yes
  Generic /dev/mem support  yes
  Mesa/DRM/KMS support      no                 
  PVR2D                     no                
  EGL                       no                  
  X11 support               no                  
  X11/VDPAU support         no             
  OSX support               no                  
  SDL support               no                  
  VNC support               no  
  
  
  
I had the same issue, removing __initdata in
> arch/arm/mach-s3c2440/mach-mini2440.c
> in mini2440_lcd_cfg array and mini2440_fb_info data structure, solves
> the issue.
> But after that, I ran other issues, may be I miscompile directfb, i need
> to investigate more.  


export FREETYPE_CFLAGS="-I${FRIENDLYARM}/usr/local/include -I${FRIENDLYARM}/usr/local/include/freetype2"
export FREETYPE_LIBS="-L${FRIENDLYARM}/usr/local/lib -lfreetype"

export LIBPNG_CFLAGS="-I${FRIENDLYARM}/usr/local/include"
export LIBPNG_LIBS="-L${FRIENDLYARM}/usr/local/lib -lpng16"

export DIRECTFB_CFLAGS="-I${FRIENDLYARM}/usr/local/include -I${FRIENDLYARM}/usr/local/include/freetype2"
export DIRECTFB_LIBS="-L${FRIENDLYARM}/usr/local/lib"
export MODULEDIR="/home/ninhld/Documents/mini2440/OpenSource/DirectFb/DirectFB-1.6.0"
export CFLAGS=-g

./configure --prefix=${FRIENDLYARM}/usr/local --build=${BUILD} --host=${HOST} --disable-x11 --enable-fbdev=yes --disable-devmem --with-gfxdrivers=none --with-inputdrivers=none




# build LiTE-0.8.10  engine for directfb ok
export CFLAGS=-I${FRIENDLYARM}/usr/local/include 
export CPPFLAGS=-I${FRIENDLYARM}/usr/local/include 
export LDFLAGS=-L${FRIENDLYARM}/usr/local/lib

export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${FRIENDLYARM}/usr/local/lib/pkgconfig
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${FRIENDLYARM}/usr/local/lib

export DFB_CFLAGS="-I${FRIENDLYARM}/usr/local/include -I${FRIENDLYARM}/usr/local/include/directfb -I${FRIENDLYARM}/usr/local/include/directfb-internal"
export DFB_LIBS="-L${FRIENDLYARM}/usr/local/lib -L${FRIENDLYARM}/usr/local/lib/directfb-1.6-0/wm -L${FRIENDLYARM}/usr/local/lib/directfb-1.6-0/systems -L${FRIENDLYARM}/usr/local/lib/directfb-1.6-0/interfaces -ldirectfb -lfusion -ldirect -lpthread -ldl"

./configure --prefix=${FRIENDLYARM}/usr/local --build=${BUILD} --host=${HOST}


copy install folder to /friendlyarm/litedfb on mini2440, source env and run demo from 
/friendlyarm/litedfb/bin folder


# build Directfb  example ok 
export CFLAGS=-I${FRIENDLYARM}/usr/local/include 
export CPPFLAGS=-I${FRIENDLYARM}/usr/local/include 
export LDFLAGS=-L${FRIENDLYARM}/usr/local/lib
export LIBS=" -Wl,-rpath-link -Wl,${FRIENDLYARM}/usr/local/lib"
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${FRIENDLYARM}/usr/local/lib/pkgconfig
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${FRIENDLYARM}/usr/local/lib

./configure --prefix=${FRIENDLYARM}/usr/local --build=${BUILD} --host=${HOST}




# build single file
export CFLAGS=-I${FRIENDLYARM}/usr/local/include
export LDFLAGS=-L${FRIENDLYARM}/usr/local/lib
export FILE=df_matrix
arm-linux-gcc -o $FILE $FILE.c -I$DFBDIR/include/directfb -D_REENTRANT $DFBDIR/lib/directfb-1.6-0/wm/libdirectfbwm_default.so $DFBDIR/lib/directfb-1.6-0/systems/libdirectfb_fbdev.so -L$DFBDIR/lib -ldirectfb -lfusion -ldirect -lpthread -ldl



# run Directfb & LiTE example on board target
export FRIENDLYARM=/friendlyarm/friendlyarm
export PATH=$PATH:${FRIENDLYARM}/usr/local/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${FRIENDLYARM}/usr/local/lib:${FRIENDLYARM}/usr/local/lib/directfb-1.6-0/wm:${FRIENDLYARM}/usr/local/lib/directfb-1.6-0/systems:${FRIENDLYARM}/usr/local/lib/directfb-1.6-0/interfaces
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${FRIENDLYARM}/usr/local/lib/pkgconfig






#=======================================================================
# build Directfb 1.7 & ilixi 1.0 
#=======================================================================
#alsa-lib-1.0.22
./configure --prefix=${FRIENDLYARM}/usr/local --build=${BUILD} --host=${HOST} 



#alsa-utils-1.0.22 (NOT NEED for Directfb)
export CFLAGS=-I${FRIENDLYARM}/usr/local/include
export LDFLAGS=-L${FRIENDLYARM}/usr/local/lib
export PATH=$PATH:${FRIENDLYARM}/usr/local/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${FRIENDLYARM}/usr/local/lib
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${FRIENDLYARM}/usr/local/lib/pkgconfig

./configure --prefix=${FRIENDLYARM}/usr/local --build=${BUILD} --host=${HOST}


# linux-fusion-9.0.2
requirement: 
- build linux kernel modules ok
- for example: ${FRIENDLYARM}/lib/modules/2.6.32.2-FriendlyARM


open linux-fusion Makefile and edit:

KERNEL_VERSION   = 2.6.32.2-FriendlyARM
INSTALL_MOD_PATH = ${FRIENDLYARM}
KERNELDIR        = $(INSTALL_MOD_PATH)/lib/modules/$(KERNEL_VERSION)/build
FUSIONCORE       = single
ONECORE          = single

- make
- make install

=> install fusion.ko and linux-one.ko to ${FRIENDLYARM}/lib/modules/2.6.32.2-FriendlyARM/drivers/char/fusion
   fusion.h && one.h to ${FRIENDLYARM}/usr/include/linux

-runtime: insmod fusion.ko, insmod linux-one.ko


#Directfb 1.7	
export CPPFLAGS="-I${FRIENDLYARM}/usr/include -I${FRIENDLYARM}/usr/local/include -g"
export CFLAGS="-I${FRIENDLYARM}/usr/include -I${FRIENDLYARM}/usr/local/include -g"
export LDFLAGS="-L${FRIENDLYARM}/lib -L${FRIENDLYARM}/usr/lib -L${FRIENDLYARM}/usr/local/lib"
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${FRIENDLYARM}/usr/local/lib
export PKG_CONFIG_PATH=${FRIENDLYARM}/usr/local/lib/pkgconfig
./configure --prefix=${FRIENDLYARM}/usr/local \
			--build=${BUILD} --host=${HOST} \
			--disable-x11 \
			--enable-drmkms=no \
			--enable-fbdev=yes \
			--disable-devmem \
			--with-gfxdrivers=none \
			--with-inputdrivers=input_hub,keyboard,serialmouse,linuxinput,tslib \
			--enable-multi-kernel \
			--enable-fusiondale \
			--enable-fusionsound \
			--enable-one \
			--enable-sawman

--with-inputdrivers=LIST
                          LIST is a comma separated selection of inputdrivers
                          to build. Possible inputdrivers are: all (builds all
                          drivers), none (builds none), dbox2remote,
                          dreamboxremote, dynapro, elo-input, gunze, h3600_ts,
                          input_hub, joystick, keyboard, linuxinput, lirc,
                          mutouch, penmount, ps2mouse, serialmouse,
                          sonypijogdial, tslib, ucb1x00, wm97xx, zytronic.
                          [default=all]
./configure --help                          















#libsigc++-2.4.0
./configure --prefix=${FRIENDLYARM}/usr/local --build=${BUILD} --host=${HOST}


#libxml-2.0 >= 2.7.7
./configure --prefix=${FRIENDLYARM}/usr/local --build=${BUILD} --host=${HOST}

#fontconfig >= 2.6.0
export PATH=$PATH:${FRIENDLYARM}/usr/local/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${FRIENDLYARM}/usr/local/lib
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${FRIENDLYARM}/usr/local/lib/pkgconfig

./configure --prefix=${FRIENDLYARM}/usr/local --build=${BUILD} --host=${HOST} --enable-libxml2=yes


			
#ilixi 1.0
export CPPFLAGS="-I${FRIENDLYARM}/usr/include -I${FRIENDLYARM}/usr/local/include -g"
export CFLAGS="-I${FRIENDLYARM}/usr/include -I${FRIENDLYARM}/usr/local/include -g"
export LDFLAGS="-L${FRIENDLYARM}/lib -L${FRIENDLYARM}/usr/lib -L${FRIENDLYARM}/usr/local/lib"
export PKG_CONFIG_PATH=${FRIENDLYARM}/usr/local/lib/pkgconfig

./configure --prefix=${FRIENDLYARM}/usr/local --build=${BUILD} --host=${HOST} --with-examples --enable-nls=yes --enable-fusiondale=yes --enable-fusionsound=yes --enable-sawman=yes



# run Directfb & ilixi example on board target
export FRIENDLYARM=/friendlyarm
insmod ${FRIENDLYARM}/lib/modules/2.6.32.2-FriendlyARM/drivers/char/fusion/fusion.ko
insmod ${FRIENDLYARM}/lib/modules/2.6.32.2-FriendlyARM/drivers/char/fusion/linux-one.ko
export PATH=$PATH:${FRIENDLYARM}/usr/local/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${FRIENDLYARM}/usr/local/lib
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${FRIENDLYARM}/usr/local/lib/pkgconfig



#=======================================================================
# Build OpenCV
#=======================================================================

using cmake-gui to configure Opencv2.1 (or later) and setup for

1.BUILD_PACKAGE
2.BUILD_SHARED_LIBS
3.OPENCV_BUILD_3RDPARTY-LIBS #can uncheck 
4.WITH_JPEG
5.WITH_PNG
6.WITH_V4L


#error
/home/ninhld/Documents/mini2440/OpenSource/opencv/OpenCV-2.3.1/modules/flann/include/opencv2/flann/dist.h:63: error: 'fabsl' was not declared in this scope
make[2]: *** [modules/flann/CMakeFiles/opencv_flann.dir/src/precomp.o] Error 1
make[1]: *** [modules/flann/CMakeFiles/opencv_flann.dir/all] Error 2

==>
I had the same problem when compiling for my ARM board. 
Replace fabsl() with fabs() in /OpenCV-2.3.1/modules/flann/include/opencv2/flann/dist.h



# Build OpenCV application
export OPENCV_DIR=/friendlyarm/opencv

export PATH=$PATH:${OPENCV_DIR}/bin
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${OPENCV_DIR}/lib/pkgconfig
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${OPENCV_DIR}/lib

arm-none-linux-gnueabi-g++ `pkg-config --cflags opencv` `pkg-config --libs opencv` DisplayImage.cpp -o DisplayImage


arm-none-linux-gnueabi-g++  -I/friendlyarm/opencv/include/opencv  -L/friendlyarm/opencv/lib test.c -o test -lcv -lcxcore -lcvaux -lhighgui -lml -llibjpeg -llibpng -lpthread -lz -lopencv_lapack -lrt


# Run opencv app on kit
export QTDIR=/friendlyarm/qte
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${QTDIR}/lib/pkgconfig
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${QTDIR}/lib


export TSDIR=/friendlyarm/tslib
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${TSDIR}/lib/pkgconfig
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${TSDIR}/lib


export OPENCV_DIR=/friendlyarm/opencv
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${OPENCV_DIR}/lib/pkgconfig
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${OPENCV_DIR}/lib


export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/friendlyarm/tslib/lib:/friendlyarm/qte/lib:/friendlyarm/opencv/lib                
export QWS_MOUSE_PROTO=tslib:/dev/input/event0
export TSLIB_CALIBFILE=/friendlyarm/tslib/etc/pointercal        
export TSLIB_CONFFILE=/friendlyarm/tslib/etc/ts.conf  
export TSLIB_CONSOLEDEVICE=none               
export TSLIB_FBDEVICE=/dev/fb0              
export TSLIB_PLUGINDIR=/friendlyarm/tslib/lib/ts
export TSLIB_TSDEVICE=/dev/input/event0
export TSLIB_TSEVENTTYPE=INPUT
export QWS_KEYBOARD=TTY:/dev/tty1


./DisplayImage FromId3.jpg



#=======================================================================
# Build tinyxml
#=======================================================================
do not need build






#=======================================================================
# Build libxls
#=======================================================================
export ac_cv_func_malloc_0_nonnull=yes
export ac_cv_func_realloc_0_nonnull=yes

./configure --prefix=${FRIENDLYARM}/usr/local --build=${BUILD} --host=${HOST}



#run app on kit
export PATH=$PATH:${FRIENDLYARM}/usr/local/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${FRIENDLYARM}/usr/local/lib
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${FRIENDLYARM}/usr/local/lib/pkgconfig




#=======================================================================
# Build transmission
#=======================================================================
#build curl-7.38.0
./configure --prefix=${FRIENDLYARM}/usr/local --build=${BUILD} --host=${HOST}


#build zlib-1.2.8
./configure --prefix=${FRIENDLYARM}/usr/local


#lib openssl-1.0.1j
./config compiler:"arm-none-linux-gnueabi-gcc -msoft-float -D__GCC_FLOAT_NOT_NEEDED" --openssldir=${FRIENDLYARM}/usr/local



#build libevent (dependent: openssl)
export CFLAGS=-I${FRIENDLYARM}/usr/local/include
export LDFLAGS=-L${FRIENDLYARM}/usr/local/lib
export LIBS="-lssl -lcrypto"

./configure --prefix=${FRIENDLYARM}/usr/local --build=${BUILD} --host=${HOST} 


#build boost_1_57_0_b1
./bootstrap.sh

Modify the configuration file "project-build.jam" to use the ARM toolchain by replacing the line with "using gcc" by:
using gcc : arm : arm-none-linux-gnueabi-g++ ;

./bjam install toolset=gcc-arm --prefix=${FRIENDLYARM}/usr/local 



#build transmission-2.84
export CFLAGS=-I${FRIENDLYARM}/usr/local/include
export CPPFLAGS=-DTR_EMBEDDED
export LDFLAGS=-L${FRIENDLYARM}/usr/local/lib
export PKG_CONFIG_PATH=${FRIENDLYARM}/usr/local/lib/pkgconfig
			

./configure --prefix=${FRIENDLYARM}/usr/local \
			--build=${BUILD} --host=${HOST}  \
			--without-gtk --disable-libnotify \
			--disable-mac --disable-wx \
			--disable-beos --enable-utp \
			--disable-nls --enable-inotify \
			--enable-utp --enable-lightweight \
			--enable-cli --enable-daemon \
			--with-zlib=${FRIENDLYARM}/usr/local
			


#run transmission
export PATH=$PATH:${FRIENDLYARM}/usr/local/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${FRIENDLYARM}/usr/local/lib
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${FRIENDLYARM}/usr/local/lib/pkgconfig


transmission-daemon
transmission-remote 127.0.0.1:9091 -a the_torrent_file.torrent
transmission-remote 127.0.0.1:9091 -l -si

=> /Downloads and /.config/transmission are created


transmission-cli the_torrent_file.torrent

http://127.0.0.1:9091/transmission/web




#=======================================================================
# web (exits and stream server) live555
#=======================================================================
#build
cd <live555-dir>
./genMakefiles armlinux

open all Makefile and change PREFIX=/friendlyarm/live555 and CROSS_COMPILE?=arm-none-linux-gnueabi-

make
make install


#run app
export LIVE555DIR=/friendlyarm/live555
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${LIVE555DIR}/lib
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${LIVE555DIR}/lib/pkgconfig



#=======================================================================
# build web browsser (webkit)
#=======================================================================









#=======================================================================
# gstream
#=======================================================================


#libffi-3.2.1
./configure --prefix=${FRIENDLYARM}/usr/local --build=${BUILD} --host=${HOST} 

#libiconv-1.14 
./configure --prefix=${FRIENDLYARM}/usr/local --build=${BUILD} --host=${HOST} 

#zlib-1.2.8
./configure --prefix=${FRIENDLYARM}/usr/local


#glib-2.32.3
export CFLAGS=-I${FRIENDLYARM}/usr/local/include
export LDFLAGS=-L${FRIENDLYARM}/usr/local/lib
export PATH=$PATH:${FRIENDLYARM}/usr/local/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${FRIENDLYARM}/usr/local/lib
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${FRIENDLYARM}/usr/local/lib/pkgconfig

export glib_cv_stack_grows=no
export glib_cv_uscore=yes
export ac_cv_func_posix_getpwuid_r=yes
export ac_cv_func_posix_getgrgid_r=yes

./configure --prefix=${FRIENDLYARM}/usr/local --build=${BUILD} --host=${HOST} --with-libiconv

checking for glib-genmarshal... no
configure: error: Could not find a glib-genmarshal in your PATH
An easy way to resolve this is to install libglib2.0-dev:

yum install glib2 glib2-devel

#liboil
export CFLAGS=-I${FRIENDLYARM}/usr/local/include
export LDFLAGS=-L${FRIENDLYARM}/usr/local/lib
export PATH=$PATH:${FRIENDLYARM}/usr/local/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${FRIENDLYARM}/usr/local/lib
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${FRIENDLYARM}/usr/local/lib/pkgconfig

./configure --prefix=${FRIENDLYARM}/usr/local --build=${BUILD} --host=${HOST}



#gstreamer-1.4.5
export CFLAGS=-I${FRIENDLYARM}/usr/local/include
export CPPFLAGS=-I${FRIENDLYARM}/usr/local/include
export LDFLAGS=-L${FRIENDLYARM}/usr/local/lib
export PATH=$PATH:${FRIENDLYARM}/usr/local/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${FRIENDLYARM}/usr/local/lib
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${FRIENDLYARM}/usr/local/lib/pkgconfig


./configure --prefix=${FRIENDLYARM}/usr/local --build=${BUILD} --host=${HOST}


#gst-plugins-base-1.4.5
export CFLAGS=-I${FRIENDLYARM}/usr/local/include
export CPPFLAGS=-I${FRIENDLYARM}/usr/local/include
export LDFLAGS=-L${FRIENDLYARM}/usr/local/lib
export PATH=$PATH:${FRIENDLYARM}/usr/local/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${FRIENDLYARM}/usr/local/lib
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${FRIENDLYARM}/usr/local/lib/pkgconfig


./configure --prefix=${FRIENDLYARM}/usr/local --build=${BUILD} --host=${HOST}


#gst-plugins-ugly-1.4.5
export CFLAGS=-I${FRIENDLYARM}/usr/local/include
export LDFLAGS=-L${FRIENDLYARM}/usr/local/lib
export PATH=$PATH:${FRIENDLYARM}/usr/local/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${FRIENDLYARM}/usr/local/lib
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${FRIENDLYARM}/usr/local/lib/pkgconfig


./configure --prefix=${FRIENDLYARM}/usr/local --build=${BUILD} --host=${HOST}

#gst-plugins-bad-1.4.5
export CFLAGS=-I${FRIENDLYARM}/usr/local/include
export LDFLAGS=-L${FRIENDLYARM}/usr/local/lib
export PATH=$PATH:${FRIENDLYARM}/usr/local/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${FRIENDLYARM}/usr/local/lib
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${FRIENDLYARM}/usr/local/lib/pkgconfig

./configure --prefix=${FRIENDLYARM}/usr/local --build=${BUILD} --host=${HOST} --enable-x11=no --disable-x --disable-librfb



#run
export FRIENDLYARM=/friendlyarm
export PATH=$PATH:${FRIENDLYARM}/usr/local/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${FRIENDLYARM}/usr/local/lib
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${FRIENDLYARM}/usr/local/lib/pkgconfig
gst-launch-1.0 playbin uri=file:///friendlyarm/usr/local/share/nhac.wma









#=======================================================================
# mplayer
#=======================================================================

export CFLAGS=-I${FRIENDLYARM}/usr/local/include
export LDFLAGS=-L${FRIENDLYARM}/usr/local/lib
export PATH=$PATH:${FRIENDLYARM}/usr/local/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${FRIENDLYARM}/usr/local/lib
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:${FRIENDLYARM}/usr/local/lib/pkgconfig
export FLAGS="-I${FRIENDLYARM}/usr/local/include -L${FRIENDLYARM}/usr/local/lib -lasound"


./configure --prefix=${FRIENDLYARM}/usr/local --enable-cross-compile --cc=arm-none-linux-gnueabi-gcc --as=arm-none-linux-gnueabi-as \
--host-cc=gcc --target=arm-linux --prefix=${FRIENDLYARM}/usr/local \
--disable-x11 --disable-gui --disable-armv6 --disable-armv6t2 \
--disable-armvfp --disable-neon --disable-iwmmxt \
--disable-mencoder --disable-libmpeg2 --disable-libmpeg2-internal \
--disable-pnm --disable-md5sum --disable-tv \
--disable-ftp --disable-real --disable-xanim \
--disable-dvb --disable-dvdnav \
--disable-libdvdcss-internal --disable-dvdread-internal --disable-vcd \
--disable-tremor-internal --enable-static \
--extra-cflags="-mcpu=arm9 -O3" --disable-libvorbis \
--disable-ossaudio













#gstreamer
Configuration
	Version                    : 1.4.5
	Source code location       : .
	Prefix                     : /friendlyarm/host/usr/local
	Compiler                   : gcc -std=gnu99
	Package name               : GStreamer source release
	Package origin             : Unknown package origin

	Documentation (manuals)    : no
	Documentation (API)        : no

	Debug Logging              : yes
	Command-line parser        : yes
	Option parsing in gst_init : yes
	Tracing subsystem          : yes
	Allocation tracing         : yes
	Plugin registry            : yes
	Plugin support	           : yes
	Static plugins             : no
	Unit testing support       : yes

	Debug                      : yes
	Profiling                  : no

	Building benchmarks        : yes
	Building examples          : yes
	Building test apps         : yes
	Building tests that fail   : no
	Building tools             : yes





#bad
configure: *** Plug-ins without external dependencies that will be built:
	accurip
	adpcmdec
	adpcmenc
	aiff
	asfmux
	audiofxbad
	audiomixer
	audiovisualizers
	autoconvert
	bayer
	camerabin2
	coloreffects
	compositor
	dataurisrc
	debugutils
	dvbsuboverlay
	dvdspu
	festival
	fieldanalysis
	freeverb
	frei0r
	gaudieffects
	gdp
	geometrictransform
	id3tag
	inter
	interlace
	ivfparse
	ivtc
	jp2kdecimator
	jpegformat
	librfb
	liveadder
	midi
	mpegdemux
	mpegpsmux
	mpegtsdemux
	mpegtsmux
	mxf
	pcapparse
	pnm
	rawparse
	removesilence
	sdp
	segmentclip
	siren
	smooth
	speed
	stereo
	subenc
	videofilters
	videoparsers
	videosignal
	vmnc
	y4m
	yadif

configure: *** Plug-ins without external dependencies that will NOT be built:
	cdxaparse
	dccp
	faceoverlay
	hdvparse
	mve
	nuvdemux
	patchdetect
	real
	sdi
	tta
	videomeasure

configure: *** Plug-ins that have NOT been ported:
	acm
	apexsink
	cdxaparse
	dc1394
	dccp
	directdraw
	faceoverlay
	gsettings
	hdvparse
	libvisual
	linsys
	lv2
	musepack
	mve
	mythtv
	nas
	nuvdemux
	osx_video
	patchdetect
	quicktime
	real
	sdi
	sdl
	sndio
	teletextdec
	timidity
	tta
	vcd
	videomeasure
	wininet
	xvid

configure: *** Plug-ins with dependencies that will be built:
	decklink
	dvb
	fbdevsink
	gl
	shm

configure: *** Plug-ins with dependencies that will NOT be built:
	acm
	androidmedia
	apexsink
	applemedia
	assrender
	avcsrc
	bluez
	bz2
	chromaprint
	curl
	daala
	dash
	dc1394
	dfbvideosink 
	direct3dsink
	directdrawsink
	directsoundsrc
	dtsdec
	faac
	faad
	flite
	fluidsynth
	gme
	gsettings
	gsmenc gsmdec
	hls
	kate
	ladspa
	libmms
	libvisual
	linsys
	lv2
	mimic
	modplug
	mpeg2enc
	mpg123
	mplex
	musepack
	mythtvsrc
	nassink
	neonhttpsrc
	ofa
	openal
	opencv
	openexr
	openjpeg
	openni2
	opensl
	opus
	osxvideosrc
	pvr
	qtwrapper
	resindvd
	rsvg
	rtmp
	sbc
	schro
	sdlvideosink sdlaudiosink
	sfdec sfenc
	smoothstreaming
	sndio
	soundtouch
	spandsp
	spc
	srtp
	teletextdec
	timidity
	uvch264
	vcdsrc
	vdpau
	vo-aacenc
	vo-amrwbenc
	wasapi
	wayland 
	webp 
	wildmidi
	wininet
	winks
	winscreencap
	xvid
	zbar

configure: *** Orc acceleration enabled.

#base
configure: *** Plug-ins without external dependencies that will be built:
	adder
	app
	audioconvert
	audiorate
	audioresample
	audiotestsrc
	encoding
	gio
	playback
	subparse
	tcp
	typefind
	videoconvert
	videorate
	videoscale
	videotestsrc
	volume

configure: *** Plug-ins without external dependencies that will NOT be built:

configure: *** Plug-ins that have NOT been ported:

configure: *** Plug-ins with dependencies that will be built:
	alsa
	ximagesink ####not
	xvimagesink ###not

configure: *** Plug-ins with dependencies that will NOT be built:
	cdparanoia
	ivorbisdec
	libvisual
	ogg
	pango
	theora
	vorbis

configure: *** Orc acceleration enabled.

#good
configure: *** Plug-ins without external dependencies that will be built:
	alpha
	apetag
	audiofx
	audioparsers
	auparse
	autodetect
	avi
	cutter
	debugutils
	deinterlace
	dtmf
	effectv
	equalizer
	flv
	flx
	goom
	goom2k1
	icydemux
	id3demux
	imagefreeze
	interleave
	isomp4
	law
	level
	matroska
	multifile
	multipart
	replaygain
	rtp
	rtpmanager
	rtsp
	shapewipe
	smpte
	spectrum
	udp
	videobox
	videocrop
	videofilter
	videomixer
	wavenc
	wavparse
	y4m

configure: *** Plug-ins without external dependencies that will NOT be built:
	monoscope

configure: *** Plug-ins that have NOT been ported:

configure: *** Plug-ins with dependencies that will be built:
	jpeg
	oss4
	ossaudio
	png
	video4linux2
	ximagesrc

configure: *** Plug-ins with dependencies that will NOT be built:
	1394
	aasink
	cacasink
	cairo
	directsoundsink
	dv
	flac
	gdkpixbuf
	jack
	osxaudio
	osxvideosink
	pulseaudio
	shout2
	souphttpsrc
	speex
	sunaudio
	taglib
	vpx
	waveformsink
	wavpack

configure: *** Orc acceleration enabled.



#ugly
configure: *** Plug-ins without external dependencies that will be built:
	asfdemux
	dvdlpcmdec
	dvdsub
	realmedia
	xingmux

configure: *** Plug-ins without external dependencies that will NOT be built:

configure: *** Plug-ins that have NOT been ported:

configure: *** Plug-ins with dependencies that will be built:

configure: *** Plug-ins with dependencies that will NOT be built:
	a52dec
	amrnb
	amrwbdec
	cdio
	dvdreadsrc
	lame
	mad
	mpeg2dec
	sid
	twolame
	x264

configure: *** Orc acceleration enabled.




