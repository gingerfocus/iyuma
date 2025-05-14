{ config, pkgs, inputs, system, pkgs-unstable, ... }: {
  imports = [ ];

  xdg.portal = {
    enable = true;
    extraPortals = [
      # for screen sharing
      pkgs.xdg-desktop-portal-wlr
      # for file picking
      pkgs.xdg-desktop-portal-gtk
    ];

    xdgOpenUsePortal = true;
    config.common.default = "*";
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
    # pinentryPackage = pkgs.pinentry-gnome3;
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
      swaylock foot bemenu
      sandbar swww wl-clipboard
      imv wlr-randr
    ];
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # PATH="$PATH:$HOME/.local/bin:$CARGO_HOME/bin:$HOME/dev/scripts"
  # PATH="$PATH:$HOME/.local/share/go/bin/"
  # export PATH="$PATH:$HOME/.local/bin:$CARGO_HOME/bin:$HOME/.config/scripts"

  programs.bash.interactiveShellInit = ''
    PS1="\[$(tput bold)\]\[$(tput setaf 1)\][\[$(tput setaf 3)\]\u\[$(tput setaf 2)\]@\[$(tput setaf 4)\]\h \[$(tput setaf 5)\]\W\[$(tput setaf 1)\]]\[$(tput setaf 7)\]\\$ \[$(tput sgr0)\]"
    export HISTFILE="$USER/.local/share/bash/history"
  '';

  # programs.starship.enable = true;
  # programs.starship.enableFishIntegration = true;
  # programs.starship.enableBashIntegration = false;

  environment.systemPackages = with pkgs; [
    firefox
    fish
    eza
    bat
    fzf
    # starship
    # sent

    # cava
    foot
    # git
    # river
    bottom
    newsboat
    broot

    alsa-utils
    # (pkgs.callPackage ./pkgs/jerry.nix {})

    # cargo rustc rust-analyzer # alternaticly: rustup
    pkgs-unstable.zig zls
    gdb clang
    # clang-tools
    # ghidra

    tmux

    # nixfmt-classic
    pcalc

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

    spotify
    discord

    newsboat
    mpv

    pass
    # fdupes
    # pdftk
    # imagemagick

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
    # hyperfine
    # obs-studio
    killall
    tty-clock
    file
    ffmpeg
    # blender
    pfetch
    # drive
    # pavucontrol
    # networkmanagerapplet
    porsmo
    # playerctl
    bluetuith
    # mprocs
    du-dust
    # wiki-tui
    xdg-utils
    # handlr-regex
    # neo-cowsay
    # browserpass
    # inotify-tools
    # cool-retro-term
    fd

    # Security
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
    # lsb-release
    # vscodium
    # lvm2-openrc
    # mdadm-openrc
    # memtest86+
    # mkinitcpio-openswap
    # nfs-utils-openrc
    # ntp-openrc
    # openssh-openrc
    # vkd3d
    # wpa_supplicant-openrc
    # gtk3
    # acpid-openrc
    # cups
    # ecryptfs-utils
    # gwenview
    # haveged-openrc
    # inxi
    # libva-vdpau-driver
    # libvdpau-va-gl
    # markdownpart
    # nbd
    # openrc-settingsd
    # partitionmanager
    # powertop
    # raw-thumbnailer
    # scrot
    # spectacle
    # svgpart
    # sweeper
    # texinfo
    # tumbler
    # imgclr
    # xdotool
    # simplescreenrecorder
    # pamixer
    # brillo
    # ndctl
    # xfsprogs
    # archey
    # gpatch
    # loc
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

    # dmraid
    # libva-vdpau-driver
    # libvdpau-va-gl
    # lsb-release
    # lvm2-openrc
    # man-pages
    # markdownpart
    # mdadm-openrc
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
    # wpa_supplicant-openrc
    # re2
    # btrfs-progs
    # catch2
    # gitoxide
    # gptfdisk
    # loupe
    # scdoc
    # snapshot
    # stb
    # neovide
    # wasmtime

    # rclone
    # rclone-browser
    ## OR
    # insync

    grim slurp

    ### Games
    # heroic
    # (lutris.override { steamSupport = true; })

    ## Do this one
    # lutris

    ### Japanese
    # memento
    # komikku
    # ani-cli

    obsidian
    # qutebrowser

    # godot_4

    imagemagick
    # nautilus

    lynx

    rustup

    libreoffice-fresh
    ghostscript

    pandoc
    nodejs

    # brave

    # code-cursor
    # zed-editor
    # vscode
  ];
  # programs.kdeconnect.enable = true;

  programs.steam = {
    enable = true;
    # remotePlay.openFirewall = true;
    # dedicatedServer.openFirewall = true;
  };

}
