{ config, pkgs, ... }:
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = false;
    protontricks.enable = true;
    gamescopeSession.enable = true;
  };

  programs.gamemode.enable = true;

  # controllers - users/user.nix puts the user in the uinput group
  hardware.uinput.enable = true;

  environment.systemPackages = with pkgs; [
    mangohud
    heroic
  ];

  services.flatpak.packages = [
    "net.lutris.Lutris"
    "com.usebottles.bottles"
  ];
}
