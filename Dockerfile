FROM centos:latest
MAINTAINER "kev" spam4kev@gmail.com

RUN yum install -y wget \
                   iptables-services \
		   dnsmasq && \
    wget --no-check-certificate https://raw.github.com/jpetazzo/pipework/master/pipework && \
    chmod +x pipework && \
    mkdir /tftpboot
CMD \
    echo Setting up iptables... &&\
    iptables -t nat -A POSTROUTING -j MASQUERADE &&\
    echo Waiting for pipework to give us the eth1 interface... &&\
    /pipework --wait &&\
    myIP=$(grep $(hostname) /etc/hosts | cut -d: -f2 | awk '{ print $1}') &&\
    mySUBNET=$(echo $myIP | cut -d '.' -f 1,2,3) &&\
    echo Starting DHCP+TFTP server...&&\
    dnsmasq  \
            --dhcp-match=IPXEBOOT,175 \
            --interface=eth1 \
    	    --dhcp-range=$mySUBNET.101,$mySUBNET.199,255.255.255.0,1h \
	    --dhcp-boot=net:IPXEBOOT,bootstrap.ipxe,$myIP \
            --dhcp-boot=undionly.kpxe \
	    --enable-tftp \
            --tftp-root=/tftproot \
            --no-daemon
# Let's be honest: I don't know if the --pxe-service option is necessary.
# The iPXE loader in QEMU boots without it.  But I know how some PXE ROMs
# can be picky, so I decided to leave it, since it shouldn't hurt.
