#!/bin/sh
wget --tries=0 http://boot.ipxe.org/undionly.kpxe -O /tftpboot/undionly.kpxe
wget --tries=0 http://10.11.11.59:8150/api/microkernel/bootstrap?nic_max=1 -O /tftpboot/bootstrap.ipxe
chmod +x /tftpboot/bootstrap.ipxe
chmod +x /tftpboot/undionly.kpxe
dnsmasq  \
	--dhcp-match=IPXEBOOT,175 \
	--dhcp-boot=net:IPXEBOOT,bootstrap.ipxe \
	--dhcp-boot=undionly.kpxe \
	--enable-tftp \
	--tftp-root=/tftpboot \
	--port=0 \
	--log-dhcp \
	--bind-dynamic \
	--dhcp-range=10.11.11.i1,proxy \
	--no-daemon
#	--dhcp-range=10.11.11.201,10.11.11.202 \
