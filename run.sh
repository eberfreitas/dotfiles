#!/bin/bash

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

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

manage_symlink "$HOME/.gitconfig" "$SCRIPT_DIR/git/.gitconfig"
