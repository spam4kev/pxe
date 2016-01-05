This container is used by spam4kev/razor-server as a PXE/TFTP/DCHP server and is expected to be built using docker-compose.

-  troubleshooting
```bash
docker run -ti -p 53:53/udp -p 53:53 -p 67:67 -p 69:69 -p 4011:4011 -v /media/BitTorrent/operating_systems/:/tftpboot/images/ centos sh
```
