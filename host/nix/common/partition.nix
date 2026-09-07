{ config, pkgs, machineName, ... }:

let
  efiPartition = "/dev/disk/by-partlabel/${machineName^^}-EFI";
  nixosPartition = "/dev/disk/by-partlabel/${machineName^^}-NIXOS";
  swapPartition = "/dev/disk/by-partlabel/${machineName^^}-SWAP";
in
{
  fileSystems."/" = {
    device = nixosPartition;
    fsType = "btrfs";
    options = [ "subvol=@" "compress=zstd" "noatime" ];
  };

  fileSystems."/home" = {
    device = nixosPartition;
    fsType = "btrfs";
    options = [ "subvol=@home" "compress=zstd" "noatime" ];
  };

  fileSystems."/games" = {
    device = nixosPartition;
    fsType = "btrfs";
    options = [ "subvol=@games" "compress=zstd" "noatime" ];
  };

  fileSystems."/nix" = {
    device = nixosPartition;
    fsType = "btrfs";
    options = [ "subvol=@nix" "compress=zstd" "noatime" ];
  };

  fileSystems."/boot" = {
    device = efiPartition;
    fsType = "vfat";
  };

  swapDevices = [
    { device = swapPartition; }
  ];
}