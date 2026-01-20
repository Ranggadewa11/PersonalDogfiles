{
  description = "NixOS Configuration with Flakes, Home Manager, and Mango";

  inputs = {
    # Nixpkgs Unstable (Sesuai request)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Mango (Window Manager)
    mango = {
      url = "github:DreamMaoMao/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Quickshell (Jika diminta manual di dokumentasi)
    quickshell = {
      url = "git+https://git.outfoxxed.me/quickshell/quickshell";
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
