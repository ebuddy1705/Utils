


#=======================================================================
# Building BusyBox
#=======================================================================
make ARCH=arm CROSS_COMPILE=arm-xilinx-linux-gnueabi- defconfig

"or set the install location to /home/devel/_rootfs
(BusyBox Settings->Installation Options->BusyBox installation prefix)"
make ARCH=arm CROSS_COMPILE=arm-xilinx-linux-gnueabi- menuconfig  

make ARCH=arm CROSS_COMPILE=arm-xilinx-linux-gnueabi- install


"/etc/init.d/rcS   <apply for zynq linux>"
echo "++ Starting telnet daemon"
telnetd -l /bin/sh

echo "++ Starting http daemon"
httpd -h /var/www

echo "++ Starting ftp daemon"
tcpsvd 0:21 ftpd ftpd -w /&

echo "++ Starting ssh daemon"
chmod 600 /etc/ssh_host_*
/usr/sbin/sshd




#=======================================================================
# inetutils-1.5 : ftpd, inetd, rexecd, rlogind, rshd, syslogd, talkd, 
#                 telnetd, tftpd, uucpd
#=======================================================================
./configure --prefix=$PREFIX --host=${HOST} \
CC=arm-xilinx-linux-gnueabi-gcc \
AR=arm-xilinx-linux-gnueabi-ar \
RANLIB=arm-xilinx-linux-gnueabi-ranlib \
LD=arm-xilinx-linux-gnueabi-ld

make install



#=======================================================================
# openssh-7.0p1 [dependency (search in this file): openssl, zlib]
#=======================================================================
DEPEND_LIB_DIR=/home/ninhld/Zynq706/Project/FIREWALL/user
export PREFIX= #not thing

./configure --prefix=$PREFIX --host=${HOST} \
--with-libs --with-zlib=${DEPEND_LIB_DIR} \
--with-ssl-dir=${DEPEND_LIB_DIR} \
--disable-etc-default-login \
CC=arm-xilinx-linux-gnueabi-gcc \
AR=arm-xilinx-linux-gnueabi-ar

"- open Makefile
 - remove STRIP_OPT and check-config"
 
make

export PREFIX=/home/ninhld/Zynq706/Project/FIREWALL/user
make DESTDIR=$PREFIX install



#=======================================================================
# dropbear (ssh) daemon [dependency (search in this file): zlib]
#=======================================================================
./configure --prefix=$PREFIX --host=${HOST} \
CC=${CROSS_COMPILE}gcc LDFLAGS="-Wl,--gc-sections" \
CFLAGS="-ffunction-sections -fdata-sections -Os"

make PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp" MULTI=1 strip
make install

echo "++ Starting dropbear (ssh) daemon"
ln -s $PREFIX/sbin/dropbear $PREFIX/usr/bin/scp
dropbear



#=======================================================================
# Network Time Protocol - ntp-4.2.6p5
#=======================================================================
./configure --prefix=$PREFIX --host=${HOST} CC=${CROSS_COMPILE}gcc

make ARCH=arm install


#=======================================================================
# DNS - dnsmasq-2.64
#=======================================================================
"modify PREFIX in Makefile"
make CC=${CROSS_COMPILE}gcc ARCH=arm \
PREFIX=/home/ninhld/Zynq706/Project/FIREWALL/user \
install



#=======================================================================
# iptables-1.4.21
#=======================================================================
KERNEL_DIR=/home/ninhld/Zynq706/SDK/linux-xlnx/module_install/lib/modules/3.9.0-xilinx-dirty
./configure --prefix=$PREFIX --host=${HOST} \
--enable-libipq --enable-devel \
--enable-static --enable-shared \
--with-kernel=$KERNEL_DIR/kernel \
--with-kbuild=$KERNEL_DIR/build \
--with-ksource=$KERNEL_DIR/source \
ARCH=arm \
CC=${CROSS_COMPILE}gcc


make ARCH=arm install


#=======================================================================
# arptables-v0.0.3-4
#=======================================================================
make CC=${CROSS_COMPILE}gcc ARCH=arm \
KERNEL_DIR=/home/ninhld/Zynq706/SDK/linux-xlnx/module_install/lib/modules/3.9.0-xilinx-dirty \
PREFIX=/home/ninhld/Zynq706/Project/FIREWALL/user \
install



