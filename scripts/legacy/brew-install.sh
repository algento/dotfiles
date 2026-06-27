#!/bin/bash
# Install brew packages for Ubuntu & Mac
# @author : Sejong Heo (tromberx@gmail.com)
# @file   : brew-install.sh
# Copyright (c) 2025 Sejong Heo, all rights reserved

echo '--Install modern unix tools'
# finding-tools
brew install fd fzf ripgrep
# file-navigation and monitoring tools
brew install zoxide eza thefuck
# tldr (community-maintained help pages)'
brew install tlrc

echo '--Install bat & catppuccin themes for bat'
brew install bat
mkdir -p "$(bat --config-dir)/themes"
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Latte.tmTheme
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Frappe.tmTheme
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme
bat cache --build
# bat --list-themes

echo '--Install tmux & tmux-plugins'
brew install tmux tmuxinator
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

echo '--Install modern TUI tools'
brew install nvim
brew install yazi
brew install lazygitb
brew install lazydocker

echo '--Install json/yaml viewer and processor'
brew install jq yq fx

brew install rust

brew install go

brew install lua

brew install gcc llvm
brew install cmake cmake-lint cmake-docs
brew install pkgconf
brew install ninja ccache
brew install tree-sitter tree-sitter-cli
brew install automake autoconf
brew install doxygen yasm

brew install git git-delta git-extras git-lfs gh
brew install docker docker-compose
