{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core.nix
    ../../modules/desktops/gnome.nix
    ../../modules/apps/development.nix
    ../../modules/apps/ai.nix
    ../../modules/apps/social.nix
    ../../modules/apps/multimedia.nix
    ../../modules/apps/gaming.nix
    ../../modules/apps/productivity.nix
    ../../modules/users/user.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelParams = [ "video=DSI-1:panel_orientation=right_side_up" ];

  # Hostname
  networking.hostName = "minibook";

  system.stateVersion = "26.05";
}
