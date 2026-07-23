#!/bin/bash
# ==============================================================================
# macos_defaults.sh - macOS System Preferences Configuration Module
# ==============================================================================
set -e

# Resolve script directory and source utilities if run directly
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
if [ -f "$SCRIPT_DIR/lib/utils.sh" ]; then
    source "$SCRIPT_DIR/lib/utils.sh"
fi

# macOS 시스템에서만 실행되도록 가드
if [ "$OS_TYPE" != "macOS" ]; then
    log_warn "macOS 환경이 아니므로 macOS 시스템 설정을 건너뜁니다."
    exit 0
fi

log_info "macOS 시스템 설정을 적용합니다..."

# 1. Dock 설정
log_info "Dock 설정을 구성하는 중..."
# 자동 숨기기 활성화
run_cmd defaults write com.apple.dock autohide -bool true
# 자동 숨기기 딜레이 제거
run_cmd defaults write com.apple.dock autohide-delay -float 0
# 애니메이션 시간 단축 (0.3초)
run_cmd defaults write com.apple.dock autohide-time-modifier -float 0.3
# 최근 사용한 앱 표시 안 함
run_cmd defaults write com.apple.dock show-recents -bool false

# 2. Finder 설정
log_info "Finder 설정을 구성하는 중..."
# 파일 확장자 항상 표시
run_cmd defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# 숨김 파일 항상 표시
run_cmd defaults write com.apple.finder AppleShowAllFiles -bool true
# Finder 경로바 표시
run_cmd defaults write com.apple.finder ShowPathbar -bool true
# Finder 상태바 표시
run_cmd defaults write com.apple.finder ShowStatusBar -bool true
# 확장자 변경 시 경고 비활성화
run_cmd defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# 검색 범위를 현재 폴더로 기본 설정
run_cmd defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# 3. 키보드 & 입력기 설정
log_info "키보드 및 입력 설정을 구성하는 중..."
# 키 반복 속도를 빠르게 설정 (1: 아주 빠름, 2: 보통 빠름)
run_cmd defaults write NSGlobalDomain KeyRepeat -int 1
# 키 반복 시작 시간을 짧게 설정 (15: 아주 짧음)
run_cmd defaults write NSGlobalDomain InitialKeyRepeat -int 15
# 자동 맞춤법 및 대문자 자동 전환 비활성화
run_cmd defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false
run_cmd defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
run_cmd defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

# 4. 트랙패드 설정 (탭해서 클릭하기 활성화)
log_info "트랙패드 설정을 구성하는 중..."
run_cmd defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
run_cmd defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
run_cmd defaults write -g com.apple.mouse.tapBehavior -int 1

# 5. 스크린샷 설정
log_info "스크린샷 설정을 구성하는 중..."
# 스크린샷 저장 디렉토리 생성 및 설정
SCREENSHOTS_DIR="$HOME/Pictures/Screenshots"
if [ ! -d "$SCREENSHOTS_DIR" ]; then
    run_cmd mkdir -p "$SCREENSHOTS_DIR"
fi
run_cmd defaults write com.apple.screencapture location -string "$SCREENSHOTS_DIR"
# 포맷은 PNG로 설정
run_cmd defaults write com.apple.screencapture type -string "png"

# 설정 반영을 위해 UI 에이전트 재시작
log_info "변경된 설정을 반영하기 위해 시스템 UI 프로세스를 재시작합니다..."
if [ "$DRY_RUN" != "1" ]; then
    for app in "Finder" "Dock" "SystemUIServer"; do
        killall "$app" >/dev/null 2>&1 || true
    done
fi

log_success "macOS 시스템 설정 적용 완료!"
