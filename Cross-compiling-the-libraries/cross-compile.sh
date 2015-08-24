


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
# static library
./Configure dist --prefix=${PREFIX}
make CC="${CROSS}gcc" AR="${CROSS}ar r" RANLIB="${CROSS}ranlib" install

# shared library
./Configure --prefix=${PREFIX} shared "${HOST}":"${CROSS}gcc:-DTERMIO -O3 -Wall -I../../host/include::-D_REENTRANT::-L../../host/lib -ldl:BN_LLONG RC4_CHAR RC4_CHUNK DES_INT DES_UNROLL BF_PTR::bn_asm.o armv4-mont.o::aes_cbc.o aes-armv4.o:::sha1-armv4-large.o sha256-armv4.o sha512-armv4.o:::::::void:dlfcn:linux-shared:-fPIC::.so.1.0.0":${CROSS}ranlib::

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

./configure --prefix=$PREFIX --host=${HOST} CC=${CROSS}gcc \
--disable-plugin-auth-pam

make ARCH=arm install


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
--without-openssl --with-logfile="/var/log/ snmpd.log" \
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
./configure --prefix=$PREFIX \
CC=${CROSS}gcc

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
LD=${CROSS}ld



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






#============= cppcms-1.0.5 NOT OK ====================
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
-DCMAKE_ISTALL_PREFIX=$PREFIX ..








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
# CORBA: omniORB-4.2.0 NOT OK
#=======================================================================
#python-2.7.10
"build pgen on host first"
SOURCE_DIR=/home/ninhld/Zynq706/Project/FIREWALL/web-admin/Python-2.7.10
export CFLAGS="-I${SOURCE_DIR} -I${SOURCE_DIR}/Include"




"configure for target"
./configure --prefix=$PREFIX --host=${HOST} --build=x86_64 \
CC=${CROSS}gcc  \
--disable-ipv6 \
ac_cv_file__dev_ptmx=no \
ac_cv_file__dev_ptc=no

cp -rf Parser/pgen-host Parser/pgen
touch Parser/pgen




#=======================================================================
# Web Application Framework: Wt
#=======================================================================
#libfcgi
./configure --prefix=$PREFIX --host=${HOST} \
CC=${CROSS}gcc


#boost_1_58_0
"Bootstrap the code:"
./bootstrap.sh

"Modify the configuration file (project-config.jam) to use the ARM toolchain 
by replacing the line with “using gcc” by:
using gcc : arm : arm-xilinx-linux-gnueabi-g++ ;
using zlib : 1.2.8 : /home/ninhld/Zynq706/Project/FIREWALL/user/lib ;"

"Install the python development package:
sudo yum install python-devel"


"Build and install the boost libraries:"
./bjam install toolset=gcc-arm --prefix=$PREFIX

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
arm-xilinx-linux-gnueabi-g++ hello.C -o hello ${CFLAGS} ${LDFLAGS} ${LIBS}

"run"
./hello.wt --docroot . --http-address 0.0.0.0 --http-port 8080  #ok





#=======================================================================
# export environment
#=======================================================================
source /opt/Xilinx/14.3/ISE_DS/settings64.sh
export HOST=arm-xilinx-linux-gnueabi
export CROSS=arm-xilinx-linux-gnueabi-
export PREFIX=/home/ninhld/Zynq706/Project/FIREWALL/user
export PREFIX=`pwd`/install


export CC=${CROSS}gcc
export AR=${CROSS}ar
export RANLIB=${CROSS}ranlib
export LD=${CROSS}ld 


DEPEND_LIB_DIR=/home/ninhld/Zynq706/Project/FIREWALL/user
DEPEND_LIB_DIR=/home/ninhld/Zynq706/Project/FIREWALL/web-admin/cppcms-1.0.5/release/install
DEPEND_LIB_DIR=/opt/nfs/lighttpd
export CFLAGS=-I${DEPEND_LIB_DIR}/include
export CPPFLAGS=-I${DEPEND_LIB_DIR}/include
export LDFLAGS=-L${DEPEND_LIB_DIR}/lib
export PKG_CONFIG_PATH=${DEPEND_LIB_DIR}/lib/pkgconfig
export LD_LIBRARY_PATH=${DEPEND_LIB_DIR}/lib
export PATH=$PATH:${DEPEND_LIB_DIR}/bin:${DEPEND_LIB_DIR}/sbin


