{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    python3
    uv
    go
    rustup
    nodejs
  ];

  virtualisation.docker.enable = true;
}
