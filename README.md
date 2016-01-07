This container is used by spam4kev/razor-server as a PXE/TFTP/DCHP server and is expected to be built using docker-compose.

-  How to Build

Becuase tftp returns traffic over a random ephimeral port after first client connection on port 69, a special network mode using the hosts interface as the containers interface must be used. This can be done using 'docker run --net=host \<other options> \<image name>'.

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
