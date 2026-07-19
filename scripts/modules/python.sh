#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [ -f "$SCRIPT_DIR/lib/utils.sh" ]; then
    source "$SCRIPT_DIR/lib/utils.sh"
fi

log_info "modules/python.sh 실행 중..."
log_info "pyenv 및 uv 패키지 매니저를 구성하고 파이썬 글로벌 버전을 설정합니다."

run_cmd echo "[Install] pyenv runtime manager"
run_cmd echo "[Install] uv packaging tool"
run_cmd echo "[Setup] python global version assignment"
