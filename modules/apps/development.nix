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
    gh
    zed-editor
  ];

  # Lets prebuilt generic-Linux binaries run: Zed's npx-fetched agents
  # (claude-acp, gemini), uv-downloaded Pythons, etc.
  programs.nix-ld.enable = true;

  virtualisation.docker.enable = true;
  # The group only exists where docker does, so it's declared here rather
  # than in users/user.nix. List options merge across modules.
  users.users.user.extraGroups = [ "docker" ];
}
