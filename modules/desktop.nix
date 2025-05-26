{
  config,
  pkgs,
  inputs,
  system,
  pkgs-unstable,
  ...
}:
let
  mkScript = name: pkgs.writeScriptBin (builtins.baseNameOf name) (builtins.readFile name);
in {
  imports = [ ./pkgs/neomacs.nix ];

  # xdg.icons.enable = false;

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # extraPortals = [
    #   # for screen sharing
    #   pkgs.xdg-desktop-portal-wlr
    #   # for file picking
    #   pkgs.xdg-desktop-portal-gtk
    # ];
    # xdgOpenUsePortal = true;
    # config.common.default = "*";
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
    enableSSHSupport = true;
  };

  ## Bluetooth
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  # services.blueman.enable = true;

  security.pam.services.swaylock = {};
  programs.river = {
    enable = true;
    extraPackages = with pkgs; [
      swaylock
      foot
      bemenu
      sandbar
      swww
      wl-clipboard
      imv
      wlr-randr
    ];
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  environment.systemPackages = with pkgs; [
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

    rustup
    # cargo rustc rust-analyzer
    pkgs-unstable.zig
    zls
    gdb
    clang
    # clang-tools
    # ghidra

    pcalc

    groff
    pandoc

    ## Langs
    # go
    # nim
    # gleam
    # erlang
    # elixir
    # bun nodejs
    # sassc
    # ghc
    # flutter

    ## Python
    # jupyter
    # python3
    # pip3
    # pyright

    ### Tools
    # clang gcc
    # gnumake
    # just

    # bazel meson cmake
    # qtcreator qt6.full

    ### Lsp (try to limit use of)
    # elixir-ls
    # shellcheck
    # gopls
    # lua-language-server
    # haskell-language-server
    # swiftlint

    #### Formating
    # shfmt
    # stylua
    # swiftformat
    # taplo

    ### Music
    # mpd
    # mpc-cli
    # mpdevil # clerk ncmpcpp

    # spotify
    ncspot
    discord
    discordo

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
    # rsync # provided by system
    jq
    killall
    tty-clock
    file
    ffmpeg
    # blender
    pfetch
    # drive
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
    # qutebrowser

    # godot_4

    imagemagick
    nautilus

    lynx

    libreoffice-fresh
    ghostscript

    nodejs

    # brave

    # code-cursor
    # zed-editor

    ## Security
    # nmap

    # vorbis-tools
    # man-db
    # mediainfo
    # linux-headers
    # qastools
    # nm-connection-editor
    # net-tools
    # netctl
    # gitoxide
    # cpupower-openrc
    # alsa-utils-openrc
    # cronie-openrc
    # dhcpcd-openrc
    # memtest86+
    # mkinitcpio-openswap
    # nfs-utils-openrc
    # ntp-openrc
    # openssh-openrc
    # gtk3
    # acpid-openrc
    # cups
    # ecryptfs-utils
    # gwenview
    # haveged-openrc
    # inxi
    # markdownpart
    # openrc-settingsd
    # partitionmanager
    # raw-thumbnailer
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
    # man-pages
    # mdadm-openrc
    # gpatch
    # micro
    # opam
    # open-mpi
    # openblas
    # peco
    # plplot
    # sccache
    # basictex
    # orbstack
    # swimat
    # alsa-utils
    # neo-cowsay
    # glow gum
    # slides charm
    # skate vhs
    # acpi
    # nginx
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
    # btrfs-progs
    # catch2
    # loupe
    # scdoc
    # snapshot
    # stb

    ### Games
    # lutris
    # (lutris.override { steamSupport = true; })

    ### Japanese
    # memento
    # komikku
    # ani-cli

    gcc
    # clang-manpages
    man-pages
    man-pages-posix

    (pkgs.callPackage ./pkgs/zen.nix {})

    neovim
  ];

  documentation.enable = true;
  documentation.man.enable = true;
  documentation.dev.enable = true;

  # programs.kdeconnect.enable = true;

  programs.steam = {
    enable = true;
    # remotePlay.openFirewall = true;
    # dedicatedServer.openFirewall = true;
  };

  # gtk = {
  #   enable = true;
  #   theme = {
  #     name = "Catppuccin-Mocha-Compact-Mauve-Dark";
  #     package = pkgs.catppuccin-gtk.override {
  #       accents = ["mauve"];
  #       size = "compact";
  #       variant = "mocha";
  #     };
  #   };
  #   # iconTheme = {
  #   #   name = "Papirus-Dark";
  #   #   package = pkgs.papirus-icon-theme;
  #   # };
  #   font = {
  #     name = "Hack Nerd Font Medium";
  #     # package = pkgs.nerdfont.override { fonts = [ "Hack", "Mononoki" ] }
  #   };
  # };

  environment.systemPackages = map mkScript (pkgs.lib.filesystem.listFilesRecursive "${inputs.scripts}/bin");

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

    VISUAL = "nvim"; # emacs
    EDITOR = "nvim";
    READER = "zathura";
    TERMINAL = "foot";
    BROWSER = "firefox";
    VIDEO = "mpv";
    IMAGE = "imv";
    OPENER = "xdg-open";
    PAGER = "less"; # TODO: use zss
    MANPAGER = "less";

    HISTORY_IGNORE = "(ls|cd|pwd|exit|sudo reboot|history|cd -|cd ..|clear)";
    LESSHISTFILE = "-";
  };
}
