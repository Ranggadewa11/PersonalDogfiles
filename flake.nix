{
  description = "Nixpant8 User Config";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Input User Apps
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    nix-monitor.url = "github:antonjah/nix-monitor";
    quickshell.url = "git+https://git.outfoxxed.me/quickshell/quickshell";
    dms.url = "github:AvengeMedia/DankMaterialShell"; # Butuh module home-nya
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: 
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."dewtf" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { inherit inputs; };
        modules = [
          inputs.nix-monitor.homeManagerModules.default
          ./home.nix
        ];
      };
    };
}
