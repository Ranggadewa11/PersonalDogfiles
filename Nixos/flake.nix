{
  description = "NixOS System Config - ax14r5";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Modul System Only
    dms.url = "github:AvengeMedia/DankMaterialShell";
    mango.url = "github:DreamMaoMao/mango";
  };

  outputs = { self, nixpkgs, dms, mango, ... }@inputs: {
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
