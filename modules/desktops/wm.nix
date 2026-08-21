{ config, pkgs, lib, ... }:
{
  # Shared userland for the wlroots-style WMs (sway, mango, river).
  # The compositor itself stays in its own module; everything here is the
  # stuff the WM *configs* reach for by name.
  #
  # Nothing here writes config files - all of that still comes from
  # ~/.config, checked out from the dotfiles repo.

  environment.systemPackages = with pkgs; [
    # screenshots + clipboard
    grim
    slurp
    wl-clipboard
    cliphist

    # session bits
    swaybg
    swayidle
    swaylock
    wlogout
    sway-audio-idle-inhibit
    wlsunset

    # shell
    waybar
    rofi
    kitty

    # notifications: sway/config autostarts mako, mango/autostart.sh
    # uses swaync. They never run at the same time, so ship both.
    mako
    swaynotificationcenter

    # tray applets the WM configs launch by name
    networkmanagerapplet

    # audio / media keybinds
    pulseaudio # for pactl, which sway/config binds
    pamixer    # river/init binds this instead
    pavucontrol
    playerctl

    # gsettings, for the GTK block in sway/config
    glib

    # waybar's mediaplayer.py does `import gi`
    (python3.withPackages (ps: [ ps.pygobject3 ]))
  ];

  # mediaplayer.py calls gi.require_version("Playerctl", "2.0"); without this
  # gi only searches glib's own typelib dir and won't find playerctl's.
  environment.sessionVariables.GI_TYPELIB_PATH =
    "/run/current-system/sw/lib/girepository-1.0";

  # $file_browser
  programs.thunar.enable = true;
  programs.xfconf.enable = true; # so thunar's settings persist

  # blueman-applet, launched from mango/autostart.sh
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Secrets vault, exposed over DBus to anything that wants it.
  services.gnome.gnome-keyring.enable = true;

  # Needed for swaylock to authenticate.
  security.pam.services.swaylock = { };

  # The WM configs hardcode /usr/libexec/polkit-gnome-authentication-agent-1,
  # which doesn't exist on NixOS. Start it ourselves - their `pidof ... || ...`
  # lines then just fail quietly and we still get an auth agent.
  #
  # default.target, not graphical-session.target: only sway wires up a session
  # target on NixOS, mango and labwc just set sessionPackages.
  systemd.user.services.polkit-gnome-authentication-agent-1 = {
    description = "polkit-gnome authentication agent";
    wantedBy = [ "default.target" ];
    serviceConfig.ExecStart =
      "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}
