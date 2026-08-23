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
  # The group only exists where docker does, so it's declared here rather
  # than in users/user.nix. List options merge across modules.
  users.users.user.extraGroups = [ "docker" ];
}
