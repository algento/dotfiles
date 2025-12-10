#!/bin/bash
# Brew install list

# mas for Appstore Install
brew install mas
# curl,wget for download automation
brew install curl wget

# ------------------------------------------------ #
# Desktop application
# ------------------------------------------------ #

# Terminal ----------------------------------#
brew install --cask ghostty
brew install --cask kitty
# brew install --cask alacritty

# Browser & Cloud disk ----------------------#
brew install --cask google-chrome brave-browser opera
brew install --cask dropbox google-drive

# Productivity ------------------------------#
brew install --cask ticktick
brew install --cask input-source-pro karabiner-elements
brew install --cask tencent-lemon onyx
brew install --cask cyberduck folx
brew install --cask raycast

# Ebook -------------------------------------#
brew install --cask ridibooks millie

# menubar -----------------------------------#
brew install --cask vanilla

# automation tool ---------------------------#
brew install --cask hammerspoon

# window manager -------------------------- -#
brew install --cask nikitabobko/tap/aerospace
# brew install --cask rectangle
# brew install --cask rectangle-pro

# Programming -------------------------------#
brew install --cask visual-studio-code sublime-text
brew install --cask balenaetcher
brew install --cask container
# brew install colima
# brew install lima
# brew install --cask utm # Opensource VM for Silicon Mac

# Documentation
brew install --cask obsidian devonthink
brew install --cask pdf-expert papers
brew install --cask microsoft-office
brew install --cask mactex texifier
brew install --cask pdf-expert
brew install --cask pinta

# Github
brew install --cask github
brew install git git-delta git-extras git-lfs gh

# Docker
brew install --cask docker-desktop
brew install docker docker-compose

# ------------------------------------------------ #
# Latex
# ------------------------------------------------ #

# Fonts
brew install --cask font-jetbrains-mono font-jetbrains-mono-nerd-font
brew install --cask font-fira-code font-fira-mono font-fira-mono-for-powerline
brew install --cask font-noto-sans-cjk-kr font-noto-sans-mono-cjk-kr
brew install --cask font-symbols-only-nerd-font
# brew install --cask font-0xproto-nerd-font

# 한글 입력기: https://github.com/gureum/gureum
brew install --cask gereumkim

# ------------------------------------------------ #
# Terminal application
# ------------------------------------------------ #
# modern unix tools
brew install fd fzf ripgrep
brew install zoxide bat eza thefuck
brew install fonts-powerline
brew install tlrc # tldr
brew install git git-lfs

# tmux
brew install tmux tmuxinator

# programming langauge
brew install go zig npm lua # rust rustup nvm rbenv
curl https://sh.rustup.rs -sSf | sh -s

# c/c++ tools
brew install llvm clang-format gcc
brew install make cmake cmake-docs pkg-config
brew install ninja ccahe mold
brew install lcov gcovr
brew install doxygen
brew install postgresql
brew install tree-sitter tree-sitter-cli

# utility tools
brew install gnupg tree
brew install p7zip gzip
brew install nvim mermaid-cli luarocks jsonlint imagemagick pngpaste
brew install stow
brew install codex

# 텍스트 처리
brew install jq # JSON 처리
brew install yq # YAML 처리
brew install fx # JSON 뷰어
brew install vale

# tui application
brew install yazi
brew install lazygit lazydocker
# brew install neofetch
