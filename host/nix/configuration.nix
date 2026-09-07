{ config, pkgs, ... }:

let
  # PROXMOXVM
  host = import ./proxmoxvm/configuration.nix;
in
{
  imports = [
    ./hardware-configuration.nix
    ./common/partition.nix
    ./common/configuration.nix
  ];

  _module.args.machineName = host.machineName;

  system.stateVersion = "26.11";
}
