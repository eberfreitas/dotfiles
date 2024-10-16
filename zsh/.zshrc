## https://github.com/ohmyzsh/ohmyzsh/wiki/Settings

## EXPORTS

export ZSH="$HOME/.oh-my-zsh"
export EDITOR="nvim"
export VISUAL="$EDITOR"

## OMZ STUFF

ZSH_THEME="avit"
plugins=(git asdf)

## ALIASES

alias sss="cd ~/ && clear && zellij"

# asdf installs everything locally, so running sudo directly doesn't work
# this command uses the local path variable so you can access everything
# from the root user
alias mysudo='sudo -E env "PATH=$PATH"'

## NIX
if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then . ~/.nix-profile/etc/profile.d/nix.sh; fi

## SOURCES

source $ZSH/oh-my-zsh.sh
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

