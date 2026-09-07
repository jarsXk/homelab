{ config, lib, pkgs, ... }:

{
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "usbhid"
    "usb_storage"
  ];

  hardware.cpu.intel.updateMicrocode = lib.mkDefault true;
}
