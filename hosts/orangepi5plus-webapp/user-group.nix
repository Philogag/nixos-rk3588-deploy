let
  username = "philogag";
  hostName = "orangepi5plus-webapp";
  # To generate a hashed password run `mkpasswd -m scrypt`.
  hashedPassword = "$7$CU..../....W7OB8WC2eZgIiVfT8G/Ed/$ePdgT.bfMzIyuQWeImKAzedoW1vJrQD41KNICeP6gi1";
in {
  # =========================================================================
  #      Users & Groups NixOS Configuration
  # =========================================================================

  networking.hostName = hostName;

  users.users."${username}" = {
    inherit hashedPassword;
    isNormalUser = true;
    home = "/home/${username}";
    extraGroups = ["users" "wheel" "docker"];
  };

  users.groups = {
    "${username}" = {};
    docker = {};
  };
}
