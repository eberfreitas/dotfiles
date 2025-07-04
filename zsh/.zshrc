## https://github.com/ohmyzsh/ohmyzsh/wiki/Settings

## EXPORTS

export ZSH="$HOME/.oh-my-zsh"
export EDITOR="nvim"
export VISUAL="$EDITOR"

## OMZ STUFF

ZSH_THEME="avit"
plugins=(git asdf)

source $ZSH/oh-my-zsh.sh

## ALIASES

alias start="cd ~/ && clear && zellij"

# asdf installs everything locally, so running sudo directly doesn't work
# this command uses the local path variable so you can access everything
# from the root user
alias mysudo='sudo -E env "PATH=$PATH"'

## STUFF

if command -v direnv &> /dev/null; then
    eval "$(direnv hook zsh)"
fi

if command -v starship &> /dev/null; then
    eval "$(starship init zsh)"
fi

[ -f "$HOME/.atuin/bin/env" ] && . "$HOME/.atuin/bin/env"

if command -v atuin >/dev/null 2>&1; then
    eval "$(atuin init zsh)"
fi

if [[ -d "$HOME/.lmstudio/bin" ]]; then
  export PATH="$PATH:$HOME/.lmstudio/bin"
fi

if [ -r "$HOME/.opam/opam-init/init.zsh" ]; then
    source "$HOME/.opam/opam-init/init.zsh" > /dev/null 2> /dev/null
fi
