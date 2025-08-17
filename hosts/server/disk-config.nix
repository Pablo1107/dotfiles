# Example to create a bios compatible gpt partition
{ lib, ... }:
{
  disko.devices = {
    disk.disk1 = {
      device = lib.mkDefault "/dev/nvme0n1";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            name = "boot";
            size = "1M";
            type = "EF02";
          };
          esp = {
            name = "ESP";
            size = "500M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          plainSwap = {
            size = "69G";
            content = {
              type = "swap";
              resumeDevice = true; # resume from hiberation from this device
            };
          };
          root = {
            name = "root";
            size = "100%";
            content = {
              type = "lvm_pv";
              vg = "pool";
            };
          };
        };
      };
    };
    disk.disk2 = {
      device = lib.mkDefault "/dev/sda";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          data = {
            name = "data";
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [ "-L" "data" "-f" ];
              subvolumes = {
                "/data" = {
                  mountpoint = "/data";
                  mountOptions = [
                    "compress=zstd"
                  ];
                };
                "/windows" = {
                  mountpoint = "/windows";
                  mountOptions = [
                    "compress=zstd"
                  ];
                };
                "/games" = {
                  mountpoint = "/games";
                  mountOptions = [
                    "compress=zstd"
                  ];
                };
              };
              mountpoint = "/btrfs";
            };
          };
        };
      };
    };
    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          root = {
            size = "100%FREE";
            content = {
              type = "filesystem";
              format = "ext4";
              mountpoint = "/";
              mountOptions = [
                "defaults"
              ];
            };
          };
        };
      };
    };
  };
}
