{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core.nix
    ../../modules/desktops/gnome.nix
    ../../modules/packages/development.nix
    ../../modules/packages/social.nix
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

  system.stateVersion = "25.05";
}
