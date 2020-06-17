FROM 	ubuntu

RUN 	apt-get update && apt-get install -y nfs-kernel-server

WORKDIR /usr/nfs_server

COPY 	docker-entrypoint.sh .

ENTRYPOINT "/usr/nfs_server/docker-entrypoint.sh"

EXPOSE 	2049 111
