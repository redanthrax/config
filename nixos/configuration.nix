{ config, pkgs, ... }:

{
    imports =
    [
        ./hardware-configuration.nix
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "redrazer";

    networking.networkmanager.enable = true;

    time.timeZone = "America/Los_Angeles";

    i18n.defaultLocale = "en_US.UTF-8";

    services.xserver = {
        layout = "us";
        xkbVariant = "";
    };

    users.users.red = {
        isNormalUser = true;
        description = "red";
        extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
        packages = with pkgs; [];
    };

    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    environment.systemPackages = with pkgs; [
        git
        neovim
        wget
        curl
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
    ];

    fonts.packages = with pkgs; [
        fira-code
        fira-code-symbols
    ];

    programs.hyprland = {
      # Install the packages from nixpkgs
      enable = true;
      # Whether to enable XWayland
      xwayland.enable = true;
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

    environment.variables.EDITOR = "neovim";

    system.stateVersion = "23.11";
}