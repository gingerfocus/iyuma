{
  pkgs,
  pkgs-unstable,
  # pkgs-stable,
  inputs,
  system,
  ...
}: {
  imports = [
    # ./pkgs/saka.nix
    ./work.nix
  ];
  # ~/.local/share/zed/external_agents/registry/opencode/v_1.14.40_5d952406c488fc43_efdccbece96c9a3c/opencode

  programs.nix-ld = {
    enable = true;
    # Optionally set a library path if the binary needs more than just glibc:
    # libraries = with pkgs; [
    #   stdenv.cc.cc
    #   openssl
    # ];
  };

  nixpkgs.config = {allowUnfree = true;};
  xdg.portal = {
    enable = true;

    extraPortals = [
      pkgs.xdg-desktop-portal-wlr
      pkgs.xdg-desktop-portal-gtk
      # pkgs.xdg-desktop-portal-gnome
    ];
    config = {};
  };

  environment = {
    variables = {
      # gsettings set org.gnome.desktop.input-sources xkb-options "['caps:swapescape']"
      XKB_DEFAULT_OPTIONS = "caps:swapescape"; # used by river
    };
    etc."xdg/xdg-desktop-portal-gtk/config".text = ''
      [OpenURI]
      cmd=/home/focus/.local/bin/open
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
    pinentryPackage = pkgs.pinentry-bemenu;
    # pinentryPackage = pkgs.pinentry-gnome3;
    enableSSHSupport = true;
  };

  ## Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  security.pam.services.swaylock = {};

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  environment.systemPackages = with pkgs;
    [
      bat
      fzf

      cava
      broot
      bottom
      alsa-utils

      rustup
      go

      ### Tools
      gdb
      gnumake
      cmake
      gcc
      patch

      # ghidra
      # qemu

      # groff

      ### Music
      # mpd
      # mpc-cli
      # mpdevil # clerk ncmpcpp
      # ncspot
      spotify

      weechat
      # discordo #
      discord
      newsboat

      mpv
      pandoc
      pass
      fdupes
      pdftk
      imagemagick
      # obs-studio
      # sent

      libnotify
      brightnessctl

      unzip
      zip
      btar
      libarchive

      # wget
      ripgrep
      mediainfo
      rsync # provided by system
      jq
      tty-clock
      file
      ffmpeg
      pfetch
      porsmo
      bluetuith
      dust
      xdg-utils
      # playerctl
      fd

      grim
      slurp

      nodejs
      bun
      # prettier

      ## Security
      # nmap

      # vorbis-tools

      # qastools
      # net-tools
      # simplescreenrecorder
      # brillo
      # ndctl
      # xfsprogs
      # archey

      # neo-cowsay
      # glow gum
      # slides charm
      # skate vhs

      # deluge

      ### Japanese
      # memento
      ani-cli
      # komikku

      # nautilus

      # parallel
      # alejandra

      # pavucontrol

      tealdeer
      wiki-tui
      wikiman
      man-pages
      # man-pages-posix

      # networkmanager-openconnect
      # openconnect_openssl
      # protonvpn-gui

      # libreoffice-fresh
      python3
      rclone

      ## Yeah Im a math major
      miktex
      # rocq-core
      typst
      julia

      pcalc
      just
      websocat

      ## Our minds are thinking
      blanket
      # anki

      ## Lsp Editor
      lua-language-server
      tinymist
      libclang # clangd
      gopls
      typescript-go
      # stylua
      tree-sitter

      # prismlauncher
      # inputs.neomacs.packages.${system}.default
      # kicad-small

      ## web browser
      chawan
      # qutebrowser

      # lutris

      # sioyek
      zathura

      yt-dlp

      inputs.zen-browser.packages."${system}".default
      # octaveFull
      # aichat
      bespokesynth
      # reaper
      dwarf-fortress

      godot
      pavucontrol

      # nomachine-client
    ]
    ++ (with pkgs-unstable; [
      # ghostty
      zig
      zls

      # docling
      neovide
      opencode
      # zed-editor

      # claude-code
      # antigravity-cli
      # antigravity-fhs
      # t3code

      runpodctl

      #claude-code
      #inputs.claude-desktop.packages."${system}".default

      # mathematica

      t3code
    ]);

  # virtualisation.docker.enable = true;
  users.users."focus".extraGroups = [ "docker" "tty" ];

  # allow ptrace debugging
  # boot.kernel.sysctl."kernel.yama.ptrace_scope" = pkgs.lib.mkOverride 10 0;

  documentation.enable = true;
  documentation.man.enable = true;
  documentation.dev.enable = true;

  # programs.wireshark.enable = true;
  # programs.wireshark.package = pkgs.wireshark;

  # programs.kdeconnect.enable = true;

  services.ollama = {
    enable = true;
    package = pkgs-unstable.ollama;
  };

  services.printing.enable = true;
}
