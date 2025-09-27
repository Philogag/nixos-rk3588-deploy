{ config, ... }: {

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
  };
  environment.etc."docker/daemon.json".text = ''
  {
    "data-root": "/opt/docker",
    "registry-mirrors": [
        "https://docker.m.daocloud.io",
        "https://docker.1ms.run"
    ]
  }
  '';

}