#=======================================================================
# Dynamic Routing - quagga-0.99.22.4
#=======================================================================
./configure --prefix=$PREFIX --host=${HOST} CC=${CROSS_COMPILE}gcc

make ARCH=arm install




#=======================================================================
# SSL VPN - openvpn-2.3.8
#=======================================================================
# openssl-1.0.0s (dependency)
# static library
./Configure dist --prefix=${PREFIX}
make CC="${CROSS_COMPILE}gcc" AR="${CROSS_COMPILE}ar r" RANLIB="${CROSS_COMPILE}ranlib" install

# shared library
export PREFIX=/home/ninhld/Zynq706/Project/FIREWALL/user
source /opt/Xilinx/14.3/ISE_DS/settings64.sh

./Configure --prefix=${PREFIX} shared "arm-xilinx-linux-gnueabi":"arm-xilinx-linux-gnueabi-gcc:-DTERMIO -O3 -Wall -I../../host/include::-D_REENTRANT::-L../../host/lib -ldl:BN_LLONG RC4_CHAR RC4_CHUNK DES_INT DES_UNROLL BF_PTR::bn_asm.o armv4-mont.o::aes_cbc.o aes-armv4.o:::sha1-armv4-large.o sha256-armv4.o sha512-armv4.o:::::::void:dlfcn:linux-shared:-fPIC::.so.1.0.0":arm-xilinx-linux-gnueabi-ranlib::

# lzo-2.09
./configure --prefix=$PREFIX --host=${HOST} CC=${CROSS_COMPILE}gcc
make ARCH=arm install

# openvpn-2.3.8
DEPEND_LIB_DIR=/home/ninhld/Zynq706/Project/FIREWALL/user
export PKG_CONFIG_PATH=${DEPEND_LIB_DIR}/lib/pkgconfig
export CFLAGS=-I${DEPEND_LIB_DIR}/include
export LDFLAGS=-L${DEPEND_LIB_DIR}/lib
./configure --prefix=$PREFIX --host=${HOST} CC=${CROSS_COMPILE}gcc \
--disable-plugin-auth-pam

make ARCH=arm install


#=======================================================================
# IPSec VPN - strongswan-5.1.0
#=======================================================================
#gmp-6.0.0 (dependency)
./configure --prefix=$PREFIX --host=${HOST} CC=${CROSS_COMPILE}gcc
make ARCH=arm install

#strongswan-5.1.0
DEPEND_LIB_DIR=/home/ninhld/Zynq706/Project/FIREWALL/user
export CFLAGS=-I${DEPEND_LIB_DIR}/include
export LDFLAGS=-L${DEPEND_LIB_DIR}/lib
./configure --prefix=$PREFIX \
--host=${HOST} CC=${CROSS_COMPILE}gcc \
CFLAGS="-DDEBUG_LEVEL=4" \
--disable-scripts \
--enable-dhcp --enable-farp \
--with-systemdsystemunitdir=${PREFIX}/service

make ARCH=arm install




#=======================================================================
# iproute2-4.1.1
#=======================================================================
for dir in ip misc tc; do
    cp ${dir}/Makefile{,.orig}
    sed 's/0755 -s/0755/' ${dir}/Makefile.orig > ${dir}/Makefile
done

cp misc/Makefile{,.orig}
sed '/^TARGETS./s@arpd@@g' misc/Makefile.orig > misc/Makefile

INSTALL_DIR=/home/ninhld/Zynq706/Project/FIREWALL/user
make  CC=${CROSS_COMPILE}gcc \
PREFIX=$INSTALL_DIR \
LIBDIR=$INSTALL_DIR/lib \
SBINDIR=$INSTALL_DIR/sbin \
CONFDIR=$INSTALL_DIR/etc/iproute2 \
DATADIR=$INSTALL_DIR/share \
DOCDIR=$INSTALL_DIR/doc/iproute2 \
MANDIR=$INSTALL_DIR/man \
ARPDDIR=$INSTALL_DIR/var/lib/arpd \
install



