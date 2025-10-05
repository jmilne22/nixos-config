{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core.nix
    ../../modules/desktops/gnome.nix
    ../../modules/packages/development.nix
    ../../modules/packages/gaming.nix
    ../../users/user.nix
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Chuwi MiniBook X hardware configuration
  hardware.chuwi-minibook-x = {
    # Choose your model:
    mountMatrix = "1,0,0;0,1,0;0,0,1";      # For N150 model (default)
    
    tabletMode.enable = false;  # Enables tablet mode detection
    
    # Auto-rotation (optional, disable if you don't want it)
    autoDisplayRotation = {
      enable = false;  # Set to true if you want auto-rotation
      # If enabled, configure rotation commands for your DE
      # commands = {
      #   normal = "wlr-randr --output DSI-1 --transform normal";
      #   bottomUp = "wlr-randr --output DSI-1 --transform 180";
      #   rightUp = "wlr-randr --output DSI-1 --transform 270";
      #   leftUp = "wlr-randr --output DSI-1 --transform 90";
      # };
    };
  };

  # Hostname
  networking.hostName = "laptop";

  # Locale
  time.timeZone = "Asia/Jerusalem";
  i18n.defaultLocale = "en_IL";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "he_IL.UTF-8";
    LC_IDENTIFICATION = "he_IL.UTF-8";
    LC_MEASUREMENT = "he_IL.UTF-8";
    LC_MONETARY = "he_IL.UTF-8";
    LC_NAME = "he_IL.UTF-8";
    LC_NUMERIC = "he_IL.UTF-8";
    LC_PAPER = "he_IL.UTF-8";
    LC_TELEPHONE = "he_IL.UTF-8";
    LC_TIME = "he_IL.UTF-8";
  };

  system.stateVersion = "25.05";
}
