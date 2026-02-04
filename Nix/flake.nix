{
  description = "Nixpant8";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    mango.url = "github:DreamMaoMao/mango";
    dms.url = "github:AvengeMedia/DankMaterialShell";
    quickshell.url = "git+https://git.outfoxxed.me/quickshell/quickshell";
    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    nix-monitor.url = "github:antonjah/nix-monitor";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, mango, dms, ... }: {

    # =========================
    # NixOS (SYSTEM)
    # =========================
    nixosConfigurations.ax14r5 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };

      modules = [
        ./configuration.nix
        mango.nixosModules.mango
        dms.nixosModules.dank-material-shell
      ];
    };
     home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.dewtf = import ./home-manager/home.nix;
        }
     };
}
