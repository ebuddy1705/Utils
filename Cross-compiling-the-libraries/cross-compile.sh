#=======================================================================
# Enable localhost
#=======================================================================

cat > /etc/nsswitch.conf << EONSSWITCH
hosts:          files
networks:       files
protocols:      files
services:       files
EONSSWITCH

cat > /etc/host.conf << EOHOSTCONF
order hosts
multi on
EOHOSTCONF


echo "127.0.0.1 localhost" > /etc/hosts
echo "localhost" > /etc/hostname
hostname localhost


ifconfig lo 127.0.0.1 netmask 255.0.0.0 up


ping localhost


#=======================================================================
# Building BusyBox
#=======================================================================
make ARCH=arm CROSS_COMPILE=arm-xilinx-linux-gnueabi- defconfig

"or set the install location to /home/devel/rootfs
(BusyBox Settings->Installation Options->BusyBox installation prefix)
OR
you can set via CONFIG_PREFIX, for example:
	make CONFIG_PREFIX=/home/devel/rootfs install
"
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
CC=${CROSS}gcc \
AR=${CROSS}ar \
RANLIB=${CROSS}ranlib \
LD=${CROSS}ld

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
CC=${CROSS}gcc \
AR=${CROSS}ar

"- open Makefile
 - remove STRIP_OPT and check-config"
 
make

export PREFIX=/home/ninhld/Zynq706/Project/FIREWALL/user
make DESTDIR=$PREFIX install



#=======================================================================
# dropbear (ssh) daemon [dependency (search in this file): zlib]
#=======================================================================
./configure --prefix=$PREFIX --host=${HOST} \
CC=${CROSS}gcc LDFLAGS="-Wl,--gc-sections" \
CFLAGS="-ffunction-sections -fdata-sections -Os"

make PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp" MULTI=1 strip
make install

echo "++ Starting dropbear (ssh) daemon"
ln -s $PREFIX/sbin/dropbear $PREFIX/usr/bin/scp
dropbear



#=======================================================================
# Network Time Protocol - ntp-4.2.6p5
#=======================================================================
./configure --prefix=$PREFIX --host=${HOST} CC=${CROSS}gcc

make install

#create /etc/services file with content below
ntp             123/tcp
ntp             123/udp

#run
ntpdate pool.ntp.org



#=======================================================================
# DNS - dnsmasq-2.64  lightweight DNS (Domain Name Server) forwarder
# and DHCP (Dynamic Host Configuration Protocol) server.
#=======================================================================
#dnsmasq-2.64
"modify PREFIX in Makefile"
make CC=${CROSS}gcc \
PREFIX=${PREFIX} \
install

#ddclient-3.8.3
"don't need"


#noip-duc-linux
make CC=${CROSS}gcc PREFIX=/path/to/install

