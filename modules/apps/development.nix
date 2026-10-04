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
    kubectl
    k9s
    kubernetes-helm
    k3d
    go-task
    act
  ];

  # Tab-completes like kubectl via the alias completion set up in core.nix.
  environment.shellAliases.k = "kubectl";

  # Lets prebuilt generic-Linux binaries run: Zed's npx-fetched agents
  # (claude-acp, gemini), uv-downloaded Pythons, etc.
  programs.nix-ld.enable = true;
  # Extra libs on top of nix-ld's defaults, for prebuilt Electron apps.
  programs.nix-ld.libraries = with pkgs; [
    glib
    nss
    nspr
    atk
    at-spi2-atk
    at-spi2-core
    cups
    dbus
    cairo
    pango
    gtk3
    expat
    libxkbcommon
    libgbm
    alsa-lib
    udev
    libx11
    libxcomposite
    libxdamage
    libxext
    libxfixes
    libxrandr
    libxcb
  ];

  virtualisation.docker.enable = true;
  # The group only exists where docker does, so it's declared here rather
  # than in users/user.nix. List options merge across modules.
  users.users.user.extraGroups = [ "docker" ];

  # QEMU user-mode emulation so `docker buildx --platform linux/arm64` works.
  # Static emulators get registered with the F flag, so the kernel preloads them
  # and they work inside containers without being present in the image.
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.binfmt.preferStaticEmulators = true;
}
