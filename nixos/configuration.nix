{ config, pkgs, ... }:

let
  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
in
{
    imports =
    [
        ./hardware-configuration.nix
    ];

    nixpkgs.config = {
        packageOverrides = pkgs: {
            unstable = import unstableTarball {
                config = config.nixpkgs.config;
            };
        };
    };

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    boot.extraModprobeConfig = ''
      blacklist nouveau
      options nouveau modeset=0
    '';

    boot.blacklistedKernelModules = [ "nouveau" ];

    networking.hostName = "redrazer";

    networking.networkmanager.enable = true;

    time.timeZone = "America/Los_Angeles";

    i18n.defaultLocale = "en_US.UTF-8";

    services.xserver = {
        layout = "us";
        xkbVariant = "";
	videoDrivers = [ "intel" "nvidia" ];
    };

    services.logind.lidSwitchExternalPower = "ignore";

    users.users.red = {
        isNormalUser = true;
        description = "red";
        extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
        packages = with pkgs; [];
    };

    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    hardware.opengl = {
        enable = true;
        driSupport = true;
        driSupport32Bit = true;
    };

    hardware.nvidia = {
        modesetting.enable = true;
        powerManagement.enable = false;
        powerManagement.finegrained = false;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    hardware.nvidia.prime = {
        sync.enable = true;
        intelBusId = "PCI:0:0:2";
        nvidiaBusId = "PCI:0:1:0";
    };

    environment.systemPackages = with pkgs; [
        git
        neovim
        wget
        curl
        lshw
        waybar
        mako
        libnotify
        kitty
        alacritty
        swww
        wofi
        dolphin
        networkmanagerapplet
        brave
        discord
        teams-for-linux
        docker
        bitwarden
    ];

    programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestions.enable = true;
        syntaxHighlighting.enable = true;
    };
    programs.neovim.enable = true;
    programs.neovim.defaultEditor = true;

    fonts = {
    	packages = with pkgs; [
		fira-code
		fira-code-symbols
		font-awesome
	    ];

	    fontconfig = {
		enable = true;
		defaultFonts = {
		    monospace = [ "Fira Code" ];
		};
	};
    };

    programs.hyprland = {
      enable = true;
      enableNvidiaPatches = true;
      xwayland.enable = true;
    };

    environment.sessionVariables = {
    	WLR_NO_HARDWARE_CURSORS = "1";
	NIXOS_OZONE_WL = "1";
    };

    programs.virt-manager.enable = true;

    virtualisation.libvirtd = {
        enable = true;
        qemu = {
            package = pkgs.qemu_kvm;
            runAsRoot = true;
            swtpm.enable = true;
            ovmf = {
                enable = true;
                packages = [(pkgs.unstable.OVMF.override {
                    secureBoot = true;
                    tpmSupport = true;
                }).fd];
            };
        };
    };

    sound.enable = true;
    security.rtkit.enable = true;
    services.pipewire = {
    	enable = true;
	alsa.enable = true;
	alsa.support32Bit = true;
	pulse.enable = true;
	jack.enable = true;
    };

    environment.variables.EDITOR = "neovim";

    system.stateVersion = "23.11";
}
