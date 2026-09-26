{ config, pkgs, ... }:
{
  services.xserver.enable = true;

  services.xserver.displayManager.startx = {
    enable = true;
    generateScript = true;
  };

  services.xserver.windowManager.dwm = {
    enable = true;
    extraSessionCommands = ''
      ${pkgs.feh}/bin/feh --no-fehbg --bg-fill /home/user/Pictures/Wallpapers/matrix.png
      # Full repaints avoid the wallpaper trails seen without a compositor.
      ${pkgs.picom}/bin/picom --config /dev/null --backend xrender --no-use-damage --daemon
      ${(pkgs.slstatus.override {
        conf = ''
          const unsigned int interval = 2000;
          static const char unknown_str[] = "n/a";
          #define MAXLEN 2048
          static const struct arg args[] = {
            { cpu_perc, " CPU %s%% |", NULL },
            { ram_perc, " RAM %s%% |", NULL },
            { datetime, " %s ", "%a %d %b %H:%M" },
          };
        '';
      })}/bin/slstatus &
    '';
    package = pkgs.dwm.override {
      conf = ./config.def.h;
      patches = [ ];
    };
  };

  xdg.portal.config.common.default = [ "gtk" ];

  environment.systemPackages = with pkgs; [
    kitty
    dmenu
    j4-dmenu-desktop
    feh
  ];
}
