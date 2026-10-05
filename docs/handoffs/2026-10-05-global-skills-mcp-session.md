# 세션 기록 — 전역 스킬·MCP 관리

- 날짜: 2026-10-05
- 저장소: `/Users/sejong/Github/docs/dotfiles`
- 현재 상태: 전역 MCP 등록·공통 배포·복구 도구 구현 및 최초 관리 이관 완료.
  후속 스킬 8개 검토·Zotero 글로벌 원본 전환·DEVONthink 로컬 분리 완료.
- 검증: 격리·SDK 회귀 테스트 18개 통과, 설정 일치·반복 적용·세 서버 연결 확인.
- 앱 후속 검증: [앱 로딩 검증 기록](2026-10-05-agent-app-validation.md). Codex 새 CLI 서버·Claude 연결 성공, Antigravity Zotero 호환성 오류와 Codex 데스크톱 재로딩 확인이 남아 있다.
- 남은 범위: 스킬 배포 자동화·UA 준비, Hermes `edith`, 프로젝트 중복·이벤트 훅.
- Git: MCP 관련 변경은 `31ba585`로 커밋했다. 볼트 변경은 `30da3e0`, 로컬 스킬로
  남긴 세션 로그는 `d845840`으로 커밋했다. dotfiles 스킬 분리·문서 변경은
  후속 요청으로 선별 커밋하며 push는 수행하지 않는다.

## 작업 목적과 승인 범위

Codex·Claude Code·Antigravity·Hermes `edith`에서 공통 사용자 스킬과 MCP를
재현 가능하게 관리하려는 작업이다. 이전 에이전트 동기화 작업을 이어서
`sejong-wiki`의 직접 제작 스킬·MCP와 프로젝트 등록을 조사했다.

첫 단계에서는 사용자 요청으로 DEVONthink·Raindrop·Zotero를 세 에이전트의
전역 사용 대상으로 등록하고 관리 방안을 문서화했다. 후속 단계에서는
[변경 미리보기](../plans/2026-10-05-global-mcp-preview.md)를 제시하고 사용자의
진행 승인으로 공통 MCP 명세와 배포 도구를 구현·검증·적용했다.

MCP 구현 대상은 Codex·Claude·Antigravity의 stdio MCP 세 서버였다.
그 단계에서는 스킬 원본 이동을 수행하지 않았으며, 후속 사용자 요청으로 아래
Zotero 글로벌 전환·DEVONthink 로컬 분리를 적용했다.
프로젝트 MCP 등록 제거·Hermes 생성·이벤트 훅은 수행하지 않았다.
계정·대화·모델 설정은 공통화 대상에 포함하지 않았다.

## 문서와 원본의 역할

| 문서·파일 | 역할 |
| :--- | :--- |
| [전역 관리 방안](../agents/global-management.md) | 관리 구조·배포 계약·사용법·복구 절차의 정본 |
| [공통 MCP 명세](../../macos/agents/.agents/mcp/servers.json) | 실행 정의·대상·활성 여부·인증 경로 참조 |
| [MCP 출처 기록](../../macos/agents/.agents/mcp/sources.json) | 설치 방식·관측 버전·원본 확인 한계 |
| [전역 MCP 적용 기록](../agents/global-mcp.md) | 실제 적용 경로·검증 결과·로컬 복구 기록 |
| [공유 스킬 관리](../agents/shared-skills.md) | 스킬 출처·설치·제외·업데이트·복구 안내 |
| [전체 동기화 계획](../plans/2026-10-05-macos-agent-sync.md) | 전체 단계와 완료 기준·미완료 범위 |
| 이 세션 기록 | 수행 결과·변경 범위·다음 세션 시작점 |

## 수행 결과

### 전역 등록과 현황 조사

- 스킬 원본 8개 확인: 볼트 운영용 6개, 전역 재사용 Raindrop 스킬 2개.
- 자체 `sejong-wiki-skills` MCP의 13개 도구와 프로젝트 MCP 4개 등록 확인.
- Codex 전역 설정에 Raindrop·Zotero 추가. 기존 DEVONthink와 기타 설정 보존.
- Antigravity MCP 전용 JSON에 세 서버 등록 후 전역 경로 연결.
- Claude의 기존 세 전역 MCP 등록 유지.
- 관리 방안·적용 기록 작성 후 README·공유 스킬 관리·전체 계획·인수인계 연결.

