{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    claude-code
    codex
    mcp-nixos
    chatgpt
  ];
}
