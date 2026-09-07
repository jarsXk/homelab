{ config, pkgs, machineName, ... }:

let
  efiPartition = "/dev/disk/by-partlabel/${machineName}-EFI";
  nixosPartition = "/dev/disk/by-partlabel/${machineName}-NIXOS";
  swapPartition = "/dev/disk/by-partlabel/${machineName}-SWAP";
in
{

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

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

  services.xserver.enable = true;
  services.xserver.desktopManager.mate.enable = true;
  services.xserver.displayManager.lightdm.enable = true;

  environment.systemPackages = with pkgs; [
    mc
    htop
    micro
  ];

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "ru_RU.UTF-8";

  users.users.lesha = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  security.sudo.wheelNeedsPassword = true;
}