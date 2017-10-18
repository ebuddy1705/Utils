PHONY:=

#ifeq ($(strip $(XILINX_EDK)),)
#$(error "Please setup ISE Building Environment")
#endif

#ifeq ($(strip $(ROOTFS_DIR)),)
#$(error "Please specify rootfs directory")
#endif

ROOTDIR=$(shell pwd)
SRC_DIR=$(ROOTDIR)/srcdir
INFO_DIR=$(ROOTDIR)/buid
SCRIPT_DIR=$(ROOTDIR)/script
PATCHES_DIR=$(ROOTDIR)/patches
EXTPKGS_DIR=$(ROOTDIR)/extpkgs




NUM_DL_RETRIES=3
URL_SOURCE_DL=http://source.ipfire.org/source-2.x
CROSS=arm-xilinx-linux-gnueabi


ifeq ($(APPS_VERBOSE),1)
	Q =
else
	Q = @
endif



ifeq ($(shell [ ! -d $(SRC_DIR) ] && echo -n yes),yes)
    $(shell mkdir $(SRC_DIR))
endif
ifeq ($(shell [ ! -d $(INFO_DIR) ] && echo -n yes),yes)
	$(shell mkdir $(INFO_DIR))
endif


export Q APPS_VERBOSE URL_SOURCE_DL NUM_DL_RETRIES CROSS ROOTDIR ROOTFS_DIR SRC_DIR INFO_DIR PATCHES_DIR EXTPKGS_DIR




	
BASE_APPLIST:=  dhcp   
	       
	       
# install before build   
# yum install git wget bison flex glib-devel glib2-devel perl-Text-CSV_XS perl-ExtUtils-MakeMaker intltool.noarch  	      
BASE_APPLIST-:= makescripts \
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
	      fix_somethings 
	

buildlist:= $(addsuffix .build,$(BASE_APPLIST))
cleanlist:= $(addsuffix .clean,$(BASE_APPLIST))


PHONY+= all
all: $(buildlist)

PHONY+= clean
clean: $(cleanlist)

PHONY+=$(buildlist)
$(buildlist):
	@if [ ! -f $(INFO_DIR)/$(basename  $@) ]; then \
		#$(MAKE) -f $(SCRIPT_DIR)/$(basename  $@) _build && touch $(INFO_DIR)/$(basename  $@) ;\
		#$(MAKE) -f $(SCRIPT_DIR)/$(basename  $@) _build ;\
		$(MAKE) -C $(SCRIPT_DIR) -f $(basename  $@) _build ;\
	fi
	
	
PHONY+=$(cleanlist)
$(cleanlist):
	$(Q)$(MAKE) -f $(SCRIPT_DIR)/$(basename  $@) _clean

.PHONY: $(PHONY)

