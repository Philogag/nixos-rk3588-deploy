{
  config,
  pkgs,
  nixpkgs,
  ...
}: {
  # =========================================================================
  #      Base NixOS Configuration
  # =========================================================================

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  nix.settings = {
    # Manual optimise storage: nix-store --optimise
    # https://nixos.org/manual/nix/stable/command-ref/conf-file.html#conf-auto-optimise-store
    auto-optimise-store = true;
    builders-use-substitutes = true;
    # enable flakes globally
    experimental-features = ["nix-command" "flakes"];
  };

  # make `nix run nixpkgs#nixpkgs` use the same nixpkgs as the one used by this flake.
  nix.registry.nixpkgs.flake = nixpkgs;
  # make `nix repl '<nixpkgs>'` use the same nixpkgs as the one used by this flake.
  environment.etc."nix/inputs/nixpkgs".source = "${nixpkgs}";
  nix.nixPath = ["/etc/nix/inputs"];

  environment.systemPackages = with pkgs; [
    neovim
    neofetch
    ncdu
    colmena

    # download
    wget
    curl
    git

    # archives
    zip
    xz
    unzip
    p7zip
    zstd
    gnutar

    # misc
    file
    which
    tree
    gawk
    jq
    docker-compose
  ];

  # replace default editor with neovim
  environment.variables.EDITOR = "nvim";
  programs.neovim = {
    viAlias = true;
    vimAlias = true;
  };

  system.stateVersion = "25.05";
}