USAGE: noip2 [ -C [ -F][ -Y][ -U #min]
	[ -u username][ -p password][ -x progname]]
	[ -c file][ -d][ -D pid][ -i addr][ -S][ -M][ -h]

Version Linux-2.1.9
Options: -C               create configuration data
         -F               force NAT off
         -Y               select all hosts/groups
         -U minutes       set update interval
         -u username      use supplied username
         -p password      use supplied password
         -x executable    use supplied executable
         -c config_file   use alternate data path
         -d               increase debug verbosity
         -D processID     toggle debug flag for PID
         -i IPaddress     use supplied address
         -I interface     use supplied interface
         -S               show configuration data
         -M               permit multiple instances
         -K processID     terminate instance PID
         -z               activate shm dump code
         -h               help (this text)

Requirement:
	- username: your email
	- password: your password
	- domain  : domain which you want up to date new ip address 


Ex:
"create configuration file"
./noip2 -C -U 1 -u luongduyninh@gmail.com -p 123456
Auto configuration for Linux client of no-ip.com.
2 hosts are registered to this account.
Do you wish to have them all updated?[N] (y/N)  N
Do you wish to have host [duyninh.ddns.net] updated?[N] (y/N)  N
Do you wish to have host [ninhldcompany.ddns.net] updated?[N] (y/N)  y

New configuration file '/path/to/install/etc/no-ip2.conf' created.

"run noip2"
./noip2




#=======================================================================
# iptables-1.4.21
#=======================================================================
KERNEL_DIR=/home/ninhld/Zynq706/SDK/linux-xlnx/module_install/lib/modules/3.9.0-xilinx-dirty

./configure --prefix=$PREFIX --host=${HOST} \
CC=${CROSS}gcc \
--enable-libipq --enable-devel \
--enable-static --enable-shared \
--with-kernel=$KERNEL_DIR/kernel \
--with-kbuild=$KERNEL_DIR/build \
--with-ksource=$KERNEL_DIR/source


make install


#=======================================================================
# arptables-v0.0.3-4, ebtables-v2.0.10-4
#=======================================================================
#arptables-v0.0.3-4
"run as root"
INSTALL_DIR=`pwd`/install
make \
CC=${CROSS}gcc \
AR=${CROSS}ar \
KERNEL_DIR=/home/ninhld/Zynq706/SDK/linux-xlnx/module_install/lib/modules/3.9.0-xilinx-dirty \
PREFIX=${INSTALL_DIR} \
INITDIR=${INSTALL_DIR}/etc/rc.d/init.d \
SYSCONFIGDIR=${INSTALL_DIR}/etc/sysconfig \
install



#ebtables-v2.0.10-4
"run as root"
"remove ret variable in function store_counters_in_file (communication.c)"
make CC=${CROSS}gcc \
KERNEL_INCLUDES=/home/ninhld/Zynq706/SDK/linux-xlnx/include \
LIBDIR=${PREFIX}/usr/lib \
MANDIR=${PREFIX}/usr/local/man \
BINDIR=${PREFIX}/usr/local/sbin \
ETCDIR=${PREFIX}/etc \
INITDIR=${PREFIX}/etc/rc.d/init.d \
SYSCONFIGDIR=${PREFIX}/etc/sysconfig \
install



#=======================================================================
# Dynamic Routing - quagga-0.99.22.4
#=======================================================================
./configure --prefix=$PREFIX --host=${HOST} CC=${CROSS}gcc

make ARCH=arm install



#=======================================================================
# SSL VPN - openvpn-2.3.8
#=======================================================================
# openssl-1.0.0s (dependency)
"static library"
./Configure dist --prefix=${PREFIX}
make CC="${CROSS}gcc" AR="${CROSS}ar r" RANLIB="${CROSS}ranlib" install

"shared library"
./Configure --prefix=${PREFIX} shared "${HOST}":"${CROSS}gcc:-DTERMIO -O3 -Wall -I../../host/include::-D_REENTRANT::-L../../host/lib -ldl:BN_LLONG RC4_CHAR RC4_CHUNK DES_INT DES_UNROLL BF_PTR::bn_asm.o armv4-mont.o::aes_cbc.o aes-armv4.o:::sha1-armv4-large.o sha256-armv4.o sha512-armv4.o:::::::void:dlfcn:linux-shared:-fPIC::.so.1.0.0":${CROSS}ranlib::


"if you configure for host with shared library"
./config --prefix=${PREFIX}/usr         \
--openssldir=${PREFIX}/etc/ssl \
--libdir=lib          \
shared                \
zlib-dynamic






# Linux-PAM-1.2.1
./configure --prefix=$PREFIX --host=${HOST} CC=${CROSS}gcc

# lzo-2.09
./configure --prefix=$PREFIX --host=${HOST} CC=${CROSS}gcc
make ARCH=arm install

# openvpn-2.3.8
DEPEND_LIB_DIR=/home/ninhld/Zynq706/Project/FIREWALL/user
export CFLAGS=-I${DEPEND_LIB_DIR}/include
export CPPFLAGS=-I${DEPEND_LIB_DIR}/include
export LDFLAGS=-L${DEPEND_LIB_DIR}/lib
export PKG_CONFIG_PATH=${DEPEND_LIB_DIR}/lib/pkgconfig
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${DEPEND_LIB_DIR}/lib


./configure --prefix=$PREFIX --host=${HOST} CC=${CROSS}gcc


"remove all security path header in 
src/auth-pam/auth-pam.c
and
include/pam_appl.h
include/_pam_types.h
"
make install


#=======================================================================
# IPSec VPN - strongswan-5.1.0
#=======================================================================
#gmp-6.0.0 (dependency)
./configure --prefix=$PREFIX --host=${HOST} CC=${CROSS}gcc
make ARCH=arm install

#strongswan-5.1.0
DEPEND_LIB_DIR=/home/ninhld/Zynq706/Project/FIREWALL/user
export CFLAGS=-I${DEPEND_LIB_DIR}/include
export CPPFLAGS=-I${DEPEND_LIB_DIR}/include
export LDFLAGS=-L${DEPEND_LIB_DIR}/lib
export PKG_CONFIG_PATH=${DEPEND_LIB_DIR}/lib/pkgconfig
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${DEPEND_LIB_DIR}/lib


./configure --prefix=$PREFIX \
--host=${HOST} CC=${CROSS}gcc \
CFLAGS="-DDEBUG_LEVEL=4" \
--disable-scripts \
--enable-dhcp --enable-farp \
--with-systemdsystemunitdir=${PREFIX}/service

make install


#=======================================================================
# libmnl
#=======================================================================
./configure --prefix=$PREFIX --host=${HOST} \
CC=${CROSS}gcc

#=======================================================================
# iproute2-4.1.1 (dependency iptables-1.4.21, libmnl<may be don't need>)
#=======================================================================
#modify configure file
"search and remove 4 command below:"
echo -n "libc has setns: "
check_setns
"and"
echo -n "SELinux support: "
check_selinux


#configure to create Makefile
DEPEND_LIB_DIR=/home/ninhld/Zynq706/Project/FIREWALL/user
export CFLAGS=-I${DEPEND_LIB_DIR}/include
export CPPFLAGS=-I${DEPEND_LIB_DIR}/include
export LDFLAGS=-L${DEPEND_LIB_DIR}/lib
export PKG_CONFIG_PATH=${DEPEND_LIB_DIR}/lib/pkgconfig
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${DEPEND_LIB_DIR}/lib

./configure


#modify Makefile
for dir in ip misc tc; do
    cp ${dir}/Makefile{,.orig}
    sed 's/0755 -s/0755/' ${dir}/Makefile.orig > ${dir}/Makefile
done

cp misc/Makefile{,.orig}
sed '/^TARGETS./s@arpd@@g' misc/Makefile.orig > misc/Makefile

#make install
INSTALL_DIR=`pwd`/install
make  \
CC=${CROSS}gcc \
AR=${CROSS}ar \
RANLIB=${CROSS}ranlib \
LD=${CROSS}ld \
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
./configure --prefix=$PREFIX --host=${HOST} CC=${CROSS}gcc

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
--with-cc=${CROSS}gcc \
--with-ar=${CROSS}ar \
--with-ld=${CROSS}ld \
--with-endianness=little --with-defaults --without-perl-modules \
--build=x86_64-linux --host=${HOST} --target=${HOST} \
--without-openssl --with-logfile="/var/log/snmpd.log" \
--with-default-snmp-version=2 --disable-mib-loading \
--with-mib-modules="mibII ip-mib if-mib tcp-mib udp-mib ucd_snmp target agent_mibs notification-log-mib snmpv3mibs notification"

make install



#=======================================================================
# IDS Snort
#=======================================================================
#libpcap-1.7.4
./configure --prefix=$PREFIX --host=${HOST} CC=${CROSS}gcc \
--with-pcap=linux

#tcpdump-4.7.4
./configure --prefix=$PREFIX --host=${HOST} CC=${CROSS}gcc
make install

#libdnet-1.11
KERNEL_DIR=/home/ninhld/Zynq706/SDK/linux-xlnx
./configure --kernel-dir=${KERNEL_DIR} \
--cc=${CROSS}gcc
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
CC=${CROSS}gcc \
--with-libpcap-includes=${DEPEND_LIB_DIR}/include \
--with-libpcap-libraries=${DEPEND_LIB_DIR}/lib \
--with-dnet-includes=${DEPEND_LIB_DIR}/include \
--with-dnet-libraries=${DEPEND_LIB_DIR}/lib \
--disable-netmap-module \
--enable-static

#pcre-8.36
./configure --prefix=$PREFIX --host=${HOST} \
CC=${CROSS}gcc

make install

#zlib-1.2.8
export CC=${CROSS}gcc
export CXX=${CROSS}g++
export AR=${CROSS}ar
export RANLIB=${CROSS}ranlib
export STRIP=${CROSS}strip
export LD=${CROSS}ld 

./configure --prefix=$PREFIX

make
make install


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
CC=${CROSS}gcc \
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
CC=${CROSS}gcc \
AR=${CROSS}ar \
RANLIB=${CROSS}ranlib \
LD=${CROSS}ld


make -C lib 
make -C src cf_gen 

cp -rf src/cf_gen-host src/cf_gen
touch src/cf_gen
 
make CC=${CROSS}gcc \
AR=${CROSS}ar \
RANLIB=${CROSS}ranlib \
LD=${CROSS}ld \
--enable-delay-pools --enable-cache-digests \
--enable-poll --enable-truncate \
--enable-removal-policies



#=======================================================================
# AAA server: freeradius-server-2.2.8, libtacplus-0.2a, openldap-2.4.41
#=======================================================================
#talloc-1.3.0 (RADIUS dependency)
./configure --prefix=$PREFIX --host=${HOST} CC=${CROSS}gcc
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
CC=${CROSS}gcc \
AR=${CROSS}ar \
RANLIB=${CROSS}ranlib \
LD=${CROSS}ld

make install



#tcp_wrappers_7.6 (dependency for tacacs+-F5.0.0a1)
patch -Np1 -i ../tcp_wrappers-7.6-shared_lib_plus_plus-1.patch
sed -i -e "s,^extern char \*malloc();,/* & */," scaffold.c
make CC=${CROSS}gcc REAL_DAEMON_DIR=/usr/sbin STYLE=-DPROCESS_OPTIONS linux


#libtacplus-0.2a
make CC=${CROSS}gcc \
AR=${CROSS}ar \
RANLIB=${CROSS}ranlib \
LD=${CROSS}ld

#openldap-2.4.41 (make ok, make install FAIL)
./configure --prefix=$PREFIX --host=${HOST} \
CC=${CROSS}gcc \
AR=${CROSS}ar \
RANLIB=${CROSS}ranlib \
LD=${CROSS}ld \
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
# web administrator: 
#	server: 					lighttpd-1.4.36
#	web application framework:	cppcms-1.0.5
#	dependency lib:	lighttpd, libiconv, pcre, fcgi, openssl
#=======================================================================
#========== lighttpd-1.4.36 (dependency: zlib, pcre, ...)=================
DEPEND_LIB_DIR=/home/ninhld/Zynq706/Project/FIREWALL/user
export CFLAGS=-I${DEPEND_LIB_DIR}/include
export CPPFLAGS=-I${DEPEND_LIB_DIR}/include
export LDFLAGS=-L${DEPEND_LIB_DIR}/lib
export PKG_CONFIG_PATH=${DEPEND_LIB_DIR}/lib/pkgconfig
export LD_LIBRARY_PATH=${DEPEND_LIB_DIR}/lib
export PATH=$PATH:${DEPEND_LIB_DIR}/bin:${DEPEND_LIB_DIR}/sbin

./configure --prefix=$PREFIX --host=${HOST} \
CC=${CROSS}gcc \
AR=${CROSS}ar \
RANLIB=${CROSS}ranlib \
LD=${CROSS}ld \
--with-bzip2=no

make
make install


"CREATE CONFIGURATION FILE: lighttpd.conf"
server.document-root = "/opt/nfs/www" 
index-file.names = ( "index.html" )
server.port = 8080
mimetype.assign = (
  ".html" => "text/html", 
  ".txt" => "text/plain",
  ".jpg" => "image/jpeg",
  ".png" => "image/png" 
)

"CREATE index.html AND STORE IN /opt/nfs/www"
<html>
	<body>
		<h1>Hello World</h1>
	</body>
</html>


"First, check that your configuration is ok:"
	lighttpd -t -f /opt/nfs/etc/lighttpd.conf -m /opt/nfs/lib

"Now start the server for testing:"
	lighttpd -D -f /opt/nfs/etc/lighttpd.conf -m /opt/nfs/lib



#============= libiconv-1.14 ====================
./configure --prefix=$PREFIX --host=${HOST} \
CC=${CROSS}gcc

make
make install






#============= cppcms-1.0.5 (cross compile NOT OK) ====================
"Create ToolChain.cmake file"
SET(CMAKE_SYSTEM_NAME arm-linux)  
SET(CMAKE_C_COMPILER  /opt/Xilinx/14.3/ISE_DS/EDK/gnu/arm/lin64/bin/arm-xilinx-linux-gnueabi-gcc)  
SET(CMAKE_CXX_COMPILER /opt/Xilinx/14.3/ISE_DS/EDK/gnu/arm/lin64/bin/arm-xilinx-linux-gnueabi-g++)  
SET(CMAKE_FIND_ROOT_PATH  /home/ninhld/Zynq706/Project/FIREWALL/user)  
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)  
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)  
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)


