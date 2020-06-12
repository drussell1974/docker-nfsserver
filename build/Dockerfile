FROM debian:latest

RUN apt-get update && apt-get install -y nfs-kernel-server

RUN mkdir -p /mnt/nfs_share && \
	chown -R nobody:nogroup /mnt/nfs_share/ && \
	chmod 777 /mnt/nfs_share/

RUN mkdir /usr/nfs_server/
WORKDIR /usr/nfs_server/
COPY docker-entrypoint.sh .

ENTRYPOINT "/usr/nfs_server/docker-entrypoint.sh"

#vOLUME /mnt/nfs_share

