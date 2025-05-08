{ config, lib, pkgs, ... }:

let
  cfg = config.personal.wireguard;
in
{
  options.personal.wireguard = {
    enable = lib.mkEnableOption "wireguard";
  };

  config = lib.mkIf cfg.enable {
    # enable NAT
    networking.nat.enable = true;
    networking.nat.externalInterface = "br0";
    networking.nat.internalInterfaces = [ "wg0" ];
    networking.firewall = {
      allowedUDPPorts = [ 51820 ];
    };

    networking.wireguard.interfaces = {
      # "wg0" is the network interface name. You can name the interface arbitrarily.
      wg0 = {
        # Determines the IP address and subnet of the server's end of the tunnel interface.
        ips = [ "10.100.0.1/24" ];

        # The port that WireGuard listens to. Must be accessible by the client.
        listenPort = 51820;

        # This allows the wireguard server to route your traffic to the internet and hence be like a VPN
        # For this to work you have to set the dnsserver IP of your router (or dnsserver of choice) in your clients
        postSetup = ''
          ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o enp5s0 -j MASQUERADE
        '';

        # This undoes the above command
        postShutdown = ''
          ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o enp5s0 -j MASQUERADE
        '';

        # Path to the private key file.
        #
        # Note: The private key can also be included inline via the privateKey option,
        # but this makes the private key world-readable; thus, using privateKeyFile is
        # recommended.
        privateKeyFile = "/etc/wireguard/private_key";
        generatePrivateKeyFile = true;

        peers = [
          # List of allowed peers.
          { # Galaxy Fold
            publicKey = "C2Mn8LCkg8lLUp8mI4eqnQ8XpUZ+0c+qkC+qUgjmKFg=";
            # List of IPs assigned to this peer within the tunnel subnet. Used to configure routing.
            allowedIPs = [ "10.100.0.2/32" ];
          }
          { # Sofia
            publicKey = "5Dnedbi81GpRqFj2wdan4oHYEbnh/MlKCacoXEraoDY=";
            allowedIPs = [ "10.100.0.3/32" ];
          }
          { # Sofia Tablet
            publicKey = "8JUv3YNXTnidDB2xcPsgLRAyCot9FIECtsDQBi2Iwws=";
            allowedIPs = [ "10.100.0.4/32" ];
          }
          { # Sofia Notebook
            publicKey = "iLItoeiRiKfAy428oUgAgSHgfoD5gGOj6GiPqkRXPhY=";
            allowedIPs = [ "10.100.0.5/32" ];
          }
          { # Omen Windows
            publicKey = "/l/SZu14CLhxG651iAll7MU2QeOa/tByBh8Fvz/B1gQ=";
            allowedIPs = [ "10.100.0.6/32" ];
          }
          { # Steam Deck
            publicKey = "IE68MmDZCef9+52PQz0hZbQMD2WAF0j5EE2Lz+03exc=";
            allowedIPs = [ "10.100.0.7/32" ];
          }
        ];
      };
    };
  };
}
