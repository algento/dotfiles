#!/bin/bash
# Install vscode for ubuntu
# @author : Sejong Heo (tromberx@gmail.com)
# @file   : vscode-setup.sh
# Copyright (c) 2025 Sejong Heo, all rights reserved

# sudo snap install code

echo '--Add vscode repository to apt'
sudo apt install -y wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor >packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list >/dev/null
rm -f packages.microsoft.gpg

echo '--Install vscode with apt'
sudo apt update
sudo apt install -y vscode

echo '--Install vscode plugins'