"run cmake"
DEPEND_LIB_DIR=/home/ninhld/Zynq706/Project/FIREWALL/user
export CFLAGS=-I${DEPEND_LIB_DIR}/include
export CPPFLAGS=-I${DEPEND_LIB_DIR}/include
export LDFLAGS="-L${DEPEND_LIB_DIR}/lib -Wl,--no-as-needed -ldl -pthread"
export PKG_CONFIG_PATH=${DEPEND_LIB_DIR}/lib/pkgconfig
export LD_LIBRARY_PATH=${DEPEND_LIB_DIR}/lib
export PATH=$PATH:${DEPEND_LIB_DIR}/bin:${DEPEND_LIB_DIR}/sbin


mkdir release
cd release

cmake -DCMAKE_BUILD_TYPE=Release \
-DCMAKE_TOOLCHAIN_FILE=ToolChain.cmake \
-DDISABLE_ICU_LOCALE=ON \
-DCMAKE_INSTALL_PREFIX=$PREFIX ..

CMake Error: The following variables are used in this project, but they are set to NOTFOUND.
Please set them or make sure they are set and tested correctly in the CMake files:
PTHREAD_INC
   used as include directory in directory /home/ninhld/Zynq706/Project/FIREWALL/web-admin/cppcms-1.0.5/booster






