{ config, pkgs, ... }:
{
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    gnome-tweaks
  ];
}
