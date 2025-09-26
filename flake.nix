{
  description = "NixOS configuration for rk3588 remote deployment with UEFI";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    nixos-rk3588.url = "github:Philogag/nixos-rk3588-template";
  };

  outputs = { self, nixos-rk3588, disko, ...}: let
    inherit (nixos-rk3588.inputs) nixpkgs;
    # choose your rk3588 SBC model
    boardModule = nixos-rk3588.nixosModules.orangepi5plus;

    # System architecture
    system = "aarch64-linux";

    # UEFI bootloader configuration
    bootloaderModule = {
      boot = {
        kernelParams = ["console=ttyS0"];
        initrd.availableKernelModules = ["uas"];
        loader.grub = {
          enable = true;
          device = "nodev";
          efiSupport = true;
          efiInstallAsRemovable = true;
        };
      };
    };

    # Import nixpkgs
    pkgs = import nixpkgs { system = system; };
  in {
    nixosConfigurations = {
      orangepi5plus-webapp = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          # import the rk3588 module, which contains the configuration for bootloader/kernel/firmware
          nixos-rk3588.nixosModules.orangepi5plus.core

          # UEFI bootloader
          bootloaderModule

          # import disko for disk init and mount
          disko.nixosModules.disko

          # Custom configuration
          ./hosts/orangepi5plus-webapp
        ];
      };
    };
  };
}