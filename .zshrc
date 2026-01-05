export EDITOR=nvim
plugins=(
    git
    sudo
    web-search
    archlinux
    zsh-autosuggestions
    zsh-syntax-highlighting
    fast-syntax-highlighting
    copyfile
    copybuffer
    dirhistory
)

source <(fzf --zsh)

# zsh history
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory
set -o vi

PROMPT="┌[%T]-[%n]-[%~]
└─> "

precmd() {
  # Set terminal title to "kitty [current directory]"
  print -Pn "\e]0;  %~\a"
}

preexec() {
  # Set terminal title to "kitty [current directory]"
  print -Pn "\e]0;  %~\a"
}

# -----------------------------------------------------
# ALIASES
# -----------------------------------------------------
alias c='clear'
alias ls='eza -a --icons=always'
alias ll='eza -al --icons=always'
alias lt='eza -a --tree --level=1 --icons=always'
alias v='$EDITOR'
 alias ..='cd ..'
 alias ...='cd ../..'

# -----------------------------------------------------
# Pywal
# -----------------------------------------------------
cat ~/.cache/wal/sequences
