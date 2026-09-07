{ config, pkgs, ... }:

let
  # PROXMOXVM
  host = import ./proxmoxvm/configuration.nix;
in
{
  imports = [
    ./common/configuration.nix
  ];

  _module.args.machineName = host.machineName;

  system.stateVersion = "26.11";
}
