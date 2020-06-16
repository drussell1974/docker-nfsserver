#!/bin/sh

# Give permission to subnet - e.g. /mnt/nfs_share 192.168.1.0/24(rw,sync,no_subtree_check)
# requires NFS_IPADDR_ALLOWED environment variable

echo "Allowing ${NFS_IPADDR_ALLOWED} to /mnt/nfs_share/${NFS_PUBLIC_PATH} in /etc/export/ ..."

echo "/mnt/nfs_share/${NFS_PUBLIC_PATH} ${NFS_IPADDR_ALLOWED}(rw,sync,no_subtree_check)" > /etc/exports


echo "Allowing ${NFS_IPADDR_ALLOWED} to /mnt/nfs_share/${NFS_HOME_PATH} in /etc/export/ ..."

echo "/mnt/nfs_share/${NFS_HOME_PATH} ${NFS_IPADDR_ALLOWED}(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports

# refresh nfs service

echo "Applying exportfs and restarting nfs-kernel-server..."

exportfs -a && service nfs-kernel-server reload

# prevent docker from exiting

echo "keep alive"
tail -f /dev/null


