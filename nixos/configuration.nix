{ config, pkgs, ... }:

let
  unstableTarball = fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
  home-manager = fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
in
{
    imports =
    [
      ./hardware-configuration.nix
      ./software.nix
      ./share.nix
	    (import "${home-manager}/nixos")
    ];

    nixpkgs.config = {
        packageOverrides = pkgs: {
            unstable = import unstableTarball {
                config = config.nixpkgs.config;
            };
        };
    };

    networking.hostName = "redrazer";
    networking.extraHosts =
    ''
    127.0.0.1 windmill
    192.168.39.114 windmill
    '';
    networking.networkmanager.enable = true;

    time.timeZone = "America/Los_Angeles";

    i18n.defaultLocale = "en_US.UTF-8";

    services.xserver = {
        layout = "us";
        xkbVariant = "";
	      videoDrivers = [ "nvidia" ];
    };

    xdg.portal.enable = true;
    xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

    services.logind.lidSwitchExternalPower = "ignore";

    #users.defaultUserShell = pkgs.zsh;

    users.users.red = {
        isNormalUser = true;
        description = "red";
        extraGroups = [ "networkmanager" "wheel" "libvirtd" "docker" "audio" "duplicati"];
        shell = pkgs.zsh;
        packages = with pkgs; [
          ncmpcpp
          mpd
        ];

    };

    services.mpd = {
      enable = true;
      user = "red";
      musicDirectory = "/home/red/Music";
      network.listenAddress = "any";
      startWhenNeeded = true;
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "My PipeWire Output"
        }
    '';
    };

    systemd.services.mpd.environment = {
      XDG_RUNTIME_DIR = "/run/user/1000";
    };

    services.duplicati = {
      enable = true;
      user = "red";
    };

    home-manager.users.red = { pkgs, ... }: {
        programs.home-manager.enable = true;
        dconf.settings = {
            "org/gnome/desktop/interface" = {
                color-scheme = "prefer-dark";
            };
        };

        gtk = {
            enable = true;
            theme = {
                name = "Adwaita-dark";
                package = pkgs.gnome.gnome-themes-extra;
           };
        };

	home.stateVersion = "23.11";
    };

	  qt = {
	    enable = true;
	    platformTheme = "gnome";
	    style = "adwaita-dark";
	  };

    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    services.blueman.enable = true;

    fonts = {
    	packages = with pkgs; [
        fira-code
        fira-code-symbols
        font-awesome
        meslo-lgs-nf
        (nerdfonts.override { fonts = [ "FiraCode" ]; })
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
      DOTNET_SYSTEM_GLOBALIZATION_INVARIANT = "1";
      #XDG_CONFIG_HOME = "@{HOME}/.config";
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

    virtualisation.docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
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

    nixpkgs = {
    overlays = [
      (self: super: {
        waybar = super.waybar.overrideAttrs (oldAttrs: {
          mesonFlags = oldAttrs.mesonFlags ++ ["-Dexperimental=true" "-Dmpd=enabled"];
        });
      })
    ];
  };

    environment.variables.EDITOR = "nvim";

    nix.settings.extra-sandbox-paths = [ "/bin/sh=${pkgs.bash}/bin/sh" ];


    system.stateVersion = "23.11";
}
