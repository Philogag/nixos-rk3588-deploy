{
  description = "NixOS configuration for rk3588 remote deployment with UEFI and U-Boot options";

  inputs = {
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    # nixos-rk3588.url = "path:.."; # For local testing
    nixos-rk3588.url = "github:Philogag/nixos-rk3588-template";  # For production
  };

  outputs = {nixos-rk3588, disko, ...}: let
    inherit (nixos-rk3588.inputs) nixpkgs;
    # choose your rk3588 SBC model
    boardModule = nixos-rk3588.nixosModules.orangepi5;

    # Define system architecture and different compilation options.
    bootType = "uefi"; # Change to "u-boot" for U-Boot

    # Possible values for compilationType: "local-native", "remote-native", or "cross".
    compilationType = "cross"; # Choose the compilation type here.

    localSystem = "x86_64-linux";
    targetSystem = "aarch64-linux";

    # Kernel packages based on compilationType (local native, remote native, or cross-compilation)
    pkgsKernel =
      if compilationType == "cross"
      then
        import nixpkgs {
          inherit localSystem;
          crossSystem = targetSystem;
        }
      else
        # For both local-native & remote-native compilation
        import nixpkgs {system = targetSystem;};

    # Define bootloader based on bootType (UEFI or U-Boot)
    bootloaderModule =
      if bootType == "uefi"
      then {
        # grub bootloader configured for UEFI
        boot = {
          # growPartition = true;  # If partition resizing is necessary
          kernelParams = ["console=ttyS0"]; # If you need serial console access
          # loader.timeout = lib.mkDefault 0;  # Optional, to skip GRUB menu
          initrd.availableKernelModules = ["uas"]; # If specific kernel modules are required
          loader.grub = {
            enable = true;
            device = "nodev";
            efiSupport = true;
            efiInstallAsRemovable = true;
          };
        };
      }
      else
        # U-Boot configuration using sd-image
        boardModule.sd-image;
  in {
    colmena = {
      meta = {
        nixpkgs = import nixpkgs {system = localSystem;};
        specialArgs = {
          rk3588 = {
            inherit nixpkgs pkgsKernel;
          };
          inherit nixpkgs;
        };
      };

      # to apply locally this "opi5" must match your local host name, such as "orangepi5" or "orangepi5plus"
      orangepi5plus-webapp = {
        deployment.targetHost =
          if compilationType != "local-native"
          then "10.5.1.10"
          else null;
        deployment.targetUser =
          if compilationType != "local-native"
          then "root"
          else null;

        # Allow local deployment only if building locally
        deployment.allowLocalDeployment = compilationType == "local-native";

        imports = [
          # import the rk3588 module, which contains the configuration for bootloader/kernel/firmware
          boardModule.core

          # Import the correct bootloader based on the selected bootType.
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
