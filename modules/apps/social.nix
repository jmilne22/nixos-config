{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    discord
    telegram-desktop
  ];

  services.flatpak.packages = [
    "us.zoom.Zoom"
  ];

}
