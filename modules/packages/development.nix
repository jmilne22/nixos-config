{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    python3
    uv
    go
    gopls
    rustup
    nodejs
  ];

  virtualisation.docker.enable = true;
}