"======================== TEST ON HOST ================================="
mkdir release
cd release  
cmake -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=`pwd`/install ..
make install
 

"modify cppcms_run in installed directory"
in lighttpd() function, modify WEB_SERVER="$WEB_SERVER -f $CONFIG_FILE"
to WEB_SERVER="$WEB_SERVER -f $CONFIG_FILE -m $LIGHTTPDM"

"modify source below: add LIGHTTPDM variable"
ROOT=`pwd`
LIGHTTPDM="/lib"

while ! [ -e "$1" ] ; do
	if [ "$1" == "-s" ] ;  then
		SCRIPT="$2"
		shift
	elif [ "$1" == "-S" ] ; then
		TRY_SETUP="$2"
		shift
	elif [ "$1" == "-h" ]; then
		HOST="$2"
		shift
	elif [ "$1" == "-p" ]; then
		PORT="$2";
		shift
	elif [ "$1" == "-e" ]; then
		NO_APP=yes
	elif [ "$1" == "-r" ]; then
		ROOT="$2"
		shift
	elif [ "$1" == "-m" ]; then
		LIGHTTPDM="$2"
		echo $LIGHTTPDM
		shift
	else
		help
	fi
	shift
done


"run"
DEPEND_LIB_DIR=/home/ninhld/Zynq706/Project/FIREWALL/web-admin/cppcms-1.0.5/release-host/install
export CFLAGS=-I${DEPEND_LIB_DIR}/include
export CPPFLAGS=-I${DEPEND_LIB_DIR}/include
export LDFLAGS=-L${DEPEND_LIB_DIR}/lib
export PKG_CONFIG_PATH=${DEPEND_LIB_DIR}/lib/pkgconfig
export LD_LIBRARY_PATH=${DEPEND_LIB_DIR}/lib
export PATH=$PATH:${DEPEND_LIB_DIR}/bin:${DEPEND_LIB_DIR}/sbin

cd /home/ninhld/Zynq706/Project/FIREWALL/web-admin/cppcms-1.0.5/examples/hello_world
cppcms_run -h 0.0.0.0 -p 3000 -m /home/ninhld/Zynq706/Project/FIREWALL/web-admin/cppcms-1.0.5/release-host/install/lib hello -c config.js




#=======================================================================
# Web Application Framework: Wt
# Dependency: boost, libfcgi, openssl, zlib
#=======================================================================
#GraphicsMagick-1.3.21
# Dependency: zlib, freetype2, libpng, libxml
DEPEND_LIB_DIR=/home/ninhld/Zynq706/Project/FIREWALL/user
export CFLAGS=-I${DEPEND_LIB_DIR}/include
export CPPFLAGS=${CFLAGS}
export LDFLAGS=-L${DEPEND_LIB_DIR}/lib
export PKG_CONFIG_PATH=${DEPEND_LIB_DIR}/lib/pkgconfig
export LD_LIBRARY_PATH=${DEPEND_LIB_DIR}/lib
export PATH=$PATH:${DEPEND_LIB_DIR}/bin:${DEPEND_LIB_DIR}/sbin


./configure --prefix=$PREFIX --host=${HOST} \
CC=${CROSS}gcc

#postgresql-9.4.4
./configure --prefix=$PREFIX --host=${HOST} \
CC=${CROSS}gcc \
--without-readline




#pango-1.37.0
# Dependency: freetype2, libpng, glib



#fcgi-2.4.1
./configure --prefix=$PREFIX --host=${HOST} \
CC=${CROSS}gcc


#boost_1_58_0
"Bootstrap the code:"
./bootstrap.sh

"
Modify the configuration file (project-config.jam) to use the ARM toolchain 
by replacing the line with “using gcc” by:
using gcc : arm : arm-xilinx-linux-gnueabi-g++ ;
"

"Install the python development package:
sudo yum install python-devel"


"Build and install the boost libraries:"
DEPEND_LIB_DIR=/home/ninhld/Zynq706/Project/FIREWALL/user
ZLIB_SOURCE_DIR=/home/ninhld/Zynq706/Project/FIREWALL/IDS-IPS/zlib-1.2.8
BZIP2_SOURCE_DIR=/home/ninhld/Zynq706/Project/FIREWALL/web-admin/bzip2-1.0.6

