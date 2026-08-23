{ config, pkgs, ... }:
{
  services.xserver.enable = true;

  services.xserver.displayManager.startx = {
    enable = true;
    generateScript = true;
  };

  services.xserver.windowManager.dwm = {
    enable = true;
    package = pkgs.dwm.override {
      conf = ./config.def.h;
      patches = [ ];
    };
  };

  xdg.portal.config.common.default = [ "gtk" ];

  environment.systemPackages = with pkgs; [
    st
    dmenu
  ];
}
