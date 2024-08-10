# [ General ]
is_available() { command -v "$1" &> /dev/null; }

export HISTCONTROL="ignoredups:ignorespace"
export HISTFILE=~/.zsh_history
export HISTSIZE=5000
export SAVEHIST="${HISTSIZE}"
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt APPENDHISTORY
setopt SHAREHISTORY

export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

is_available tmux \
  && export ZSH_TMUX_AUTOSTART=true

is_available nvim \
  && export EDITOR=nvim

export MOZ_ENABLE_WAYLAND="1"

# [ OMZ ]
export ZSH="$HOME/.oh-my-zsh" 

zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 20 

ZSH_THEME="geometry/geometry"

plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

# [ Paths ]
export PATH=$PATH:$HOME/go/bin
export PATH=$PATH:$HOME/.cargo/bin
export PATH=$PATH:$HOME/.local/bin
export PATH=$PATH:$HOME/.local/scripts
export PATH=$PATH:$HOME/.config/composer/vendor/bin

# [ Aliases ]
is_available zoxide \
  && [ "${USER}" != "root" ] \
  && eval "$(zoxide init zsh)" \
  && alias cd='z'

is_available tmux \
  && alias t='tmux' \
  && alias ta='tmux attach -t' \
  && alias tls='tmux list-session'

is_available nvim \
  && alias v='nvim' \
  && alias vim='nvim'

is_available exa \
  && alias ls='exa --icons --grid --classify --colour=auto --sort=type --group-directories-first --header --modified --created --git --binary --group' \
  && alias la='ls -a' \
  && alias ll='ls -al'

is_available eva \
  && alias calc='eva'

is_available fzf \
  && alias preview='fzf --preview "bat {} --color=always"'

is_available task \
  && alias tt='task status:pending list' \
  && alias tf='task end:today status:completed list'

alias myip='curl http://ipecho.net/plain; echo'
alias localip="ip addr show enp4s0 | grep 'inet ' | awk '{print \$2}' | cut -d'/' -f1"

alias c='clear'
alias q='exit'
alias rmrf='rm -rf'

alias dk='docker'

alias pa='php artisan'
alias pas='php artisan serve'
alias pt='php artisan test'
alias ptt='php artisan test --filter '
alias pti='php artisan tinker'

# [ Functions ]
mkcd() { mkdir -p "$1" && cd "$1" }

# [ Additional Sources ]
. "$HOME/.asdf/asdf.sh"
