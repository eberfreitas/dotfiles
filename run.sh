#!/bin/bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

manage_symlink() {
    local target_path="$1"
    local source_file="$2"

    echo "* symlinking $source_file"

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

manage_symlink "$HOME/.gitconfig" "$SCRIPT_DIR/git/.gitconfig"
manage_symlink "$HOME/.zshrc" "$SCRIPT_DIR/zsh/.zshrc"
manage_symlink "$HOME/.tmux.conf" "$SCRIPT_DIR/tmux/.tmux.conf"
manage_symlink "$HOME/.config/lvim/config.lua" "$SCRIPT_DIR/lunarvim/config.lua"
manage_symlink "$HOME/.config/lazygit/config.yml" "$SCRIPT_DIR/lazygit/config.yml"

echo '- Don'\''t forget to run "source ~/.zshrc" to refresh Zsh config'
echo '- Don'\''t forget to run "tmux source ~/.tmux.conf" to refresh tmux config'