Zotero MCP는 직접 제작 서버로 분류하지 않았다. 외부 코드의 기존 로컬 빌드이며
원본 후보는 `richardjlyon/zotero-mcp`다. 원본 커밋과 로컬 수정 여부는 미확인이다.
기존 바이너리를 사용했고 별도 재설치·업데이트를 수행하지 않았다.

### 공통 정본과 배포 도구 구현

- `servers.json`과 `sources.json`을 만들고 기존 세 설정과 같은 실행 정의를 기록했다.
- [배포 도구](../../scripts/sync-agents)에 `check·plan·apply·restore`를 구현했다.
- 관리 항목 병합, Codex 주석·사용자 설정 보존, 계획 변경 감지, 관리 상태·백업,
  부분 실패 기록·복구와 반복 적용을 구현했다. 동작 계약은 관리 방안을 따른다.
- 임시 홈 통합 테스트와 SDK 응답 모델 회귀 테스트, 명시적 연결 검증 스크립트를 추가했다.
- 세 에이전트의 기존 9개 MCP 항목을 최초 관리 상태로 이관했다.
  적용 결과는 `changed_configs: []`로 설정 파일을 다시 쓰지 않았다.
- 관리 문서·README·미리보기·전체 계획·핸드오프에 구현 결과와 남은 범위를 반영했다.

## 검증 결과와 해결한 문제

### 후속 글로벌 스킬 분류·전환

`sejong-wiki` 스킬 8개 전체를 검토했다. 사용자 결정으로 `raindrop-zotero`만
글로벌 원본으로 옮기고 DEVONthink와 볼트 운영 6개는 로컬에 유지했다.
[분류·전환 기록](../plans/2026-10-05-global-skills-preview.md)에 전체 판단 근거와
실제 경로·변경 파일·백업 위치를 기록했다.

- Zotero 본문·결과 스키마 2개 파일을 변경 없이 dotfiles로 이동하고 Claude에 연결했다.
- 볼트의 Zotero 경로는 처음 호환 링크로 전환했다가 후속 사용자 결정으로 제거했다.
- DEVONthink 글로벌 공유 링크를 제거하고 구현·테스트를 보존했다. 본문에는
  글로벌 Zotero 원본 경로와 미설치 시 보류하는 라우팅 안내만 보강했다.
- 기존 볼트 `.agents/skills → ../skills` 연결을 유지했고 새 로컬 링크는 추가하지 않았다.
- 볼트의 `global-setup.sh`를 제거하고 `local-setup.sh` 호출부를 dotfiles 안내로 바꿨다.
  README·스킬 README·DEVONthink 본문·ADR-0002는 Obsidian CLI로 정리했다.
- 글로벌 Codex·Claude·Antigravity 경로의 동일 원본 55개·깨진 링크 없음과
  Zotero 상대 참조·설치 스크립트 구문을 확인했다. 실제 앱 내부 로딩은 미검증이다.
- 외부 스킬 설치 기록·본문·UA 원본·MCP 설정은 이번 분리에서 변경하지 않았다.

볼트 스킬 변경은 `30da3e0`, 월별 세션 로그·hot 요약은 `d845840`으로 선별 커밋했다.
볼트 작업 세션 토큰은 `07d04fdd1940`이다. dotfiles의 원본·관련 문서도 후속 요청으로
선별 커밋한다. 아래 MCP 테스트는 이전 구현 단계의 결과다.

### MCP 구현 검증

이 표는 이번 구현 세션에서 실제 수행한 결과다. 문서 정리 요청으로 테스트와
연결 검사를 다시 실행한 것은 아니다. 상세 명령과 재현 절차는 관리 방안을 따른다.

| 검증 | 결과 |
| :--- | :--- |
| 임시 홈 통합·SDK 회귀 테스트 | 18개 통과. 보존·충돌·오래된 계획·제거·링크·부분 실패·복구 검증 |
| 최초 관리 이관 | 9개 항목 `adopt`, 설정 파일 변경 없음 |
| 적용 후 차이 검사 | 9개 항목 `equal`, Codex·Antigravity `managed-link` |
| 반복 적용 | `unchanged` |
| DEVONthink 초기화·도구 조회 | 성공. `0.1.0`, 29개 도구 |
| Raindrop 초기화·도구 조회 | 성공. `2.4.5`, 17개 도구 |
| Zotero 초기화·도구 조회 | 성공. `0.4.0`, 35개 도구 |
| 구문·문서 검사 | Python 구문·JSON·상대 링크·`git diff --check` 통과 |
| 각 앱의 실제 발견·재로딩 | 미검증 |
| 계정 데이터 조회·서비스 도구 호출·외부 쓰기 | 미수행 |

