#!/bin/bash
# Install vcpkg for ubuntu
# @author : Sejong Heo (tromberx@gmail.com)
# @file   : vscode-setup.sh
# Copyright (c) 2025 Sejong Heo, all rights reserved

sudo apt update
sudo apt install build-essential tar git zip unzip curl pkg-config

echo '--Install vcpkg'
git clone https://github.com/microsoft/vcpkg.git ~/vcpkg

cd ~/vcpkg
./bootstrap-vcpkg.sh

echo '--Create symbolic link'
sudo ln -s ~/vcpkg/vcpkg /usr/local/bin/vcpkg

# ./vcpkg help
# ./vcpkg list
