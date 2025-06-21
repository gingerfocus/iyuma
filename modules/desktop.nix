{
  config,
  pkgs,
  inputs,
  system,
  pkgs-unstable,
  ...
}: {
  imports = [./pkgs/neomacs.nix ./games.nix];

  # xdg.icons.enable = false;

  # desktops.wayland.enable = true;

  xdg.portal = {
    enable = true;
    # wlr.enable = true;

    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];

    config = {
      gnome = {
        default = [ "gnome" "wlr" "gtk" ]; 
        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
        "org.freedesktop.impl.portal.OpenURI" = [ "xdg-open" ];
      };
    };
  };

  environment.etc."xdg/xdg-desktop-portal-gtk/config".text = ''
    [OpenURI]
    cmd=/run/current-system/sw/bin/xdg-open
  '';

  # ------------- Input --------------- #
  # i18n.inputMethod = {
  #   type = "fcitx5";
  #   enable = true;
  #   fcitx5.addons = [ pkgs.fcitx5-mozc ];
  # };
  # ----------------------------------- #

  programs.gnupg.agent = {
    enable = true;
    # pinentryPackage = pkgs.pinentry-bemenu;
    # pinentryPackage = pkgs.pinentry-gnome3;
    enableSSHSupport = true;
  };

  ## Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  # services.blueman.enable = true;

  security.pam.services.swaylock = {};
  programs.river.enable = true;

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  environment.systemPackages = with pkgs; [
      swaylock
      foot
      bemenu
      sandbar
      swww
      wl-clipboard
      imv
      wlr-randr

      firefox
      fish

      eza
      bat
      fzf
      # starship
      # sent
      tmux

      # cava
      # git
      bottom
      newsboat
      broot

      alsa-utils

      # rustup
      # cargo rustc rust-analyzer

      ### Tools
      gdb gnumake
      clang gcc

      man-pages man-pages-posix
      # just
      # clang-tools
      # ghidra

      groff
      pandoc

      ### Music
      # mpd
      # mpc-cli
      # mpdevil # clerk ncmpcpp

      # spotify
      ncspot

      discord
      # discordo
      weechat

      newsboat
      mpv

      pass
      # fdupes
      # pdftk
      # imagemagick
      # obs-studio

      zathura
      mako
      libnotify
      brightnessctl

      unzip
      btar
      libarchive

      wget
      ripgrep
      yt-dlp
      # mediainfo
      rsync # provided by system
      jq
      killall
      tty-clock
      file
      ffmpeg
      pfetch
      # pavucontrol
      porsmo
      # playerctl
      bluetuith
      # mprocs
      du-dust
      # wiki-tui
      xdg-utils
      # inotify-tools
      # cool-retro-term
      fd

      grim
      slurp

      obsidian

      # godot_4

      # nautilus

      lynx

      libreoffice-fresh
      # ghostscript
      # imagemagick

      nodejs

      ## Security
      # nmap

      # vorbis-tools
      # linux-headers
      # qastools
      # nm-connection-editor
      # net-tools
      # netctl
      # alsa-utils-openrc
      # cronie-openrc
      # dhcpcd-openrc
      # memtest86+
      # ntp-openrc
      # acpid-openrc
      # ecryptfs-utils
      # gwenview
      # haveged-openrc
      # inxi
      # markdownpart
      # spectacle
      # tumbler
      # imgclr
      # xdotool
      # simplescreenrecorder
      # pamixer
      # brillo
      # ndctl
      # xfsprogs
      # archey
      # dmraid
      # libva-vdpau-driver
      # libvdpau-va-gl
      # lsb-release
      # lvm2-openrc
      # gpatch
      # micro
      # opam
      # open-mpi
      # openblas
      # peco
      # plplot
      # basictex
      # orbstack
      # swimat
      # alsa-utils
      # neo-cowsay
      # glow gum
      # slides charm
      # skate vhs
      # acpi
      # deluge
      # inxi
      # nbd
      # nfs-utils-openrc
      # openrc-settingsd
      # powertop
      # scrot
      # svgpart
      # sweeper
      # sysfsutils
      # syslog-ng-openrc
      # texinfo
      # vkd3d
      # re2
      # catch2
      # loupe
      # scdoc
      # snapshot
      # stb

      ### Japanese
      # memento
      # komikku
      # ani-cli



      (pkgs.callPackage ./pkgs/zen.nix {})

      # qutebrowser

      # pkgs.texlive.combined.scheme-medium
    ]
    ++ (with pkgs-unstable; [
      # code-cursor
      zed-editor
      ghostty

      neovim

      zig zls
    ])
    ++ (map
        (name: pkgs.writeScriptBin (builtins.baseNameOf name) (builtins.readFile name))
        (pkgs.lib.filesystem.listFilesRecursive
          "${inputs.scripts}/bin"));

  # environment.systemPackages = map mkScript (pkgs.lib.filesystem.listFilesRecursive "${inputs.scripts}/bin");

  documentation.enable = true;
  documentation.man.enable = true;
  documentation.dev.enable = true;

  # programs.kdeconnect.enable = true;

  environment.variables = rec {
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.cache";
    # export XDG_DESKTOP_DIR="$HOME/cur"; # this moves the location of where `.desktop` files go
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
}
