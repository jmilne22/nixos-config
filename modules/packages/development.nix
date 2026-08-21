{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    python3
    uv
    go
    gopls
    golangci-lint
    golangci-lint-langserver
    rustup
    nodejs
    bat
  ];

  virtualisation.docker.enable = true;
}
