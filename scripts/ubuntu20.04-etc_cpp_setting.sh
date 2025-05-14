#! /bin/bash
# Ubuntu 20.04 Setting
# @author : Sejong Heo (tromberx@gmail.com)
# @file   : etc_setting_ubuntu20.04.sh
# Copyright (c) 2021 Sejong Heo, all rights reserved

echo '-- Update and Upgrade apt' 
sudo apt update
sudo apt upgrade

echo '-- Installing programming fonts'
sudo apt install fonts-firacode
sudo apt-get install fonts-powerline
sudo apt-get install fonts-cascadia-code
sudo apt-get install fonts-hack fonts-ibm-plex fonts-inconsolata fonts-naver-d2coding
sudo apt-get install fonts-mathjax fonts-mathjax-extras

echo '-- Installing Font Source Code Pro'
version=1.050
# Downloading version $version of source code pro font
rm -f SourceCodePro_FontsOnly-$version.zip
rm -rf SourceCodePro_FontsOnly-$version
font_folder=source-code-pro-2.030R-ro-${version}R-it
zip_file=${version}R-it.zip
wget https://github.com/adobe-fonts/source-code-pro/archive/2.030R-ro/$zip_file
# Unziping package"
unzip $zip_file
mkdir -p ~/.fonts
# Copying fonts to ~/fonts"
cp $font_folder/OTF/*.otf ~/.fonts/
# Updating font cache"
sudo fc-cache -f -v
# Looking for 'Source Code Pro' in installed fonts"
fc-list | grep "Source Code Pro"
# "font_face": "Source Code Pro",'

echo '--Installing vscode'
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt install -y apt-transport-https
sudo apt update
sudo apt install -y code

# g++-12 symbolic-link ln -s <g++-11 path> /usr/local/bin/g++-12

echo '--Installing other editors (vim, sublime-text3, typora)'
# sublime text 3 repository
sudo apt install dirmngr gnupg apt-transport-https ca-certificates software-properties-common
curl -fsSL https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo add-apt-repository "deb https://download.sublimetext.com/ apt/stable/"

# install editors
sudo apt-get update
sudo apt install -y sublime-text
sudo apt install -y vim

# sudo add-apt-repository ppa:webupd8team/sublime-text-3
# sudo apt update
# sudo apt install sublime-text-installer

echo '-- Updating and cleaning unnecessary packages'
sudo sh -c 'apt update; apt upgrade -y; apt full-upgrade -y; apt autoremove -y; apt autoclean -y'









