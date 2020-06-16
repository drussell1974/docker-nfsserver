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

2. Download and edit yaml file

> wget https://raw.githubusercontent.com/drussell1974/docker-nfsserver/master/docker-compose.yml

> vim docker-compose.yml

3. Download the example .env file and rename

> wget https://raw.githubusercontent.com/drussell1974/docker-nfsserver/master/.env.example

> mv .env.example .env

> vim .env

4. Run the container

> docker-compose up --detach

5. Download the build file

> mkdir -t build

> wget https://raw.githubusercontent.com/drussell1974/docker-nfsserver/master/build/Dockerfile

> vim Dockerfile 

The build files
===========

Dockerfile
-------------

```
FROM debian:latest

RUN apt-get update && apt-get install -y nfs-kernel-server

# create nfs_share which will be bind to the nfs_share host directory
RUN mkdir -p /mnt/nfs_share && \
	chown -R nobody:nogroup /mnt/nfs_share/ && \
	chmod 777 /mnt/nfs_share/

RUN mkdir /usr/nfs_server/
WORKDIR /usr/nfs_server/
COPY docker-entrypoint.sh .

ENTRYPOINT "/usr/nfs_server/docker-entrypoint.sh"

EXPOSE 2049
```

docker-entrypoint.sh
-------------------------

```
#!/bin/sh

# Give permission to subnet - e.g. /mnt/nfs_share 192.168.1.0/24(rw,sync,no_subtree_check)
# requires NFS_IPADDR_ALLOWED environment variable

echo "Create export for...${NFS_IPADDR_ALLOWED}"
echo "/mnt/nfs_share ${NFS_IPADDR_ALLOWED}(rw,sync,no_subtree_check)" > /etc/exports

# refresh nfs service

exportfs -a && service nfs-kernel-server reload

echo "Content of /mnt/nfs_share directory... (should be mapped using volume) "
:wq
ls -l /mnt/nfs_share

# prevent docker from exiting

echo "keep alive"
tail -f /dev/null

```

Docker CLI

> docker pull drussell1974/nfs-server

> docker build -t nfs_server .


> sudo docker run -d -v /media/dave/My\ Passport/home/:/mnt/nfs_share -e NFS_IPADDR_ALLOWED="192.168.1.0/24" nfs_server

Docker Compose

docker-compose.yml

```
version: "3.2"
services:
        nfs_server:
                build: ./build
                image: drussell1974/nfs-server:latest
                external_links:
			- ldap_server
		ports:
                        - 2049:2049
                environment:
                        - NFS_IPADDR_ALLOWED=${NFS_IPADDR_ALLOWED}
                volumes:
                        - ${NFS_SHARE_HOST_DIR}:/mnt/nfs_share

```

> docker-compose build
> docker-compose up -d