./bjam toolset=gcc-arm --prefix=$PREFIX \
-sZLIB_SOURCE=${ZLIB_SOURCE_DIR} \
-sBZIP2_SOURCE=${BZIP2_SOURCE_DIR} \
--without-python \
install

#============= Wt ==============================
mkdir release
cd release


"create ToolChain.cmake in release directory"
SET(CMAKE_SYSTEM_NAME Linux)  
SET(CMAKE_C_COMPILER  /opt/Xilinx/14.3/ISE_DS/EDK/gnu/arm/lin64/bin/arm-xilinx-linux-gnueabi-gcc)  
SET(CMAKE_CXX_COMPILER /opt/Xilinx/14.3/ISE_DS/EDK/gnu/arm/lin64/bin/arm-xilinx-linux-gnueabi-g++)  
SET(CMAKE_FIND_ROOT_PATH  /home/ninhld/Zynq706/Project/FIREWALL/user)  
SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)  
SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)  
SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
SET(BOOST_DIR /home/ninhld/Zynq706/Project/FIREWALL/user)
SET(BOOST_INCLUDEDIR /home/ninhld/Zynq706/Project/FIREWALL/user/include)
SET(BOOST_LIBRARYDIR /home/ninhld/Zynq706/Project/FIREWALL/user/lib)

"create Makefile by cmake"
DEPEND_LIB_DIR=/home/ninhld/Zynq706/Project/FIREWALL/user
export CFLAGS=-I${DEPEND_LIB_DIR}/include
export CPPFLAGS=-I${DEPEND_LIB_DIR}/include
export LDFLAGS="-L${DEPEND_LIB_DIR}/lib -pthread -lm"
export PKG_CONFIG_PATH=${DEPEND_LIB_DIR}/lib/pkgconfig
export LD_LIBRARY_PATH=${DEPEND_LIB_DIR}/lib
export PATH=$PATH:${DEPEND_LIB_DIR}/bin:${DEPEND_LIB_DIR}/sbin


cmake -DCMAKE_TOOLCHAIN_FILE=ToolChain.cmake \
-DCMAKE_BUILD_TYPE=RELEASE \
-DCMAKE_INSTALL_PREFIX=$PREFIX ..


make 
make install


#============= build app ==============================
DEPEND_LIB_DIR=/home/ninhld/Zynq706/Project/FIREWALL/user
export CFLAGS=-I${DEPEND_LIB_DIR}/include
export CPPFLAGS=-I${DEPEND_LIB_DIR}/include
export LDFLAGS="-L${DEPEND_LIB_DIR}/lib -pthread -lm -lwt -lwthttp -lwtfcgi"
export PKG_CONFIG_PATH=${DEPEND_LIB_DIR}/lib/pkgconfig
export LD_LIBRARY_PATH=${DEPEND_LIB_DIR}/lib
export PATH=$PATH:${DEPEND_LIB_DIR}/bin:${DEPEND_LIB_DIR}/sbin
LIBS="-Wl,-rpath-link -Wl,$DEPEND_LIB_DIR/lib"

"build"
arm-xilinx-linux-gnueabi-g++ hello.C -o hello ${CFLAGS} ${LDFLAGS} ${LIBS}

"run"
./hello --docroot . --http-address 0.0.0.0 --http-port 80  #ok



#=======================================================================
# python-2.7.10
#=======================================================================
"configure for host, do not source environment"
./configure
make python Parser/pgen

mv python hostpython
mv Parser/pgen Parser/hostpgen

make distclean
patch -p1 < ../Python-2.7.3-xcompile.patch

"configure for target, source environment"
./configure \
--host=${HOST} --build=x86_64-linux-gnu \
CC=${CROSS}gcc \
CXX=${CROSS}g++ \
AR=${CROSS}ar \
RANLIB=${CROSS}ranlib \
LD=${CROSS}ld \
NM=arm-xilinx-linux-gnueabi-nm \
--enable-shared \
--disable-ipv6 \
--prefix=$PREFIX


make HOSTPYTHON=./hostpython \
HOSTPGEN=./Parser/hostpgen \
BLDSHARED="${CROSS}gcc -shared" \
CROSS_COMPILE=${CROSS} \
CROSS_COMPILE_TARGET=yes \
HOSTARCH=${HOST} \
BUILDARCH=x86_64-linux-gnu

make install \
HOSTPYTHON=./hostpython \
BLDSHARED="${CROSS}gcc -shared" \
CROSS_COMPILE=${CROSS} \
CROSS_COMPILE_TARGET=yes \
prefix=$PREFIX
 
 


#=======================================================================
# CORBA: omniORB-4.2.0
# Dependency: openssl
#=======================================================================
DEPEND_LIB_DIR=/home/ninhld/Zynq706/Project/FIREWALL/user
export CFLAGS=-I${DEPEND_LIB_DIR}/include
export CPPFLAGS=-I${DEPEND_LIB_DIR}/include
export LDFLAGS=-L${DEPEND_LIB_DIR}/lib
export PKG_CONFIG_PATH=${DEPEND_LIB_DIR}/lib/pkgconfig
export LD_LIBRARY_PATH=${DEPEND_LIB_DIR}/lib
export PATH=$PATH:${DEPEND_LIB_DIR}/bin:${DEPEND_LIB_DIR}/sbin

./configure --prefix=$PREFIX --host=${HOST} --build=x86_64-linux-gnu \
CC=${CROSS}gcc \
CXX=${CROSS}g++

"build cccp, cxx, omkdepend for host"
make CC=gcc -C src/tool/omniidl/cxx/cccp
make CXX=g++ -C src/tool/omniidl/cxx
make CC=gcc -C src/tool/omkdepend


