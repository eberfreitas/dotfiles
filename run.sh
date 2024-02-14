#!/bin/bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
ASDF_VERSION=v0.14.0

manage_symlink() {
    local target_path="$1"
    local source_file="$2"

    if [ -e "$target_path" ]; then
        if [ -L "$target_path" ] && [ "$(readlink "$target_path")" = "$source_file" ]; then
            echo "** symlink at $target_path already points to $source_file. doing nothing..."
        else
            if [ -L "$target_path" ]; then
                echo "** replacing existing symlink at $target_path with $source_file"
            else
                echo "** backing up existing file at $target_path to $target_path.bak"
            fi

            mv "$target_path" "$target_path.bak"
            ln -s "$source_file" "$target_path"

            echo "** symlink created at $target_path"
        fi
    else
        ln -s "$source_file" "$target_path"
        echo "** symlink created at $target_path"
    fi
}

update() {
    echo "** updating system packages..."
    sudo apt update && sudo apt upgrade -y
}

install_essentials() {
    echo "** installing essential software..."
    sudo apt install curl git tmux
}

setup_zsh() {
    if [ -z "$(command -v zsh)" ]; then
        echo "** zsh is not installed. installing..."
        sudo apt install zsh -y
    else
        echo "** zsh is already installed!"
    fi

    if [ "$SHELL" != "$(which zsh)" ]; then
        chsh -s "$(which zsh)"
        echo "** zsh is now the default shell. enter zsh and re-run this script."
        exit 0
    else
        echo "** zsh is already the default shell."
    fi
}

setup_omz() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "** omz is not installed. installing..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        echo "** omz is already installed. updating..."
        "$HOME/.oh-my-zsh/tools/upgrade.sh"
    fi
}

setup_asdf() {
    if [ ! -d "$HOME/.asdf" ]; then
        echo "** asdf is not installed. installing..."
        git clone https://github.com/asdf-vm/asdf.git "$HOME/.asdf" --branch "$ASDF_VERSION"
        sed -i.bak '/^plugins=(/ s/)$/ asdf)/' "$HOME/.zshrc"
    else
        echo "** asdf is already installed. updating..."
        asdf update
        echo "** updating asdf plugins..."
        asdf plugin update --all
    fi
}

setup_tpm() {
    tmux_plugins_dir="$HOME/.tmux/plugins/tpm"

    if [ ! -d "$tmux_plugins_dir" ]; then
        echo "** tpm is not installed. installing..."
        git clone https://github.com/tmux-plugins/tpm "$tmux_plugins_dir"
    else
        echo "** tpm is already installed."
    fi
}

update
install_essentials
manage_symlink "$HOME/.gitconfig" "$SCRIPT_DIR/git/.gitconfig"
setup_zsh
setup_omz
setup_asdf
setup_tpm
