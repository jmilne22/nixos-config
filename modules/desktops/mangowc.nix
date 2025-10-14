{ config, pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    grim # screenshot functionality
    slurp # screenshot functionality
    wl-clipboard # wl-copy and wl-paste for copy/paste from stdin / stdout
    swaynotificationcenter # notification system developed by swaywm maintainer
    swaylock
    swayidle
    wlogout
    waybar
    rofi
    kitty
    swaybg
    scenefx
  ];

  # Enable the gnome-keyring secrets vault. 
  # Will be exposed through DBus to programs willing to store secrets.
  services.gnome.gnome-keyring.enable = true;

  # Need this for swaylock to work
  security.pam.services.swaylock = {};
  
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
  };
  
  # Enable mango
  programs.mango = {
    enable = true;
  };
}
