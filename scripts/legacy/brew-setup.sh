#!/bin/bash
# Install brew and packages for ubuntu & Mac
# @author : Sejong Heo (tromberx@gmail.com)
# @file   : brew-setup.sh
# https://velog.io/@citron03/Mac-%EC%84%B8%ED%8C%85%ED%95%98%EA%B8%B0-brew-nvm-node-git
# Copyright (c) 2025 Sejong Heo, all rights reserved

echo '--Source untility scripts'
. ./script-utils.sh

echo '--Install dependencies'
if [ "$OS" = "Ubuntu" ]; then
    sudo apt install -y build-essential procps curl file git
fi

echo '--Install brew'
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo '--Set-up shell configurations'
add_line 'eval "$($(brew --prefix)/bin/brew shellenv)"' "$FILE"
echo '--Brew setup is done!'
echo '[Warning] Restart your terminal or run `source ' $FILE '`'
