{ config, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # --- BOOTLOADER & KERNEL ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
     # --- NETWORKING ---
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # --- TIME & LOCALE ---
  time.timeZone = "Asia/Jakarta";
  i18n.defaultLocale = "en_US.UTF-8";

  # --- DESKTOP ENVIRONMENT ---
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  fonts.fontconfig.defaultFonts = {
    monospace = [
      "JetBrainsMono Nerd Font'"
    ];
  };
      
  
  # X11 Layout
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # --- MANGO CONFIGURATION ---
  programs.mango.enable = true;

  # --- SOUND & HARDWARE ---
  services.printing.enable = true;
  
  # Sound with Pipewire & Wireplumber
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # --- USER CONFIGURATION (UPDATED) ---
  users.users.dewtf = {
    isNormalUser = true;
    description = "Ranggadewtf";
    # Grup ditambahkan sesuai request + rekomendasi penting lainnya
    extraGroups = [ 
      "networkmanager" 
      "wheel" 
      "audio"   # Akses hardware suara
      "video"   # Akses hardware video/webcam/akselerasi
      "input"   # Akses device input (mouse/gamepad)
      "lp"      # Akses printer
      "scanner" # Akses scanner
    ];
    shell = pkgs.fish; 
  };
  
  environment.variables = {
    EDITOR = "hx";
    VISUAL = "hx";
  };
  # --- SYSTEM PACKAGES ---
  # PASANG
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    # Editor & Tools
    helix
    git
    curl
    wget
    gemini-cli
    
    dms-shell
    quickshell
    dgop
    rofi    
    
    # Apps
    firefox
    kitty
    libreoffice
    zotero
  ];

  # --- PROGRAMS & SERVICES ---
  programs.firefox.enable = true;
  programs.fish.enable = true;
  services.flatpak.enable = true;
  services.tuned.enable = true;
  
  # --- SYSTEM STATE ---
  system.stateVersion = "25.11";
}
