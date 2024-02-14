## https://github.com/ohmyzsh/ohmyzsh/wiki/Settings

## EXPORTS

export ZSH="$HOME/.oh-my-zsh"

## OMZ STUFF

ZSH_THEME="avit"
plugins=(git asdf)

## ALIASES

alias sss='cd ~/ && clear && tmux'

# asdf installs everything locally, so running sudo directly doesn't work
# this command uses the local path variable so you can access everything
# from the root user
alias mysudo='sudo -E env "PATH=$PATH"'

# git aliases
alias gs='git status -s'
alias gl='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'

## SOURCES

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
source $ZSH/oh-my-zsh.sh
