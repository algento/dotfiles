# .zshenv - Zsh Environment Variables
# 이 파일은 로그인/비로그인 모든 쉘 세션에서 가장 먼저 로드됩니다.
# 주의: API Key와 같은 민감 정보가 포함될 경우 저장소(Git)에 Push하기 전에 반드시 확인하십시오.

# --- 기본 환경 변수 ---
export EDITOR='nvim'
export VISUAL='nvim'
export LANG='ko_KR.UTF-8'

# --- API Keys (민감 정보) ---
# 여기에 직접 키를 입력하거나, 보안을 위해 ~/.zshenv.local 파일을 생성하여 관리하는 것을 권장합니다.
export GOOGLE_API_KEY=""      # Gemini CLI 용
export ANTHROPIC_API_KEY=""   # Claude Code 용
export OPENAI_API_KEY=""      # 기타 도구용

# --- 경로 설정 (PATH) ---
export PATH="$HOME/bin:$HOME/.local/bin:$PATH"

# --- 기존 로컬 설정 유지 ---
# Cargo (Rust)
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

# Bob (Neovim Version Manager)
[[ -f "$HOME/.local/share/bob/env/env.sh" ]] && . "$HOME/.local/share/bob/env/env.sh"

# --- 로컬 전용 추가 설정 (Git 제외 대상) ---
[[ -f "$HOME/.zshenv.local" ]] && . "$HOME/.zshenv.local"
