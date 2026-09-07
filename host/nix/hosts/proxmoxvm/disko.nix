let
  commonDisko = import ../../common/disko.unencrypted.nix;
in
commonDisko {
  disk = "/dev/disk/by-id/scsi-0QEMU_QEMU_HARDDISK_drive-scsi0";
  swapSize = "4G";
}