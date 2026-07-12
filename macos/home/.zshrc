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
DISABLE_UNTRACKED_FILES_DIRTY="true"

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
# eval "$(fzf --zsh)"
plugins=(
  git
  fzf
  vscode
  zsh-autocomplete
  zsh-autosuggestions
  zsh-syntax-highlighting
  z
  # dirhistory
)

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
# Python
#------------------------------------------------------------------------------#
# Conda
export CONDA_HOME="$HOME/miniforge3"
export PATH="$CONDA_HOME/bin:$PATH"
source ${CONDA_HOME}/etc/profile.d/conda.sh

# commented out by conda initialize
# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!

# __conda_setup="$('$CONDA_HOME/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "$CONDA_HOME/etc/profile.d/conda.sh" ]; then
# # . "$CONDA_HOME/etc/profile.d/conda.sh"  # commented out by conda initialize  # commented out by conda initialize
#     else
#        export PATH="$CONDA_HOME/bin:$PATH"  # commented out by conda initialize
#     fi
# fi
# unset __conda_setup

#<<< conda initialize <<<

# for UV
export PATH="$HOME/.local/bin:$PATH" # for uv

#------------------------------------------------------------------------------#
# C/C++
#------------------------------------------------------------------------------#
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
# To install symlinks for compilers that will automatically use ccache
export PATH="/opt/homebrew/opt/ccache/libexec/:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/llvm/lib"
export CPPFLAGS="-I/opt/homebrew/opt/llvm/include"

export VCPKG_ROOT="$HOME/vcpkg"

#------------------------------------------------------------------------------#
# Rust
#------------------------------------------------------------------------------#
export PATH="$PATH:$HOME/.cargo/bin"

#------------------------------------------------------------------------------#
# Latex setting
#------------------------------------------------------------------------------#
export PATH="/usr/local/texlive/2025/bin/universal-darwin:$PATH"

#------------------------------------------------------------------------------#
# fzf/fd
#------------------------------------------------------------------------------#
eval "$(fzf --zsh)"

# -- Use fd instead of fzf --
export FZF_DEFAULT_COMMAND="fd --hidden --strip-cwd-prefix --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND="fd --type=d --hidden --strip-cwd-prefix --exclude .git"

# Use fd (https://github.com/sharkdp/fd) for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
    fd --hidden --exclude .git . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
    fd --type=d --hidden --exclude .git . "$1"
}

# --- setup fzf theme ---
fg="#CBE0F0"
bg="#011628"
bg_highlight="#143652"
purple="#B388FF"
blue="#06BCE4"
cyan="#2CF9ED"

export FZF_DEFAULT_OPTS="--color=fg:${fg},bg:${bg},hl:${purple},fg+:${fg},bg+:${bg_highlight},hl+:${purple},info:${blue},prompt:${cyan},pointer:${cyan},marker:${cyan},spinner:${cyan},header:${cyan}"

# --- setup fzf-git ---
source ${ZSH_CUSTOM}/fzf-git/fzf-git.sh

# --- setup fzf previewer ---
show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    z)            fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo ${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}
#------------------------------------------------------------------------------#
# bat (better cat)
#------------------------------------------------------------------------------#
# export BAT_THEME="Catppuccin Mocha"
alias cat="$(which bat)"
alias rcat="$(which cat)"

#------------------------------------------------------------------------------#
# eza (better ls)
#------------------------------------------------------------------------------#
# ls는 시스템 기본(plain)으로 두어 스크립트 파싱 안정성 확보. eza 롱뷰는 ll로 사용.
# alias ll="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias ll="eza --color=always --long --git --icons=always --no-user"

#------------------------------------------------------------------------------#
# Zoxide (better cd)
#------------------------------------------------------------------------------#
eval "$(zoxide init zsh)"
# alias cd="z"

#------------------------------------------------------------------------------#
# thefuck
#------------------------------------------------------------------------------#
eval $(thefuck --alias)
eval $(thefuck --alias fk)

#------------------------------------------------------------------------------#
# Git
#------------------------------------------------------------------------------#
# export PATH="/usr/local/opt/libiconv/bin:$PATH"

#------------------------------------------------------------------------------#
# NeoVim & Tmux
#------------------------------------------------------------------------------#
export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
export PATH="$HOME/.tmux/plugins/tmuxifier/bin:$PATH"
# export LANG=ko_KR.UTF-8
# export LC_ALL=ko_KR.UTF-8

#------------------------------------------------------------------------------#
# yazi
#------------------------------------------------------------------------------#
function y() {
    local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
    yazi "$@" --cwd-file="$tmp"
    if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then builtin cd -- "$cwd"
    fi
    rm -f -- "$tmp"
}

export XDG_CONFIG_HOME="$HOME/.config"

#------------------------------------------------------------------------------#
# brew setting
#------------------------------------------------------------------------------#
export PATH="/opt/homebrew/sbin:$PATH"
export PATH="/opt/homebrew/bin:$PATH"

#-------------------------------------------------------------------------------
# Docker
#-------------------------------------------------------------------------------

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/sejong/.docker/completions $fpath)
autoload -Uz compinit
compinit
# End of Docker CLI completions

export MY_VAULT="$HOME/Github/sejong-wiki"
export PATH="/usr/local/bin:$PATH"

#------------------------------------------------------------------------------#
#- MATLAB Setting
#------------------------------------------------------------------------------#
# export PATH="/Applications/MATLAB_R2021b.app/bin:$PATH"

#------------------------------------------------------------------------------#
# MLOpsND protobuf error
#------------------------------------------------------------------------------#
# export PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=python

#-------------------------------------------------------------------------------
# Ruby
#-------------------------------------------------------------------------------
# if [ -d "/usr/local/opt/ruby/bin" ]; then
#   export PATH=/usr/local/opt/ruby/bin:$PATH
#   export PATH=`gem environment gemdir`/bin:$PATH
# fi

# [[ -d ~/.rbenv ]] && \
#     export PATH=${HOME}/.rbenv/bin:$PATH && \
#     eval "$(rbenv init -)"
#
# export PATH="/usr/local/opt/libpq/bin:$PATH"
# export LDFLAGS="-L/usr/local/opt/libpq/lib"
# export CPPFLAGS="-I/usr/local/opt/libpq/include"


#-------------------------------------------------------------------------------
# Swift
#-------------------------------------------------------------------------------

# source ~/.swiftly/env.sh

# Added by Antigravity
export PATH="/Users/sejong/.antigravity/antigravity/bin:$PATH"

# Added by Antigravity IDE
export PATH="/Users/sejong/.antigravity-ide/antigravity-ide/bin:$PATH"
