{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    python3
    uv
    go
    rustup
  ];

  virtualisation.docker.enable = true;
}
