let
  diskoCommon = import ../common/disco.nix;
in
diskoCommon {
  disk = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";
  swapSize = "16G";
}