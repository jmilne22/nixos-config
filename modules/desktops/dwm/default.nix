{ config, pkgs, ... }:
{
  services.xserver.enable = true;

  # No display manager here on purpose, so this module composes both ways: next
  # to plasma.nix or gnome.nix, their sddm/gdm picks dwm up as a session; on a
  # host with no desktop environment, log in on a TTY and run startx. startx is
  # the one "display manager" that doesn't claim
  # services.displayManager.generic.execCmd, so it never conflicts with a real
  # one. For a greeter on a dwm-only host, import one from ../displaymanagers.
  services.xserver.displayManager.startx = {
    enable = true;
    generateScript = true;
  };

  services.xserver.windowManager.dwm = {
    enable = true;
    # nixpkgs' dwm takes conf and patches directly, so the repo only carries the
    # files we actually wrote - no vendored copy of upstream. Note that conf is
    # copied over config.def.h in postPatch, i.e. *after* patches apply: a patch
    # that adds config variables needs its config.def.h hunk hand-merged into
    # ours, or the build fails on an undefined symbol.
    package = pkgs.dwm.override {
      conf = ./config.def.h;
      patches = [ ];
    };
  };

  # config.def.h binds these by name (Mod+Shift+Enter, Mod+p) and they're
  # useless without them. Both accept `conf = ./...` the same way dwm does,
  # whenever they're worth styling.
  environment.systemPackages = with pkgs; [
    st
    dmenu
  ];
}
