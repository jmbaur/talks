{ nixosTest, curl }:
nixosTest {
  nodes.serviceA = { };
  nodes.serviceB = {
    services.nginx.enable = true;
    networking.firewall.allowedTCPPorts = [ 80 ];
  };
  # python code
  testScript = ''
    start_all()
    serviceB.wait_for_unit("nginx.service")
    print(serviceA.succeed(
      "${curl}/bin/curl http://serviceB"
    ))
  '';
}
