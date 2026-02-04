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
    # Hostname kamu adalah "nixos" (sesuai configuration.nix baris 5)
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      
      # Meneruskan input ke dalam modul agar bisa dipanggil
      specialArgs = { inherit inputs; };
      
      modules = [
        # Modul Sistem Utama
        ./configuration.nix

        # Modul Mango
        mango.nixosModules.mango
        dms.nixosModules.dank-material-shell

         
        # Modul Home Manager
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.users.dewtf = import ./home-manager/home.nix;
        }
      ];
    };
  };
}