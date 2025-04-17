#!/bin/zsh

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

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

    eval "asdf plugin add $plugin"
    eval "asdf install $plugin latest"
    eval "asdf set $plugin latest"

    echo ""
}

cd $HOME

install_with_asdf "bat"
install_with_asdf "difftastic"
install_with_asdf "fzf"
install_with_asdf "lazygit"
install_with_asdf "neovim"
install_with_asdf "nodejs"
install_with_asdf "ripgrep"
install_with_asdf "rust"
install_with_asdf "starship"
install_with_asdf "zellij"

manage_symlink "$HOME/.config/alacritty" "$SCRIPT_DIR/alacritty"
manage_symlink "$HOME/.config/atuin/config.toml" "$SCRIPT_DIR/atuin/config.toml"
manage_symlink "$HOME/.config/nvim" "$SCRIPT_DIR/nvim"
manage_symlink "$HOME/.config/zellij/config.kdl" "$SCRIPT_DIR/zellij/config.kdl"
manage_symlink "$HOME/.gitconfig" "$SCRIPT_DIR/git/.gitconfig"
manage_symlink "$HOME/.zshrc" "$SCRIPT_DIR/zsh/.zshrc"

echo 'DONE'
