#!/bin/bash

# make.sh build
# make.sh clean app_name
# make.sh cleanall

. ./tools/Config


if [ ! -d "${INFO_DIR}" ]; then
	mkdir ${INFO_DIR}
fi
if [ ! -d "${SRC_DIR}" ]; then
	mkdir ${SRC_DIR}
fi






# install before build   
# yum install git wget bison flex glib-devel glib2-devel perl-Text-CSV_XS perl-ExtUtils-MakeMaker intltool.noarch 
BASE_APPLIST=(makescripts \
	      stage2 scripts configroot initscripts backup freefont  dejavu-fonts-ttf \
	      sed zlib openssl apache2 openssh jquery web-user-interface \
	      perl Digest Digest-SHA1 Digest-HMAC HTML-Parser Crypt-PasswdMD5 experimental \
	      HTML-Tagset HTML-Template perl-gettext URI IO-Socket-SSL IO-Stringy \
	      MIME-Tools libnet libwww-perl sqlite Locale-Country GeoIP flag-icons \
	      perl-TimeDate Net-IPv4Addr Net-Telnet perl-Sort-Naturally Net-DNS \
	      perl-Authen-SASL perl-Carp-Clan  perl-Date-Calc perl-Date-Manip \
	      perl-DBI perl-Net-SMTP-SSL perl-Device-Modem perl-Device-SerialPort  \
	      perl-File-ReadBackwards perl-File-Tail Net-Server Unix-Syslog Text-Tabs+Wrap swatch \
	      Archive-Tar Archive-Zip Net_SSLeay perl-Text-CSV_XS perl-PDF-API2 \
	      util-linux kmod udev \
	      popt libsmooth pciutils \
	      misc-progs setup \
	      libnl libmnl libnfnetlink libnetfilter_queue libnetfilter_cttimeout libnetfilter_cthelper libnetfilter_conntrack \
	      iptables xtables-addons iproute2 \
	      libffi pcre glib-2.36.4 \
	      flex pam monit  \
	      fcron ethtool  \
	      ntp lzma python libxml2 dbus  \
	      hostname pakfire \
	      freetype fontconfig libpng pixman \
	      cairo pango rrdtool \
	      gmp netsnmpd curl intltool libgpg-error libgcrypt strongswan \
	      ddns libtool db BerkeleyDB openldap dhcpcd \
	      libpcap arping \
	      lzo openvpn \
	      libdnet daq netcat \
	      nettle libidn dnsmasq \
	      libtiff libgd perl-GD GD-TextUtil GD-Graph  \
	      ca-certificates \
	      sysvinit \
	      bind dhcp sysklogd  \
	      whatmask vnstat tzdata logrotate logwatch \
	      coreutils liboping collectd \
	      bash tcpdump \
	      quagga \
	      vlan \
	      squid squid-accounting calamaris \
	      fix_somethings)
	      
	      
BASE_APPLIST=(opencv zlib)






if [ "$1" == "build" ]; then
	for app in "${BASE_APPLIST[@]}"
	do
		if [ -f "${INFO_DIR}/${app}.buildflag" ]; then
			continue
		fi
		${SCRIPT_DIR}/${app} &&  touch "${INFO_DIR}/${app}.buildflag"
	done
elif [ "$1" == "clean" ]; then
	echo "clean ${2}"
	rm -rf ${INFO_DIR}/${2}.buildflag
elif [ "$1" == "cleanall" ]; then
	echo "clean all app"
	rm -rf ${INFO_DIR}/*
else
	echo "other"
fi




