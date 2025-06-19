#!/usr/bin/env bash

# After cloning this repo to ~/.dotfiles, run this to create symlinks

files=(
    .config/Code/User/keybindings.json
    .config/Code/User/settings.json
    .config/nvim/init.lua
    .git-completion.sh
    .git-prompt.sh
    .gitconfig
    .githooks/pre-commit
    .inputrc
    .my.sh
    .my.vim
    .mybase.vim
    .mytiny.vim
)

mkdir -p ../.config/nvim
mkdir -p ../.githooks
for path in ${files[@]}; do
    # Change path into the format "../../"
    up=$(echo $path | sed -E -e 's/[^/]*$//g' -e 's/[^/]*\//..\//g')
    ln -s $up.dotfiles/$path ../$path
done
echo Created symlinks
