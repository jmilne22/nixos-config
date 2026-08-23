{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core.nix
    ../../modules/desktops/plasma.nix
    # dwm shows up as a session in sddm's picker, next to Plasma. It enables no
    # display manager of its own, which is what lets the two coexist here.
    ../../modules/desktops/dwm
    ../../modules/apps/development.nix
    ../../modules/apps/ai.nix
    ../../modules/apps/social.nix
    ../../modules/apps/multimedia.nix
    ../../modules/apps/gaming.nix
    ../../modules/apps/sunshine.nix
    ../../modules/apps/productivity.nix
    ../../modules/users/user.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "desktop";

  system.stateVersion = "26.05";
}
