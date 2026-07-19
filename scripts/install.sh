#!/bin/bash
# ==============================================================================
# install.sh - Dev-Env-Management Bootstrap Entry Point
# ==============================================================================

set -e
set -E

# Resolve script directory path
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Source utility functions
if [ -f "$SCRIPT_DIR/lib/utils.sh" ]; then
    source "$SCRIPT_DIR/lib/utils.sh"
else
    echo "[ERROR] scripts/lib/utils.sh 를 찾을 수 없습니다." >&2
    exit 1
fi

# Set up error trapping (Omakub pattern)
trap 'trap_error ${LINENO} $? "$BASH_COMMAND"' ERR

# Display Help Message
show_help() {
    cat <<EOF
사용법: ./install.sh [옵션...]

옵션:
  -h, --help      도움말 메시지를 출력하고 종료합니다.
  -d, --dry-run   실제 설치 명령을 실행하지 않고 예상 수행 동작만 출력합니다.
  --core          zsh, git, tmux, nvim 공통 설정을 설치합니다.
  --macos         Homebrew, AeroSpace, Ghostty, Yazi 등 macOS용 도구를 설치합니다.
  --ubuntu        apt 패키지 및 Ubuntu 전용 설정을 설치합니다.
  --python        pyenv 및 uv를 사용하여 파이썬 개발 환경을 구축합니다.
  --rust          rustup 및 stable 툴체인을 설치합니다.

※ 옵션을 명시하지 않고 실행할 경우, 대화형 셸 환경에서는 확인 과정을 거친 후
   OS 감지 결과에 맞춰 기본 모듈 세트가 자동 가동됩니다.
EOF
}

# Default Options Status
export DRY_RUN=0
INSTALL_CORE=0
INSTALL_MACOS=0
INSTALL_UBUNTU=0
INSTALL_PYTHON=0
INSTALL_RUST=0
HAS_FLAG=0

# Parse Command Line Arguments
while [[ $# -gt 0 ]]; do
    case "$1" in
        -h|--help)
            show_help
            exit 0
            ;;
        -d|--dry-run)
            export DRY_RUN=1
            shift
            ;;
        --core)
            INSTALL_CORE=1
            HAS_FLAG=1
            shift
            ;;
        --macos)
            INSTALL_MACOS=1
            HAS_FLAG=1
            shift
            ;;
        --ubuntu)
            INSTALL_UBUNTU=1
            HAS_FLAG=1
            shift
            ;;
        --python)
            INSTALL_PYTHON=1
            HAS_FLAG=1
            shift
            ;;
        --rust)
            INSTALL_RUST=1
            HAS_FLAG=1
            shift
            ;;
        *)
            error_exit "알 수 없는 옵션입니다: $1 (도움말을 보려면 --help 를 사용하세요)"
            ;;
    esac
done

# Perform Pre-flight Check (OS & Shell Check)
pre_flight_check

# Handle Default Installation Selection (No flags provided)
if [ "$HAS_FLAG" = "0" ]; then
    # Check if standard input is a terminal (Interactive environment)
    if [ -t 0 ]; then
        echo -e -n "${YELLOW}[PROMPT] 지정된 설치 모듈 플래그가 없습니다. 현재 OS(${OS_TYPE})에 맞춰 기본 모듈 세트를 설치할까요? [y/N]: ${NC}"
        read -r answer
        case "$answer" in
            [yY][eE][sS]|[yY])
                log_info "기본 설치 구성을 승인하셨습니다."
                ;;
            *)
                log_info "설치가 취소되었습니다."
                exit 0
                ;;
        esac
    fi

    # Activate default modules
    INSTALL_CORE=1
    INSTALL_PYTHON=1
    INSTALL_RUST=1
    if [ "$OS_TYPE" = "macOS" ]; then
        INSTALL_MACOS=1
    elif [ "$OS_TYPE" = "Ubuntu" ]; then
        INSTALL_UBUNTU=1
    fi
fi

# ==============================================================================
# Execute Modular Installation Scripts
# ==============================================================================
log_info "설치를 시작합니다..."

# 1. OS-specific System Package Setup
if [ "$INSTALL_MACOS" = "1" ] && [ "$OS_TYPE" = "macOS" ]; then
    run_cmd bash "$SCRIPT_DIR/modules/brew.sh"
fi

# 2. Core Development Environment (zsh plugins, bob-nvim)
if [ "$INSTALL_CORE" = "1" ]; then
    run_cmd bash "$SCRIPT_DIR/modules/core.sh"
fi

# 3. Dotfiles Symlink Deployment (Stow)
if [ "$INSTALL_MACOS" = "1" ] && [ "$OS_TYPE" = "macOS" ]; then
    run_cmd bash "$SCRIPT_DIR/modules/dotfiles.sh"
fi

if [ "$INSTALL_UBUNTU" = "1" ] && [ "$OS_TYPE" = "Ubuntu" ]; then
    run_cmd bash "$SCRIPT_DIR/modules/dotfiles.sh"
fi

# 4. Runtime Environment Setup
if [ "$INSTALL_PYTHON" = "1" ]; then
    run_cmd bash "$SCRIPT_DIR/modules/python.sh"
fi

if [ "$INSTALL_RUST" = "1" ]; then
    run_cmd bash "$SCRIPT_DIR/modules/rust.sh"
fi

log_success "모든 설치 태스크가 정상 완료되었습니다!"
EOF=$(cat <<'EOF'
Note: 변경을 반영하려면 터미널을 다시 시작하거나 'source ~/.zshrc'를 실행하세요.
EOF
)
echo -e "${YELLOW}${EOF}${NC}"
