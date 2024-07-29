# ---------------------
#   Environment Setup
# ---------------------
# Adding directories to PATH
export PATH=$PATH:/usr/local/bin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.local/scripts
export PATH=$PATH:$HOME/.config/composer/vendor/bin
export PATH=$PATH:$HOME/go/bin

# Setting Zsh configuration directory
export ZSH="$HOME/.oh-my-zsh" 

export EDITOR=nvim

# ---------------------
#   Oh-My-Zsh Updates
# ---------------------
# Configure Oh-My-Zsh to update automatically
zstyle ':omz:update' mode auto     # update automatically without asking
zstyle ':omz:update' frequency 13

# ---------------------
#   Theme & Plugins
# ---------------------
ZSH_THEME="geometry/geometry" # enable zsh theme

# List of plugins to load
plugins=(
  git
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh # load oh-my-zsh config

# ---------------------
#       Aliases
# ---------------------
# Frequently used command aliases
alias v="nvim"
alias c="clear"
alias q="exit"
alias l="exa -l --icons"
alias ls="exa --icons"
alias cd="z"

alias gs="git status"
alias gaa="git add -A"
alias gc="git commit"

alias half="countdown 30m && notify-send 'Half hour happend'"

alias dcla="docker container ls -a"

alias pa="php artisan"
alias pas="php artisan serve"
alias pt="php artisan test"
alias ptt="php artisan test --filter "
alias pti="php artisan tinker"

# ---------------------
#    External Tools
# ---------------------
. "$HOME/.asdf/asdf.sh"   # load asdf version manager
eval "$(zoxide init zsh)" # initialize zoxide for directory jumping

function is_available {
  command -v "$1" &> /dev/null;
}

is_available zip \
  && alias zipdir='zip -r ../$(basename "$PWD").zip .' \
  && alias pzipdir='zip -er ../$(basename "$PWD").zip .'

export FZF_DEFAULT_OPTS='--color=16,bg:-1,bg+:15,hl:4,hl+:4,fg:-1,fg+:-1,gutter:-1,pointer:-1,marker:-1,prompt:1 --height 60% --reverse --color border:46 --border=sharp --prompt="➤  " --pointer="➤ " --marker="➤ "'

function __fsel_files() {
  setopt localoptions pipefail no_aliases 2> /dev/null
  eval find ./ -type f -print | fzf -m "$@" | while read item; do
    echo -n "${(q)item} "
  done
  local ret=$?
  echo
  return $ret
}

function fzf-vim {
    selected=$(__fsel_files)
    if [[ -z "$selected" ]]; then
        zle redisplay
        return 0
    fi
    zle push-line # Clear buffer
    BUFFER="v $selected";
    zle accept-line
}
zle -N fzf-vim
bindkey "^v" fzf-vim
bindkey -s '^a' "tsesh\n"

# if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
#   exec tmux new-session -A -s default; tmux set status off;
# fi
