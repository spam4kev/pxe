This container is used by spam4kev/razor-server as a PXE/TFTP/DCHP server and is expected to be built using docker-compose.

-  How to Build

Becuase tftp returns traffic over a random ephimeral port after first client connection on port 69, a special network mode using the hosts interface as the containers interface must be used. This can be done using 'docker run --net=host \<other options> \<image name>'.

- iPXE boot using dnsmasq
```bash
dnsmasq  \
        --dhcp-match=IPXEBOOT,175 \
          # 175 sets a variable to the value before the comma. In this case, the variable is IPXEBOOT
        --dhcp-boot=net:IPXEBOOT,bootstrap.ipxe \
          # This sets dhcp-boot option equal to whatever is after the comma if the variable to the
          # right of the colon is set. Since our previous statement sets IPXEBOOT, the dhcp-boot gets
          # a value of bootstrap.ipxe
        --dhcp-boot=undionly.kpxe \
          # this sets dhcp-boot to what is on the right of the equal sign. This will be applied at first tftpboot
          # because within the undionly.kpxe it says to boot the net option
        --enable-tftp \
	  # turns on tftp service in dnsmasq
        --tftp-root=/tftpboot \
	  # sets the directory that iPXE clients will pull from. in our scripts, we put bootstrap.ipxe & 
	  # undionly.kpxe in /tftpboot on image startup.
        --log-dhcp \
	  # help with troubleshooting any problems
        --dhcp-range=10.11.11.1,proxy \
	  # when proxy is listed to the right of the comma, the server differs all iPXE clients toe the 
	  # ip set before the comma.
        --no-daemon
	  # needed so docker container stays running(?)
```

-  troubleshooting
```bash
docker run -ti -p 53:53/udp -p 53:53 -p 67:67 -p 68:68/udp -p 69:69 -p 69:69/udp -p 4011:4011/udp --net=host -v /media/BitTorrent/operating_systems/:/tftpboot/images/ centos sh
#on docker host based on https://goldmann.pl/blog/2014/01/21/connecting-docker-containers-on-multiple-hosts/
sudo sh -c 'echo 1 > /proc/sys/net/ipv4/conf/docker0/arp_accept'
sudo sh -c 'echo 1 > /proc/sys/net/ipv4/conf/enp0s3/arp_accept'
#or
sudo sysctl net.ipv4.conf.enp0s3.proxy_arp=1 
sudo sysctl net.ipv4.conf.docker0.proxy_arp=1
sudo sysctl net.ipv4.ip_forward=1
sudo sysctl net.ipv4.conf.all.forwarding=1	#allowed all interfaces to forward traffic if exposed in dockerfile
```
