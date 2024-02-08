{ config, options, lib, pkgs, ... }:

with lib;

let
  cfg = config.personal.ssh;
in
{
  options.personal.ssh = {
    enable = mkEnableOption "ssh";
    withAuthorizationKeys = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Adds the authorization keys to the correct file
      '';
    };
  };

  config = mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      extraConfig = ''
        Host github.com
        Hostname ssh.github.com
        Port 443
      '';
    };

    home.file.".ssh/authorized_keys" = mkIf cfg.withAuthorizationKeys {
      text = ''
        ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC8rhqit1j9KhWWR2/gJn3sasBlAL4NFb6p2beKs0K39UqR4yMOnWtnR4O8DemdugsW1d1lmUVbBV+Rz6Ma6izccrzImO5q8mY1Rr6kZ2Id2++dl+Gf116r4VxexYrS6pGYy4unDXQCcmV+w5wfuI362Zi1NoLUJU6QY2p7scJhTpl2ONcp+6HA+h+DgMADcZjLWsFn2mKgl4SUoyhrguwXCPMXL8VUaso2tuBP/v7d4PD5GFUD0vqD5KO4Fqy9amFPkUvr1T/u4MrrbSbjO//4BmLbOZaN+CI9LNSL/svSAdCRuwzJrBPiJdAC1HhgX4Y4y/6iTcwPaSRGshguq5DuB2Usvhy01I3erOV/u88VUQU82P6yWTbIZWlzwQ3PCbMfjzRwrsvHFl0F//gejqvdH1CFDDTp6NScTMzK6a+rtosHADkFLFnriTPoi2kQbEHdb7P5WOofQP/7EHsB/5saqLy/pL1ZkgUZQTnoDIwa8Xh0nsJtYDzoXFHXQ5usnuc= pablo@t14s
        ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDcSvBDE5Rc5M1GeHC4UlDYsW51Hv32SxhuMqKW4DXKwQgDyp+mzsthLYfpF5f3UVx3JdvHRBB+A4ve430eSxnvNJjHy7amBV1x5B9mpWLM7/IQrrzgC6w2f3UM03iAEZpiGvOe+OmC7IpQu9oDukTLYZhpYv0nt4sXOcb3pYjfSnMo8LdeCEIYqYYqeb+I/Z9gmuSflOci0DZJHBA3jrL7TVpVQ1h+83+mxpZps6sIsSJ/cMbkSjo2FmDP5dkiRKYMEAZXnIXicw1HAOU5X+Jrd5GjUBBtaR3njyRv/Qxlk7bHk8QazZuRm0GT82zjtTGI4niEwFy2aTXQXbLZeQXB1WiYVxF+DICcQ3LkqojtWs0nJiR0Qk7W/YjZH18Vno+4FKLo3SMKpQSLtDclsA2i0JBod41Z2DWPS72AfMhgknp3vn5h++5WcNsTk8dhVCl3prDgZfkphodMGA45Eil/v6AG5/FEy8kpOLpXGJJPgFhZ+DVrDy8Ut3QlI3cjtF8= nix-on-droid@localhost
        ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC9fzmsBd5E3cJ8RLVo39IEUa/KfNBiyx6bO4+h+BYz+vI69MmDf60ooQGSoOoXviZ3li4MQ4N7kuH1Ic6ngvdaLwyOF+eOQxHLYRSP7c65ftwjiC6IQZS489s+LaMHf7eFk4aRA1XImAO8pzWxRPZRoIP916lyWW+Urp9vODEWYAwvA1GFTjtd/0/vZ8pitgyizVi7hR9rXnWqivnZRkB66Aqt43vVF0bPh5Ln6id4u1sKEomb5YTrm14O9HlFBAIs6hN9kfl8yFFd1Q1qrXruKxKN4LEiMMuSHyH/Y/48Q87Q0WjrZc2x9WSDvcVZQFdVvtxAfgk46HfvY9+BRRvZhACKFTeg3MmfZeH9s979mg5/7HHBEflJxgo60yUicPOqT9yUS7xfYdDlCqL7KhrH3lHNAlI7CWNAJpKgsnRktgFylugx3qA5lli2BfpClSEhp7kxcMUhP9vMCg7vKXCOlrn/2qDIiC8z8cBi76Hu2A1Vn18EpRE2k3vKmEblbk0= pablo.dealbera.ctr@MacBook-Pro.local
      '';
    };
  };
}
