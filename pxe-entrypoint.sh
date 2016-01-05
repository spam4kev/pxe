#!/bin/sh
wget --tries=0 http://boot.ipxe.org/undionly.kpxe
myIP=$(ip addr show dev eth0 | awk -F '[ /]+' '/global/ {print $3}')
mySUBNET=$(echo $myIP | cut -d '.' -f 1,2,3)
dnsmasq  \
	--dhcp-match=IPXEBOOT,175 \
	--dhcp-boot=net:IPXEBOOT,bootstrap.ipxe \
	--dhcp-boot=undionly.kpxe \
	--enable-tftp \
	--tftp-root=/tftpboot \
	--port=0 \
	--log-dhcp \
	--bind-dynamic \
	--dhcp-range=10.11.11.1,proxy \
	--no-daemon
