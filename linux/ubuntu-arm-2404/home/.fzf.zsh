# Setup fzf
FZF_BASE="/usr/locla/opt/fzf"
# ---------
if [[ ! "$PATH" == *$FZF_BASE/bin* ]]; then
  PATH="${PATH:+${PATH}:}$FZF_BASE/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "$FZF_BASE/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "$FZF_BASE/shell/key-bindings.zsh"