#=======================================================================
# Logging and snmp:  
#=======================================================================
#nfdump-1.6.13
./configure --prefix=$PREFIX --host=${HOST} CC=${CROSS_COMPILE}gcc

"
- open Makefile
- Comment 2 lines below:
	#define malloc rpl_malloc
	#define realloc rpl_realloc
"

make install

#net-snmp-5.7.3
./configure -prefix=$PREFIX --enable-static --disable-shared \
--enable-mini-agent --disable-applications --disable-des --disable-privacy \
--disable-md5 --disable-manuals --with-ldflags=-Bstatic \
--with-cc=arm-xilinx-linux-gnueabi-gcc \
--with-ar=arm-xilinx-linux-gnueabi-ar \
--with-ld=arm-xilinx-linux-gnueabi-ld \
--with-endianness=little --with-defaults --without-perl-modules \
--build=x86_64-linux --host=arm-xilinx-linux-gnueabi --target=arm-xilinx-linux-gnueabi \
--without-openssl --with-logfile="/var/log/ snmpd.log" \
--with-default-snmp-version=2 --disable-mib-loading \
--with-mib-modules="mibII ip-mib if-mib tcp-mib udp-mib ucd_snmp target agent_mibs notification-log-mib snmpv3mibs notification"

make install



#=======================================================================
# IDS Snort
#=======================================================================
#libpcap-1.7.4
source /opt/Xilinx/14.3/ISE_DS/settings64.sh
export PREFIX=/home/ninhld/Zynq706/Project/FIREWALL/user
export HOST=arm-xilinx-linux-gnueabi
./configure --prefix=$PREFIX --host=${HOST} CC=arm-xilinx-linux-gnueabi-gcc \
--with-pcap=linux

#tcpdump-4.7.4
./configure --prefix=$PREFIX --host=${HOST} CC=arm-xilinx-linux-gnueabi-gcc
make install

#libdnet-1.11
./configure --kernel-dir=/home/ninhld/Zynq706/SDK/linux-xlnx \
--cc=arm-xilinx-linux-gnueabi-gcc
make install

#daq-2.0.6
"
- open configure file
- search 'cannot run test program while cross compiling'
  and remove all test compile to disable check compiler;
  replace by another command, ex: echo cross_compiling=yes
"

DEPEND_LIB_DIR=/home/ninhld/Zynq706/Project/FIREWALL/user

./configure --prefix=$PREFIX --host=${HOST} \
CC=arm-xilinx-linux-gnueabi-gcc \
--with-libpcap-includes=${DEPEND_LIB_DIR}/include \
--with-libpcap-libraries=${DEPEND_LIB_DIR}/lib \
--with-dnet-includes=${DEPEND_LIB_DIR}/include \
--with-dnet-libraries=${DEPEND_LIB_DIR}/lib \
--disable-netmap-module \
--enable-static

#pcre-8.36
./configure --prefix=$PREFIX --host=${HOST} \
CC=arm-xilinx-linux-gnueabi-gcc

make install

#zlib-1.2.8
export CC=${CROSS_COMPILE}gcc
./configure --prefix=$PREFIX
make ARCH=arm
make ARCH=arm install


#snort-2.9.7.5
"
- open configure file
- search 'cannot run test program while cross compiling'
  and remove all test compile to disable check compiler;
  replace by another command, ex: echo cross_compiling=yes
"

DEPEND_LIB_DIR=/home/ninhld/Zynq706/Project/FIREWALL/user
export CFLAGS=-I${DEPEND_LIB_DIR}/include
export CPPFLAGS=-I${DEPEND_LIB_DIR}/include
export LDFLAGS=-L${DEPEND_LIB_DIR}/lib
export PKG_CONFIG_PATH=${DEPEND_LIB_DIR}/lib/pkgconfig
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${DEPEND_LIB_DIR}/lib

./configure --prefix=$PREFIX --host=${HOST} \
CC=arm-xilinx-linux-gnueabi-gcc \
--with-dnet-includes=${DEPEND_LIB_DIR}/include \
--with-dnet-libraries=${DEPEND_LIB_DIR}/lib \
--with-daq-includes=${DEPEND_LIB_DIR}/include \
--with-daq-libraries=${DEPEND_LIB_DIR}/lib \
--with-openssl-includes=${DEPEND_LIB_DIR}/include \
--with-openssl-libraries=${DEPEND_LIB_DIR}/lib \
--disable-static-daq




