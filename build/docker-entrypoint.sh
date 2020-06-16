#!/bin/sh

echo "docker-entrypoint.sh: change options in port maps and allow sub net in hosts for port maps"
perl -pi -e "s/^OPTIONS/#OPTIONS/" /etc/default/portmap
echo "portmap: 192.168.1.0" >> /etc/hosts.allow

# Give permission to subnet - e.g. /mnt/nfs_share 192.168.1.0/24(rw,sync,no_subtree_check)
# requires NFS_IPADDR_ALLOWED environment variable


echo "docker-entrypoint.sh: allowing ${NFS_IPADDR_ALLOWED} to /mnt/nfs_share/public in /etc/exports ..."

echo "/usr/nfs_server/nfs_share/public ${NFS_IPADDR_ALLOWED}(rw,sync,no_subtree_check)" > /etc/exports


echo "docker-entrypoint.sh: allowing ${NFS_IPADDR_ALLOWED} to /mnt/nfs_share/home in /etc/exports ..."

echo "/usr/nfs_server/nfs_share/home ${NFS_IPADDR_ALLOWED}(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports


# refresh nfs service

echo "docker-entrypoint.sh: applying exportfs and restarting portmap and nfs-kernel-server..."
exportfs -a && \
service nfs-kernel-server reload && \
service rpcbind restart

echo "docker-entrypoint.sh: showing contents of /usr/nfs_server/nfs_share/hone ..."
ls -l /usr/nfs_server/nfs_share/home

echo "docker-entrypoint.sh: showing contents of /usr/nfs_server/nfs_share/public ..."
ls -l /usr/nfs_server/nfs_share/public

# prevent docker from exiting

echo "docker-entrypoint.sh: keep alive!"
tail -f /dev/null


