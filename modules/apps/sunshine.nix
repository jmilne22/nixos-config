{ config, pkgs, ... }:
{
  services.sunshine = {
    enable = true;
    autoStart = false;
    capSysAdmin = true; # required for KMS capture under KDE Plasma Wayland
    openFirewall = true;
  };
}
