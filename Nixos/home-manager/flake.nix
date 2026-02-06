{
  description = "User Home Manager Config - dewtf";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Inputs Aplikasi User
    dms.url = "github:AvengeMedia/DankMaterialShell";
    quickshell.url = "git+https://git.outfoxxed.me/quickshell/quickshell";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    # Perbaikan: Titik koma dihapus dari dalam tanda kutip
    nix-monitor.url = "github:antonjah/nix-monitor";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-monitor,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    homeConfigurations."dewtf" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = {inherit inputs;};

      modules = [
        ./home.nix
        nix-monitor.homeManagerModules.default
        {
          programs.nix-monitor = {
            enable = true;
            rebuildCommand = [
              "bash"
              "-c"
              "cd ~/.config/home-manager && home-manager switch --flake ~/.config/home-manager/#dewtf"
            ];
          };
        }
      ];
    };
  };
}
