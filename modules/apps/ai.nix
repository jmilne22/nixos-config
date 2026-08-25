{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    claude-code
    mcp-nixos
  ];
}
