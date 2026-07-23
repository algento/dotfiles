#!/bin/bash
# ==============================================================================
# python.sh - Python Runtime Environment Setup Module (pyenv + uv)
# ==============================================================================
set -e

# Resolve script directory and source utilities if run directly
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [ -f "$SCRIPT_DIR/lib/utils.sh" ]; then
    source "$SCRIPT_DIR/lib/utils.sh"
fi

log_info "modules/python.sh 실행 중..."
log_info "pyenv 및 uv 패키지 매니저를 구성하고 파이썬 글로벌 버전을 설정합니다."

# ==============================================================================
# 1. Ensure pyenv is Installed
# ==============================================================================
if ! has_command pyenv; then
    log_info "pyenv가 시스템에 감지되지 않았습니다. 설치를 진행합니다..."
    if [ "$OS_TYPE" = "macOS" ]; then
        if has_command brew; then
            run_cmd brew install pyenv
        else
            error_exit "Homebrew가 설치되어 있지 않아 macOS에서 pyenv를 설치할 수 없습니다."
        fi
    elif [ "$OS_TYPE" = "Ubuntu" ]; then
        log_info "Ubuntu pyenv 의존성 및 pyenv-installer 다운로드..."
        run_cmd sudo apt update -y
        run_cmd sudo apt install -y make build-essential libssl-dev zlib1g-dev \
            libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm \
            libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
        run_cmd curl https://pyenv.run | bash
    fi
else
    log_info "pyenv가 이미 설치되어 있습니다. (건너뜀)"
fi

# ==============================================================================
# 2. Load pyenv into Active Script Context
# ==============================================================================
# Define pyenv root path
export PYENV_ROOT="$HOME/.pyenv"
if [ "$OS_TYPE" = "macOS" ] && has_command brew; then
    # On macOS via brew, pyenv root might be different or managed by brew
    BREW_PYENV_ROOT="$(brew --prefix pyenv 2>/dev/null)/bin"
    if [ -d "$BREW_PYENV_ROOT" ]; then
        export PATH="$BREW_PYENV_ROOT:$PATH"
    fi
fi
# Add standard paths
export PATH="$PYENV_ROOT/bin:$PATH"
if has_command pyenv; then
    eval "$(pyenv init -)"
fi

# ==============================================================================
# 3. Install Target Python Version
# ==============================================================================
TARGET_PYTHON_VERSION="3.11.11"

if has_command pyenv || [ "$DRY_RUN" = "1" ]; then
    log_info "pyenv를 통해 Python v${TARGET_PYTHON_VERSION} 설치 상태를 확인합니다."
    
    python_installed=0
    if [ "$DRY_RUN" != "1" ]; then
        if pyenv versions --bare 2>/dev/null | grep -Fxq "$TARGET_PYTHON_VERSION"; then
            log_info "Python v${TARGET_PYTHON_VERSION}이 이미 설치되어 있습니다. (건너뜀)"
            python_installed=1
        fi
    fi
    
    if [ "$python_installed" = "0" ]; then
        log_info "Python v${TARGET_PYTHON_VERSION} 설치를 진행합니다 (시간이 다소 소요될 수 있습니다)..."
        run_cmd pyenv install "$TARGET_PYTHON_VERSION"
    fi
    
    log_info "Python 글로벌 버전을 v${TARGET_PYTHON_VERSION}으로 설정합니다."
    run_cmd pyenv global "$TARGET_PYTHON_VERSION"
else
    log_warn "pyenv 명령어를 실행할 수 없어 파이썬 버전 설정을 건너뜁니다."
fi

# ==============================================================================
# 4. Install uv Packaging Tool
# ==============================================================================
# Load uv path just in case it is installed but not in current shell PATH
export PATH="$HOME/.local/bin:$PATH"

if ! has_command uv; then
    log_info "uv 패키지 매니저가 감지되지 않았습니다. 설치를 시작합니다..."
    # Install uv via official standalone installer script
    run_cmd curl -LsSf https://astral.sh/uv/install.sh | sh
    
    # Reload PATH context
    export PATH="$HOME/.local/bin:$PATH"
else
    log_info "uv 패키지 매니저가 이미 설치되어 있습니다. (건너뜀)"
fi

if has_command uv || [ "$DRY_RUN" = "1" ]; then
    if [ "$DRY_RUN" != "1" ]; then
        log_success "설치된 uv 버전: $(uv --version)"
    fi
else
    log_warn "uv 설치를 확인할 수 없습니다."
fi

log_success "python.sh 모듈 설치 완료!"
