#!/bin/sh

echo "change options in port maps and allow sub net in hosts for port maps"
perl -pi -e "s/^OPTIONS/#OPTIONS/" /etc/default/portmap
echo "portmap: 192.168.1.0" >> /etc/hosts.allow

# Give permission to subnet - e.g. /mnt/nfs_share 192.168.1.0/24(rw,sync,no_subtree_check)
# requires NFS_IPADDR_ALLOWED environment variable


echo "docker-entrypoint.sh: Allowing ${NFS_IPADDR_ALLOWED} to /mnt/nfs_share/${NFS_PUBLIC_PATH} in /etc/exports ..."

echo "/mnt/nfs_share/${NFS_PUBLIC_PATH} ${NFS_IPADDR_ALLOWED}(rw,sync,no_subtree_check)" > /etc/exports


echo "docker-entrypoint.sh: Allowing ${NFS_IPADDR_ALLOWED} to /mnt/nfs_share/${NFS_HOME_PATH} in /etc/exports ..."

echo "/mnt/nfs_share/${NFS_HOME_PATH} ${NFS_IPADDR_ALLOWED}(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports


# refresh nfs service

echo "docker-entrypoint.sh: Applying exportfs and restarting portmap and nfs-kernel-server..."
exportfs -a && \
service nfs-kernel-server reload && \
service rpcbind restart

echo "docker-entrypoint.sh: Getting Contents of root share directory /mnt/nfs_share/ ..."
ls -l /mnt/nfs_share/


# prevent docker from exiting

echo "docker-entrypoint.sh: keep alive!"
tail -f /dev/null


