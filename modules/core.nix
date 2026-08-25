{ config, pkgs, inputs, ... }:
{
  imports = [ inputs.nix-flatpak.nixosModules.nix-flatpak ];

  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # Networking
  networking.networkmanager.enable = true;

  # Bluetooth
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Flatpak. nix-flatpak adds declarative package/remote management as sibling
  # options under the same services.flatpak namespace that nixpkgs' own module
  # provides `enable` in - the two compose, they don't conflict.
  #
  # Flatpaks live in /var/lib/flatpak, not the nix store, and are NOT
  # generational: rolling the system back does not roll these back, and changing
  # the list re-downloads rather than switching a symlink. That's the tradeoff
  # for tracking upstream releases - don't move anything here that wants pinning.
  services.flatpak.enable = true;

  services.flatpak.remotes = [{
    name = "flathub";
    location = "https://flathub.org/repo/flathub.flatpakrepo";
  }];

  # Nothing declared yet. `packages` is a list option, so it merges across
  # modules - an app module can declare its own flatpaks and they concatenate:
  #
  #   services.flatpak.packages = [
  #     "org.some.App"                                  # from the default remote
  #     { appId = "org.other.App"; origin = "flathub"; }
  #   ];
  services.flatpak.packages = [ ];

  # A weekly timer rather than update.onActivation, which would make every
  # nixos-rebuild switch hit the network and slow the rebuild down.
  services.flatpak.update.auto = {
    enable = true;
    onCalendar = "weekly";
  };

  # Deliberately false for now: true is the fully declarative end state, but it
  # silently uninstalls anything added by hand, which is a confusing way to lose
  # an app you were trying out. Flip it once the list above has settled.
  services.flatpak.uninstallUnmanaged = false;

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
