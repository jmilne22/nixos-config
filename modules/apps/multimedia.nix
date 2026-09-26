{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    vlc
    feishin
  ];

    services.flatpak.packages = [
    "com.stremio.Stremio"
  ];
}
