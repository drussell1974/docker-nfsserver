FROM debian:jessie

RUN apt-get update && apt-get install -y nfs-kernel-server portmap

RUN mkdir -p /mnt/nfs_share/ && \
	chown -R nobody:nogroup /mnt/nfs_share/ && \
	chmod 777 /mnt/nfs_share/

RUN mkdir /usr/nfs_server/

WORKDIR /usr/nfs_server/
COPY docker-entrypoint.sh .

ENTRYPOINT "/usr/nfs_server/docker-entrypoint.sh"

VOLUME /mnt/nfs_share 
EXPOSE 2049
