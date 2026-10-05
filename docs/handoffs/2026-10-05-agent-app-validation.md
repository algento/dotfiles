# 에이전트 앱 로딩 검증 — 2026-10-05

글로벌 스킬·MCP 적용 후 실제 로딩 결과다. 연결과 도구 발견만 검사했으며,
계정 데이터 조회·수정 및 논문 가져오기는 실행하지 않았다.

## 결과

| 실행 환경 | 스킬 | DEVONthink | Raindrop | Zotero |
| :--- | :--- | :--- | :--- | :--- |
| Codex CLI 0.160.0 새 app-server | 공통 55개 모두 발견, 오류 없음. Zotero `user`·enabled, DT 글로벌 없음 | 29개 도구 | 17개 도구 | 35개 도구 |
| Claude Code 2.1.277, `/private/tmp` | `Skill` 도구로 `raindrop-zotero` 실제 로드 성공 | Connected | Connected | Connected |
| Antigravity 1.0.10 실행 중 GUI | 글로벌 목록에서 Zotero 확인 | 29 tools enabled | Refresh 후 17 tools enabled | 초기 연결 실패 |

Codex는 `codex app-server --stdio`의 `skills/list`(forceReload)와
`mcpServerStatus/list`(toolsAndAuthOnly) 응답으로 검증했다. 공통 스킬 55개는
플러그인 접두사 `understand-anything:`를 정규화해 대조했다. 전체 발견 수는
시스템·플러그인 스킬을 포함한 69개다. `authStatus: unsupported`는 stdio 서버의
인증 상태 표시이며, 실제 도구 목록을 반환한 결과와 구분한다.

실행 중 Codex 데스크톱 앱의 기존 세션 재로딩까지 확인한 것은 아니다.
`app-server proxy`는 initialize 응답 시간 초과로 확인하지 못했고,
GUI 접근은 컴퓨터 자동화 도구의 안전 정책에 의해 차단됐다.

Claude는 프로젝트 설정의 영향을 피하려고 `/private/tmp`에서
`claude mcp list`를 실행했다. 별도 읽기 전용 검증에서 `--tools Skill`,
`--allowedTools Skill`, `--permission-prompts none`, `--no-session-persistence`로
Zotero 스킬 로드를 요청했으며 성공·permission_denials 없음이 반환됐다.
Claude의 55개 전체 스킬 호출을 각각 실행한 것은 아니다.

## Antigravity 오류와 최소 재현

MCP 관리 화면의 Refresh 전 Raindrop에는 상대 경로 `./.env` 오류가 남아 있었다.
Refresh 후 현재 글로벌 설정을 읽어 DEVONthink와 Raindrop 도구 발견에 성공했다.
설정 파일 변경은 없었다.

Zotero는 Refresh 후에도 다음 오류가 발생했다.

```text
expect initialized request ... method: "server/discover"
connection closed: calling "initialize": client is closing: EOF
```

동일한 `/Users/sejong/.cargo/bin/zotero-mcp`에 첫 JSON-RPC 요청만 바꿔 비교했다.

| 첫 요청 | 결과 |
| :--- | :--- |
| `initialize`, protocolVersion `2024-11-05` | 정상 응답, serverInfo `zotero-mcp` / `0.4.0` |
| `server/discover`, params `{}` | 응답 없이 종료 코드 1, 동일한 initialized-request 오류 |

표준 초기화는 Codex와 Claude에서도 성공한다. 따라서 현재 관측한 실패는
Antigravity의 발견 요청과 Zotero 서버의 초기 연결 처리 사이의 호환성 문제다.
바이너리 업데이트·프로토콜 어댑터 설치·설정 변경은 수행하지 않았다.

## 남은 검증

- Antigravity와 Zotero 초기 연결 호환성 해결 후 Refresh 재검증.
- Codex 데스크톱 앱의 기존 세션 발견·재로딩 직접 확인.
- 실제 서비스 기능과 스킬 작업 전체의 검증은 별도 범위다.
- Hermes `edith`는 이번 세 앱 검증 대상에 포함하지 않았다.

공통 설정의 `scripts/sync-agents check`도 다시 실행해 9개 항목 `equal`,
Codex·Antigravity `managed-link`를 확인했다. 기존 미커밋 설정·다른 작업은 유지했다.
