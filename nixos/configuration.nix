# NixOS Configuration - Minimal Hyprland Setup

{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Boot
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Network
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Locale
  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";

  # Auto-mount internal drive
  fileSystems."/mnt/internal" = {
    device = "/dev/disk/by-uuid/5db7cbb1-60ce-4867-80ea-998dccda13ca";
    fsType = "ext4";
  };

  # NVIDIA
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  
  hardware.nvidia = {
    modesetting.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Display Manager
  services.displayManager.gdm = {
    enable = true;
    wayland = true;
  };

  # Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Auto-mount drives
  services.udisks2.enable = true;
  services.gvfs.enable = true;

  # Polkit
  security.polkit.enable = true;

  # Steam
  programs.steam.enable = true;

  # User
  users.users.ashmity = {
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "storage" "disk" ];
  };

  # Packages
  nixpkgs.config.allowUnfree = true;
  environment.systemPackages = with pkgs; [
    # Your apps
    firefox
    spotify
    vesktop
    alacritty
    vlc
    vscode
    
    # Hyprland essentials
    kitty
    rofi
    waybar
    mako
    
    # File manager
    kdePackages.dolphin
    
    # System tools
    udisks
    playerctl
    cava
    grimblast
    hyprpaper
    fastfetch
    
    # Tools
    git
    vim
    wget
    wl-clipboard
  ];

  # Nix
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "24.11";
}
