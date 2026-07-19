#!/bin/bash
# ==============================================================================
# brew.sh - Homebrew Setup & Package Synchronization Module (macOS & Ubuntu)
# ==============================================================================
set -e

# Resolve script directory and source utilities if run directly
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [ -f "$SCRIPT_DIR/lib/utils.sh" ]; then
    source "$SCRIPT_DIR/lib/utils.sh"
fi

log_info "modules/brew.sh 실행 중..."
log_info "Homebrew 설치 상태 점검 및 패키지 동기화를 진행합니다."

# ==============================================================================
# 1. OS Compatibility Check
# ==============================================================================
if [ "$OS_TYPE" != "macOS" ] && [ "$OS_TYPE" != "Ubuntu" ]; then
    log_warn "Homebrew 설치는 macOS 및 Ubuntu 환경에서만 지원됩니다."
    exit 0
fi

# Function to load Homebrew into current script context
load_brew_env() {
    if [ -f "/opt/homebrew/bin/brew" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -f "/usr/local/bin/brew" ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    elif [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
}

# Load current context environment if already installed
load_brew_env

# Check if brew command exists, if not proceed to installation
if ! has_command brew; then
    log_info "Homebrew가 시스템에 감지되지 않았습니다. 설치를 진행합니다..."
    
    if [ "$OS_TYPE" = "Ubuntu" ]; then
        log_info "Linuxbrew 설치를 위해 필수 의존성(build-essential, curl 등)을 먼저 확보합니다..."
        run_cmd sudo apt update -y
        run_cmd sudo apt install -y build-essential procps curl file git
    fi
    
    # Run the Homebrew installation non-interactively
    run_cmd env NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Load Homebrew environment immediately for subsequent commands in this process
    load_brew_env
else
    log_info "Homebrew가 이미 설치되어 있습니다. (건너뜀)"
fi

# Double check if brew path resolved correctly
load_brew_env

if ! has_command brew && [ "$DRY_RUN" != "1" ]; then
    error_exit "Homebrew가 성공적으로 설치되었거나 경로가 바르게 로드되지 않았습니다."
fi

# ==============================================================================
# 2. Brewfile Bundle Synchronization
# ==============================================================================
BREWFILE_PATH=""
if [ "$OS_TYPE" = "macOS" ]; then
    # macOS uses full configuration (.Brewfile)
    BREWFILE_PATH="$SCRIPT_DIR/../macos/home/.Brewfile"
elif [ "$OS_TYPE" = "Ubuntu" ]; then
    # Ubuntu only installs common CLI tools (Brewfile.common)
    BREWFILE_PATH="$SCRIPT_DIR/../macos/home/Brewfile.common"
fi

if [ -f "$BREWFILE_PATH" ]; then
    log_info "Brewfile 동기화를 시작합니다: $BREWFILE_PATH"
    
    # Perform brew bundle execution
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

# ==============================================================================
# 3. Ubuntu-specific VS Code Snap Installation & Extension Sync
# ==============================================================================
if [ "$OS_TYPE" = "Ubuntu" ]; then
    # If code command is not present, check GUI environment and install via snap
    if ! has_command code; then
        # Check if desktop display environment is active (GUI environment)
        if [ -n "${DISPLAY:-}" ]; then
            log_info "우분투 데스크톱 GUI 환경을 감지했습니다. VS Code 설치를 시작합니다 (snap)..."
            run_cmd sudo snap install --classic code
        else
            log_info "헤드리스/서버 환경입니다. VS Code GUI 설치를 건너뜁니다."
        fi
    fi
    
    # Sync VS Code extensions if code is now available
    if has_command code || [ "$DRY_RUN" = "1" ]; then
        VSCODE_BREWFILE_PATH="$SCRIPT_DIR/../macos/home/Brewfile.vscode"
        if [ -f "$VSCODE_BREWFILE_PATH" ]; then
            log_info "VS Code 환경이 감지되어 익스텐션 동기화를 진행합니다: $VSCODE_BREWFILE_PATH"
            bundle_status=0
            run_cmd brew bundle --file="$VSCODE_BREWFILE_PATH" || bundle_status=$?
            
            if [ -f "${VSCODE_BREWFILE_PATH}.lock.json" ]; then
                run_cmd rm -f "${VSCODE_BREWFILE_PATH}.lock.json"
            fi
            
            if [ $bundle_status -ne 0 ]; then
                log_warn "일부 VS Code 익스텐션 설치 중 경고가 감지되었습니다. Exit Code: $bundle_status"
            else
                log_info "VS Code 익스텐션 동기화가 완료되었습니다."
            fi
        fi
    else
        log_warn "VS Code가 설치되지 않아 Brewfile.vscode 동기화를 건너뜁니다. (원격 환경 권장)"
    fi
fi

log_success "brew.sh 모듈 설치 완료!"
