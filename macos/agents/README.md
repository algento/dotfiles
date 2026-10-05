# macos/agents — AI 에이전트 설정 (stow 패키지)

여러 AI 에이전트(Claude Code / Codex / Gemini·Antigravity)의 **재현 가능한 설정만** dotfiles로
버전 관리하고, 인증 토큰·세션 히스토리·캐시 등 민감/런타임 데이터는 **원천 제외**한다.

## 진행 계획

- [최근 세션 기록](../../docs/handoffs/2026-10-05-global-skills-mcp-session.md):
  전역 MCP 등록·공통 정본·배포 구현의 결과, 검증·미커밋 변경 범위와 다음 작업.
- [전역 스킬·MCP 관리 방안](../../docs/agents/global-management.md): 정본을
  추가·이동하거나 배포·차이 검사 도구를 구현할 때 읽는 관리 구조와 전환 기준.
- [전역 MCP 설정](../../docs/agents/global-mcp.md): DEVONthink·Raindrop·Zotero의
  에이전트별 적용 경로, 인증 참조 및 검증 상태.
- [현재 작업 인수인계](../../docs/handoffs/2026-10-05-agent-sync.md): 결정 맥락,
  적용 상태, 검증 한계와 다음 세션의 작업 순서.
- [공유 스킬 관리](../../docs/agents/shared-skills.md): 제작 출처, 설치·제외 목록,
  Matt 스킬 업데이트 및 이름 변경, 프로젝트별 재설치와 복구 기준.
- [macOS 에이전트 설정 동기화 계획](../../docs/plans/2026-10-05-macos-agent-sync.md):
  Codex·Claude Code·Antigravity·Hermes `edith`의 공통 스킬·MCP·이벤트 관리.
  현황과 합의 범위, 단계별 완료 기준, 다음 세션 인수인계를 기록한다.

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
| `.gemini/config/mcp_config.json` | Antigravity 전역 DEVONthink·Raindrop·Zotero MCP |
| `.gemini/trusted_hooks.json` | Gemini 신뢰 훅 목록 |
| `.agents/skills/` | 공유 스킬 원본. Codex·Antigravity는 전체 경로 참조, Claude는 개별 스킬 링크 |
| `.agents/.skill-lock.json` | 스킬 잠금 메타 |
| `.agents/mcp/servers.json`, `sources.json` | 공통 MCP 실행 정의·출처 기록 |

## MCP 배포

실행 정의 변경은 `.agents/mcp/servers.json`에서 시작한다. 저장소 루트의
`scripts/sync-agents`가 검사·계획·적용·복구를 제공하며 Python 3.11 이상과
`uv`가 필요하다. 사용법·관리 범위는 [전역 관리 방안](../../docs/agents/global-management.md)의
배포 도구 계약을 따른다. 로컬 상태·백업과 계정 파일은 Git 밖에 둔다.
Hermes와 스킬 링크 자동화는 아직 지원하지 않는다.

## 제외 (절대 커밋 금지 — `.gitignore` 안전망 등록)

- `~/.codex/auth.json`, `*.sqlite*` (인증·로컬 DB)
- `~/.gemini/oauth_creds.json`, `google_accounts.json` (OAuth 자격증명)
- `~/.claude/projects/`, `sessions/`, `history.jsonl`, `*.sqlite` (대화 히스토리·세션)
- 각종 `cache/`, `tmp/`, `antigravity*/`, `config/projects/` (런타임·머신별 상태)

## 주의

일부 도구는 설정 저장 시 atomic write(임시파일→rename)로 심링크를 실파일로 대체할 수 있다.
설정이 dotfiles에서 분리된 듯하면 `stow -R -t ~ agents`로 재링크한다.
