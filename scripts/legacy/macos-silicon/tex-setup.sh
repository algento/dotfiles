#!/bin/bash
# [macOS에서 Tex 설치하기](https://nonametex.imweb.me/?q=YTozOntzOjEyOiJrZXl3b3JkX3R5cGUiO3M6MzoiYWxsIjtzOjc6ImtleXdvcmQiO3M6MzoibWFjIjtzOjQ6InBhZ2UiO2k6Mjt9&bmode=view&idx=150835187&t=board)
# [macOS에서 Tex 업그레이드 후 할일](https://nonametex.imweb.me/?q=YTozOntzOjEyOiJrZXl3b3JkX3R5cGUiO3M6MzoiYWxsIjtzOjc6ImtleXdvcmQiO3M6MzoibWFjIjtzOjQ6InBhZ2UiO2k6Mjt9&bmode=view&idx=156966511&t=board)
# https://m.blog.naver.com/elecdory/222791512509

# -------------------------------------- #
# MacTex First install
# -------------------------------------- #
sudo tlmgr option repository https://mirror.kakao.com/CTAN/systmes/texlive/tlnet/
# sudo tlmgr option repository https://mirror.navercorp.com/CTAN/systems/texlive/tlnet

sudo tlmgr pinning remove ktug "*"
sudo tlmgr repository add https://mirror.ischo.org/KTUG/texlive/tlnet ktug
# sudo tlmgr repository add http://ftp.ktug.org/KTUG/texlive/tlnet ktug
sudo tlmgr pinning add ktug "*"
curl -O https://mirror.ischo.org/KTUG/texlive/tlnet/ktugrepo.pub.txt
sudo tlmgr key add ./ktugrepo.pub.txt

sudo tlmgr install nanumttf hcr-lvt jiwonlipsum ksmisc
sudo tlmgr update --all --self
# sudo tlmgr update --all --self --reinstall-forcibly-removed
