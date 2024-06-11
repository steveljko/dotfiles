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
alias ls="exa --icons"
alias cd="z"

# ---------------------
#    External Tools
# ---------------------
. "$HOME/.asdf/asdf.sh"   # load asdf version manager
eval "$(zoxide init zsh)" # initialize zoxide for directory jumping
