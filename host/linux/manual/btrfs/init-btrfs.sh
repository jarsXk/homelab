#!/bin/sh

# common
btrfs quota enable .
btrfs subvolume create @var-log
btrfs subvolume create @var-tmp

# snapshots
btrfs subvolume create .snapshots
mkdir -p ./@rootfs/.snapshots

# data
mkdir -p ./@rootfs/srv/data
mkdir -p ./@rootfs/srv/data/local-download
mkdir -p ./@rootfs/srv/data/local-junk
mkdir -p ./@rootfs/srv/data/local-share
mkdir -p ./@rootfs/srv/data/local-books
mkdir -p ./@rootfs/srv/data/local-music
mkdir -p ./@rootfs/srv/data/local-software
mkdir -p ./@rootfs/srv/data/local-video/public
mkdir -p ./@rootfs/srv/data/local-video/groups/family
mkdir -p ./@rootfs/srv/data/local-documents
mkdir -p ./@rootfs/srv/data/local-photo
mkdir -p ./@rootfs/srv/data/local-saves
mkdir -p ./@rootfs/srv/data/local-backup

# docker
mkdir -p ./@rootfs/var/snap/docker/common/var-lib-docker/volumes
btrfs subvolume create @docker-volumes
btrfs qgroup limit "<20%>"G @docker-volumes
mkdir -p ./@rootfs/var/snap/docker/common/var-lib-docker/overlay2
btrfs subvolume create @docker-overlay2
btrfs qgroup limit "<40%>"G @docker-overlay2
mkdir -p ./@rootfs/var/snap/docker/common/data
mkdir -p ./@rootfs/var/snap/docker/common/dummy

# vm
mkdir -p ./@rootfs/srv/vm
btrfs subvolume create @vm-data
btrfs qgroup limit "<60%>"G @vm-data
mkdir -p ./@rootfs/var/lib/machines
btrfs subvolume create @vm-machines
mkdir -p ./@rootfs/var-lib-portables
btrfs subvolume create @vm-portables
