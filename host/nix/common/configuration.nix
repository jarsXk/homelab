{ config, pkgs ... }:

{

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.xserver.enable = true;
  services.xserver.desktopManager.mate.enable = true;
  
  services.displayManager.lightdm.enable = true;

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