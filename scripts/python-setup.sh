#!/bin/bash
# Install python-related tools for Ubuntu & Mac
# @author : Sejong Heo (tromberx@gmail.com)
# @file   : zsh-setup.sh
# Copyright (c) 2025 Sejong Heo, all rights reserved

echo '--Source untility scripts'
. ./script-utils.sh

echo '--Install miniforge3'
curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh
rm Miniforge3-$(uname)-$(uname -m).sh

# Conda init —reverse $SHELL

echo '--Install uv'
curl -LsSf https://astral.sh/uv/install.sh | sh

add_line 'source "$HOME/.local/bin/env"' "$FILE"
echo '--Python setup is done!'
echo '[Warning] Restart your terminal or run `source ' $FILE '`'
