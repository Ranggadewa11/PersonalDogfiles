{
  description = "Nixpant8 System";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    
    # Input yang dibutuhkan SYSTEM saja (misal untuk display manager)
    mango.url = "github:DreamMaoMao/mango";
    dms.url = "github:AvengeMedia/DankMaterialShell";
    
    # Hapus input home-manager, zen-browser, dll yang cuma dipakai user
  };

  outputs = inputs@{ self, nixpkgs, mango, dms, ... }: {
    
    # Hapus bagian homeConfigurations!
    
    nixosConfigurations.ax14r5 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        ./configuration.nix
        mango.nixosModules.mango
        dms.nixosModules.dank-material-shell
      ];
    };
  };
}
