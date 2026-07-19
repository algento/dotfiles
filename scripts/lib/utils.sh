#!/bin/bash
# ==============================================================================
# utils.sh - Common Utilities for Dev-Env-Management Installation Scripts
# ==============================================================================

# ANSI Color Codes
export RED='\033[0;31m'
export GREEN='\033[0;32m'
export YELLOW='\033[0;33m'
export BLUE='\033[0;34m'
export NC='\033[0m' # No Color

# Logging Functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $*"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

# Exit with error message
error_exit() {
    log_error "$*"
    exit 1
}

# Trap Error Handler (Omakub pattern)
trap_error() {
    local parent_lineno="$1"
    local code="$2"
    local last_command="$3"
    
    echo -e "\n${RED}======================================================================${NC}"
    log_error "설치 진행 중 예상치 못한 오류가 발생하여 비정상 종료되었습니다."
    log_error "실패 위치: line ${parent_lineno} (Exit Code: ${code})"
    log_error "실패 명령어: ${last_command}"
    echo -e "${YELLOW}----------------------------------------------------------------------${NC}"
    log_warn "해당 오류를 확인 및 해결한 뒤 아래 명령어로 설치를 재시도할 수 있습니다:"
    log_warn "  source ~/.local/share/omakub/install.sh (또는 로컬의 install.sh 직접 실행)"
    echo -e "${RED}======================================================================${NC}\n"
}

# Detect OS and WSL Status
detect_os() {
    export OS_TYPE="Unknown"
    export IS_WSL=0
    
    local system_os
    system_os="$(uname -s)"
    
    if [ "$system_os" = "Darwin" ]; then
        export OS_TYPE="macOS"
    elif [ "$system_os" = "Linux" ]; then
        if [ -f /etc/os-release ]; then
            . /etc/os-release
            if [ "$ID" = "ubuntu" ]; then
                export OS_TYPE="Ubuntu"
            else
                export OS_TYPE="Linux-Other"
            fi
        fi
        
        # Check if running under WSL
        if grep -qi "microsoft" /proc/version 2>/dev/null; then
            export IS_WSL=1
        fi
    fi
}

# Check Shell Compatibility
check_shell() {
    export SHELL_NAME
    SHELL_NAME="$(basename "$SHELL" 2>/dev/null || echo "unknown")"
    
    case "$SHELL_NAME" in
        zsh|bash)
            # Supported
            ;;
        *)
            log_warn "현재 지원되지 않는 셸(${SHELL_NAME})을 사용 중입니다. zsh 또는 bash를 권장합니다."
            ;;
    esac
}

# Pre-flight checks before installer execution
pre_flight_check() {
    detect_os
    check_shell
    
    if [ "$OS_TYPE" = "Unknown" ] || [ "$OS_TYPE" = "Linux-Other" ]; then
        error_exit "지원되지 않는 OS 환경입니다: ${OS_TYPE}. macOS, Ubuntu, WSL만 공식 지원합니다."
    fi
    
    log_info "환경 분석 완료: OS=${OS_TYPE} (WSL=${IS_WSL}), Shell=${SHELL_NAME}"
}

# Check if command exists
has_command() {
    command -v "$1" &>/dev/null
}

# Command Execution Helper with Dry Run Simulation
run_cmd() {
    if [ "${DRY_RUN:-0}" = "1" ]; then
        echo -e "${BLUE}[DRY-RUN] Would execute:${NC} $*"
    else
        "$@"
      fi
}
