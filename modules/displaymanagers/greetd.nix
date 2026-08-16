{ config, pkgs, ... }:
{
  # generic session picker, not tied to any one desktop/compositor.
  # first login: hit F3 to pick a session, then it's remembered per-user.
  services.greetd = {
    enable = false;
    settings.default_session.command =
      "${pkgs.tuigreet}/bin/tuigreet --time --remember --remember-user-session";
  };
}
