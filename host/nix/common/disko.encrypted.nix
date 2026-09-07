{ disk, swapSize ? "16G" }:

{
  disko.devices = {
    disk.main = {
      type = "disk";
      device = disk;
      content = {
        type = "gpt";
        partitions = {

          ESP = {
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };

          luks = {
            size = "100%";
            content = {
              type = "luks";
              name = "cryptroot";
              settings = {
                allowDiscards = true;
              };
              content = {
                type = "lvm_pv";
                vg = "vg";
              };
            };
          };
        };
      };
    };

    lvm_vg.vg = {
      type = "lvm_vg";

      lvs = {
        swap = {
          size = swapSize;
          content = {
            type = "swap";
            # Использовать этот swap для hibernation
            resumeDevice = true;
          };
        };

        root = {
          size = "100%";
          content = {
            type = "btrfs";
            subvolumes = {

              "@" = {
                mountpoint = "/";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };

              "@home" = {
                mountpoint = "/home";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };

              "@games" = {
                mountpoint = "/games";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };

              "@nix" = {
                mountpoint = "/nix";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
              };
            };
          };
        };
      };
    };
  };
}