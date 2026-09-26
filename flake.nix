{
  description = "My NixOS configurations";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    chuwi-minibook-x = {
      url = "github:knoopx/nix-chuwi-minibook-x";
      # without this the lock carries a second, year-old nixpkgs tree
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # No follows needed - nix-flatpak declares no inputs of its own, so there is
    # no second nixpkgs tree to deduplicate. `ref=latest` is upstream's moving
    # stable tag; the bare URL would track their dev branch.
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    codex-desktop-linux = {
      url = "github:ilysenko/codex-desktop-linux";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # inputs@ binds the whole argument set as `inputs` *and* destructures from it,
  # so specialArgs below can hand the full set to every module. The `...` absorbs
  # inputs not named here - without it, adding an input means also adding it to
  # this pattern or evaluation fails with "called with unexpected argument".
  outputs = inputs@{ self, nixpkgs, ... }: {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # specialArgs rather than _module.args: modules need `inputs` while their
        # own `imports` are still being resolved, which happens before module
        # config - and so before _module.args - exists.
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/desktop
        ];
      };

      minibook = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/minibook
          inputs.chuwi-minibook-x.nixosModules.default
        ];
      };
    };
  };
}
