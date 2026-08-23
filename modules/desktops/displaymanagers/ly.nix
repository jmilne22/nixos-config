{ config, pkgs, ... }:
{
  # TUI greeter. x11Support defaults to true, so dwm sessions show up as-is.
  #
  # Import at most one module from this directory, and never alongside
  # gnome.nix or plasma.nix - those bring gdm and sddm with them. A second
  # display manager is an *evaluation* error rather than a runtime one: they
  # all feed services.displayManager.generic.execCmd, which is a nullOr str.
  services.displayManager.ly.enable = true;
}
