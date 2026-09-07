let
  commonDisko = import ../../common/disko.unencrypted.nix;
in
commonDisko {
  disk = "/dev/sda";
  swapSize = "4G";
}