FROM debian:jessie

RUN apt-get update && apt-get install -y nfs-kernel-server portmap

RUN mkdir /usr/nfs_server/

WORKDIR /usr/nfs_server/

RUN mkdir -p /usr/nfs_server/nfs_share/ && \
	chown -R nobody:nogroup /usr/nfs_server/nfs_share && \
	chmod 777 /usr/nfs_server/nfs_share && \
	mkdir -p  /usr/nfs_server/nfs_share/public && \
	mkdir -p  /usr/nfs_server/nfs_share/home

COPY docker-entrypoint.sh .

ENTRYPOINT "/usr/nfs_server/docker-entrypoint.sh"

EXPOSE 2049
