#!/bin/sh
#SFTP put down SD card (sftp command line)
#sftp root@172.17.67.91
#put /home/ninhld/ZYNQ/init.sh /mnt

echo "--> Starting CENTIC Application..."

#========================================================================================================
# mount kernel modules
#========================================================================================================
echo "--> mount kernel modules"
rm -rf /lib/modules/*
mount /mnt/modules.img /lib/modules -o loop
ls -l /lib/modules/

#========================================================================================================
# mount zynq_lib
#========================================================================================================
echo "--> mount zynq_lib"
mkdir /zynq_lib
mount /mnt/zynq_lib.img /zynq_lib -o loop
cp -rf /zynq_lib/bin/pkg-config /usr/bin
cp -rf /zynq_lib/bin/arm-xilinx-linux-gnueabi-pkg-config /usr/bin
ln -sf /zynq_lib/sbin/xtables-multi /usr/bin/iptables-xml
ln -sf /zynq_lib/lib/xtables /lib/xtables

#========================================================================================================
# mount zynq_lib
#========================================================================================================
echo "--> export linux environment"
export PATH=$PATH:/zynq_lib/bin:/zynq_lib/sbin
export INCLUDE_PATH=$INCLUDE_PATH:/zynq_lib/include:/zynq_lib/include/gio-unix-2.0/gio:/zynq_lib/include/glib-2.0:/zynq_lib/include/glib-2.0/gio:/zynq_lib/include/glib-2.0/glib:/zynq_lib/include/glib-2.0/gobject:/zynq_lib/lib/libffi-3.0.13/include:/zynq_lib/include/libiptc:/zynq_lib/lib/glib-2.0/include
export PKG_CONFIG_PATH=$PKG_CONFIG_PATH:/zynq_lib/lib/pkgconfig
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/lib:/usr/lib:/zynq_lib/lib:/zynq_lib/lib/ipsec:/zynq_lib/lib/ipsec/plugins:/zynq_lib/lib/xtables

#========================================================================================================
# mount zynq_lib
#========================================================================================================
echo "--> load driver networking"
sleep 1
modprobe nf_conntrack_broadcast
modprobe ipt_MASQUERADE
modprobe ip6table_nat
modprobe nf_nat_ipv6
modprobe ip6table_mangle
modprobe ip6t_REJECT
modprobe nf_conntrack_ipv6
modprobe nf_defrag_ipv6
modprobe iptable_nat
modprobe nf_nat_ipv4
modprobe nf_nat
modprobe iptable_mangle
modprobe nf_conntrack_ipv4
modprobe nf_defrag_ipv4
modprobe xt_conntrack
modprobe nf_conntrack
modprobe ebtable_filter
modprobe ebtables
modprobe ip6table_filter
modprobe ip6_tables

echo "--> load driver need for IPSec"
sleep 1
modprobe af_key
modprobe ah4
modprobe esp4
modprobe ipcomp
modprobe xfrm_user
modprobe xfrm4_tunnel
modprobe xt_policy
modprobe nf_conntrack_netbios_ns
modprobe nf_nat

#========================================================================================================
# configure network
#========================================================================================================
echo "--> configure network"
#udhcpc
#configure eth0
ifconfig eth0 172.17.67.91 netmask 255.255.255.0
route add default gw 172.17.67.1 dev eth0
echo "nameserver 8.8.8.8" > /etc/resolv.conf
#configure eth1
sleep 1
ifconfig eth1 192.168.1.1 netmask 255.255.255.0

#========================================================================================================
# time update from ntp server
#========================================================================================================
echo "--> time update from ntp server"
cp -rf /zynq_lib/bin/ntpdate /usr/bin/
cp -rf /zynq_lib/service/services /etc
ntpdate pool.ntp.org
#date 070514002014  #is 07=Jul, 05=Day, 14=Hour, 00=Min, 2014=Year                                                      



#========================================================================================================
# setup ZedBoard as router  
#========================================================================================================
#IP forwarding
echo "--> IP forwarding"
echo 1 > /proc/sys/net/ipv4/ip_forward

#IP Masquerading
echo "--> IP Masquerading"
iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -o eth0 -m policy --dir out --pol ipsec -j ACCEPT
iptables -t nat -A POSTROUTING -s 192.168.1.0/24 -o eth0 -j MASQUERADE
iptables -A INPUT -p udp --sport 500 --dport 500 --j ACCEPT
iptables -A INPUT -p udp --sport 4500 --dport 4500 --j ACCEPT
iptables -A INPUT -p esp -j ACCEPT
iptables -A OUTPUT -p udp --sport 500 --j ACCEPT
iptables -A OUTPUT -p udp --sport 4500 --j ACCEPT
iptables -A OUTPUT -p esp -j ACCEPT


## OR YOU CAN USE SIMPLE SETTING BELOW
#route add -net 192.168.1.0 netmask 255.255.255.0 gw 172.17.67.91
#route add -net 192.168.2.0 netmask 255.255.255.0 gw 172.17.67.92
#route add -net 192.168.3.0 netmask 255.255.255.0 gw 172.17.67.93
#route del -net 192.168.1.0 netmask 255.255.255.0 gw 172.17.67.91
#route del -net 192.168.2.0 netmask 255.255.255.0 gw 172.17.67.92
#route del -net 192.168.3.0 netmask 255.255.255.0 gw 172.17.67.93 


#========================================================================================================
# start ipsec   
#========================================================================================================
#create /var/run for pid  ikev2
echo "--> create /var/run for pid "
sleep 1
mkdir /var/run

#ipsec start
#echo "--> ipsec start"
#ipsec start

#========================================================================================================
# the end 
#========================================================================================================
echo "--> Stop CENTIC Application..."

