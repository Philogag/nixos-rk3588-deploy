# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      ./configuration.nix
      ./user-group.nix
      ./disko-config.nix

      # modules selected
      ../../modules/nfs-mount.nix
      ../../modules/service.docker.nix
      ../../modules/service.ssh.nix
    ];
}
