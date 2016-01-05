#!/bin/sh
    dnsmasq  \
		--dhcp-match=IPXEBOOT,175 \
		--dhcp-boot=net:IPXEBOOT,bootstrap.ipxe \
		--dhcp-boot=undionly.kpxe \
		--enable-tftp \
		--tftp-root=/tftpboot \
		--port=0 \
		--log-dhcp \
		--bind-dynamic \
		--dhcp-range=10.11.11.201,10.11.11.202
		--no-daemon
