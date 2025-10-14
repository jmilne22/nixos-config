{ config, pkgs, ... }:
{
  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # Networking
  networking.networkmanager.enable = true;

  # Essential packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    htop
    telegram-desktop
    helix
    fastfetch
    wl-clipboard
    zellij
    wallust
    brightnessctl
  ];

  fonts.packages = with pkgs; [
    google-fonts
    nerd-fonts.jetbrains-mono
    noto-fonts
  ];


  # starship prompt
  programs.starship.enable = true;

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # video
  hardware.graphics.enable = true;

  # Printing
  services.printing.enable = true;
}
