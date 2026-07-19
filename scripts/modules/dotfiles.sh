#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [ -f "$SCRIPT_DIR/lib/utils.sh" ]; then
    source "$SCRIPT_DIR/lib/utils.sh"
fi

log_info "modules/dotfiles.sh 실행 중..."
log_info "GNU Stow를 활용하여 설정 파일들의 심볼릭 링크 배선을 수행합니다."

run_cmd echo "[Stow] Linking dotfiles directories (stow -v -R -t ~ -d macos home)"
