#! /bin/bash
# Ubuntu 20.04 Setting
# @author : Sejong Heo (tromberx@gmail.com)
# @file   : mbp_setting_ubuntu20.04.sh
# Copyright (c) 2021 Sejong Heo, all rights reserved

echo '-- Update and Upgrade apt' 
sudo apt update
sudo apt upgrade

echo '-- Installing Wireless adapter driver for MBP 2014 late' 
sudo apt remove --purge bcmwl-kernel-source
sudo apt install broadcom-sta-source
sudo apt install broadcom-sta-dkms
sudo apt install broadcom-sta-common

echo 'Installing Dropbox'
sudo apt-get install -y nautilus-dropbox

echo 'Installing Lotion: Notion client'
sudo git clone https://github.com/puneetsl/lotion.git /usr/local/lotion
cd /usr/local/lotion && sudo ./install.sh

# Optional (for MBP 2014 late)
echo 'Installing TLP that saves battery when Ubuntu is installed on Laptops'
sudo apt-get remove laptop-mode-tools
sudo add-apt-repository ppa:linrunner/tlp
sudo apt-get update
sudo apt-get install -y tlp tlp-rdw smartmontools ethtool
sudo tlp start
sudo tlp stat

# Optional (for MBP 2014 late, ubuntu 16.04)
echo 'Installing  mactel-utils (intel Mac utilities):16.04'
sudo add-apt-repository ppa:detly/mactel-utils
sudo apt-get update
sudo apt-get install mactel-boot hfsprogs gdisk grub-efi-amd64

# show battery percentage
gsettings set org.gnome.desktop.interface show-battery-percentage true

# disable trackpad while typing
gsettings set org.gnome.desktop.peripherals.touchpad disable-while-typing true

echo '-- Enabling usb wake-up'
sh enable-usb-roothub-enable.sh

echo '-- Updating and cleaning unnecessary packages'
sudo sh -c 'apt update; apt upgrade -y; apt full-upgrade -y; apt autoremove -y; apt autoclean -y'