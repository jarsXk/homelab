{
  description = "Общая конфигурация NixOS для всех ПК";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, disko, ... }:
    {
      nixosConfigurations = {

        test = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            disko.nixosModules.disko

            ./common/configuration.nix
            ./hosts/test/configuration.nix
            ./hosts/test/hardware.nix
            ./hosts/test/disko.nix
          ];
        };

        proxmoxvm = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            disko.nixosModules.disko

            ./common/configuration.nix
            ./hosts/proxmoxvm/configuration.nix
            ./hosts/proxmoxvm/hardware.nix
            ./hosts/proxmoxvm/disko.nix
          ];
        };
      };
    };
}