{ config, pkgs, lib, ... }:
{
  imports = [ ./wm.nix ];

  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };
}
