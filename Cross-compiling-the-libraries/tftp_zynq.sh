#on host
yum install tftp tftp-server
vi /etc/xinetd.d/tftp
	service tftp
		{
			socket_type             = dgram
			protocol                = udp
			wait                    = yes
			user                    = root
			server                  = /usr/sbin/in.tftpd
			server_args             = -s /home/ninhld/ZYNQ/Git/tftp
			disable                 = no
			per_source              = 11
			cps                     = 100 2
			flags                   = IPv4
		}
setsebool -P tftp_home_dir 1
service xinet start
tftp localhost



#on zynq target
setenv kernel_image 'uImage'
setenv devicetree_image 'devicetree.dtb'
setenv sdboot 'echo TFTP Image to RAM... && tftpboot 0x3000000 ${server_ip}:${kernel_image} && tftpboot 0x2A00000 ${server_ip}:${devicetree_image} &&bootm 0x3000000 - 0x2A00000'
setenv server_ip '192.168.124.2'
setenv modeboot 'tftpboot'
setenv bootcmd 'run $modeboot'
setenv ipaddr '192.168.124.3'
saveenv

setenv sdboot 'if mmcinfo; then run uenvboot; echo Copying Linux from SD to RAM... && fatload mmc 0 0x3000000 ${kernel_image} && fatload mmc 0 0x2A00000 ${devicetree_image} && fatload mmc 0 0x2000000 ${ramdisk_image} && bootm 0x3000000 0x2000000 0x2A00000; fi;'


../linux-xlnx/scripts/dtc/dtc -I dtb -O dts -o my.dts devicetree.dtb


setenv modeboot 'sdboot'

#on host
su -c "ifconfig p1p1:0 192.168.124.2 netmask 255.255.255.0"
