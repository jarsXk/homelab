#!/bin/sh

# common
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
mkdir -p ./@rootfs/var/snap/docker/common/var-lib-docker
btrfs subvolume create @var-lib-docker
mkdir -p ./@rootfs/srv/docker
btrfs subvolume create @srv-docker
mkdir -p ./@rootfs/@var-lib-docker/volumes
mkdir -p ./@srv-docker/volumes
mkdir -p ./@rootfs/var/snap/docker/common/assets
mkdir -p ./@srv-docker/assets
mkdir -p ./@rootfs/var/snap/docker/common/data
mkdir -p ./@rootfs/var/snap/docker/common/dummy

# vm
btrfs subvolume create @srv-vm
mkdir -p ./@rootfs/srv/vm
btrfs subvolume create @var-lib-machines
mkdir -p ./@rootfs/var/lib/machines
btrfs subvolume create @var-lib-portables
mkdir -p ./@rootfs/var-lib-portables
