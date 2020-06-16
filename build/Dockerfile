FROM 	debian:jessie
ENV	NFS_WORK_DIR=/usr/nfs_server/
ENV  	NFS_PUBLIC_CONT=nfs_share/public
ENV	NFS_HOME_CONT=nfs_share/home

RUN 	apt-get update && apt-get install -y nfs-kernel-server portmap

RUN 	mkdir $NFS_WORK_DIR

WORKDIR $NFS_WORK_DIR

RUN 	mkdir -p  $NFS_PUBLIC_CONT && \
	mkdir -p  $NFS_HOME_CONT && \
	chown -R nobody:nogroup $NFS_PUBLIC_CONT && \
	chmod 777 $NFS_PUBLIC_CONT && \
	chown -R nobody:nogroup $NFS_HOME_CONT && \
	chmod 777 $NFS_HOME_CONT

COPY 	docker-entrypoint.sh .

ENTRYPOINT "/usr/nfs_server/docker-entrypoint.sh"

EXPOSE 	2049
