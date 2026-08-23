{ config, pkgs, ... }:
{
  # generic session picker, not tied to any one desktop/compositor.
  # first login: hit F3 to pick a session, then it's remembered per-user.
  #
  # Same rule as ly.nix: at most one greeter, and not next to a DE that
  # already ships one.
  services.greetd = {
    enable = true;
    settings.default_session.command =
      "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-user-session";
  };
}