Claude 런타임 파일이 계획 생성 이후 바뀌어 첫 적용은 stale 판정으로 중단됐다.
MCP 항목이 동일함을 확인하고 새 계획으로 관리 이관을 완료했다.

첫 연결 검증은 SDK `2.3.0`에서 이전 `serverInfo` 필드 접근 때문에 실패했다.
최소 재현에서 초기화 자체는 성공했음을 확인했고 `server_info`로 수정했다.
실제 응답 모델을 사용하는 회귀 테스트의 실패·수정 후 성공과 세 서버 재검증을 확인했다.

샌드박스의 `uv`는 macOS system-configuration의 NULL object panic으로 실패했다.
라이브러리 준비·테스트·적용·연결 검사는 외부 실행으로 수행했다. 이 문제는 서버
연결 실패와 구분한다. 서버 작업 디렉터리는 볼트 밖 `/private/tmp` 아래 임시 경로였다.
각 앱의 실제 재로딩 성공이나 서비스 인증·기능 검증으로 확대 해석하지 않는다.

## 변경 범위와 로컬 기록

이전 전역 등록 단계의 저장소 변경:

- `macos/agents/.codex/config.toml`: MCP 추가. 작업 시작 전 미커밋 변경도 있던 파일.
- `macos/agents/.gemini/config/mcp_config.json`: 신규 전역 MCP 설정.
- `docs/agents/{global-mcp,global-management,shared-skills}.md`,
  `macos/agents/README.md`, 전체 계획과 기존 인수인계·이 세션 기록.

이번 정본·배포 구현 단계의 추가 파일:

- `macos/agents/.agents/mcp/servers.json`, `sources.json`
- `scripts/sync-agents`
- `scripts/tests/test_sync_agents.py`, `test_verify_mcp_connection.py`,
  `verify_mcp_connection.py`
- `docs/plans/2026-10-05-global-mcp-preview.md`

관련 관리 문서·README·전체 계획·핸드오프도 갱신했다. 이번 구현 단계에서는
기존 세 에이전트 설정의 MCP 실행 정의를 변경하지 않았다.

저장소 밖에는 기존 Antigravity 전역 링크와 신규 관리 상태·복구 기록이 있다.
관리 상태는 `~/.local/state/sync-agents/`에만 두며 권한은 디렉터리 `0700`,
파일 `0600`이다. 최초 이관의 복구 ID·경로는 전역 MCP 적용 기록을 따른다.
기존 빈 Antigravity 설정 백업과 계획 파일은 `/private/tmp`에 있으므로 장기 보존을
보장하지 않는다. 인증 파일·로컬 관리 상태·계정 백업은 Git에 넣지 않았다.

Aerospace·스킬 잠금 기록·Claude 설정·셸 설정과 기존 미추적 스킬 링크·Neovim 압축·
RunPod Dockerfile은 이번 MCP 구현 변경으로 취급하지 않는다. 이후 커밋 요청 시
선택적으로 검토하며, Codex 설정의 기존 변경과 이전 MCP 추가도 구분한다.

## 남은 작업과 다음 세션 시작

- [ ] 세 에이전트 앱에서 실제 MCP 발견·재로딩을 확인한다.
- [x] 볼트 스킬 8개 검토, Zotero 글로벌 연결과 DEVONthink 로컬 분리를 적용한다.
- [ ] 각 앱의 실제 스킬 로딩과 스킬 배포 자동화를 확인한다.
- [ ] 외부 UA 원본 준비의 재현·자동화 범위를 검토한다.
- [ ] `sejong-wiki`의 끊어진 Claude 프로젝트 스킬 링크 5개와 MCP 중복 등록을 검토한다.
- [ ] Hermes `edith`의 생성·상속 범위를 확인하고 해당 프로필만 구성한다.
- [ ] 공통 이벤트·훅의 목적과 에이전트별 지원 차이를 확정하고 구현·검증한다.

다음 세션은 `git status`, 이 기록, 전역 관리 방안, 전역 MCP 적용 기록,
전체 동기화 계획을 읽고 시작한다. 필요하면 `scripts/sync-agents check`로 현재
차이를 확인한다. 이번 구현에서 Hermes는 생성하지 않았고 확인 당시 활성 프로필은
`iris`였다. 기존 프로필과 활성 선택을 보존한다.

추가 스킬 이동·프로젝트 등록 제거는 영향과 범위를 제시한 뒤 별도 승인으로 진행한다.
기록 정리·새 세션 시작은 커밋이나 남은 구조 전환의 실행 승인이 아니다.
