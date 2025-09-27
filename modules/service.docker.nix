{ config, ... }: {

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;

    daemon.settings = {
      data-root = "/opt/docker";
      registry-mirrors = [
        "https://docker.m.daocloud.io"
        "https://docker.1ms.run"
      ]
    };
  };
}