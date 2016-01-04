#!/bin/sh
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
            --tftp-root=/tftpboot \
            --no-daemon
