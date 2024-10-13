#!/bin/zsh

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
ASDF_VERSION="v0.14.1"
ASDF="$HOME/.asdf/bin/asdf"

manage_symlink() {
    local target_path="$1"
    local source_file="$2"

    echo "* symlinking $source_file"

    if [ ! -d "$(dirname "$target_path")" ]; then
        echo "* $target_path target folder does not exist. Creating it..."
        mkdir -p "$(dirname "$target_path")"
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

setup_omz
setup_asdf

install_with_asdf "bat"
install_with_asdf "difftastic"
install_with_asdf "fzf"
install_with_asdf "lazygit"
install_with_asdf "neovim"
install_with_asdf "nodejs"
install_with_asdf "ripgrep"
install_with_asdf "rust"
install_with_asdf "zellij"

manage_symlink "$HOME/.config/lazygit/config.yml" "$SCRIPT_DIR/lazygit/config.yml"
manage_symlink "$HOME/.config/nvim/lua" "$SCRIPT_DIR/nvim"
manage_symlink "$HOME/.config/zellij/config.kdl" "$SCRIPT_DIR/zellij/config.kdl"
manage_symlink "$HOME/.gitconfig" "$SCRIPT_DIR/git/.gitconfig"
manage_symlink "$HOME/.zshrc" "$SCRIPT_DIR/zsh/.zshrc"

echo '- don'\''t forget to open a terminal session to see changes'
echo '- don'\''t forget to run "$HOME/.asdf/installs/fzf/[version]/install" to enable auto completion and key bindings'
echo '- if any of the steps failed, close the terminal, open it and run this script again'
