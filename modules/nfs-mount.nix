{pkgs, ...}: {

  environment.systemPackages = [
    pkgs.nfs-utils
    pkgs.autofs5
  ];

  services.autofs = {
    enable = true;

    autoMaster = let
      mapNasConf = pkgs.writeText "autofs.nas.mnt" ''
        BackupVault -fstype=nfs4,rw,hard,intr,tcp 10.5.1.20:/fs/1000/nfs/BackupVault
        MediaVault -fstype=nfs4,rw,hard,intr,tcp 10.5.1.20:/fs/1000/nfs/MediaVault
      '';
    in ''
      /mnt/nas ${mapNasConf} --timeout=20
    '';
  };
  environment.etc."autofs.conf".text = ''
    TIMEOUT=20
    BROWSE_MODE=no
  '';
}