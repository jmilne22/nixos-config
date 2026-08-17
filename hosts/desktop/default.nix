{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core.nix
    ../../modules/desktops/plasma.nix
    ../../modules/packages/development.nix
    ../../modules/packages/ai.nix
    ../../modules/packages/social.nix
    ../../modules/packages/gaming.nix
    ../../modules/packages/productivity.nix
    ../../users/user.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "desktop";

  system.stateVersion = "26.05";
}
