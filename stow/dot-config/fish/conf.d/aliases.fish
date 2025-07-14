# Aliases
# see abbr.fish for a more full picture of my aliases

### 1 Key Aliases
# alias e "$EDITOR" # nvim
# alias o "$OPENER"
alias o "handlr open"
# alias m "$VIDEO"
alias m "mpv"
# alias i "$IMAGE"
alias i "imv"

alias n newsboat
# alias g="gix"

### 2 Key Aliases
alias ka killall
# alias it img2sixel

# file viewing
# alias ls eza
# alias la 'eza -a'
# alias ll 'eza -l'
# alias lla 'eza -la'
# alias lt 'eza --tree --level=4'
# alias lss="eza --group-directories-first --icons"
# alias l.='eza -a | command grep -E "^\."'

### core utils
alias cp="cp -ivr"
alias mv="mv -iv"
alias rm="rm -vI" # -I is not posix so this is an error on Busybox
alias mkd="mkdir -pv"
alias cat="bat --plain"

### yt-dl stuff
alias yt="yt-dlp --embed-metadata -i"
alias yta="yt-dlp --embed-metadata -i -x -f bestaudio/best --audio-format vorbis"
alias ytt="yt-dlp --embed-metadata -i --skip-download --write-thumbnail"

# alias cdf="cd (fd -t d . | fzf)"
alias wget="wget --hsts-file /dev/null"
alias psg="ps aux | grep -v grep | grep -i -e VSZ -e"
alias vdiff="nvim -d"
alias sdn 'shutdown -h now'

## Colors
alias grep="grep --color=auto"
alias diff="diff --color=auto"
alias ip="ip -color=auto"


alias nmutt='neomutt'
# alias land 'cat $HOME/.config/george.txt | cowsay -W 70'

### root privileges
# alias doas="doas --"
# alias sudo='doas'

alias ttc 'tty-clock -c -C 7 -r -f "%A, %B %d"'

alias free='free -m'
alias lynx='lynx -vikeys'
# alias ncmpcpp='ncmpcpp ncmpcpp_directory=$HOME/.config/ncmpcpp/'

# ps
alias psa="ps auxf"
alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
alias psmem='ps auxf | sort -nr -k 4'
alias pscpu='ps auxf | sort -nr -k 3'


# TODO: find out what this does
# source /etc/inputrc


# Use lf to switch directories and bind it to ctrl-o

# ********** The Binding of  **********
# bindkey -s '^o' '^ulfcd\n'
# bindkey -s '^f' '^ucd "$(dirname "$(fzf)")"\n'
# bindkey '^e' edit-command-line


# Lang
# export LANG=en_US.UTF-8

# fzf source
# source /usr/share/fzf/shell/key-bindings.fish

# Other program settings:
# export SUDO_ASKPASS="$HOME/.config/scripts/askpass"
# export QT_QPA_PLATFORMTHEME="gtk2" # Have QT use gtk2 theme.

# alias startw="wpa supplicant -B -D wext -i wlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf"


# Aliases

# alias cdf="cd \$(fd -t d . | fzf)"
#
# alias wget="wget --hsts-file /dev/null"
# alias psg="ps aux | grep -v grep | grep -i -e VSZ -e"
# alias vdiff="nvim -d"
#
# alias grep="grep --color=auto"
# alias diff="diff --color=auto"
# alias ip="ip -color=auto"
#
# alias h=history
# alias zr='zellij run -c --'
#
# alias ka="killall"
#
# alias nmutt='neomutt'
#
# # root privileges
# alias doas="doas --"
# #alias sudo='doas'



# alias free='free -m'
# alias lynx='lynx -vikeys'
# alias ncmpcpp='ncmpcpp ncmpcpp_directory=$HOME/.config/ncmpcpp/'

### ps
# alias psa="ps auxf"
# alias psgrep="ps aux | grep -v grep | grep -i -e VSZ -e"
# alias psmem='ps auxf | sort -nr -k 4'
# alias pscpu='ps auxf | sort -nr -k 3'


### ************* The Binding of  ************* ###
# bindkey -s '^o' '^ulf\n'
# bindkey -s '^f' '^ucdf\n'
# bindkey '^e' edit-command-line


# alias 'cpu-savepower'='cpupower frequency-set -g powersave'
# alias 'cpu-performance'='cpupower frequency-set -g performance'

# Lang
# export LANG=en_US.UTF-8



# # ---------------P R O M P T------------------
# #
# # Other program settings:
# export SUDO_ASKPASS="$HOME/.config/scripts/askpass"
# export SUDO_PROMPT=$'password for\033[32;05;16m %u\033[0m -> '
# export FZF_DEFAULT_OPTS="--layout=reverse --height 40%"
# # export QT_QPA_PLATFORMTHEME="gtk2" # Have QT use gtk2 theme.
#
#
# ### fzf source
# ### CTRL-T - Paste the selected file path(s) into the command line
# ### ALT-C - cd into the selected directory (DOESNT WORK)
# ### CTRL-R - Paste the selected command from history into the command line
# # DOESNT WORK ON NIX
# source /usr/share/fzf/shell/key-bindings.zsh
#
# export FZF_DEFAULT_OPTS="--layout=reverse --height 40%"
#
# # export FZF_DEFAULT_OPTS='
# #         --color hl:#dadada,hl+:#13171b,gutter:#13171b
# #         --color bg+:#ef7d7d,fg+:#2c2f30
# #         --color pointer:#373d49,info:#606672
# #         --height 13'
#
# # --color fg:#b6beca,bg:#13171b
# # --border
# # --color border:#13171b
#
#
# # export FZF_CTRL_R_OPTS="
# #   --preview 'echo {}' --preview-window up:3:hidden:wrap
# #   --bind 'ctrl-/:toggle-preview'
# #   --bind 'ctrl-y:execute-silent(echo -n {2..} | wl-copy)+abort'
# #   --color header:italic
# #   --header 'Press CTRL-Y to copy command into clipboard'"
#
# # aliases
# # alias uni="cd $HOME/dox/skool/13/"
# # alias uni-jap="cd $HOME/dox/skool/13/fall/japn/"
#
# alias doom1="chocolate-doom -iwad $HOME/dox/games/DOOM1.wad"
# alias doom2="chocolate-doom -iwad $HOME/dox/games/DOOM2.wad"
