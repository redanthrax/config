{ config, pkgs, ... };

{
    imports =
    [
        ./hardware-configuration.nix
    ];

    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    network.hostName = "redrazer";

    networking.networkmanager.enable = true;

    time.timeZone = "America/Los_Angeles";

    i18n.defaultLocale = "en_US.UTF-8";

    services.xserver = {
        layout = "us";
        xkbVarient = "";
    };

    users.users.red = {
        isNormalUser = true;
        description = "red";
        extraGroups = [ "networkmanager" "wheel" ];
        packages = with pkgs; [];
    };

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [

    ];

    system.stateVersion = "23.11";
}