{
  config,
  pkgs,
  pkgs-unstable,
  lib,
  inputs,
  ...
}: {
  imports = [];
  boot.loader.timeout = 3;
  boot.loader.efi.canTouchEfiVariables = true;

  # Pinning the registry on NixOS makes it so `nix shell nixpkgs#ITEM` does not
  # download a tarball for only a lookup. Also enables being able to use
  # chached evaluations.
  #
  # This similarly makes it so unlocked flakes that use "nixpkgs" as an input
  # can similarly draw from the registry.
  nix.registry = {
    nixpkgs.flake = inputs.nixpkgs;
    nixpkgs-unstable.flake = inputs.nixpkgs-unstable;
  };

  programs.river.enable = true;

  nixpkgs.config = {
    # permittedInsecurePackages = ["electron-25.9.0"];
    # allowUnfree = true;
    trustedUsers = "@wheel";
  };

  ## Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  i18n.defaultLocale = "en_US.UTF-8";

  environment.sessionVariables = {
    # tell electron apps to use wayland
    NIXOS_OZONE_WL = "1";
  };

  programs.dconf.enable = true;
  hardware.graphics.enable = true;

  # security.polkit.enable = true;
  # security.sudo.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_latest;

  ## Network Manager
  networking.networkmanager.enable = true;
  ## Wpa Supplicant
  # networking.wireless.enable = true;

  # Set your time zone.
  time.timeZone = "America/Tijuana";

  # # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";

  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = false;
  # };

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    # pulse.enable = true;
    # alsa.support32Bit = true;
    # jack.enable = true;
  };

  # ------------- Fonts --------------- #
  fonts = {
    packages = with pkgs; [
      nerd-fonts.hack
      nerd-fonts.mononoki
      noto-fonts-emoji
      dejavu_fonts
      ipafont
      kochi-substitute
      # rounded-mgenplus
      ## Too Fancy
      # hanazono
    ];
    enableDefaultPackages = false;
  };

  # fonts.fontconfig.defaultFonts = {
  #   monospace = ["Hack Nerd Mono" "DejaVu Sans Mono" "IPAGothic"];
  #   sansSerif = ["DejaVu Sans" "IPAPGothic"];
  #   serif = ["DejaVu Serif" "IPAPMincho"];
  # };

  # ----------------------------------- #
  users.users.focus = {
    isNormalUser = true;
    description = "Evan Stokdyk";
    shell = pkgs.bash;
    extraGroups = ["wheel" "networkmanager" "audio" "video" "libvirtd"];
  };
  # ----------------------------------- #

  nix.settings.experimental-features = ["nix-command" "flakes"];

  users.defaultUserShell = pkgs.bash;

  environment = {
    shellAliases = {
      vim = "nvim";
      nixbld = "sudo nixos-rebuild switch --flake $HOME/dev/iyuma";
    };

    defaultPackages = [];
    systemPackages =
      (with pkgs; [vim git busybox rsync])
      ++ (with pkgs-unstable; [neovim-unwrapped zig]);

    variables = rec {
      XKB_DEFAULT_OPTIONS = "caps:swapescape"; # used by river

      XDG_CONFIG_HOME = "$HOME/.config";
      XDG_DATA_HOME = "$HOME/.local/share";
      XDG_CACHE_HOME = "$HOME/.cache";
      XDG_DOCUMENTS_DIR = "$HOME/dox";
      XDG_DOWNLOAD_DIR = "$HOME/dl";
      XDG_MUSIC_DIR = "$HOME/aud";
      XDG_PICTURES_DIR = "$HOME/pix";
      XDG_PUBLICSHARE_DIR = "$HOME";

      RUSTUP_HOME = "${XDG_DATA_HOME}/rustup";
      CARGO_HOME = "${XDG_DATA_HOME}/cargo";
      GNUPGHOME = "${XDG_DATA_HOME}/gnupg";
      PASSWORD_STORE_DIR = "${XDG_DATA_HOME}/pass";

      VISUAL = "nvim";
      EDITOR = "nvim";
      READER = "zathura";
      TERMINAL = "foot";
      BROWSER = "firefox";
      VIDEO = "mpv";
      IMAGE = "imv";
      OPENER = "xdg-open";
      PAGER = "less";
      MANPAGER = "less";

      HISTORY_IGNORE = "(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..|clear)";
      LESSHISTFILE = "-";
    };
  };

  nixpkgs.flake.setNixPath = true;
}
