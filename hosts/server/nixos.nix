{ modulesPath, config, lib, pkgs, ... }:

{
  personal.syncthing.enable = true;
  personal.photoprism.enable = true;
  personal.homepage-dashboard.enable = true;
  personal.duckdns.enable = true;

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  services.openssh = {
    enable = true;
    ports = [ 22 2205 ];
  };

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
  ];

  users.mutableUsers = false;

  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC8rhqit1j9KhWWR2/gJn3sasBlAL4NFb6p2beKs0K39UqR4yMOnWtnR4O8DemdugsW1d1lmUVbBV+Rz6Ma6izccrzImO5q8mY1Rr6kZ2Id2++dl+Gf116r4VxexYrS6pGYy4unDXQCcmV+w5wfuI362Zi1NoLUJU6QY2p7scJhTpl2ONcp+6HA+h+DgMADcZjLWsFn2mKgl4SUoyhrguwXCPMXL8VUaso2tuBP/v7d4PD5GFUD0vqD5KO4Fqy9amFPkUvr1T/u4MrrbSbjO//4BmLbOZaN+CI9LNSL/svSAdCRuwzJrBPiJdAC1HhgX4Y4y/6iTcwPaSRGshguq5DuB2Usvhy01I3erOV/u88VUQU82P6yWTbIZWlzwQ3PCbMfjzRwrsvHFl0F//gejqvdH1CFDDTp6NScTMzK6a+rtosHADkFLFnriTPoi2kQbEHdb7P5WOofQP/7EHsB/5saqLy/pL1ZkgUZQTnoDIwa8Xh0nsJtYDzoXFHXQ5usnuc= pablo@t14s"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDcSvBDE5Rc5M1GeHC4UlDYsW51Hv32SxhuMqKW4DXKwQgDyp+mzsthLYfpF5f3UVx3JdvHRBB+A4ve430eSxnvNJjHy7amBV1x5B9mpWLM7/IQrrzgC6w2f3UM03iAEZpiGvOe+OmC7IpQu9oDukTLYZhpYv0nt4sXOcb3pYjfSnMo8LdeCEIYqYYqeb+I/Z9gmuSflOci0DZJHBA3jrL7TVpVQ1h+83+mxpZps6sIsSJ/cMbkSjo2FmDP5dkiRKYMEAZXnIXicw1HAOU5X+Jrd5GjUBBtaR3njyRv/Qxlk7bHk8QazZuRm0GT82zjtTGI4niEwFy2aTXQXbLZeQXB1WiYVxF+DICcQ3LkqojtWs0nJiR0Qk7W/YjZH18Vno+4FKLo3SMKpQSLtDclsA2i0JBod41Z2DWPS72AfMhgknp3vn5h++5WcNsTk8dhVCl3prDgZfkphodMGA45Eil/v6AG5/FEy8kpOLpXGJJPgFhZ+DVrDy8Ut3QlI3cjtF8= nix-on-droid@localhost"
    ];
    hashedPassword = "$y$j9T$LjnlfD3.zXLMqTZ00Rl2p0$SDavtIWFF1ZgjRu6hH59bngEimTwaZg4kpv80GzyhQ.";
  };

  users.users.pablo = {
    isNormalUser = true;
    home = "/home/pablo";
    extraGroups = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC8rhqit1j9KhWWR2/gJn3sasBlAL4NFb6p2beKs0K39UqR4yMOnWtnR4O8DemdugsW1d1lmUVbBV+Rz6Ma6izccrzImO5q8mY1Rr6kZ2Id2++dl+Gf116r4VxexYrS6pGYy4unDXQCcmV+w5wfuI362Zi1NoLUJU6QY2p7scJhTpl2ONcp+6HA+h+DgMADcZjLWsFn2mKgl4SUoyhrguwXCPMXL8VUaso2tuBP/v7d4PD5GFUD0vqD5KO4Fqy9amFPkUvr1T/u4MrrbSbjO//4BmLbOZaN+CI9LNSL/svSAdCRuwzJrBPiJdAC1HhgX4Y4y/6iTcwPaSRGshguq5DuB2Usvhy01I3erOV/u88VUQU82P6yWTbIZWlzwQ3PCbMfjzRwrsvHFl0F//gejqvdH1CFDDTp6NScTMzK6a+rtosHADkFLFnriTPoi2kQbEHdb7P5WOofQP/7EHsB/5saqLy/pL1ZkgUZQTnoDIwa8Xh0nsJtYDzoXFHXQ5usnuc= pablo@t14s"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDcSvBDE5Rc5M1GeHC4UlDYsW51Hv32SxhuMqKW4DXKwQgDyp+mzsthLYfpF5f3UVx3JdvHRBB+A4ve430eSxnvNJjHy7amBV1x5B9mpWLM7/IQrrzgC6w2f3UM03iAEZpiGvOe+OmC7IpQu9oDukTLYZhpYv0nt4sXOcb3pYjfSnMo8LdeCEIYqYYqeb+I/Z9gmuSflOci0DZJHBA3jrL7TVpVQ1h+83+mxpZps6sIsSJ/cMbkSjo2FmDP5dkiRKYMEAZXnIXicw1HAOU5X+Jrd5GjUBBtaR3njyRv/Qxlk7bHk8QazZuRm0GT82zjtTGI4niEwFy2aTXQXbLZeQXB1WiYVxF+DICcQ3LkqojtWs0nJiR0Qk7W/YjZH18Vno+4FKLo3SMKpQSLtDclsA2i0JBod41Z2DWPS72AfMhgknp3vn5h++5WcNsTk8dhVCl3prDgZfkphodMGA45Eil/v6AG5/FEy8kpOLpXGJJPgFhZ+DVrDy8Ut3QlI3cjtF8= nix-on-droid@localhost"
    ];
    hashedPassword = "$y$j9T$LjnlfD3.zXLMqTZ00Rl2p0$SDavtIWFF1ZgjRu6hH59bngEimTwaZg4kpv80GzyhQ.";
  };

  services.avahi = {
    enable = true;
    nssmdns = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
  };
  networking.firewall.enable = false;

  services.getty.greetingLine = ''
    Welcome to my Server!

    If you want to connect with this computer via SSH, you can use the following command:
    ssh root@${config.networking.hostName}.local

    IP Address: \4{enp4s0}
  '';
  environment.etc."issue.d/ip.issue".text = "\\4\n";
  networking.dhcpcd.runHook = "${pkgs.utillinux}/bin/agetty --reload";

  system.stateVersion = "23.11";
}
