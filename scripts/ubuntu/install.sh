#! /bin/bash
# Ubuntu 24.04 Setting for VMware Fusion on Mac-Mini M4 pro
# @author : Sejong Heo (tromberx@gmail.com)
# @file   : ubuntu-arm-2404/install.sh
# Copyright (c) 2025 Sejong Heo, all rights reserved

# Exit immediately if a command exits with a non-zero status
set -e

echo '-- Update and Upgrade apt'
sudo apt update
sudo apt upgrade

sudo apt install --reinstall open-vm-tools open-vm-tools-desktop
sudo reboot

echo '-- Install essential-pacakges'
# sudo apt install -y ubuntu-desktop
sudo apt install -y build-essential
sudo apt install -y curl wget
sudo apt install -y stow
sudo apt install -y fonts-powerline
sudo apt install -y fonts-firacode
sudo apt install -y fonts-jetbrains-mono

echo '-- Install modern-unix tools'
# sudo apt install fzf ripgrep fd-find bat zoxide eza thefuck

mkdir -p "$(bat --config-dir)/themes"
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Latte.tmTheme
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Frappe.tmTheme
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme
bat cache --build
# bat --list-themes

echo '-- Install git-related packages'
sudo apt install -y git gh git-delta git-lfs

echo '-- Installing C/C++-relateed tools'
sudo apt install -y llvm
sudo apt install -y clang clang-tools clang-tidy clang-format clangd python3-clang libclang-dev libclang1

sudo apt install -y clang-format clang-tidy clang-tools clang clangd
sudo apt install -y libc++-dev libc++1 libc++abi-dev libc++abi1 libclang-dev libclang1 liblldb-dev libllvm-ocaml-dev libomp-dev libomp5
sudo apt install -y lld lldb llvm-dev llvm-runtime llvm python3-clang

echo '-- Installing build tools'
sudo apt install -y cmake pkg-config
sudo apt install -y autoconf automake libtool checkinstall yasm doxygen

echo '-- Installing development utils (cppcheck, valgrind)'
sudo apt install -y cppcheck valgrind

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"

# Desktop Applications ------------------------------------------------------------#
echo '-- Install google-chrome'
# wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
# sudo apt install ./google-chrome-stable_current_amd64.deb
sudo apt install -y chromium-browser

sudo apt install libxinerama-dev libxcursor-dev xorg-dev libglu1-mesa-dev
