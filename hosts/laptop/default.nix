{ config, pkgs, ... }:
{
  # This host isn't installed yet - hardware-configuration.nix gets generated
  # on the machine at install time (see README step 3). Until then .#laptop
  # can't evaluate, which is expected, not a missing file.
  imports = [
    ./hardware-configuration.nix
    ../../modules/core.nix
    # dwm is the only desktop here, so this host brings its own greeter -
    # nothing else on it provides one. Swap ly.nix for greetd.nix to change
    # greeters; never import two, and never one next to gnome/plasma.
    ../../modules/desktops/dwm
    ../../modules/desktops/displaymanagers/ly.nix
    ../../modules/apps/development.nix
    ../../modules/apps/social.nix
    ../../modules/apps/gaming.nix
    ../../modules/apps/productivity.nix
    ../../modules/users/user.nix
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
