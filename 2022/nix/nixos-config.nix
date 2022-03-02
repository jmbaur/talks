{ config, ... }: {
  services.nginx.enable = true;
  services.postgresql.enable = true;
  networking.firewall.allowedTCPPorts = [
    config.services.postgresql.port
  ];
}
