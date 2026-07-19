#!/bin/bash
set -e

# Resolve script directory and source utilities if run directly
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [ -f "$SCRIPT_DIR/lib/utils.sh" ]; then
    source "$SCRIPT_DIR/lib/utils.sh"
fi

log_info "modules/core.sh 실행 중..."
log_info "zsh, git, tmux, Neovim(bob v0.12.x) 설치 및 공통 설정을 연동합니다."

run_cmd echo "[Install] Core tools (zsh, git, tmux, bob-nvim)"
run_cmd echo "[Setup] Symbolic link creation for core config files"
