#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# NixOS automatic partitioning
#
# Layout:
#
#   GPT
#   ├── EFI   1 GiB
#   ├── Btrfs remaining space
#   │   ├── @
#   │   ├── @home
#   │   ├── @games
#   │   └── @nix
#   └── swap  at the END of the disk
#
# No LUKS
# No LVM
# No Disko
# ============================================================

error() {
    echo
    echo "ERROR: $*" >&2
    exit 1
}

# ------------------------------------------------------------
# Root check
# ------------------------------------------------------------

if [[ $EUID -ne 0 ]]; then
    error "Run this script as root."
fi

# ------------------------------------------------------------
# Machine name
# ------------------------------------------------------------

read -rp "Host name: " MACHINE_NAME

MACHINE_NAME="${MACHINE_NAME^^}"

if [[ -z "$MACHINE_NAME" ]]; then
    echo "Error: host name cannot be empty."
    exit 1
fi

# ------------------------------------------------------------
# Select disk
# ------------------------------------------------------------

echo
echo "Available disks:"
echo

lsblk -d -o NAME,SIZE,MODEL,SERIAL,TYPE

echo
read -rp "Enter disk (example: /dev/nvme0n1): " DISK

[[ -b "$DISK" ]] || error "$DISK is not a block device."

REAL_DISK="$(readlink -f "$DISK")"

echo
echo "Selected disk:"
lsblk -d -o NAME,SIZE,MODEL,SERIAL,TYPE "$REAL_DISK"

# ------------------------------------------------------------
# Select swap size
# ------------------------------------------------------------

echo
read -rp "Swap size [40G]: " SWAP_SIZE
SWAP_SIZE="${SWAP_SIZE:-40G}"

if [[ "$SWAP_SIZE" =~ ^([0-9]+)(G|g)$ ]]; then
    SWAP_MIB=$(( ${BASH_REMATCH[1]} * 1024 ))
elif [[ "$SWAP_SIZE" =~ ^([0-9]+)(M|m)$ ]]; then
    SWAP_MIB="${BASH_REMATCH[1]}"
else
    error "Invalid swap size. Use e.g. 16G, 32G or 40G."
fi

# ------------------------------------------------------------
# Disk size
# ------------------------------------------------------------

DISK_BYTES="$(blockdev --getsize64 "$REAL_DISK")"
DISK_MIB=$((DISK_BYTES / 1024 / 1024))

EFI_SIZE_MIB=1024
SWAP_START_MIB=$((DISK_MIB - SWAP_MIB))

if (( SWAP_START_MIB <= EFI_SIZE_MIB + 1024 )); then
    error "Disk is too small."
fi

# ------------------------------------------------------------
# Safety check
# ------------------------------------------------------------

ROOT_SOURCE="$(findmnt -no SOURCE /)"

if [[ "$ROOT_SOURCE" == "$REAL_DISK"* ]]; then
    error "This appears to be the currently running system disk!"
fi

# ------------------------------------------------------------
# Show final plan
# ------------------------------------------------------------

echo
echo "============================================================"
echo "FINAL PARTITIONING PLAN"
echo "============================================================"
echo
echo "Disk:"
echo "  $REAL_DISK"
echo
echo "EFI:"
echo "  1 GiB"
echo
echo "Btrfs:"
echo "  remaining space"
echo
echo "Swap:"
echo "  $SWAP_SIZE"
echo "  END OF DISK"
echo
echo "Btrfs subvolumes:"
echo "  @       -> /"
echo "  @home   -> /home"
echo "  @games  -> /games"
echo "  @nix    -> /nix"
echo
echo "============================================================"
echo
echo "WARNING: ALL DATA ON THIS DISK WILL BE DESTROYED!"
echo

read -rp "Type YES to continue: " CONFIRM

[[ "$CONFIRM" == "YES" ]] || {
    echo "Aborted."
    exit 0
}

# ------------------------------------------------------------
# Partition names
# ------------------------------------------------------------

case "$REAL_DISK" in
    /dev/nvme*|/dev/mmcblk*)
        EFI="${REAL_DISK}p1"
        ROOT="${REAL_DISK}p2"
        SWAP="${REAL_DISK}p3"
        ;;
    *)
        EFI="${REAL_DISK}1"
        ROOT="${REAL_DISK}2"
        SWAP="${REAL_DISK}3"
        ;;
esac

# ------------------------------------------------------------
# Unmount
# ------------------------------------------------------------

echo
echo "Unmounting existing filesystems..."

swapoff -a 2>/dev/null || true
umount -R /mnt 2>/dev/null || true

# ------------------------------------------------------------
# Wipe
# ------------------------------------------------------------

echo "Wiping old partition information..."

wipefs -af "$REAL_DISK"

# ------------------------------------------------------------
# Create GPT
# ------------------------------------------------------------

echo "Creating GPT..."

parted -s "$REAL_DISK" --script --align optimal \
    mklabel gpt \
    mkpart "${MACHINE_NAME}-EFI" fat32 1MiB 1025MiB \
    set 1 esp on \
    mkpart "${MACHINE_NAME}-NIXOS" btrfs 1025MiB "${SWAP_START_MIB}MiB" \
    mkpart "${MACHINE_NAME}-SWAP" linux-swap "${SWAP_START_MIB}MiB" 100%

partprobe "$REAL_DISK"
udevadm settle

# ------------------------------------------------------------
# Format EFI
# ------------------------------------------------------------

echo "Formatting EFI..."

mkfs.fat -F32 -n efi "$EFI"

# ------------------------------------------------------------
# Format Btrfs
# ------------------------------------------------------------

echo "Formatting Btrfs..."

mkfs.btrfs -f -L nixos "$ROOT"

# ------------------------------------------------------------
# Format swap
# ------------------------------------------------------------

echo "Formatting swap..."

mkswap -L swap "$SWAP"

# ------------------------------------------------------------
# Create Btrfs subvolumes
# ------------------------------------------------------------

echo "Creating Btrfs subvolumes..."

mount "$ROOT" /mnt

btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@games
btrfs subvolume create /mnt/@nix

umount /mnt




# ------------------------------------------------------------
# Mount root
# ------------------------------------------------------------

echo "Mounting filesystems..."

mount \
    -o subvol=@,compress=zstd,noatime \
    "$ROOT" /mnt

mkdir -p /mnt/home
mkdir -p /mnt/games
mkdir -p /mnt/nix
mkdir -p /mnt/boot

mount \
    -o subvol=@home,compress=zstd,noatime \
    "$ROOT" /mnt/home

mount \
    -o subvol=@games,compress=zstd,noatime \
    "$ROOT" /mnt/games

mount \
    -o subvol=@nix,compress=zstd,noatime \
    "$ROOT" /mnt/nix

# ------------------------------------------------------------
# Mount EFI
# ------------------------------------------------------------

mount "$EFI" /mnt/boot

# ------------------------------------------------------------
# Enable swap
# ------------------------------------------------------------

swapon "$SWAP"

# ------------------------------------------------------------
# Done
# ------------------------------------------------------------

echo
echo "============================================================"
echo "PARTITIONING COMPLETE"
echo "============================================================"
echo

lsblk -o NAME,SIZE,TYPE,FSTYPE,LABEL,MOUNTPOINTS "$REAL_DISK"

echo
echo "Btrfs subvolumes:"
btrfs subvolume list /mnt

echo
echo "Swap:"
swapon --show

echo
echo "Everything is mounted under /mnt."
echo
echo "Next:"
echo
echo "  nixos-generate-config --root /mnt"
echo "  nixos-install"
echo
