{ config, lib, pkgs, modulesPath, ... }:

{
    imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot.initrd.availableKernelModules = [ "xhci_pci" "thunderbolt" "vmd" "nvme" "usbhid" "usb_storage" "sd_mod" ];
    boot.initrd.kernelModules = [ ];
    boot.kernelModules = [ "i915" "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" "kvm-intel" ];
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


    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    boot.extraModprobeConfig = ''
      blacklist nouveau
      options nouveau modeset=0
    '';

    boot.kernelParams = [
      "kvm.ignore_msrs=1"
      "kvm.report_ignored_msrs=0"
    ];

    boot.blacklistedKernelModules = [ "nouveau" ];

    hardware.opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
        extraPackages = with pkgs; [
          intel-media-driver # LIBVA_DRIVER_NAME=iHD
          intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
          libvdpau-va-gl
        ];
    };

    hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = false;
        powerManagement.finegrained = false;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.production;
    };

    hardware.nvidia.prime = {
        sync.enable = true;
        intelBusId = "PCI:0:0:2";
        nvidiaBusId = "PCI:0:1:0";
    };

    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
}
