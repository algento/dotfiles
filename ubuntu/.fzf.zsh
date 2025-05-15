# Setup fzf
# ---------
if [[ ! "$PATH" == */Users/sejongheo/.fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/Users/sejongheo/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/Users/sejongheo/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/Users/sejongheo/.fzf/shell/key-bindings.zsh"
