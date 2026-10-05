# 전역 MCP 설정

2026-10-05 사용자 요청으로 DEVONthink·Raindrop을 전역 사용 대상으로 확정했고,
후속 요청으로 Zotero도 추가했다. Hermes 프로필 생성은 별도 작업이다.

공통 정본과 생성·병합 배포로 전환할 때는
[전역 스킬·MCP 관리 방안](global-management.md)을 읽는다. 현재 실행 정의 정본은
[servers.json](../../macos/agents/.agents/mcp/servers.json)이며
[배포 도구](../../scripts/sync-agents)가 에이전트별 설정의 관리 항목만 병합한다.

## 적용 경로

| 에이전트 | 전역 설정 | 적용 상태 |
| :--- | :--- | :--- |
| Codex | `~/.codex/config.toml` → `macos/agents/.codex/config.toml` | 기존 DEVONthink 유지, Raindrop·Zotero 추가 |
| Claude Code | `~/.claude.json`의 최상위 `mcpServers` | 기존 세 서버 등록 유지 |
| Antigravity | `~/.gemini/config/mcp_config.json` → `macos/agents/.gemini/config/mcp_config.json` | 세 서버 추가 |
| Hermes `edith` | 아직 프로필 없음 | 프로필 생성 후 적용할 대상 |

Antigravity의 기존 `~/.gemini/antigravity/mcp_config.json`은 위 전역 경로를
가리키므로 같은 설정을 참조한다. Claude의 런타임·계정 파일 전체를 dotfiles에
복사하지 않는다. 앱 전용 서버·훅·에이전트 설정은 유지한다.

## 실행과 인증

실행 명령·인자·인증 파일 경로는 [공통 명세](../../macos/agents/.agents/mcp/servers.json),
출처·설치 방식·관측 버전·미확인 사항은
[출처 기록](../../macos/agents/.agents/mcp/sources.json)이 소유한다.
`auth_file`은 사전 조건 검사 참조이며 인증 내용을 설정으로 복사하지 않는다.
홈 변수는 배포 도구가 실제 경로로 해석하고 셸 인자는 홈 경로를 인용한다.

인증 파일은 Git 밖에 유지하고 `0600`으로 제한한다. `npx`, DEVONthink 앱 및
계정 접근 권한, 기존 Zotero 바이너리가 필요하다. 이번 전환에서 외부 서버를
재설치하거나 버전을 고정하지 않았다. Zotero는 외부 코드의 기존 로컬 빌드로
분류하며 원본 커밋·로컬 수정 여부는 미확인이다.

## 프로젝트 설정과 재적용

`sejong-wiki`의 기존 프로젝트 MCP 등록은 유지했다. 이 변경은 다른 디렉터리에서도
전역 서버를 사용할 수 있게 하며, 프로젝트별 덮어쓰기 설정까지 제거하지 않는다.

Antigravity 관리 파일은 `macos`에서 `stow -t ~ agents`의 배포 대상이다.
이번에는 비어 있던 기존 전역 파일을 백업한 뒤 관리 파일로 연결했다.
다른 머신에서 기존 MCP 설정이 있으면 전체 교체 전에 항목을 병합해야 한다.

빈 원본의 이번 백업: `/private/tmp/sejong-antigravity-mcp-before-global-20261005.json`.
앱이 atomic write로 심링크를 실파일로 바꾸면 파일을 비교한 뒤 재연결한다.

## 검증

- TOML·JSON 구문 검사 및 세 에이전트의 실행 설정 일치 검사 통과.
- Codex는 `/private/tmp`에서 `mcp get`으로 두 서버를 활성 전역 서버로 해석했다.
- Claude는 같은 디렉터리에서 Raindrop을 `User config (available in all your
  projects)`로 해석했다.
