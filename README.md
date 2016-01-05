This container is used by spam4kev/razor-server as a PXE/TFTP/DCHP server and is expected to be built using docker-compose.

-  troubleshooting
```bash
docker run -ti -p 53:53/udp -p 53:53 -p 67:67 -p 69:69 -p 4011:4011 -v /media/BitTorrent/operating_systems/:/tftpboot/images/ centos sh
#on docker host based on https://goldmann.pl/blog/2014/01/21/connecting-docker-containers-on-multiple-hosts/
sudo sh -c 'echo 1 > /proc/sys/net/ipv4/conf/docker0/arp_accept'
sudo sh -c 'echo 1 > /proc/sys/net/ipv4/conf/enp0s3/arp_accept'
```
