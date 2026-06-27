# macos/agents — AI 에이전트 설정 (stow 패키지)

여러 AI 에이전트(Claude Code / Codex / Gemini·Antigravity)의 **재현 가능한 설정만** dotfiles로
버전 관리하고, 인증 토큰·세션 히스토리·캐시 등 민감/런타임 데이터는 **원천 제외**한다.

## 적용

```bash
cd ~/Github/docs/dotfiles/macos && stow -t ~ agents
```

`~/.claude`·`~/.codex`·`~/.gemini`는 이미 런타임 파일이 있는 실디렉토리이므로, stow는
디렉토리를 통째 링크(folding)하지 않고 아래 파일만 개별 심링크한다.

## 관리 대상

| 경로 | 내용 |
| :--- | :--- |
| `.claude/CLAUDE.md` | Claude Code 글로벌 지시 |
| `.claude/settings.json` | Claude Code 설정 (민감정보 없음) |
| `.codex/config.toml` | Codex CLI 설정 |
| `.gemini/settings.json` | Gemini/Antigravity 설정 |
| `.gemini/trusted_hooks.json` | Gemini 신뢰 훅 목록 |
| `.agents/skills/` | 에이전트 공유 커스텀 스킬 (`~/.claude/skills`가 이리로 링크) |
| `.agents/.skill-lock.json` | 스킬 잠금 메타 |

## 제외 (절대 커밋 금지 — `.gitignore` 안전망 등록)

- `~/.codex/auth.json`, `*.sqlite*` (인증·로컬 DB)
- `~/.gemini/oauth_creds.json`, `google_accounts.json` (OAuth 자격증명)
- `~/.claude/projects/`, `sessions/`, `history.jsonl`, `*.sqlite` (대화 히스토리·세션)
- 각종 `cache/`, `tmp/`, `antigravity*/`, `config/projects/` (런타임·머신별 상태)

## 주의

일부 도구는 설정 저장 시 atomic write(임시파일→rename)로 심링크를 실파일로 대체할 수 있다.
설정이 dotfiles에서 분리된 듯하면 `stow -R -t ~ agents`로 재링크한다.
