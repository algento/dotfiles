#! /bin/bash
# MacOS Big Sur Setting
# @author : Sejong Heo (tromberx@gmail.com)
# @file   : install_opencv4_MacOS.sh
# referenced from learnopencv.com
# Copyright (c) 2021 Sejong Heo, all rights reserved
#!/bin/sh

echo "opencv sejong-build by learnopencv.com"

echo "Make sure XCode is installed"

echo "Press Enter if you have installed XCode"

# read tmp

echo "Installing Homebrew"

# ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# # update homebrew 
# brew update
  
# # Add Homebrew path in PATH
# echo "# Homebrew" >> ~/.bash_profile
# echo "export PATH=/usr/local/bin:$PATH" >> ~/.bash_profile
# #source ~/.bash_profile

# brew install python3
# brew install cmake
# brew install qt5

QT5PATH=/usr/local/Cellar/qt/5.15.1

# sudo -H pip3 install -U pip numpy

# # Install virtual environment
# sudo -H python3 -m pip install virtualenv virtualenvwrapper
# VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3
# echo "VIRTUALENVWRAPPER_PYTHON=/usr/local/bin/python3" >> ~/.bash_profile
# echo "# Virtual Environment Wrapper" >> ~/.bash_profile
# echo "source /usr/local/bin/virtualenvwrapper.sh" >> ~/.bash_profile
# cd $cwd
# source /usr/local/bin/virtualenvwrapper.sh

#=================================================================

echo "Installing opencv - 4.5"

mkdir ~/Github
cd ~/Github

#Specify opencv version
cvVersion="4.5"

# Clean build directories
rm -rf opencv/build
rm -rf opencv_contrib/build

# Create directory for local-build
mkdir local-build
mkdir local-build/opencv-"$cvVersion"

############ For Python 3 ############
# create virtual environment
# mkvirtualenv opencv-"$cvVersion"-py3 -p python3
# workon opencv-"$cvVersion"-py3
# conda create -n opencv-3.4 python=3.7
conda activate opencv4
 
# now install python libraries within this virtual environment
pip install cmake numpy scipy matplotlib scikit-image scikit-learn ipython dlib
 
# quit virtual environment
# conda deactivate
######################################

git clone https://github.com/opencv/opencv.git
cd opencv
git checkout "$cvVersion"
cd ..
 
git clone https://github.com/opencv/opencv_contrib.git
cd opencv_contrib
git checkout "$cvVersion"
cd ..

cd opencv
mkdir build
cd build

cmake -D CMAKE_BUILD_TYPE=RELEASE \
        -D CMAKE_INSTALL_PREFIX=~Github/local-build/opencv-"$cvVersion" \
        -D INSTALL_C_EXAMPLES=ON \
        -D INSTALL_PYTHON_EXAMPLES=ON \
        -D WITH_TBB=ON \
        -D opencv_SKIP_PYTHON_LOADER=ON \
        -D CMAKE_PREFIX_PATH=$QT5PATH \
        -D CMAKE_MODULE_PATH="$QT5PATH"/lib/cmake \
        -D OPENCV_ENABLE_NONFREE=ON \
        -D opencv_PYTHON3_INSTALL_PATH=/usr/local/anaconda3/envs/opencv4/lib/python3.8/site-packages \
        -D BUILD_opencv_python2=OFF \
        -D opencv_PYTHON3_LIBRARY=/usr/local/anaconda3/envs/opencv4/lib/libpython3.8.dylib \
        -D WITH_QT=ON \
        -D WITH_OPENGL=ON \
        -D opencv_EXTRA_MODULES_PATH=/Users/sejong-imac/Sejong-Workspace/github/opencv_contrib/modules \
        -D BUILD_EXAMPLES=ON ..
        # -D WITH_V4L=ON ..
        
make -j$(sysctl -n hw.physicalcpu)
make install
conda deactivate
cd $cwd