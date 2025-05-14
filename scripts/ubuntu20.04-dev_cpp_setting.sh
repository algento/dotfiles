#! /bin/bash
# Ubuntu 20.04 Setting
# @author : Sejong Heo (tromberx@gmail.com)
# @file   : dev_cpp_setting_ubuntu20.04.sh
# Copyright (c) 2021 Sejong Heo, all rights reserved

echo 'Start c++ development settings'

echo '-- Update and Upgrade apt' 
sudo apt update
sudo apt upgrade

echo '-- Installing ubuntu-restricted-extras'
sudo apt install ubuntu-restricted-extras

echo '-- Installing build-essential'	# essential build tools
sudo apt install -y build-essential
echo '-- Installing clang compiler and tools' # for clang environment and tools 
sudo apt install -y clang clang-tools clang-tidy clang-format clangd python3-clang libclang-dev libclang1

echo '-- Installing build tools'
sudo apt install -y cmake pkg-config
sudo apt install -y autoconf automake libtool checkinstall yasm doxygen

echo '-- Installing development utils (cppcheck, valgrind)'
sudo apt install -y cppcheck valgrind

echo '-- Installing latest gcc/g++(gcc-11, g++-11)'
# https://kukuta.tistory.com/394
sudo add-apt-repository ppa:ubuntu-toolchain-r/test
sudo apt update
sudo apt install -y gcc-11 g++-11
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-11 110 --slave /usr/bin/g++ g++ /usr/bin/g++-11
# sudo update-alternatives --config gcc


echo '-- Installing latest clang (14)'
# https://apt.llvm.org
wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key|sudo apt-key add -
apt-get install clang-14 lldb-14 lld-14
# # LLVM
# apt-get install libllvm-14-ocaml-dev libllvm14 llvm-14 llvm-14-dev llvm-14-doc llvm-14-examples llvm-14-runtime
# # Clang and co
# apt-get install clang-14 clang-tools-14 clang-14-doc libclang-common-14-dev libclang-14-dev libclang1-14 clang-format-14 python3-clang-14 clangd-14 clang-tidy-14 
# # libfuzzer
# apt-get install libfuzzer-14-dev
# # lldb
# apt-get install lldb-14
# # lld (linker)
# apt-get install lld-14
# # libc++
# apt-get install libc++-14-dev libc++abi-14-dev
# # OpenMP
# apt-get install libomp-14-dev
# # libclc
# apt-get install libclc-14-dev
# # libunwind
# apt-get install libunwind-14-dev
# # mlir
# apt-get install libmlir-14-dev mlir-14-tools



echo '-- Installing development utils (graphics)'
sudo apt install -y libcairo2-dev libgraphicsmagic1-dev libpng-dev libjpeg-dev

echo '-- Installing development utils (ncurses)'
sudo apt install -y libncurses-dev

echo '-- Installing git and related tools'
sudo add-apt-repository ppa:git-core/ppa -y
sudo apt-get update && sudo apt install -y git xclip

echo '-- Installing github CLI'
# https://github.com/cli/cli/blob/trunk/docs/install_linux.md
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y

echo '-- Installing programming interface tools'
sudo apt install -y libreadline-gplv2-dev libncursesw5-dev libssl-dev \
    libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev libffi-dev zlib1g-dev

echo '-- Installing python3 and related tools'
sudo apt install -y python3-dev python3-pip python3-venv -y
sudo -H pip3 install -U pip numpy
sudo apt install -y python3-testresources

echo 'Installing jre and jdk'
sudo apt install -y default-jre
sudo apt install -y default-jdk

echo '-- Installing eigen3'
sudo apt install -y libatlas-base-dev libeigen3-dev

echo '-- Installing ceres'
sudo apt install -y libceres-dev

echo '-- Installing pcl'
sudo apt install -y libpcl-dev

echo '-- Installing test package'
sudo apt install libgtest-dev libgoogle-glog-dev libgflags-dev

echo '-- Installing qt5'
sudo apt install qt5-default qt5-doc qt5-assistant libqglviewer-dev-qt5
sudo apt install qtcreator qt5-doc-html qtbase5-doc-html qtbase5-examples

echo '-- Installing opengl related tools'
sudo apt install freeglut3-dev libglu1-mesa-dev mesa-common-dev
sudo apt install libgles2-mesa-dev libglew-dev libglfw3-dev libglm-dev

echo '-- Installing programming fonts'
sudo apt install fonts-firacode
sudo apt install fonts-powerline
sudo apt install fonts-ubuntu-font-family-console
sudo apt install fonts-namum-coding fonts-naver-d2coding
sudo apt install fonts-hack fonts-ibm-plex fonts-inconsolata fonts-naver-d2coding
sudo apt install fonts-mathjax fonts-mathjax-extras

echo '--Installing ROS'
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list' # set up 'source.list'
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 # set up 'key'
sudo apt update
sudo apt install -y ros-noetic-desktop-full # ros desktop install
echo "source /opt/ros/noetic/setup.bash" >> ~/.bashrc # ros setup command to .bashrc
source~/.bashrc
sudo apt install python3-rosdep python3-rosinstall python3-rosinstall-generator python3-wstool build-essential # ros package python dependencys
#sudo apt-get install libeigen3-dev python-catkin-tools # ubuntu 16.04 or 18.04
sudo apt-get install libeigen3-dev python3-catkin-tools python3-osrf-pycommon # ubuntu 20.04
# rosdep initialize
sudo rosdep init
rosdep update

# catkin initialize
mkdir -p ~/catkin_ws/src
cd ~/catkin_ws/
catkin_make

echo '--Installing anacona (python virtual environment)'
# https://docs.anaconda.com/anaconda/install/linux/
sudo apt install libgl1-mesa-glx libegl1-mesa libxrandr2 libxrandr2 libxss1 libxcursor1 libxcomposite1 libasound2 libxi6 libxtst6
wget -P /tmp wget https://repo.anaconda.com/archive/Anaconda3-2021.05-Linux-x86_64.sh # change download url as latest one
sha256sum /tmp/Anaconda3-2021.05-Linux-x86_64.sh
bash /tmp/Anaconda3-2021.05-Linux-x86_64.sh
source~/.bashrc
# recommend conda config --set auto_activate_base false

echo '-- Updating and cleaning unnecessary packages'
sudo sh -c 'apt update; apt upgrade -y; apt full-upgrade -y; apt autoremove -y; apt autoclean -y'
