{
  description = "My NixOS configurations";
  
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    chuwi-minibook-x.url = "github:knoopx/nix-chuwi-minibook-x";
    mango = {
      url = "github:DreamMaoMao/mango";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  
  outputs = { self, nixpkgs, chuwi-minibook-x, mango }: {
    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ 
        ./hosts/laptop
        chuwi-minibook-x.nixosModules.default
        mango.nixosModules.mango
      ];
    };
  };
}
