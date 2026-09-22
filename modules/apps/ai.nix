{ config, pkgs, inputs, ... }:
{
  imports = [
    inputs.codex-desktop-linux.nixosModules.default
  ];

  programs.codexDesktopLinux.enable = true;

  environment.systemPackages = with pkgs; [
    # nixpkgs is on 2.1.278, which the API refuses to serve Claude Opus 5.5 to
    # ("Claude Code 2.1.278 does not support this model; version 2.1.280 or newer
    # is required"). The derivation reads its version and per-platform binary out
    # of a `manifest` arg, so pin that forward. Drop this whole override and go
    # back to plain `claude-code` once nixpkgs is at 2.1.280 or newer.
    # Source: https://downloads.claude.ai/claude-code-releases/2.1.280/manifest.zst.json
    (claude-code.override {
      manifest = {
        version = "2.1.280";
        platforms."linux-x64" = {
          binary = "claude.zst";
          checksum = "27910e2ae704d8f2e8024897d8fdf1e7710807baf4f6982c0e3797c058315384";
        };
      };
    })
    codex
    mcp-nixos
  ];
}
