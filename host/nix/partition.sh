```bash
#!/usr/bin/env bash
set -euo pipefail

# ============================================================
# NixOS disk partitioning
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
#   └── swap  <SWAP_SIZE> at the END of the disk
#
# Usage:
#   ./partition.sh /dev/disk/by-id/nvme-XXX 40G
#   ./partition.sh /dev/disk/by-id/ata-XXX 16G
#
# WARNING: EVERYTHING ON THE SELECTED DISK WILL BE DESTROYED.
# ============================================================

EFI_SIZE_MIB=1024
EFI_START_MIB=1

DISK="${1:-}"
SWAP_SIZE="${2:-40G}"

error() {
    echo
    echo "ERROR: $*" >&2
    exit 1
}

cleanup_mounts() {
    swapoff -a 2>/dev/null || true
    umount -R /mnt 2>/dev/null || true
}

# ------------------------------------------------------------
# Convert G/M to MiB
# ------------------------------------------------------------

size_to_mib() {
    local size="$1"

    if [[ "$size" =~ ^([0-9]+)([Gg])$ ]]; then
        echo $(( ${BASH_REMATCH[1]} * 1024 ))
    elif [[ "$size" =~ ^([0-9]+)([Mm])$ ]]; then
        echo "${BASH_REMATCH[1]}"
    else
        error "Invalid swap size '$size'. Use e.g. 16G, 32G or 40G."
    fi
}

# ------------------------------------------------------------
# Arguments
# ------------------------------------------------------------

[[ -n "$DISK" ]] || error \
    "Usage: $0 /dev/disk/by-id/DEVICE 40G"

[[ -b "$DISK" ]] || error \
    "'$DISK' is not a block device."

[[ $EUID -eq 0 ]] || error \
    "Run this script as root."

SWAP_MIB="$(size_to_mib "$SWAP_SIZE")"

# ------------------------------------------------------------
# Resolve /dev/disk/by-id/...
# ------------------------------------------------------------

REAL_DISK="$(readlink -f "$DISK")"

echo
echo "Selected disk:"
echo "  $DISK"
echo "  -> $REAL_DISK"
echo

# ------------------------------------------------------------
# Disk size
# ------------------------------------------------------------

DISK_BYTES="$(blockdev --getsize64 "$REAL_DISK")"
DISK_MIB=$((DISK_BYTES / 1024 / 1024))

MIN_DISK_MIB=$((EFI_SIZE_MIB + SWAP_MIB + 4096))

if (( DISK_MIB < MIN_DISK_MIB )); then
    error "Disk is too small.

Required: ${MIN_DISK_MIB} MiB
Available: ${DISK_MIB} MiB"
fi

# ------------------------------------------------------------
# Show disk
# ------------------------------------------------------------

lsblk -o NAME,SIZE,MODEL,SERIAL,TYPE,FSTYPE,MOUNTPOINTS "$REAL_DISK"

echo
echo "Partitioning plan:"
echo
echo "  EFI:        1 GiB"
echo "  Btrfs:      remaining space"
echo "  Swap:       $SWAP_SIZE (at END of disk)"
echo

# ------------------------------------------------------------
# Safety check
# ------------------------------------------------------------

ROOT_SOURCE="$(findmnt -no SOURCE /)"

if [[ "$ROOT_SOURCE" == "$REAL_DISK"* ]]; then
    error "Selected disk appears to contain the currently running root filesystem."
fi

echo "ALL DATA ON THIS DISK WILL BE DESTROYED."
echo

read -rp "Type exactly: ERASE $REAL_DISK : " CONFIRM

if [[ "$CONFIRM" != "ERASE $REAL_DISK" ]]; then
    echo "Aborted."
    exit 1
fi

# ------------------------------------------------------------
# Unmount existing filesystems
# ------------------------------------------------------------

echo
echo "Unmounting existing filesystems..."

cleanup_mounts

# ------------------------------------------------------------
# Partition names
# ------------------------------------------------------------

case "$REAL_DISK" in
    /dev/nvme*|/dev/mmcblk*)
        P1="${REAL_DISK}p1"
        P2="${REAL_DISK}p2"
        P3="${REAL_DISK}p3"
        ;;
    *)
        P1="${REAL_DISK}1"
        P2="${REAL_DISK}2"
        P3="${REAL_DISK}3"
        ;;
esac

# ------------------------------------------------------------
# Wipe old signatures
# ------------------------------------------------------------

echo "Wiping old filesystem signatures..."

wipefs -af "$REAL_DISK"

# ------------------------------------------------------------
# Calculate partition positions
#
# EFI:
#   1 MiB → 1025 MiB
#
# Btrfs:
#   1025 MiB → SWAP_START
#
# Swap:
#   SWAP_START → END
# ------------------------------------------------------------

SWAP_START_MIB=$((DISK_MIB - SWAP_MIB))

if (( SWAP_START_MIB <= EFI_SIZE_MIB + 1024 )); then
    error "Not enough space for Btrfs."
fi

# ------------------------------------------------------------
# Create GPT
# ------------------------------------------------------------

echo "Creating GPT partition table..."

parted -s "$REAL_DISK" \
    mklabel gpt \
    mkpart ESP fat32 "${EFI_START_MIB}MiB" "${EFI_SIZE_MIB}MiB" \
    set 1 esp on \
    mkpart root btrfs "${EFI_SIZE_MIB}MiB" "${SWAP_START_MIB}MiB" \
    mkpart swap linux-swap "${SWAP_START_MIB}MiB" 100%

partprobe "$REAL_DISK"
udevadm settle

# ------------------------------------------------------------
# Format EFI
# ------------------------------------------------------------

echo "Formatting EFI..."

mkfs.fat -F 32 -n efi "$P1"

# ------------------------------------------------------------
# Format Btrfs
# ------------------------------------------------------------

echo "Formatting Btrfs..."

mkfs.btrfs -f -L nixos "$P2"

# ------------------------------------------------------------
# Format swap
# ------------------------------------------------------------

echo "Formatting swap..."

mkswap -L swap "$P3"

# ------------------------------------------------------------
# Create Btrfs subvolumes
# ------------------------------------------------------------

echo "Creating Btrfs subvolumes..."

mount "$P2" /mnt

btrfs subvolume create /mnt/@
btrfs subvolume create /mnt/@home
btrfs subvolume create /mnt/@games
btrfs subvolume create /mnt/@nix

umount /mnt

# ------------------------------------------------------------
# Mount Btrfs
# ------------------------------------------------------------

echo "Mounting Btrfs..."

mount \
    -o subvol=@,compress=zstd,noatime \
    "$P2" /mnt

mkdir -p \
    /mnt/home \
    /mnt/games \
    /mnt/nix \
    /mnt/boot

mount \
    -o subvol=@home,compress=zstd,noatime \
    "$P2" /mnt/home

mount \
    -o subvol=@games,compress=zstd,noatime \
    "$P2" /mnt/games

mount \
    -o subvol=@nix,compress=zstd,noatime \
    "$P2" /mnt/nix

# ------------------------------------------------------------
# Mount EFI
# ------------------------------------------------------------

mount "$P1" /mnt/boot

# ------------------------------------------------------------
# Enable swap
# ------------------------------------------------------------

swapon "$P3"

# ------------------------------------------------------------
# Result
# ------------------------------------------------------------

echo
echo "============================================================"
echo "DONE"
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
echo "Mounts:"
findmnt /mnt
findmnt /mnt/home
findmnt /mnt/games
findmnt /mnt/nix
findmnt /mnt/boot

echo
echo "UUIDs:"
blkid "$P1" "$P2" "$P3"

echo
echo "The filesystem is ready for NixOS."
echo
echo "Next:"
echo
echo "  nixos-generate-config --root /mnt"
echo "  nixos-install"
echo
```
