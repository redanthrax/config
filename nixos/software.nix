{ config, pkgs, ... }:
let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
in
{
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
    freerdp
    zip
    lynx
    nwg-displays
    wlr-randr
    steam
    nvidia-offload
    nethack
    vulkan-tools
    lutris
    azure-functions-core-tools
    nodejs_20
    gnumake
    lua
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

    programs.neovim = {
      enable = true;
      defaultEditor = true;
    };

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
}
