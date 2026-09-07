{ config, pkgs, desktopEnviroment, ... }:

{
  services.xserver.enable = desktopEnviroment == "mate";
  services.xserver.desktopManager.mate.enable = desktopEnviroment == "mate";
  services.xserver.displayManager.lightdm.enable = desktopEnviroment == "mate";
}