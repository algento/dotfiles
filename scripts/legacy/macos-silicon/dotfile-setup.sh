#!/bin/bash

git clone https://github.com/algento/dotfiles.git
cd dotfiles/macos
stow -v -t ~ *
