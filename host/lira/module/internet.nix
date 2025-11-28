{
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both";
  };

  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  networking.firewall = {
    enable = true;
    trustedInterfaces = [ "tailscale0" ];
    allowedUDPPorts = [ 41641 ]; # Tailscale port
  };
}
