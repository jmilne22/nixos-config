{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vlc
  ];

    services.flatpak.packages = [
    "com.stremio.Stremio"
  ];
}
