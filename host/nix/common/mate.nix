{ config, pkgs, ... }:

{
  services.xserver.enable = true;
  services.xserver.desktopManager.mate.enable = true;
  services.xserver.displayManager.lightdm.enable = true;
}