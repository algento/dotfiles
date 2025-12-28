#! /bin/bash
# Ubuntu 20.04 Setting
# @author : Sejong Heo (tromberx@gmail.com)
# @file   : util_setting_ubuntu20.04.sh
# Copyright (c) 2021 Sejong Heo, all rights reserved
 
echo 'Start utility program settings'

echo '-- Update and Upgrade apt' 
sudo apt update
sudo apt upgrade

echo '-- Installing snapd'
sudo apt install -y snapd

# sudo apt install -y zsh
echo '-- Installing curl(cli-download tool)'
sudo apt install -y curl

echo '-- Installing Gimp Image Editor'
sudo apt install -y gimp gimp-data gimp-plugin-registry gimp-data-extras

echo '-- Installing Sticky Notes'
sudo apt install -y xpad

echo '-- Installing Nomacs: image viewer'
sudo apt install -y nomacs

echo '-- Installing VLC: media playe'
sudo apt-get install vlc -y

echo '-- Installing Snaptic: package manager'
sudo apt install -y synaptic

echo '-- Installing Inkscape: vector graphics editor'
sudo apt install -y inkscape

echo '-- Installing Scientific tools (sciLab, cctave, gnuPlot)'
sudo apt install -y scilab octave gnuplot

echo '-- Installing gnome-tweak-tool'
sudo apt install -y gnome-tweak-tool

echo '-- Installing gnome-software'
sudo apt install -y gnome-software

echo '-- Installing bleachbit'
sudo apt install -y bleachbit

echo '-- Installing Double Commander'
# sudo apt-get install doublecmd-gtk
sudo apt install doublecmd-qt

# echo '-- Installing Brew (Package Manager for Mac)'
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
# echo '-- Uninstalling Brew (Package Manager for Mac)'
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/uninstall.sh)"

# echo '-- Installing Jetbrains-toolbox'
# # Open Console and change the directory
# cd /opt/
# # Extract the file
# sudo tar -xvzf ~/Downloads/jetbrains-toolbox-1.xx.xxxx.tar.gz
# # Rename the folder (not mandatory but it's easier for later use)
# sudo mv jetbrains-toolbox-1.xx.xxxx jetbrains
# #Open JetBrains Toolbox
# jetbrains/jetbrains-toolbox
# # If you can't open the file type 'sudo apt install libfuse2'

echo '-- Installing Chrome'
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
sudo apt update
sudo apt install google-chrome-stable
ls /etc/apt/sources.list.d/google*
sudo rm -rf /etc/apt/sources.list.d/google.list


echo '-- Installing Github CLI'
type -p curl >/dev/null || sudo apt install curl -y
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y

echo '-- Installing Rust'
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

echo '-- Installing Alacritty'
cargo install alacritty

echo '-- Installing hfsprogs'
sudo apt install hfsprogs

echo '-- Installing spotify: music streaming service'
sudo apt install spotitfy

echo '-- Installing texlive-full & texmaker'
sudo apt install texlive-full
# sudo apt install ko.tex
sudo apt install texmaker

echo '-- Installing Typora'
# based on https://support.typora.io/Typora-on-Linux/
# # or use
# # wget -qO - https://typora.io/linux/public-key.asc | sudo apt-key add -
# wget -qO - https://typoraio.cn/linux/public-key.asc | sudo tee /etc/apt/trusted.gpg.d/typora.asc

# # add Typora's repository
# sudo add-apt-repository 'deb https://typora.io/linux ./'
# sudo apt-get update

# # install typora
# sudo apt-get install typora
sudo snap install typora
sudo apt install -y pandoc

echo '-- Installing docker'
sudo apt install apt-transport-https ca-certificates curl gnupg lsb-release
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io

sudo apt install -y terminator
sudo apt install -y filezilla
sudo apt install -y ghex

mkdir ~/Github/etc
cd ~/Github/etc
git clone https://github.com/rbreaves/kinto.git
cd kinto
sudo apt update
sudo apt install python3
./setup.py
cd ~

echo '-- Installing system monitoring tools'
sudo add-apt-repository ppa:oguzhaninan/stacer -y
sudo apt update
sudo apt install stacer -y

echo '-- Updating and cleaning unnecessary packages'
sudo sh -c 'apt update; apt upgrade -y; apt full-upgrade -y; apt autoremove -y; apt autoclean -y'
