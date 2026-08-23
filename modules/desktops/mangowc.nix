{ config, pkgs, lib, ... }:
{
  imports = [ ./common/wayland.nix ];

  environment.systemPackages = with pkgs; [
    scenefx
  ];

  programs.mango.enable = true;
}
