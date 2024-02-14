#!/bin/bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
ASDF_VERSION="v0.14.0"
ASDF="$HOME/.asdf/bin/asdf"

manage_symlink() {
    local target_path="$1"
    local source_file="$2"

    echo "* symlinking $source_file"

    if [ ! -d "$(dirname "$target_path")" ]; then
        echo "* target folder does not exist. unable to create symlink."
        echo ""

        return 1
    fi

    if [ -e "$target_path" ]; then
        if [ -L "$target_path" ] && [ "$(readlink "$target_path")" = "$source_file" ]; then
            echo "* symlink at $target_path already points to $source_file. doing nothing..."
        else
            if [ -L "$target_path" ]; then
                echo "* replacing existing symlink at $target_path with $source_file"
            else
                echo "* backing up existing file at $target_path to $target_path.bak"
            fi

            mv "$target_path" "$target_path.bak"
            ln -s "$source_file" "$target_path"

            echo "* symlink created at $target_path"
        fi
    else
        ln -s "$source_file" "$target_path"
        echo "* symlink created at $target_path"
    fi

    echo ""
}

install_with_asdf() {
    local plugin="$1"

    echo "* installing $plugin with asdf..."

    eval "$ASDF plugin add $plugin"
    eval "$ASDF install $plugin latest"
    eval "$ASDF global $plugin latest"

    echo ""
}

update() {
    echo "* updating system packages..."
    sudo apt update && sudo apt upgrade -y
    echo ""
}

install_essentials() {
    echo "* installing essential software..."
    sudo apt install make curl git tmux zsh python3 pip -y
    echo ""
}

setup_zsh() {
    if [ "$SHELL" != "$(which zsh)" ]; then
        chsh -s "$(which zsh)"
        echo "* zsh is now the default shell. rebooting in 5 seconds..."
        sleep 5
        sudo reboot
    else
        echo "* zsh is already the default shell."
    fi

    echo ""
}

setup_omz() {
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "* omz is not installed. installing..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    else
        echo "* omz is already installed. updating..."
        "$HOME/.oh-my-zsh/tools/upgrade.sh"
    fi

    echo ""
}

setup_asdf() {
    if [ ! -d "$HOME/.asdf" ]; then
        echo "* asdf is not installed. installing..."
        git clone https://github.com/asdf-vm/asdf.git "$HOME/.asdf" --branch "$ASDF_VERSION"
    else
        echo "* asdf is already installed. updating..."
        eval "$ASDF update"
        echo "* updating asdf plugins..."
        eval "$ASDF plugin update --all"
    fi

    echo ""
}

setup_tpm() {
    tmux_plugins_dir="$HOME/.tmux/plugins/tpm"

    if [ ! -d "$tmux_plugins_dir" ]; then
        echo "* tpm is not installed. installing..."
        git clone https://github.com/tmux-plugins/tpm "$tmux_plugins_dir"
    else
        echo "* tpm is already installed."
    fi

    echo ""
}

setup_lunarvim() {
    if [ ! -d "$HOME/.config/lvim" ]; then
        echo "* lunarvim is not installed. installing..."
        LV_BRANCH='release-1.3/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.3/neovim-0.9/utils/installer/install.sh)
        sudo mv $HOME/.local/bin/lvim /usr/local/bin/
    else
        echo "* lunarvim is already installed. updating..."
        lvim +LvimUpdate +q
    fi

    echo ""
}

update
install_essentials
setup_zsh
setup_omz
setup_asdf
setup_tpm

install_with_asdf "neovim"
install_with_asdf "ripgrep"
install_with_asdf "fzf"
install_with_asdf "difftastic"
install_with_asdf "bat"
install_with_asdf "lazygit"
install_with_asdf "nodejs"
install_with_asdf "rust"

setup_lunarvim

manage_symlink "$HOME/.gitconfig" "$SCRIPT_DIR/git/.gitconfig"
manage_symlink "$HOME/.zshrc" "$SCRIPT_DIR/zsh/.zshrc"
manage_symlink "$HOME/.tmux.conf" "$SCRIPT_DIR/tmux/.tmux.conf"
manage_symlink "$HOME/.config/lvim/config.lua" "$SCRIPT_DIR/lunarvim/config.lua"
manage_symlink "$HOME/.config/lazygit/config.yml" "$SCRIPT_DIR/lazygit/config.yml"

echo '- don'\''t forget to run "source ~/.zshrc" to refresh zsh config'
echo '- don'\''t forget to run "tmux source ~/.tmux.conf" to refresh tmux config'
echo '- don'\''t forget to run "$HOME/.asdf/installs/fzf/[version]/install" to enable auto completion and key bindings'
echo '- if any of the steps failed, close the terminal, open it and run this script again'
