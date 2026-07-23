#!/bin/bash
# ==============================================================================
# rust.sh - Rust Environment Setup Module (rustup & stable toolchain)
# ==============================================================================
set -e

# Resolve script directory and source utilities if run directly
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [ -f "$SCRIPT_DIR/lib/utils.sh" ]; then
    source "$SCRIPT_DIR/lib/utils.sh"
fi

log_info "modules/rust.sh 실행 중..."
log_info "rustup 및 stable 툴체인을 확보하고 cargo 환경을 정렬합니다."

# ==============================================================================
# 1. Install rustup if not present
# ==============================================================================
# Load cargo PATH just in case it is installed but not in current context
export PATH="$HOME/.cargo/bin:$PATH"

if ! has_command rustup; then
    log_info "rustup 컴파일러 관리 도구가 시스템에 감지되지 않았습니다. 설치를 진행합니다..."
    
    # Run the official rustup installer in non-interactive/silent mode
    # -y: skip interactive prompts, --no-modify-path: shell profiles are managed via dotfiles
    run_cmd curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path
    
    # Reload active cargo path context
    export PATH="$HOME/.cargo/bin:$PATH"
else
    log_info "rustup이 이미 설치되어 있습니다. (건너뜀)"
fi

# ==============================================================================
# 2. Configure Default Toolchain
# ==============================================================================
if has_command rustup || [ "$DRY_RUN" = "1" ]; then
    log_info "stable 툴체인을 기본 컴파일러 버전으로 설정 및 동기화합니다..."
    run_cmd rustup default stable
    
    if [ "$DRY_RUN" != "1" ] && has_command rustc; then
        log_success "설치된 Rust 컴파일러 버전: $(rustc --version)"
    fi
else
    log_warn "rustup 명령을 호출할 수 없어 Rust 설정을 스킵합니다."
fi

log_success "rust.sh 모듈 설치 완료!"
