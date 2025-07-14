{
  pkgs,
  pkgs-unstable,
  inputs,
  system,
  ...
}: {
  imports = [
    # ./pkgs/saka.nix
    # ./neomacs.nix
  ];

  xdg.portal = {
    enable = true;

    # extraPortals = [
    #   pkgs.xdg-desktop-portal-wlr
    #   pkgs.xdg-desktop-portal-gtk
    #   pkgs.xdg-desktop-portal-gnome
    # ];

    config = {
      # gnome = {
      #   default = ["gnome" "wlr" "gtk"];
      #   "org.freedesktop.impl.portal.Secret" = ["gnome-keyring"];
      #   "org.freedesktop.impl.portal.OpenURI" = ["xdg-open"];
      # };
    };
  };
  # gsettings set org.gnome.desktop.input-sources xkb-options "['caps:swapescape']"

  environment = {
    variables = rec {
      FANCYDESKTOP = "1"; # Enable features in my vim config
    };

    etc."xdg/xdg-desktop-portal-gtk/config".text = ''
      [OpenURI]
      cmd=/run/current-system/sw/bin/xdg-open
    '';
  };

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

  # programs.hyprland.enable = true;

  security.pam.services.swaylock = {};

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  environment.systemPackages = with pkgs;
    [
      imv
      foot
      swww
      bemenu
      sandbar
      swaylock
      wl-clipboard
      wlr-randr

      # eza
      bat
      fzf
      # starship
      tmux

      # cava
      git
      bottom
      newsboat
      broot

      alsa-utils

      rustup
      # cargo rustc rust-analyzer

      ### Tools
      gdb
      gnumake
      gcc
      # gpatch

      # just
      # clang-tools
      # ghidra

      groff
      pandoc

      ### Music
      # mpd
      # mpc-cli
      # mpdevil # clerk ncmpcpp
      ncspot # spotify

      weechat
      discord
      # discordo
      newsboat

      mpv
      pass

      # fdupes
      # pdftk
      # imagemagick
      # obs-studio
      # sent
      libreoffice-fresh

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
      porsmo
      bluetuith
      du-dust
      xdg-utils
      # playerctl
      # mprocs
      # fd

      grim
      slurp

      nodejs

      ## Security
      # nmap

      # vorbis-tools

      # qastools
      # net-tools
      # ecryptfs-utils
      # gwenview
      # haveged-openrc
      # inxi
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
      # micro
      # opam
      # open-mpi
      # openblas
      # peco
      # orbstack
      # swimat

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
      # sweeper
      # sysfsutils
      # vkd3d
      # re2
      # catch2
      # loupe
      # snapshot
      # stb

      ### Japanese
      # memento
      # komikku
      # ani-cli

      # ion
      fish

      inputs.zen-browser.packages."${system}".default
      firefox
      # qutebrowser
      lynx
      # obsidian
      # nautilus

      typst
      parallel
      alejandra

      pavucontrol

      tealdeer
      wiki-tui
      man-pages
      man-pages-posix

      # emacs29-pgtk
    ]
    ++ (with pkgs-unstable; [
      ghostty
      zig
      zls
      wikiman
    ])
    ++ (map
      (name:
        pkgs.writeScriptBin
        (builtins.baseNameOf name)
        (builtins.readFile name))
      (pkgs.lib.filesystem.listFilesRecursive
        "${inputs.scripts}/bin"));

  # allow ptrace debugging
  boot.kernel.sysctl."kernel.yama.ptrace_scope" = pkgs.lib.mkOverride 10 0;

  documentation.enable = true;
  documentation.man.enable = true;
  documentation.dev.enable = true;
}
