#!/bin/bash
# ==============================================================================
# core.sh - Core Tooling Setup Module (zsh plugins, git, tmux, bob Neovim)
# ==============================================================================
set -e

# Resolve script directory and source utilities if run directly
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [ -f "$SCRIPT_DIR/lib/utils.sh" ]; then
    source "$SCRIPT_DIR/lib/utils.sh"
fi

# Reload Homebrew PATH if not yet available (cross-module 실행 시 환경이 단절될 수 있음)
if ! command -v brew &>/dev/null; then
    if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    elif [ -f "/opt/homebrew/bin/brew" ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -f "/usr/local/bin/brew" ]; then
        eval "$(/usr/local/bin/brew shellenv)"
    fi
fi

log_info "modules/core.sh 실행 중..."
log_info "zsh, git, tmux, Neovim(bob v0.12.0 핀) 설치 및 공통 설정을 연동합니다."

# ==============================================================================
# 1. OS-specific Core Tool Installation
# ==============================================================================
if [ "$OS_TYPE" = "Ubuntu" ]; then
    log_info "Ubuntu 환경 핵심 도구(zsh, git, tmux, curl) 설치 여부 검사..."
    if ! has_command zsh || ! has_command git || ! has_command tmux || ! has_command curl; then
        log_info "필수 도구 설치를 진행합니다 (sudo apt install)..."
        run_cmd sudo apt update -y
        run_cmd sudo apt install -y zsh git tmux curl stow build-essential
    else
        log_info "Ubuntu 필수 핵심 도구들이 이미 설치되어 있습니다."
    fi

    # Zsh를 기본 셸로 설정
    if [ "$SHELL_NAME" != "zsh" ]; then
        log_info "기본 셸을 zsh로 변경합니다..."
        target_user="${USER:-$(whoami)}"
        run_cmd sudo chsh -s "$(which zsh)" "$target_user"
    fi
elif [ "$OS_TYPE" = "macOS" ]; then
    log_info "macOS 환경: 기본 zsh/git 활용 및 Homebrew 설치 여부는 brew.sh 단계에서 점검합니다."
fi

# ==============================================================================
# 2. Oh My Zsh & Plugins Setup (Idempotent)
# ==============================================================================
ZSH_DIR="$HOME/.oh-my-zsh"
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_DIR" ]; then
    log_info "Oh My Zsh을 무대화식(non-interactive) 모드로 설치합니다..."
    # CHSH=no: 기본셸 변경 질문 안함, RUNZSH=no: 설치 후 zsh로 바로 스위칭 안함, KEEP_ZSHRC=yes: zshrc 보존
    run_cmd env CHSH=no RUNZSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" ""
else
    log_info "Oh My Zsh가 이미 설치되어 있습니다. (건너뜀)"
fi

# Clone Zsh Custom Theme & Plugins if not present
clone_zsh_repo() {
    local repo_url="$1"
    local dest_path="$2"
    local repo_name
    repo_name="$(basename "$dest_path")"
    local extra_args="${3:-}"

    if [ -d "$dest_path" ]; then
        log_info "Zsh 설정: $repo_name 가 이미 설치되어 있습니다. (건너뜀)"
    else
        log_info "Zsh 설정: $repo_name 저장소를 클론합니다..."
        if [ -n "$extra_args" ]; then
            run_cmd git clone $extra_args "$repo_url" "$dest_path"
        else
            run_cmd git clone "$repo_url" "$dest_path"
        fi
    fi
}

clone_zsh_repo "https://github.com/romkatv/powerlevel10k.git" "$ZSH_CUSTOM/themes/powerlevel10k" "--depth=1"
clone_zsh_repo "https://github.com/zsh-users/zsh-autosuggestions.git" "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone_zsh_repo "https://github.com/zsh-users/zsh-syntax-highlighting.git" "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
clone_zsh_repo "https://github.com/zdharma-continuum/fast-syntax-highlighting.git" "$ZSH_CUSTOM/plugins/fast-syntax-highlighting"
clone_zsh_repo "https://github.com/marlonrichert/zsh-autocomplete.git" "$ZSH_CUSTOM/plugins/zsh-autocomplete" "--depth=1"
clone_zsh_repo "https://github.com/junegunn/fzf-git.sh.git" "$ZSH_CUSTOM/fzf-git"

# ==============================================================================
# 3. Neovim Version Management (bob)
# ==============================================================================
TARGET_NVIM_VERSION="0.12.0"

# Check bob command existence
if ! has_command bob; then
    log_info "bob 버전 관리 도구가 감지되지 않았습니다."
    if has_command brew; then
        log_info "Homebrew를 통해 bob을 자동으로 설치합니다..."
        run_cmd brew install bob
    else
        log_warn "Homebrew가 감지되지 않아 bob을 자동 설치할 수 없습니다. Neovim 버전 핀 설정을 시도하기 전에 brew가 활성화되어 있는지 확인해 주세요."
    fi
fi

# If bob is now available (or will be available during active run)
if has_command bob || [ "$DRY_RUN" = "1" ] || { [ "$OS_TYPE" = "macOS" ] && has_command brew; }; then
    # In dry-run, we pretend bob command is available
    log_info "bob을 통해 Neovim v${TARGET_NVIM_VERSION}을 핀(use)합니다."
    
    # Check if this version is already active to make it idempotent and fast
    # (Notice: in dry-run, we always log installing)
    need_install=1
    if [ "$DRY_RUN" != "1" ] && has_command bob; then
        # Check active version in bob list
        if bob list 2>/dev/null | grep -q "${TARGET_NVIM_VERSION} (active)"; then
            log_info "Neovim v${TARGET_NVIM_VERSION}이 이미 활성화되어 있습니다. (건너뜀)"
            need_install=0
        fi
    fi
    
    if [ "$need_install" = "1" ]; then
        # Temporarily export bob bin path to ensure path resolution works during installer session
        # This is useful when the path was not added to PATH in current shell yet
        export PATH="$HOME/.local/share/bob/nvim-bin:$PATH"
        
        run_cmd bob install "$TARGET_NVIM_VERSION"
        run_cmd bob use "$TARGET_NVIM_VERSION"
        
        # Log installed version information
        if [ "$DRY_RUN" != "1" ] && has_command nvim; then
            log_info "설치된 Neovim 버전: $(nvim --version | head -n 1)"
        fi
    fi
else
    log_error "Neovim 설치 관리자(bob)를 호출할 수 없어 Neovim 구성을 중단합니다."
fi

log_success "core.sh 모듈 설치 완료!"
