#!/bin/bash
. /opt/devstack_utils/profile_stack.sh
sync
echo 3 > /proc/sys/vm/drop_caches
umount /mnt/glance
mount -a
docker-delete-all
