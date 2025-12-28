#!/bin/bash
# Install brew cask packages for Mac
# @author : Sejong Heo (tromberx@gmail.com)
# @file   : brew-install-cask.sh
# Copyright (c) 2025 Sejong Heo, all rights reserved

# curl,wget for download automation
brew install curl wget

# ------------------------------------------------ #
# Terminal application
# ------------------------------------------------ #
echo '--Install Terminal Applications'
brew install --cask ghostty
brew install --cask kitty
# brew install --cask alacritty

# ------------------------------------------------ #
# Browser & Cloud disk
# ------------------------------------------------ #
echo '--Install Browser & Cloud Disk'
brew install --cask google-chrome brave-browser opera
brew install --cask dropbox google-drive
brew install --cask cyberduck

# ------------------------------------------------ #
# Productivity
# ------------------------------------------------ #
# todo list
brew install --cask ticktick

# keyboard/mouse, 한글 입력기: https://github.com/gureum/gureum
brew install --cask input-source-pro karabiner-elements
brew install --cask gereumkim

# utility and tweak
brew install --cask tencent-lemon onyx

# torrent & download
brew install --cask folx

# advanced spotlight tools
brew install --cask raycast

# Ebook
brew install --cask ridibooks millie

# menubar
brew install --cask vanilla

# automation tool
brew install --cask hammerspoon

# window manager
brew install --cask nikitabobko/tap/aerospace
# brew install --cask rectangle
# brew install --cask rectangle-pro

# ------------------------------------------------ #
# Programming
# ------------------------------------------------ #
# Editor
brew install --cask visual-studio-code sublime-text

# iso tools
brew install --cask balenaetcher

# github desktop
brew install --cask github

# container
brew install --cask docker-desktop
brew install --cask container
# brew install colima
# brew install lima
# brew install --cask utm # Opensource VM for Silicon Mac

# Fonts
brew install --cask font-jetbrains-mono font-jetbrains-mono-nerd-font
brew install --cask font-fira-code font-fira-mono font-fira-mono-for-powerline
brew install --cask font-noto-sans-cjk-kr font-noto-sans-mono-cjk-kr
brew install --cask font-symbols-only-nerd-font
# brew install --cask font-0xproto-nerd-font

# ------------------------------------------------ #
# Documentation
# ------------------------------------------------ #
brew install --cask obsidian devonthink
brew install --cask pdf-expert papers
brew install --cask microsoft-office
brew install --cask mactex texifier
brew install --cask pdf-expert
brew install --cask pinta
