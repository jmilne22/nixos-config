{ config, pkgs, inputs, ... }:
{
  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # Networking
  networking.networkmanager.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Flatpak
  services.flatpak.enable = true;

  # Portals - file pickers, screen sharing. Flatpak above is unusable without
  # them. The desktop modules add their own on top; xdg.portal.enable is a bool
  # and extraPortals is a list, so declaring them here too just merges.
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # Firefox
  programs.firefox.enable = true;

  programs.git = {
    enable = true;
    config = {
      user.name = "James Milne";
      user.email = "jmilne22@gmail.com";
      init.defaultBranch = "main";
      pull.ff = "only";
      push.autoSetupRemote = true;
    };
  };
  
  # Essential packages
  environment.systemPackages = with pkgs; [
    vim
    wget
    htop
    helix
    fastfetch
    wl-clipboard
    zellij
    wallust
    brightnessctl
    lazygit
    xclip
    pciutils
    p7zip
    unrar
  ];

  fonts.packages = with pkgs; [
    google-fonts
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
    noto-fonts
    noto-fonts-color-emoji
    noto-fonts-cjk-sans
    liberation_ttf
    _0xproto
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
  hardware.graphics.enable32Bit = true;

  # Printing
  services.printing.enable = true;

  # Timezone
  time.timeZone = "Asia/Jerusalem";

  # Locale
  i18n.defaultLocale = "en_US.UTF-8";

  # Keyboard layout. Lives here rather than in each desktop module - it's the
  # same on every host regardless of which desktop is imported.
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
}
