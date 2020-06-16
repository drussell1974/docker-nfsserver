Docker NFS Server
=================
=======
Hosting drussell1974/nfs-server
=======================

Download tar.gz
---------------

1. Download build files

> wget https://raw.githubusercontent.com/drussell1974/docker-nfsserver/development/nfs-server.tar.gz

2. Extract

> tar -xzvf nfs-server.tar.gz 

3. Copy examples

> cp .env.example .env

> cp docker-compose.yml.example docker-compose.yml

Download individual files
-------------------------

1. Create a directory for the compose and build

> mkdir -t nfs_server

2. Download and edit yaml file specify volumes

> wget https://raw.githubusercontent.com/drussell1974/docker-nfsserver/master/docker-compose.yml

3. Download the example .env file and rename

> wget https://raw.githubusercontent.com/drussell1974/docker-nfsserver/master/.env.example


Edit the configuration file
---------------------------

1. Specify allowed ip addresses from your client subnet

> mv .env.example .env
```
# Where 192.168.1.0/24 would be all machines on the network in range 192.168.1.1 - 192.168.1.255
NFS_IPADDR_ALLOWED=192.168.1.0/24
```

2. Specify your own volume mapping, or use the existing mappings. 

> vim docker-compose.yml
```
version: "3"
services:
        nfs_server:
                image: drussell1974/nfs-server:v0.0.6-alpha
                external_links:
                        - ldap_server
                ports:
                        - 2049:2049
                environment:
                        - NFS_IPADDR_ALLOWED=${NFS_IPADDR_ALLOWED}
                volumes:
                        - nfs-server_public:/mnt/nfs_share/public
                        - nfs-server_home:/mnt/nfs_share/home
volumes:
        nfs-server_public:
        nfs-server_home:
```

