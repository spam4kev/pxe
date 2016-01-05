#!/bin/sh
wget --tries=inf http://boot.ipxe.org/undionly.kpxe
wget --tries=inf http://10.11.11.59:8150/api/microkernel/bootstrap?nic_max=1 -O bootstrap.ipxe
dnsmasq  \
	--dhcp-match=IPXEBOOT,175 \
	--dhcp-boot=net:IPXEBOOT,bootstrap.ipxe \
	--dhcp-boot=undionly.kpxe \
	--enable-tftp \
	--tftp-root=/tftpboot \
	--port=0 \
	--log-dhcp \
	--bind-dynamic \
	--dhcp-range=10.11.11.201,10.11.11.202 \
	--no-daemon
