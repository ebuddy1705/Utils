#=======================================================================
# u-boot setup
#=======================================================================
setenv nfsroot '/home/ninhld/Documents/OpenGL/miracast_pilot/7420LBV1170/image/rootfs'
setenv ipaddr '192.168.1.2'
setenv serverip '192.168.1.3'
run bootcmd_hybrid
 
ls /opt/centic
 
#=======================================================================
# initial setup
#=======================================================================
#host init
systemctl stop firewalld.service
service nfs restart
ifconfig p1p1:0 192.168.1.3 netmask 255.255.255.0
minicom -m -c on -D /dev/ttyUSB0
type: q
type: root
 
 
#target init
ifconfig eth0 192.168.1.2 netmask 255.255.255.0
mount -o nolock 192.168.1.3:/carmeter/carmeter-master/source-car-meter /mnt
#mount -o nolock 192.168.1.3:/carmeter/src /mnt
modprobe galcore
modprobe ehci_hcd
modprobe usbhid
 
 
#=======================================================================
# build and run app
# note: app is in rootfs dev folder
#=======================================================================
 
#host build opengl app
#cd /home/ninhld/Documents/OpenGL/miracast_pilot/7420LBV1170/scripts
#source setenv.sh
 
cd /carmeter/src
source setenv.sh
make
 
#target run app
cd /mnt/bin
./MainApp
