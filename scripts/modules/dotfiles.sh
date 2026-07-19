#!/bin/bash
# ==============================================================================
# dotfiles.sh - GNU Stow Symlink Deployment Module with Conflict Handling
# ==============================================================================
set -e

# Resolve script directory and source utilities if run directly
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [ -f "$SCRIPT_DIR/lib/utils.sh" ]; then
    source "$SCRIPT_DIR/lib/utils.sh"
fi

log_info "modules/dotfiles.sh 실행 중..."
log_info "GNU Stow를 활용하여 설정 파일들의 심볼릭 링크 배선을 수행합니다."

# Determine Stow source directory based on OS
STOW_SOURCE_DIR=""
if [ "$OS_TYPE" = "macOS" ]; then
    STOW_SOURCE_DIR="$(cd "$SCRIPT_DIR/../macos" && pwd)"
elif [ "$OS_TYPE" = "Ubuntu" ]; then
    # default to the ubuntu-arm-2404 config folder under linux
    if [ -d "$SCRIPT_DIR/../linux/ubuntu-arm-2404" ]; then
        STOW_SOURCE_DIR="$(cd "$SCRIPT_DIR/../linux/ubuntu-arm-2404" && pwd)"
    else
        STOW_SOURCE_DIR="$(cd "$SCRIPT_DIR/../linux" && pwd)"
    fi
else
    error_exit "지원되지 않는 OS 환경입니다: ${OS_TYPE}. Stow 링크 배선을 중단합니다."
fi

log_info "Stow 소스 경로: $STOW_SOURCE_DIR"

# Global backup directory for conflicts
BACKUP_DIR="$HOME/.dotfiles.backup/$(date +%Y%m%d_%H%M%S)"

# Deploy a single stow package with conflict handling
stow_package() {
    local pkg="$1"
    local run_status=0
    
    # 1. Run simulation to check for conflicts (explicitly pass -d . to avoid Perl dir errors)
    local simulate_output
    simulate_output=$(cd "$STOW_SOURCE_DIR" && stow -d . -t "$HOME" --simulate "$pkg" 2>&1) || run_status=$?
    
    if [ $run_status -ne 0 ]; then
        log_info "패키지 [${pkg}] 배선 중 충돌이 감지되었습니다. 백업 처리를 시작합니다..."
        
        # Extract conflicting target file paths — two patterns:
        #   macOS stow: "  * cannot stow ... over existing target FOO since ..."
        #   Ubuntu stow: "  * existing target is neither a link nor a directory: FOO"
        local conflict_files
        conflict_files=$(echo "$simulate_output" | \
            sed -n \
                -e 's/.*over existing target \(.*\) since.*/\1/p' \
                -e 's/.*existing target is neither a link nor a directory: \(.*\)/\1/p' \
            )

        if [ -n "$conflict_files" ]; then
            # Ensure backup directory exists if we are not in dry-run
            run_cmd mkdir -p "$BACKUP_DIR"
            
            # Use raw IFS read loop to safely process path with potential spaces or symbols
            echo "$conflict_files" | while IFS= read -r file; do
                [ -z "$file" ] && continue
                local target_file="$HOME/$file"
                if [ -f "$target_file" ] || [ -d "$target_file" ] || [ -L "$target_file" ]; then
                    log_warn "충돌 복구: $target_file -> $BACKUP_DIR/ 로 이동합니다."
                    
                    # Create parent backup directories if needed
                    local parent_backup
                    parent_backup="$(dirname "$BACKUP_DIR/$file")"
                    run_cmd mkdir -p "$parent_backup"
                    
                    run_cmd mv "$target_file" "$BACKUP_DIR/$file"
                fi
            done
        else
            log_error "충돌 원인을 추출할 수 없습니다. 시뮬레이션 원본 메시지:"
            echo "$simulate_output"
            return 1
        fi
    fi
    
    # 2. Perform actual link deployment (Restowing enables clean upgrade if links already exist)
    log_info "stow 패키지 [${pkg}] 배선 실행..."
    (cd "$STOW_SOURCE_DIR" && run_cmd stow -d . -t "$HOME" -R "$pkg")
}

# Execute Stow linking loop
if [ -d "$STOW_SOURCE_DIR" ]; then
    # 1. Prioritize 'home' package to ensure base shellconfigs are linked first
    if [ -d "$STOW_SOURCE_DIR/home" ]; then
        stow_package "home"
    fi
    
    # 2. Loop through other packages
    for pkg_path in "$STOW_SOURCE_DIR"/*; do
        if [ -d "$pkg_path" ]; then
            pkg_name="$(basename "$pkg_path")"
            # Skip 'home' (already processed), system metadata directories, and backup markers
            if [ "$pkg_name" != "home" ] && [[ ! "$pkg_name" =~ ^\. ]] && [ "$pkg_name" != "backup" ]; then
                stow_package "$pkg_name"
            fi
        fi
    done
else
    error_exit "Stow 소스 디렉터리가 존재하지 않습니다: $STOW_SOURCE_DIR"
fi

log_success "dotfiles.sh 모듈 배선 완료!"
