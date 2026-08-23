{ config, pkgs, lib, ... }:
{
  environment.systemPackages = with pkgs; [
    # lowPrio: desktops/common/wayland.nix installs its own python3 wrapped
    # with pygobject3 for waybar. Both provide bin/python3, which is a
    # buildEnv collision - this one yields on a host that imports both.
    (lib.lowPrio python3)
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
