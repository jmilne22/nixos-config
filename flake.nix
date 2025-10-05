{
  description = "My NixOS configurations";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    chuwi-minibook-x.url = "github:knoopx/nix-chuwi-minibook-x";
  };
  
  outputs = { self, nixpkgs, chuwi-minibook-x }: {
    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ 
        ./hosts/laptop
        chuwi-minibook-x.nixosModules.default
      ];
    };
  };
}