"There are some small changes required in the omniORB build system: 
Edit dir.mk file in following directories:"
src/appl/omniMapper/dir.mk
src/appl/omniNames/dir.mk
src/appl/utils/catior/dir.mk
src/appl/utils/convertior/dir.mk
src/appl/utils/genior/dir.mk
src/appl/utils/nameclt/dir.mk

@(libs="$(CORBA_LIB_NODYN)"; $(CXXExecutable)) -> @(libs="$(CORBA_LIB_NODYN) -lstdc++"; $(CXXExecutable)) 


"cross"
make

"re-build omnicpp and omniidl for ARM [optional unless you want to use omniidl on the target]"
rm -f lib/_omniidlmodule.so* lib/omnicpp
make -C src/tool/omniidl/cxx clean
make -C src/tool/omniidl/cxx
make
"FAIL !!!"



#======= build and run example application (host server OK, target server NOT OK) ================
cd src/examples/echo
make


cp -rf /opt/nfs/etc/omniORB.cfg /etc/
export OMNIORB_CONFIG=/etc/omniORB.cfg

"on server"
./eg2_impl
-> IOR:0123456

"on target"
./eg2_clt IOR:0123456


#=======================================================================
# libxml2-2.9.1
#=======================================================================
PYTHON_SOURCE_DIR=/home/ninhld/Zynq706/Project/FIREWALL/soft-admin/Python-2.7.3/Python-2.7.3

./configure --prefix=$PREFIX --host=${HOST} \
CC=${CROSS}gcc \
--with-python=${PYTHON_SOURCE_DIR}



#=======================================================================
# bzip2-1.0.6
#=======================================================================
Modify Makefile :
                     
		  # To assist in cross-compiling
		   CC=arm-linux-gnueabihf-gcc
		   AR=arm-linux-gnueabihf-ar
		   RANLIB=arm-linux-gnueabihf-ranlib
		   LDFLAGS=
		   ####I add so file,because boost lib need so lib,not static library.
		   BZLIB=libbz2.so.1.0.6
						
		   #CLAGS=-Wall -Winline -O2 -g $(BIGFILES)
		   CLAGS=-Wall -Winline -O2 -g $(BIGFILES) -fPIC
		   SFLAGS=-shared 
		   PREFIX=$(PWD)/_install
		   
		   #all: libbz2.a bzip2 bzip2recover test
		   all: libbz2.a  $(BZLIB)

		   $(BZLIB): $(OBJS)
			   $(CC) $(SFLAGS) $(LDFLAGS) -o $@ $^

		   ####bzip2 and bzip2recover can not be execute on the ubuntu host,they are binary based arm architecture. 
		   #install: bzip2 bzip2recover
           install: $(BZLIB)


  
			#cp -f bzip2 $(PREFIX)/bin/bzip2
			#cp -f bzip2 $(PREFIX)/bin/bunzip2
			#cp -f bzip2 $(PREFIX)/bin/bzcat
			#cp -f bzip2recover $(PREFIX)/bin/bzip2recover
			#chmod a+x $(PREFIX)/bin/bzip2
			#chmod a+x $(PREFIX)/bin/bunzip2
			#chmod a+x $(PREFIX)/bin/bzcat
			#chmod a+x $(PREFIX)/bin/bzip2recover
			cp -f libbz2.a $(PREFIX)/lib
			chmod a+r $(PREFIX)/lib/libbz2.a
			cp -f $(BZLIB) $(PREFIX)/lib
			chmod a+r $(PREFIX)/lib/$(BZLIB)
make
make PREFIX=$PREFIX install




#=======================================================================
# xmlrpc-c-1.33.17
#=======================================================================
#build client on Host
install libcurl-devel
install libxml2-devel
install openssl-devel
install libxml2-devel   
  
./configure --prefix=`pwd`/install
make

#cross compiling on target 
./configure
make CC=gcc CXX=g++ -C lib/expat/gennmtab



./configure --prefix=$PREFIX --host=${HOST} \
CC=${CROSS}gcc \
CXX=${CROSS}g++

make



#build client/server app
DEPEND_LIB_DIR=/home/ninhld/Zynq706/Project/FIREWALL/soft-admin/xmlrpc-c-1.33.17/install
export CFLAGS=-I${DEPEND_LIB_DIR}/include
export CPPFLAGS=-I${DEPEND_LIB_DIR}/include
export LDFLAGS=-L${DEPEND_LIB_DIR}/lib
export PKG_CONFIG_PATH=${DEPEND_LIB_DIR}/lib/pkgconfig
export LD_LIBRARY_PATH=${DEPEND_LIB_DIR}/lib
export PATH=$PATH:${DEPEND_LIB_DIR}/bin:${DEPEND_LIB_DIR}/sbin
LIBS="-Wl,-rpath-link -Wl,$DEPEND_LIB_DIR/lib -lxmlrpc -lxmlrpc_client"
gcc xmlrpc_sample_add_client.c ${CFLAGS} ${LDFLAGS} ${LIBS}


#=======================================================================
# libsoap-1.1.0
# Dependency: libxml2, openssl
#=======================================================================

./configure --prefix=$PREFIX --host=${HOST} \
CC=${CROSS}gcc

"Modify config.h which have just is generated
comment #define malloc rpl_malloc
"

make
make install




#=======================================================================
# gsoap-2.8
# Dependency: openssl
#=======================================================================
DEPEND_LIB_DIR=/home/ninhld/Zynq706/Project/FIREWALL/user
export CFLAGS=-I${DEPEND_LIB_DIR}/include
export CPPFLAGS=-I${DEPEND_LIB_DIR}/include
export LDFLAGS=-L${DEPEND_LIB_DIR}/lib
export PKG_CONFIG_PATH=${DEPEND_LIB_DIR}/lib/pkgconfig
export LD_LIBRARY_PATH=${DEPEND_LIB_DIR}/lib
export PATH=$PATH:${DEPEND_LIB_DIR}/bin:${DEPEND_LIB_DIR}/sbin

