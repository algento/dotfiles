# scripts/legacy

dev-env-management Phase 1(2026-06-27)에서 새 모듈형 부트스트랩 구조
(`scripts/install.sh` + `scripts/lib/` + `scripts/modules/`)로 재작성되기 전의
구(舊) macOS 셋업 스크립트를 **참고용으로 보존**한 디렉토리.

신규 구조가 안정화되면 제거 예정. 새 스크립트 작성 시 설치 명령·옵션의 출처로만 참고한다.

| 파일 | 비고 |
| :--- | :--- |
| `script-utils.sh` | OS/shell 감지, `add_line` 유틸 → `lib/utils.sh`로 발전 |
| `brew-install.sh` / `brew-setup.sh` | Homebrew 설치 → `modules/brew.sh`로 재작성 |
| `python-setup.sh` | **miniforge3(conda) 기반** → `modules/python.sh`에서 pyenv+uv로 교체 |
| `zsh-setup.sh` | oh-my-zsh + p10k + 플러그인 설치 → `modules/core.sh` 참고 |
| `macos-silicon/` | dotfile-setup(잘못된 repo clone), mas/tex/github 셋업 등 구 분할 스크립트 |
