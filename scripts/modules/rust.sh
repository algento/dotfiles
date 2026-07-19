#!/bin/bash
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [ -f "$SCRIPT_DIR/lib/utils.sh" ]; then
    source "$SCRIPT_DIR/lib/utils.sh"
fi

log_info "modules/rust.sh 실행 중..."
log_info "rustup 및 stable 툴체인을 확보하고 cargo 환경을 정렬합니다."

run_cmd echo "[Install] rustup compiler manager"
run_cmd echo "[Install] stable toolchain via rustup"
