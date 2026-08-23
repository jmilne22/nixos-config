{
  description = "My NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    chuwi-minibook-x = {
      url = "github:knoopx/nix-chuwi-minibook-x";
      # without this the lock carries a second, year-old nixpkgs tree
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, chuwi-minibook-x }: {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/desktop
        ];
      };

      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/laptop
          chuwi-minibook-x.nixosModules.default
        ];
      };
    };
  };
}