- 표준 MCP SDK로 `/private/tmp`에서 `initialize`·`tools/list` 성공:
  DEVONthink `0.1.0` / 29개 도구, Raindrop `2.4.5` / 17개 도구.
  샌드박스 안에서는 두 서버 모두 45초 시간 초과였고, 외부 실행에서 성공했다.
  서버 연결·도구 발견 검증이며, 계정 데이터 조회나 외부 쓰기는 실행하지 않았다.
- 실행 중인 대화의 도구 재로딩과 Hermes `edith` 검증은 별도다.
- Zotero 추가 후 세 전역 설정 일치 검사와 Codex의 활성 서버 해석 확인 통과.
  `/private/tmp`에서 표준 MCP `initialize`·`tools/list` 성공:
  Zotero `0.4.0` / 35개 도구. 샌드박스에서는 연결이 종료됐고 외부 실행에서 성공했다.
  Zotero 데이터 조회·수정은 실행하지 않았다.

설정을 반영하려면 에이전트의 MCP 새로고침 또는 새 세션을 사용한다.
Codex 앱은 MCP 설정의 Restart, Antigravity는 MCP 관리 화면의 Refresh를 사용한다.

## 근거

- [Codex MCP 공식 문서](https://developers.openai.com/codex/mcp)
- [Antigravity MCP 공식 문서](https://antigravity.google/docs/mcp)
- [전체 동기화 계획](../plans/2026-10-05-macos-agent-sync.md)

## 정본 전환·배포 도구 검증 — 2026-10-05

- 공통 명세·출처 기록과 `check`, `plan`, `apply`, `restore` 구현.
- 임시 홈 통합·SDK 회귀 테스트 18개 통과: 사용자 항목·주석 보존, 최초 이관,
  반복 적용, 계획 변경 감지, 충돌·관리 항목 제거, 링크 유지·이탈 보고,
  부분 실패·복구 중단·복구 재실행, 상태 손상·잘못된 구문 거부 등.
- 최초 계획은 세 에이전트의 9개 관리 항목 모두 `adopt`, 설정 변경 없음.
  Claude 런타임 파일이 계획 이후 바뀌어 첫 적용은 stale 판정으로 중단됐다.
  MCP 항목이 동일함을 확인하고 새 계획으로 관리 상태 기록에 성공했다.
- 적용 결과 `changed_configs: []`. 이후 `check`는 9개 항목 모두 `equal`,
  Codex·Antigravity는 `managed-link`; 반복 적용 결과는 `unchanged`였다.
- 최초 이관 복구 기록:
  `~/.local/state/sync-agents/backups/4e3c82b4b2d047b1ba0395bd92cfba6c/`.
  설정 파일 백업은 변경이 있을 때만 생성한다. 이번에는 설정 변경이 없었다.
- 이 호스트에서 샌드박스 `uv`는 macOS system-configuration의 NULL object
  panic으로 실행되지 않았다. 외부 실행으로 라이브러리 준비·테스트·적용을 수행했다.
  이 실패를 MCP 서버 연결 실패와 구분한다.
- 계정 데이터 조회·수정 및 실행 중인 세 앱의 발견·재로딩은 이번 검증 범위에 없다.
  Hermes·스킬 원본 이동·프로젝트 중복 정리는 후속 범위다.
- 표준 MCP SDK `2.3.0`과 `scripts/tests/verify_mcp_connection.py`로 외부 실행
  연결 검사 성공: DEVONthink `0.1.0` / 29개, Raindrop `2.4.5` / 17개,
  Zotero `0.4.0` / 35개. 서버 작업 디렉터리는 `/private/tmp` 아래 임시 경로다.
  첫 검증은 SDK 1.x의 `serverInfo` 필드 접근 때문에 실패했다. 실제 초기화는
  성공했으며 SDK 2.x의 `server_info`로 수정하고 실제 응답 모델 회귀 테스트와
  원래 세 서버 검사를 재실행해 통과했다. 서버 실행 정의 변경은 없었다.