"buid soapcpp2 for host"
./configure
make CC=gcc CXX=g++ -C gsoap/src



./configure --prefix=$PREFIX --host=${HOST} \
CC=${CROSS}gcc \
CXX=${CROSS}g++ \
--with-openssl=${DEPEND_LIB_DIR}

"Modify config.h which have just is generated
comment #define malloc rpl_malloc
Note: fixbug ::malloc has not been declared
"

make 
make install


#build example

DEPEND_LIB_DIR=/home/ninhld/Zynq706/Project/FIREWALL/soft-admin/gsoap-2.8-host/install
export CFLAGS="-I${DEPEND_LIB_DIR}/include -DWITH_OPENSSL"
export CPPFLAGS=-I${DEPEND_LIB_DIR}/include
export LDFLAGS=-L${DEPEND_LIB_DIR}/lib
export PKG_CONFIG_PATH=${DEPEND_LIB_DIR}/lib/pkgconfig
export LD_LIBRARY_PATH=${DEPEND_LIB_DIR}/lib
export PATH=$PATH:${DEPEND_LIB_DIR}/bin:${DEPEND_LIB_DIR}/sbin
export LIBS="-lm -lssl -lcrypto -lpthread"
STDSOAP2_PATH=/home/ninhld/Zynq706/Project/FIREWALL/soft-admin/gsoap-2.8-host/gsoap

soapcpp2 -c calc.h
gcc -o calcclient calcclient.c ${STDSOAP2_PATH}/stdsoap2.c soapC.c soapClient.c ${CFLAGS} ${LDFLAGS} ${LIBS}
gcc -o calcserver calcserver.c ${STDSOAP2_PATH}/stdsoap2.c soapC.c soapServer.c ${CFLAGS} ${LDFLAGS} ${LIBS}



soapcpp2 -c ssl.h
gcc -DWITH_OPENSSL -o sslclient sslclient.c ${STDSOAP2_PATH}/stdsoap2.c soapC.c soapClient.c ${CFLAGS} ${LDFLAGS} ${LIBS}
gcc -DWITH_OPENSSL -o sslserver sslserver.c ${STDSOAP2_PATH}/stdsoap2.c soapC.c soapServer.c ${CFLAGS} ${LDFLAGS} ${LIBS}

Compilation in C (see samples/calc):
    soapcpp2 -c calc.h
    cc -o calcclient calcclient.c stdsoap2.c soapC.c soapClient.c
    cc -o calcserver calcserver.c stdsoap2.c soapC.c soapServer.c

Compilation in C++ (see samples/calc++):
    soapcpp2 -i calc.h
    cc -o calcclient++ calcclient.cpp stdsoap2.cpp soapC.cpp soapcalcProxy.cpp
    cc -o calcserver++ calcserver.cpp stdsoap2.cpp soapC.cpp soapcalcService.cpp


#=======================================================================
# Virus engine with Squid : squidclamav-6.13
# Dependency: 
#=======================================================================

#clamav-0.98.7
DEPEND_LIB_DIR=/home/ninhld/Zynq706/Project/FIREWALL/user
export CFLAGS="-I${DEPEND_LIB_DIR}/include -I${DEPEND_LIB_DIR}/include/libxml2"
export CPPFLAGS=-I${DEPEND_LIB_DIR}/include
export LDFLAGS=-L${DEPEND_LIB_DIR}/lib
export PKG_CONFIG_PATH=${DEPEND_LIB_DIR}/lib/pkgconfig
export LD_LIBRARY_PATH=${DEPEND_LIB_DIR}/lib
export PATH=$PATH:${DEPEND_LIB_DIR}/bin:${DEPEND_LIB_DIR}/sbin

"
add 
#include <sys/socket.h>
#include <sys/un.h>
to proto.c to fixbug 
invalid application of 'sizeof' to incomplete type 'struct sockaddr_un'   
"

./configure --prefix=$PREFIX --host=${HOST} \
CC=${CROSS}gcc \
--with-zlib=${DEPEND_LIB_DIR} \
--with-xml=${DEPEND_LIB_DIR}


#c_icap-0.4.1
DEPEND_LIB_DIR=/home/ninhld/Zynq706/Project/FIREWALL/user
export CFLAGS=-I${DEPEND_LIB_DIR}/include
export CPPFLAGS=-I${DEPEND_LIB_DIR}/include
export LDFLAGS=-L${DEPEND_LIB_DIR}/lib
export PKG_CONFIG_PATH=${DEPEND_LIB_DIR}/lib/pkgconfig
export LD_LIBRARY_PATH=${DEPEND_LIB_DIR}/lib
export PATH=$PATH:${DEPEND_LIB_DIR}/bin:${DEPEND_LIB_DIR}/sbin

./configure --prefix=$PREFIX --host=${HOST} \
CC=${CROSS}gcc \
ac_cv_10031b_ipc_sem=yes \
ac_cv_fcntl=yes


#squidclamav-6.13
DEPEND_LIB_DIR=/home/ninhld/Zynq706/Project/FIREWALL/user
export CFLAGS=-I${DEPEND_LIB_DIR}/include
export CPPFLAGS=-I${DEPEND_LIB_DIR}/include
export LDFLAGS=-L${DEPEND_LIB_DIR}/lib
export PKG_CONFIG_PATH=${DEPEND_LIB_DIR}/lib/pkgconfig
export LD_LIBRARY_PATH=${DEPEND_LIB_DIR}/lib
export PATH=$PATH:${DEPEND_LIB_DIR}/bin:${DEPEND_LIB_DIR}/sbin

./configure --prefix=$PREFIX --host=${HOST} \
CC=${CROSS}gcc \
--with-c-icap=${DEPEND_LIB_DIR}

