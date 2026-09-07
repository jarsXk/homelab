{ config, pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  config = lib.mkIf (desktopEnviroment == "mate") {
    imports = [
      ./mate.nix
    ];
  };
  
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