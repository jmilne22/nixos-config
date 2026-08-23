{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    obsidian
    calibre
  ];
}
