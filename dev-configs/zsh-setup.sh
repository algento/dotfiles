#!/bin/bash

# -------------------------------------------- #
# oh-my-zsh install
# -------------------------------------------- #
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# -------------------------------------------- #
# powerlevel10k
# -------------------------------------------- #
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

# -------------------------------------------- #
# zsh-plugins
# -------------------------------------------- #
git clone https://github.com/zsh-users/zsh-autosuggestions.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting

git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autocomplete

git clone https://github.com/junegunn/fzf-git.sh.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/fzf-git

# -------------------------------------------- #
# tmux-plugins
# -------------------------------------------- #
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
