#!/bin/sh

# Give permission to subnet - e.g. /mnt/nfs_share 192.168.1.0/24(rw,sync,no_subtree_check)
# requires NFS_IPADDR_ALLOWED environment variable

echo "Create export for...${NFS_IPADDR_ALLOWED}"
echo "/mnt/nfs_share ${NFS_IPADDR_ALLOWED}(rw,sync,no_subtree_check)" > /etc/exports

# refresh nfs service

exportfs -a && service nfs-kernel-server reload

# prevent docker from exiting

echo "keep alive"
tail -f /dev/null