#=======================================================================
# Proxy server squid-3.5.7-20150801-r13880
#=======================================================================
"native build, don't source cross environment"
./configure
make

mv src/cf_gen src/cf_gen-host


"cross compile"
export LD_LIBRARY_PATH=/lib:/lib64:/usr/lib:/usr/lib64
./configure --prefix=$PREFIX --host=${HOST} \
CC=arm-xilinx-linux-gnueabi-gcc \
AR=arm-xilinx-linux-gnueabi-ar \
RANLIB=arm-xilinx-linux-gnueabi-ranlib \
LD=arm-xilinx-linux-gnueabi-ld


make -C lib 
make -C src cf_gen 

cp -rf src/cf_gen-host src/cf_gen
touch src/cf_gen
 
make CC=arm-xilinx-linux-gnueabi-gcc \
AR=arm-xilinx-linux-gnueabi-ar \
RANLIB=arm-xilinx-linux-gnueabi-ranlib \
LD=arm-xilinx-linux-gnueabi-ld



#=======================================================================
# AAA server: freeradius-server-2.2.8, libtacplus-0.2a, openldap-2.4.41
#=======================================================================
#talloc-1.3.0 (RADIUS dependency)
./configure --prefix=$PREFIX --host=${HOST} CC=${CROSS_COMPILE}gcc
make install

#freeradius-server-2.2.8 (depend on: openssl)
"
- open configure file
- search 'cannot run test program while cross compiling'
  and remove all test compile to disable check compiler;
  replace by another command, ex: echo cross_compiling=yes
"
DEPEND_LIB_DIR=/home/ninhld/Zynq706/Project/FIREWALL/user
export CFLAGS=-I${DEPEND_LIB_DIR}/include
export CPPFLAGS=-I${DEPEND_LIB_DIR}/include
export LDFLAGS=-L${DEPEND_LIB_DIR}/lib
export PKG_CONFIG_PATH=${DEPEND_LIB_DIR}/lib/pkgconfig
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${DEPEND_LIB_DIR}/lib

./configure --prefix=$PREFIX --host=${HOST} \
CC=arm-xilinx-linux-gnueabi-gcc \
AR=arm-xilinx-linux-gnueabi-ar \
RANLIB=arm-xilinx-linux-gnueabi-ranlib \
LD=arm-xilinx-linux-gnueabi-ld

make install



#tcp_wrappers_7.6 (dependency for tacacs+-F5.0.0a1)
patch -Np1 -i ../tcp_wrappers-7.6-shared_lib_plus_plus-1.patch
sed -i -e "s,^extern char \*malloc();,/* & */," scaffold.c
make CC=${CROSS_COMPILE}gcc REAL_DAEMON_DIR=/usr/sbin STYLE=-DPROCESS_OPTIONS linux


#libtacplus-0.2a
make CC=${CROSS_COMPILE}gcc AR=${CROSS_COMPILE}ar \
RANLIB=${CROSS_COMPILE}ranlib LD=${CROSS_COMPILE}ld

#openldap-2.4.41 (make ok, make install FAIL)
./configure --prefix=$PREFIX --host=${HOST} \
CC=arm-xilinx-linux-gnueabi-gcc \
AR=arm-xilinx-linux-gnueabi-ar \
RANLIB=arm-xilinx-linux-gnueabi-ranlib \
LD=arm-xilinx-linux-gnueabi-ld \
--with-yielding_select=yes \
--enable-bdb=no \
--enable-hdb=no

"After ./configure is called and before calling make, 
commenting out the line in include/portable.h
#define NEED_MEMCMP_REPLACEMENT 1"

make
make install 
"
FAIL !
Make follow host installed format
"


#=======================================================================
# export environment
#=======================================================================
source /opt/Xilinx/14.3/ISE_DS/settings64.sh
export PREFIX=/home/ninhld/Zynq706/Project/FIREWALL/user
export HOST=arm-xilinx-linux-gnueabi
export CROSS_COMPILE=arm-xilinx-linux-gnueabi-






