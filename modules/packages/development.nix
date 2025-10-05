{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    python3
    uv
    go
  ];

  virtualisation.docker.enable = true;
}
