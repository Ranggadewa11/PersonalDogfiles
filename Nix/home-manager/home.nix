{ config, pkgs, inputs, ... }:

{
  # Info User
  home.username = "dewtf";
  home.homeDirectory = "/home/dewtf";

  # Program spesifik User (Opsional, karena sudah ada di systemPackages)
  # Bisa untuk konfigurasi git, neovim, dll secara detail nanti.
  programs.git = {
    enable = true;
    userName = "Ranggadewa11"; # Sesuaikan jika perlu
    userEmail = "r1music8d@gmail.com"; # Ubah ini
  };

  programs.fish = {
    enable = true;
    shellAliases = {
      pasang = "cd /etc/nixos && sudo git add . && sudo nixos-rebuild switch --flake .#nixos";
      ditcon = "sudo hx /etc/nixos/configuration.nix";
      dithome = "sudo hx /etc/nixos/home-manager/home.nix";
      ditflake = "sudo hx /etc/nixos/flake.nix";
    };
  };

  # Version
  home.stateVersion = "26.05"; # Sesuaikan dengan versi home-manager yg dipakai
  
  # Let Home Manager manage itself
  programs.home-manager.enable = true;

  xdg.configFile."systemd/user/mango-session.target".source = ./mango-session.target;
  xdg.configFile."mango".source = ./mango-conf;
  home.packages = with pkgs; [
    # Aplikasi Chat & Sosmed
    discord
    ripgrep
    bat
    zip
    unzip
    grim
    slurp
    satty
    fastfetch
  ];

}
