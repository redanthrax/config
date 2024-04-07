{ config, lib, pkgs, modulesPath, ... }:

{
    imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usbhid" "usb_storage" "sd_mod" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "kvm-intel" ];
    boot.extraModulePackages = [ ];

    fileSystems."/" =
      { device = "/dev/disk/by-uuid/b63c55cb-373d-42e9-97df-32bb6f6248ad";
        fsType = "ext4";
      };
    
    boot.initrd.luks.devices."luks-2cf81ba1-b150-449b-ad58-2c1b0f70ced0".device = "/dev/disk/by-uuid/2cf81ba1-b150-449b-ad58-2c1b0f70ced0";

    fileSystems."/boot" =
      { device = "/dev/disk/by-uuid/4212-C34B";
        fsType = "vfat";
      };
    
    swapDevices = [ ];

    networking.useDHCP = lib.mkDefault true;

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}