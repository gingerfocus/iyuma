{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [];

  # Pinning the registry on NixOS makes it so `nix shell nixpkgs#ITEM` does not
  # download a tarball for only a lookup. Also enables being able to use
  # chached evaluations.
  #
  # This similarly makes it so unlocked flakes that use "nixpkgs" as an input
  # can similarly draw from the registry.
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.registry.nixpkgs-unstable.flake = inputs.nixpkgs-unstable;

  nixpkgs.config = {
    permittedInsecurePackages = ["electron-25.9.0"];
    allowUnfree = true;
    trustedUsers = "@wheel";
  };

  ## Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # services.tlp = {
  #   enable = true;
  #   settings = {
  #     CPU_BOOST_ON_BAT = 0;
  #     CPU_SCALING_GOVERNOR_ON_BATTERY = "powersave";
  #     START_CHARGE_THRESH_BAT0 = 90;
  #     STOP_CHARGE_THRESH_BAT0 = 97;
  #     RUNTIME_PM_ON_BAT = "auto";
  #   };
  # };

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

  # Network Manager
  networking.networkmanager.enable = true;
  # Wpa Supplicant
  # networking.wireless.enable = true;

  # Set your time zone.
  time.timeZone = "America/Tijuana";

  # # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  #
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = false;
  # };

  environment = {
    shellAliases = {};
    variables = {};
    defaultPackages = [];
    systemPackages = with pkgs; [vim git coreutils rsync]; # busybox
  };

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    # alsa.support32Bit = true;
    # jack.enable = true;
  };

  # ------------- Fonts --------------- #
  fonts = {
    packages = with pkgs; [
      (nerdfonts.override {fonts = ["Hack" "Mononoki"];})
      noto-fonts-emoji
      dejavu_fonts
      ipafont
      kochi-substitute
      # rounded-mgenplus
      # Too Fancy
      # hanazono
    ];
    enableDefaultPackages = false;
  };

  # fonts.fontconfig.defaultFonts = {
  #   monospace = ["Hack Nerd Mono" "DejaVu Sans Mono" "IPAGothic"];
  #   sansSerif = ["DejaVu Sans" "IPAPGothic"];
  #   serif = ["DejaVu Serif" "IPAPMincho"];
  # };

  users.defaultUserShell = pkgs.bash;

  # ----------------------------------- #
  users.users.focus = {
    isNormalUser = true;
    description = "Evan Stokdyk";
    shell = pkgs.bash;
    extraGroups = ["wheel" "networkmanager" "audio" "video" "libvirtd"]; # "wireshark"
  };
  # ----------------------------------- #

  nix.settings.experimental-features = ["nix-command" "flakes"];
}
