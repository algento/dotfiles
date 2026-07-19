#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [ -f "$SCRIPT_DIR/lib/utils.sh" ]; then
    source "$SCRIPT_DIR/lib/utils.sh"
fi

log_info "modules/brew.sh 실행 중..."
log_info "Homebrew 설치 상태 점검 및 macos/home/.Brewfile 패키지 동기화를 진행합니다."

run_cmd echo "[Install] Homebrew system packages (Brewfile bundle)"
