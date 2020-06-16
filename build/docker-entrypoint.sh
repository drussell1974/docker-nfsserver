#!/bin/sh
echo "docker-entrypoint.sh: change options in port maps and allow sub net in hosts for port maps"
perl -pi -e "s/^OPTIONS/#OPTIONS/" /etc/default/portmap
echo "portmap: ${NFS_IPADDR_ALLOWED}" >> /etc/hosts.allow

# Give permission to subnet - e.g. /mnt/nfs_share/ 192.168.1.0/24(rw,sync,no_subtree_check)
# requires NFS_IPADDR_ALLOWED environment variable


echo "docker-entrypoint.sh: allowing ${NFS_IPADDR_ALLOWED} to ${NFS_PUBLIC_CONT} in /etc/exports ..."

echo "${NFS_PUBLIC_CONT} ${NFS_IPADDR_ALLOWED}(rw,sync,no_subtree_check)" > /etc/exports


echo "docker-entrypoint.sh: allowing ${NFS_IPADDR_ALLOWED} to ${NFS_HOME_CONT} in /etc/exports ..."

echo "${NFS_HOME_CONT} ${NFS_IPADDR_ALLOWED}(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports


# refresh nfs service

echo "docker-entrypoint.sh: applying exportfs and restarting portmap and nfs-kernel-server..."
exportfs -a && \
service nfs-kernel-server reload && \
service rpcbind restart

echo "docker-entrypoint.sh: showing contents of ${NFS_HOME_CONT} ..."
ls -l ${NFS_HOME_CONT}

echo "docker-entrypoint.sh: showing contents of ${NFS_PUBLIC_CONT} ..."
ls -l ${NFS_PUBLIC_CONT}

# prevent docker from exiting

echo "docker-entrypoint.sh: keep alive!"
tail -f /dev/null


