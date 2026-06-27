#!/bin/bash
# Install zsh and related framework/plugins for ubuntu
# @author : Sejong Heo (tromberx@gmail.com)
# @file   : zsh-setup.sh
# Copyright (c) 2025 Sejong Heo, all rights reserved

OS="$(uname -s)"
if [ "$OS" = "Linux" ]; then
    . /etc/os-release

    if [ "$ID" = "ubuntu" ]; then
        echo "Ubuntu detected!"
        echo '-- Install zsh'
        sudo apt install -y zsh
        chsh -s $(which zsh)
    else
        echo "Other Linux distro!: $ID"
    fi
elif [ "$OS" = "Darwin" ]; then
    echo "MacOS detected!"
else
    echo "Not linux or unix"
fi

echo '--Install Nerd font'
bash -c "$(curl -fsSL https://raw.githubusercontent.com/officialrajdeepsingh/nerd-fonts-installer/main/install.sh)"

echo '--Install oh-my-zsh'
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo '--Install powerlevel10k theme'
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

echo '--Install zsh-plugins'
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting

git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autocomplete

git clone https://github.com/junegunn/fzf-git.sh.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/fzf-git
