{ config, pkgs, scripts, ... }: 
let 
  mkScript = name: pkgs.writeScriptBin (builtins.baseNameOf name) (builtins.readFile name);
in {
  programs.neovim = {
    enable = true;
    # plugins = with pkgs.vimPlugins; [
    #   sniprun
    #   rose-pine
    # ];

    withNodeJs = false;
    withPython3 = false;
    withRuby = false;
  };

  environment.systemPackages = map mkScript (pkgs.lib.filesystem.listFilesRecursive "${scripts}/bin");

  environment.variables = rec {
    PATH = [
        "$HOME/dev/scripts"
        "$PATH"
    ];

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
