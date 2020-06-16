#!/bin/sh
echo "docker-entrypoint.sh: changing options in port maps and allow sub net in hosts for port maps...\n"
perl -pi -e "s/^OPTIONS/#OPTIONS/" /etc/default/portmap
echo "portmap: ${NFS_IPADDR_ALLOWED}" >> /etc/hosts.allow

# Give permission to subnet - e.g. /mnt/nfs_share/ 192.168.1.0/24(rw,sync,no_subtree_check)
# requires NFS_IPADDR_ALLOWED environment variable

echo "docker-entrypoint.sh: allowing ${NFS_IPADDR_ALLOWED} to ${NFS_PUBLIC_CONT} in /etc/exports ...\n"
echo "${NFS_PUBLIC_CONT} ${NFS_IPADDR_ALLOWED}(rw,sync,no_subtree_check)" >> /etc/exports


echo "docker-entrypoint.sh: allowing ${NFS_IPADDR_ALLOWED} to ${NFS_HOME_CONT} in /etc/exports ...\n"
echo "${NFS_HOME_CONT} ${NFS_IPADDR_ALLOWED}(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports

# disable version 4 of nfs
if [ ${NFS_DISABLE_V4:-false} = true ];then
	echo "docker-entrypoint.sh: disabling nfs version 4...\n"
	sed -i 's/RPCMOUNTDOPTS="--manage-gids"/RPCMOUNTDOPTS="--manage-gids --no-nfs-version 4"/' /etc/default/nfs-kernel-server
fi

# refresh nfs service

echo "docker-entrypoint.sh: applying exportfs and restarting portmap and nfs-kernel-server...\n"
exportfs -a && \
service nfs-kernel-server reload && \
service rpcbind restart

# show content

echo "docker-entrypoint.sh: showing contents of ${NFS_HOME_CONT} ...\n"
ls -l ${NFS_HOME_CONT}

echo "docker-entrypoint.sh: showing contents of ${NFS_PUBLIC_CONT} ...\n"
ls -l ${NFS_PUBLIC_CONT}

# prevent docker from exiting
echo "docker-entrypoint.sh: keep alive!\n"
tail -f /dev/null


