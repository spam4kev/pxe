FROM centos:latest
MAINTAINER "kev" spam4kev@gmail.com

EXPOSE 68/udp 69/udp 4011/udp
RUN yum update
RUN yum install -y wget \
		   tftp-server \
		   dnsmasq && \
    mkdir /tftpboot
COPY ./pxe-entrypoint.sh /tmp/pxe-entrypoint.sh
RUN chmod +x /tmp/pxe-entrypoint.sh
WORKDIR /tftpboot
CMD \
    wget --tries=0 http://boot.ipxe.org/undionly.kpxe && \
    wget --tries=0 http://10.11.11.59:8150/api/microkernel/bootstrap?nic_max=1 -O bootstrap.ipxe && \
    dnsmasq  \
		--dhcp-match=IPXEBOOT,175 \
		--dhcp-boot=net:IPXEBOOT,bootstrap.ipxe \
		--dhcp-boot=undionly.kpxe \
		--enable-tftp \
		--tftp-root=/tftpboot \
		--port=0 \
		--log-dhcp \
		--bind-dynamic \
		--dhcp-range=10.11.11.201,10.11.11.202,1h \
		--no-daemon 

