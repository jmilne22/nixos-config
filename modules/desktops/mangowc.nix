{ config, pkgs, lib, ... }:
{
  imports = [ ./wm.nix ];

  environment.systemPackages = with pkgs; [
    scenefx
  ];

  programs.mango.enable = true;
}
