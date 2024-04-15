{ config, pkgs, ... }:

let
  unstableTarball = fetchTarball https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
  home-manager = fetchTarball "https://github.com/nix-community/home-manager/archive/release-23.11.tar.gz";
in
{
    imports =
    [
        ./hardware-configuration.nix
	(import "${home-manager}/nixos")
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
	      videoDrivers = [ "intel" "nvidia" ];
	      #videoDrivers = [ "nvidia" ];
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
        package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    hardware.nvidia.prime = {
        sync.enable = true;
        intelBusId = "PCI:0:0:2";
        nvidiaBusId = "PCI:0:1:0";
    };

    hardware.bluetooth.enable = true;
    hardware.bluetooth.powerOnBoot = true;
    services.blueman.enable = true;

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
        bitwarden
        pavucontrol
        home-manager
        samba
        minikube
        cifs-utils
        azure-cli
        ripgrep
        gcc
        glxinfo
        htop
        neofetch
        lazygit
        unzip
        go
        fd
        wl-clipboard
        grim
        slurp
        swappy
        dig
        gopls
        android-file-transfer
        k9s
        kubectl
        gh
        libsForQt5.krdc
        kubernetes-helm
        podman
        docker-machine
        docker-machine-kvm2
        glibc
        obsidian
    ];

    nixpkgs.config.permittedInsecurePackages = [
      "electron-25.9.0"
    ];

    programs = {
	   zsh = {
	      enable = true;
	      autosuggestions.enable = true;
	      zsh-autoenv.enable = true;
	      syntaxHighlighting.enable = true;
	      ohMyZsh = {
         enable = true;
         plugins = [
           "git"
           "npm"
           "history"
           "node"
           "rust"
           "deno"
         ];
	      };
	   };
	};

    programs.neovim.enable = true;
    programs.neovim.defaultEditor = true;

    programs.tmux = {
        enable = true;
      clock24 = true;
      plugins = with pkgs; [
        tmuxPlugins.vim-tmux-navigator
        tmuxPlugins.battery
        tmuxPlugins.catppuccin
	];
	extraConfig = ''
unbind r
bind r source-file ~/.tmux.conf

set -g prefix C-s

# act like vim
setw -g mode-keys vi
bind-key h select-pane -L
bind-key j select-pane -D
bind-key k select-pane -U
bind-key l select-pane -R

bind '"' split-window -c "#{pain_current_path}"
bind % split-window -h -c "#{pain_current_path}"

set -g mouse on

# List of plugins
set -g @plugin 'tmux-plugins/tpm'
set -g @plugin 'christoomey/vim-tmux-navigator'
set -g @plugin 'tmux-plugins/tmux-battery'

set -g @plugin 'catppuccin/tmux'
set -g @catppuccin_window_status_icon_enable "yes"
set -g @catppuccin_window_default_fill "none"
set -g @catppuccin_status_modules_right "application session date_time"
set -g @catppuccin_date_time_text "%Y-%m-%d %H:%M"

set -g status-position top
	'';
    };

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

    fileSystems."/mnt/share" = {
      device = "//10.0.0.2/Home";
      fsType = "cifs";
      options = let
          automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
      in ["${automount_opts},credentials=/etc/nixos/smb-secrets,uid=1000,gid=100"];
    };

    system.stateVersion = "23.11";
}
