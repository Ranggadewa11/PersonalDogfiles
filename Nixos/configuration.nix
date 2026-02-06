{ config, lib, pkgs, inputs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  # Bootloader & Kernel
  boot.loader.systemd-boot.enable = false; # Pastikan systemd-boot mati
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    devices = [ "nodev" ]; # PENTING: Untuk UEFI pakai "nodev"
    efiSupport = true;     # PENTING: Nyalakan support EFI
    useOSProber = true;    # Coba nyalakan lagi
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;  
  # Kernel Modules (OBS Cam dll)
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  boot.kernelModules = [ "v4l2loopback" ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';

  # Networking
  networking.hostName = "ax14r5";
  networking.networkmanager.enable = true;

  # Time & Locale
  time.timeZone = "Asia/Jakarta";
  i18n.defaultLocale = "en_US.UTF-8";

  # Display / Desktop Environment (System Level)
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  
  # DMS & Mango System Modules
  programs.dank-material-shell.enable = true;
  programs.mango.enable = true;

  # Valent
   programs.kdeconnect = {
  enable = true;
  package = pkgs.valent;
  };

  # Audio
  services.pipewire = {
     enable = true;
     pulse.enable = true;
     alsa.enable = true;
     alsa.support32Bit = true;
     wireplumber.enable = true;
  };

  # User Account (Hanya definisi user & groups)
  users.users.dewtf = {
     isNormalUser = true;
     shell = pkgs.fish;
     extraGroups = [ 
        "wheel" "audio" "video" "input" "networkmanager"
     ];
     # Note: Packages dipindah ke Home Manager
  };

  # System Environment
  security.polkit.enable = true;
  programs.fish.enable = true;
  programs.appimage = { enable = true; binfmt = true; };
  services.flatpak.enable = true;
  services.tuned.enable = true;
  
  # OBS Studio (Butuh di system untuk Virtual Camera)
  programs.obs-studio = {
    enable = true;
    enableVirtualCamera = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi
      obs-gstreamer
      obs-vkcapture
    ];
  };
  
  # Fonts (System Wide)
  fonts.packages = [ pkgs.nerd-fonts.jetbrains-mono ];
  fonts.fontconfig.defaultFonts.monospace = [ "JetBrainsMono Nerd Font" ];

  # System Packages (Hanya core utilities, Apps pindah ke user)
  environment.systemPackages = with pkgs; [
    git curl wget vim 
    home-manager # Biar bisa run command home-manager
    
    # GNOME Core dependencies
    gnome-extension-manager
    gnome.gvfs
    gnome-shell
    gnome-tweaks
    valent
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.11";
}