"
comment data->error_page->hasalldata = 1; in squidclamav.c
"



#=======================================================================
# URL Filter squidGuard-1.4  
# Dependency: db-4.6.21
#=======================================================================
#db-4.6.21
cd build_unix

../dist/configure --prefix=$PREFIX --host=${HOST} \
--enable-compat185 \
--enable-dbm       \
--disable-static   \
--enable-cxx \
CC=${CROSS}gcc \
CXX=${CROSS}g++


#squidguard-1.4 (NOT OK)
DEPEND_LIB_DIR=/home/ninhld/Zynq706/Project/FIREWALL/user
export CFLAGS=-I${DEPEND_LIB_DIR}/include
export CPPFLAGS=-I${DEPEND_LIB_DIR}/include
export LDFLAGS=-L${DEPEND_LIB_DIR}/lib
export PKG_CONFIG_PATH=${DEPEND_LIB_DIR}/lib/pkgconfig
export LD_LIBRARY_PATH=${DEPEND_LIB_DIR}/lib
export PATH=$PATH:${DEPEND_LIB_DIR}/bin:${DEPEND_LIB_DIR}/sbin

"only one time"
patch -Nru -i ../squidguard-1.4-cross-compile.patch


./configure --prefix=$PREFIX --host=${HOST} \
CC=${CROSS}gcc \
--with-db=${DEPEND_LIB_DIR}


--with-db-inc=${DEPEND_LIB_DIR}/include \ 
--with-db-lib=${DEPEND_LIB_DIR}/lib \
--with-db=${DEPEND_LIB_DIR} \




#=======================================================================
# URL Filter dansguardian-2.10.0.1  (the same as squidguard)
# Dependency: zlib, libiconv, icap, ...
# Dansguardian is more widely used than Squidguard.
# dans does everything squidguard does + the heuristics
#=======================================================================
#dansguardian-2.10.0.1
DEPEND_LIB_DIR=/home/ninhld/Zynq706/Project/FIREWALL/user
export CFLAGS=-I${DEPEND_LIB_DIR}/include
export CPPFLAGS=-I${DEPEND_LIB_DIR}/include
export LDFLAGS="-L${DEPEND_LIB_DIR}/lib -liconv"
export PKG_CONFIG_PATH=${DEPEND_LIB_DIR}/lib/pkgconfig
export LD_LIBRARY_PATH=${DEPEND_LIB_DIR}/lib
export PATH=$PATH:${DEPEND_LIB_DIR}/bin:${DEPEND_LIB_DIR}/sbin


./configure --prefix=$PREFIX --host=${HOST} \
CC=${CROSS}gcc \
CXX=${CROSS}g++ \
--enable-commandline \
--enable-static-zlib \
--enable-clamd \
--enable-icap \
--enable-ntlm \
--enable-email 	

"add #include <stdio.h> into 
fancy.cpp, icapscan.cpp, commandlinescan.cpp 
to fixbug 
error: ‘snprintf’ was not declared in this scope"

make install






#=======================================================================
# GepIP
# Dependency: 
#=======================================================================
#libtap
make CC="${CROSS}gcc" AR="${CROSS}ar" RANLIB="${CROSS}ranlib" \
PREFIX=${PREFIX} \
install
#libmaxminddb (NOT OK)
./configure --prefix=$PREFIX --host=${HOST} \
CC=${CROSS}gcc


"Modify config.h which have just is generated
comment #define malloc rpl_malloc
"



#geoip-api-c
#geoip dependency libmaxminddb if this use .mmdb format database
# in normal it use .dat format
./configure --prefix=$PREFIX --host=${HOST} \
CC=${CROSS}gcc


"search and remove -Dmalloc=rpl_malloc -Drealloc=rpl_realloc 
in all Makefile"


make install







#=======================================================================
# export environment
#=======================================================================
source /opt/Xilinx/14.3/ISE_DS/settings64.sh
export HOST=arm-xilinx-linux-gnueabi
export CROSS=arm-xilinx-linux-gnueabi-
export PREFIX=/home/ninhld/Zynq706/Project/FIREWALL/user
export PREFIX=`pwd`/install


export CC=${CROSS}gcc
export CXX=${CROSS}g++
export AR=${CROSS}ar
export RANLIB=${CROSS}ranlib
export STRIP=${CROSS}strip
export LD=${CROSS}ld 


DEPEND_LIB_DIR=/home/ninhld/Zynq706/Project/FIREWALL/user
export CFLAGS=-I${DEPEND_LIB_DIR}/include
export CPPFLAGS=-I${DEPEND_LIB_DIR}/include
export LDFLAGS=-L${DEPEND_LIB_DIR}/lib
export PKG_CONFIG_PATH=${DEPEND_LIB_DIR}/lib/pkgconfig
export LD_LIBRARY_PATH=${DEPEND_LIB_DIR}/lib
export PATH=$PATH:${DEPEND_LIB_DIR}/bin:${DEPEND_LIB_DIR}/sbin




DEPEND_LIB_DIR=/home/ninhld/Zynq706/Project/FIREWALL/soft-admin/gsoap-2.8-host/install
export CFLAGS="-I${DEPEND_LIB_DIR}/include  -DWITH_OPENSSL"
export CPPFLAGS=-I${DEPEND_LIB_DIR}/include
export LDFLAGS=-L${DEPEND_LIB_DIR}/lib
export PKG_CONFIG_PATH=${DEPEND_LIB_DIR}/lib/pkgconfig
export LD_LIBRARY_PATH=${DEPEND_LIB_DIR}/lib
export PATH=$PATH:${DEPEND_LIB_DIR}/bin:${DEPEND_LIB_DIR}/sbin
export LIBS="-lm -lssl -lcrypto -lpthread"




