FROM centos:latest
MAINTAINER "kev" spam4kev@gmail.com

EXPOSE 68/udp 69/udp 4011/udp
RUN yum update
RUN yum install -y wget \
		   tftp-server \
		   iproute \
		   dnsmasq && \
    mkdir /tftpboot
COPY ./pxe-entrypoint.sh /tmp/pxe-entrypoint.sh
RUN chmod +x /tmp/pxe-entrypoint.sh
WORKDIR /tftpboot
CMD \
    wget --tries=0 http://boot.ipxe.org/undionly.kpxe && \
    myIP=$(ip addr show dev eth1 | awk -F '[ /]+' '/global/ {print $3}') && \
    mySUBNET=$(echo $myIP | cut -d '.' -f 1,2,3) && \
    dnsmasq  \
		--dhcp-match=IPXEBOOT,175 \
		--dhcp-boot=net:IPXEBOOT,bootstrap.ipxe \
		--dhcp-boot=undionly.kpxe \
		--enable-tftp \
		--tftp-root=/tftpboot \
		--port=0 \
		--log-dhcp \
		--bind-dynamic \
		--dhcp-range=$mySUBNET.201,$mySUBNET.202,255.255.255.0,1h \
		--no-daemon
#		--dhcp-range=10.11.11.201,10.11.11.202,1h \
