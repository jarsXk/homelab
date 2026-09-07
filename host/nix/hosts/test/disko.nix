let
  commonDisko = import ../../common/disko.encrypted.nix;
in
commonDisko {
  disk = "/dev/sda";
  swapSize = "4G";
}