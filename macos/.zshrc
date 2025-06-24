#------------------------------------------------------------------------------#
# Path to your oh-my-zsh installation.
#------------------------------------------------------------------------------#
export ZSH=$HOME/.oh-my-zsh

#------------------------------------------------------------------------------#
# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
# ZSH_THEME="robbyrussell"
#------------------------------------------------------------------------------#
ZSH_THEME="powerlevel10k/powerlevel10k"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

#------------------------------------------------------------------------------#
# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
#------------------------------------------------------------------------------#
# update your ~/.zshrc file
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

plugins=(
  git
  z
  zsh-autosuggestions
  fzf
  vscode
  zsh-syntax-highlighting
  # dirhistory
  
)

#-------------------------------------------------------------------------------
# Prefer zsh-completions
# @see https://stackoverflow.com/a/26479426
#-------------------------------------------------------------------------------
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

  autoload -Uz compinit
  compinit
fi

#------------------------------------------------------------------------------#
# Activate ZSH
#------------------------------------------------------------------------------#
source $ZSH/oh-my-zsh.sh

# User configuration

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

#------------------------------------------------------------------------------#
# brew setting 
#------------------------------------------------------------------------------#
export PATH="/usr/local/sbin:$PATH"
export PATH="/usr/local/opt/curl/bin:$PATH"
#------------------------------------------------------------------------------#
# Latex setting 
#------------------------------------------------------------------------------#
export PATH="/opt/local/bin:/opt/local/sbin:/opt/X11/bin:/usr/local/texlive/2022/bin/universal-darwin:$PATH"

#------------------------------------------------------------------------------#
#- MATLAB Setting 
#------------------------------------------------------------------------------#
# export PATH="/Applications/MATLAB_R2021b.app/bin:$PATH"

#------------------------------------------------------------------------------#
# OpenSSL Setting
#------------------------------------------------------------------------------#
export OPENSSL_ROOT_DIR=$(brew --prefix openssl)
export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

#------------------------------------------------------------------------------#
# Conda Setting
#------------------------------------------------------------------------------#
export CONDA_HOME=~/miniforge3
export PATH="$CONDA_HOME/bin:$PATH"
source ${CONDA_HOME}/etc/profile.d/conda.sh

# commented out by conda initialize
# >>> conda initialize >>>
# # !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('$CONDA_HOME/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$CONDA_HOME/etc/profile.d/conda.sh" ]; then
# . "$CONDA_HOME/etc/profile.d/conda.sh"  # commented out by conda initialize  # commented out by conda initialize
    else
       export PATH="$CONDA_HOME/bin:$PATH"  # commented out by conda initialize
    fi
fi
unset __conda_setup
#<<< conda initialize <<<

#------------------------------------------------------------------------------#
# C/C++ Dev Setting
#------------------------------------------------------------------------------#
export PATH="/usr/local/opt/llvm/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/llvm/lib"
export CPPFLAGS="-I/usr/local/opt/llvm/include"
export VCPKG_ROOT="$HOME/vcpkg"
export PATH="/usr/local/bin/mold:$PATH"

#-------------------------------------------------------------------------------
# MLOpsND protobuf error
#-------------------------------------------------------------------------------
# export PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=python

#-------------------------------------------------------------------------------
# Git
#-------------------------------------------------------------------------------
export PATH="/usr/local/opt/libiconv/bin:$PATH"

#-------------------------------------------------------------------------------
# Rust
#-------------------------------------------------------------------------------
export PATH="$PATH:$HOME/.cargo/bin"

#-------------------------------------------------------------------------------
# Ruby
#-------------------------------------------------------------------------------
# if [ -d "/usr/local/opt/ruby/bin" ]; then
#   export PATH=/usr/local/opt/ruby/bin:$PATH
#   export PATH=`gem environment gemdir`/bin:$PATH
# fi

[[ -d ~/.rbenv ]] && \
  export PATH=${HOME}/.rbenv/bin:$PATH && \
  eval "$(rbenv init -)"

export PATH="/usr/local/opt/libpq/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/libpq/lib"
export CPPFLAGS="-I/usr/local/opt/libpq/include"

#-------------------------------------------------------------------------------
# NeoVim & Tmux
#-------------------------------------------------------------------------------
export PATH="$HOME/.tmux/plugins/tmuxifier/bin:$PATH"
export LANG=ko_KR.UTF-8
export LC_ALL=ko_KR.UTF-8

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}
