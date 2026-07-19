#!/bin/bash
# ==============================================================================
# brew.sh - Homebrew Setup & Package Synchronization Module
# ==============================================================================
set -e

# Resolve script directory and source utilities if run directly
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [ -f "$SCRIPT_DIR/lib/utils.sh" ]; then
    source "$SCRIPT_DIR/lib/utils.sh"
fi

log_info "modules/brew.sh 실행 중..."
log_info "Homebrew 설치 상태 점검 및 macos/home/.Brewfile 패키지 동기화를 진행합니다."

# ==============================================================================
# 1. Homebrew Installation & Shellenv Setup
# ==============================================================================
if [ "$OS_TYPE" != "macOS" ]; then
    log_warn "Homebrew 설치 및 Brewfile 동기화는 macOS 환경에서만 지원됩니다."
    exit 0
fi

# Function to load Homebrew into current script context
load_brew_env() {
    if [ -f "/opt/homebrew/bin/brew" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -f "/usr/local/bin/brew" ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
}

# Check if brew command exists
if ! has_command brew; then
    log_info "Homebrew가 시스템에 감지되지 않았습니다. 설치를 진행합니다..."
    
    # Run the Homebrew installation non-interactively
    run_cmd env NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Load Homebrew environment immediately for subsequent commands in this process
    load_brew_env
else
    log_info "Homebrew가 이미 설치되어 있습니다. (건너뜀)"
fi

# Ensure brew command is now available in active path
load_brew_env

if ! has_command brew && [ "$DRY_RUN" != "1" ]; then
    error_exit "Homebrew가 성공적으로 설치되었거나 경로가 바르게 로드되지 않았습니다."
fi

# ==============================================================================
# 2. Brewfile Bundle Synchronization
# ==============================================================================
BREWFILE_PATH="$SCRIPT_DIR/../macos/home/.Brewfile"

if [ -f "$BREWFILE_PATH" ]; then
    log_info "Brewfile 동기화를 시작합니다: $BREWFILE_PATH"
    
    # Perform brew bundle execution
    # Some casks or MAS apps might require sudo password during upgrade/install.
    # We catch the exit status to avoid crashing the whole installer pipeline.
    bundle_status=0
    run_cmd brew bundle --file="$BREWFILE_PATH" || bundle_status=$?
    
    # Remove generated lockfile to keep the repository clean
    if [ -f "${BREWFILE_PATH}.lock.json" ]; then
        run_cmd rm -f "${BREWFILE_PATH}.lock.json"
    fi
    
    if [ $bundle_status -ne 0 ]; then
        log_warn "일부 Brewfile 패키지 동기화 중 경고가 감지되었습니다 (권한 요구 또는 MAS 로그인 미비)."
        log_warn "Exit Code: $bundle_status. 하지만 핵심 도구 설치가 확보되었으므로 진행을 이어갑니다."
    else
        log_info "Brewfile 동기화가 성공적으로 완료되었습니다."
    fi
else
    error_exit "Brewfile 원본 파일을 찾을 수 없습니다: $BREWFILE_PATH"
fi

log_success "brew.sh 모듈 설치 완료!"
