#! /bin/bash
# MacOS Setting
# @author : Sejong Heo (tromberx@gmail.com)
# @file   : setup_iMac.sh
# 참고: 
#   1. https://gist.githubusercontent.com/taking/1a03b19d580dda6376300d865b19b443/raw/db6dfe56088d8f12810da874b6f6d68108671275/.zshrc 
#   2. https://gist.githubusercontent.com/taking/9d24f1dec98b779eac44ceab24f6b5d2/raw/5a14ba522a654427a83df5b65c2722c092b399f0/Brewfile
#   3.. git clone https://github.com/djui/alias-tips.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/alias-tips  
# Copyright (c) 2022 Sejong Heo, all rights reserved

brew tap homebrew/bundle 
echo 'Homebrew Installed OK!' 

# Homebrew 설치 여부 확인
if ! which brew
then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    echo 'Homebrew Installed OK!'
fi
# xcode-select --install # xcode cli 설치 (안 깔렸으면)

# cask (외부 앱 설치)
brew install cask

# mas (애플 앱스토어용 앱 설치)
brew install mas

# brew bundle
brew tap homebrew/bundle 
echo 'Brewfile Package Installing..' 
brew bundle # brewFile 실행 명령어
echo 'Brewfile Package Installed OK!' 

# 스크립트 내에서 일부 sudo 권한이 필요한 명령을 수행하기 위해 root 패스워드를 입력
# sudo 권한이 필요한 이유 : cask로 설치한 애플리케이션을 바로 실행하기 위해 다운로드 된 파일에 대한 격리 속성 제거 작업
read -r -s -p "[sudo] sudo password for $(whoami):" pass

# cask로 다운로드시 웹에서 다운로드한 것과 동일하기 때문에 실행을 하면 Security 문제로 실행되지 않음
# cask로 설치한 애플리케이션을 바로 실행하기 위해 다운로드 된 파일에 대한 격리 속성 제거 작업 명령어
sudo xattr -dr com.apple.quarantine /Applications/Google\ Chrome.app
sudo xattr -dr com.apple.quarantine /Applications/Visual\ Studio\ Code.app
sudo xattr -dr com.apple.quarantine /Applications/Sublime\ Text.app
sudo xattr -dr com.apple.quarantine /Applications/Notion.app
sudo xattr -dr com.apple.quarantine /Applications/Slack.app

# # awscli를 사용하여 AWS 인증 정보 설정
# aws configure

## ZSH 설정 --------------------------------------------------------------------#
# oh-my-zsh 설치
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
# 설치경로 확인
which zsh
#=> /usr/bin/zsh
export ZSH=/Users/$USER/.oh-my-zsh
source $ZSH/oh-my-zsh.sh

# 기본 쉘 변경
chsh -s $(which zsh)

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

# zsh-autosuggestions
git clone git://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions

# powerlevel10k theme
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/themes/powerlevel10k

sudo chmod g-w /usr/local/share/zsh/site-functions
sudo chmod g-w /usr/local/share/zsh

echo 'zsh Installed OK!' 

## Mackup 복구------------------------------------------------------------------#
echo 'Mackup restore start!' 
mackup restore
echo 'Mackup restore OK!' 

# 설치 성공 완료 메세지 노출
printf '\n Setup iMac ends! \n'

pip install flawfinder lizard 
pip install pylint pyright # flake8 pyflake



