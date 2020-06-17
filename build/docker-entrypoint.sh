#!/bin/sh
echo "\ndocker-entrypoint.sh: changing options in port maps and allow sub net in hosts for port maps..."
perl -pi -e "s/^OPTIONS/#OPTIONS/" /etc/default/portmap
echo "portmap: ${NFS_IPADDR_ALLOWED}" >> /etc/hosts.allow

echo "\ndocker-entrypoint.sh: showing /etc/hosts.allow"
cat /etc/hosts.allow

# Give permission to subnet - e.g. /mnt/nfs_share/ 192.168.1.0/24(rw,sync,no_subtree_check)
# requires NFS_IPADDR_ALLOWED environment variable

echo "\ndocker-entrypoint.sh: allowing ${NFS_IPADDR_ALLOWED} to ${NFS_PUBLIC_CONT} in /etc/exports ..."
echo "${NFS_PUBLIC_CONT} ${NFS_IPADDR_ALLOWED}(rw,sync,no_subtree_check)" >> /etc/exports


echo "\ndocker-entrypoint.sh: allowing ${NFS_IPADDR_ALLOWED} to ${NFS_HOME_CONT} in /etc/exports ..."
echo "${NFS_HOME_CONT} ${NFS_IPADDR_ALLOWED}(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports


# disable version 4 of nfs
echo "\ndocker-entrypoint.sh: NFS_DISABLE=${NFS_DISABLE} NFS_DISABLE_VERSION=${NFS_DISABLE_VERSION}"
if [ ${NFS_DISABLE:-false} = true ];then
	echo "\ndocker-entrypoint.sh: applying RPCMOUNTDOPTS --no-nfs-version ${NFS_DISABLE_VERSION} in /etc/default/nfs-kernel-server"
	cat /etc/default/nfs-kernel-server | grep RPCMOUNTDOPTS
	sed -i "s/RPCMOUNTDOPTS=\"--manage-gids/RPCMOUNTDOPTS=\"--manage-gids --no-nfs-version ${NFS_DISABLE_VERSION}/" /etc/default/nfs-kernel-server
	cat /etc/default/nfs-kernel-server | grep RPCMOUNTDOPTS
fi

# refresh nfs service

echo "\ndocker-entrypoint.sh: applying exportfs and restarting portmap and nfs-kernel-server..."
exportfs -a && \
service nfs-kernel-server reload && \
service rpcbind restart

# show content

echo "\ndocker-entrypoint.sh: showing contents of ${NFS_HOME_CONT} ..."
ls -l ${NFS_HOME_CONT}

echo "\ndocker-entrypoint.sh: showing contents of ${NFS_PUBLIC_CONT} ..."
ls -l ${NFS_PUBLIC_CONT}

# prevent docker from exiting
echo "\ndocker-entrypoint.sh: keep alive!"
tail -f /dev/null


