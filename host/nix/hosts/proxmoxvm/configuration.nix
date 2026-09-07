{ config, pkgs, ... }:

{
  networking.hostName = "nixtest";

  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
}