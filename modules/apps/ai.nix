{ config, pkgs, inputs, ... }:
{
  imports = [
    inputs.codex-desktop-linux.nixosModules.default
  ];

  programs.codexDesktopLinux.enable = true;

  environment.systemPackages = with pkgs; [
    claude-code
    codex
    mcp-nixos
  ];
}
