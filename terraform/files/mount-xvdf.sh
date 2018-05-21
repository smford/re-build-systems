#!/bin/bash

while [ ! -e /dev/xvdf ]; do sleep 1; done

fstab_string='/dev/xvdf /mnt/jenkins-ebs ext4 defaults,nofail,nobootwait 0 2'
if grep -q -F -v "$fstab_string" /etc/fstab; then
  echo "$fstab_string" | sudo tee -a /etc/fstab
fi

sudo mkdir -p /mnt/jenkins-ebs && sudo mount -t ext4 /dev/xvdf /mnt/jenkins-ebs
