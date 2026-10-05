# 전역 MCP 정본·배포 도구 변경 미리보기

- 상태: 승인 후 MCP 정본·배포·복구 도구 구현 및 최초 관리 이관 완료.
  아래는 승인 당시의 미리보기이며 현재 계약은 전역 관리 방안을 따른다.
- 확인일: 2026-10-05
- 구조·전환 기준 정본: [전역 관리 방안](../agents/global-management.md)
- 이전 작업: [세션 기록](../handoffs/2026-10-05-global-skills-mcp-session.md)

## 현재 확인 결과

Codex·Claude·Antigravity의 `devonthink`, `raindrop`, `zotero` 실행 명령과
인자는 일치한다. TOML·JSON 파싱에 성공했다. Codex와 Antigravity의 전역
설정은 dotfiles의 관리 파일을 가리키는 심링크다. Claude는 `~/.claude.json`
실파일의 최상위 `mcpServers`에 세 서버를 등록했다.

Codex에는 `node_repl`, `computer-use`도 있다. 이 항목은 앱별 설정으로 보존한다.
이번 확인은 설정 읽기와 링크 검사이며 MCP 연결·앱 재로딩을 다시 실행하지 않았다.
이전 연결 결과는 [전역 MCP 기록](../agents/global-mcp.md)을 따른다.

Raindrop 스킬 2개는 `sejong-wiki` 원본을 참조하고 Claude 연결은 없다.
Hermes `edith`는 없으며 활성 프로필은 `iris`다.

## 1차 구현 범위와 파일 소유권

| 경로 | 예정 변경 | 소유 범위·보존 조건 |
| :--- | :--- | :--- |
| `macos/agents/.agents/mcp/servers.json` | 신규 공통 명세 | 세 서버의 실행 정의·대상·활성 여부·인증 경로 참조 |
| `macos/agents/.agents/mcp/sources.json` | 신규 출처 기록 | 출처·확인 버전·설치 방식·미확인 사항. 토큰 값 제외 |
| `scripts/sync-agents` | 신규 Python 진입점 | MCP `check`, `plan`, `apply`. 이번에는 스킬 링크를 관리하지 않음 |
| `scripts/tests/test_sync_agents.py` | 신규 격리 테스트 | 임시 홈·설정 fixture에서 보존·충돌·복구 검증 |
| `docs/agents/global-management.md` | 구현 후 상태·사용법 갱신 | 관리 계약 소유. 이 검토안의 내용을 중복 정본으로 만들지 않음 |
| `docs/agents/global-mcp.md` | 구현 후 실행 정의 참조로 전환 | 적용·복구·실제 검증 기록 소유 |
| `macos/agents/README.md`, 전체 계획·핸드오프 | 구현 후 경로·진행 상태 갱신 | 테스트 완료와 실제 적용 완료를 구분 |

실제 적용 대상은 다음 세 파일이다. 최초 계획에서 현재 정의와 명세가 같으면
설정 파일의 변경은 없고 관리 상태만 신규 기록한다.

| 대상 | 실제 쓰기 대상 | 관리 키 |
| :--- | :--- | :--- |
| Codex | 심링크가 가리키는 `macos/agents/.codex/config.toml` | `mcp_servers.devonthink`, `.raindrop`, `.zotero` |
| Claude | `~/.claude.json` | 최상위 `mcpServers`의 세 서버만 |
| Antigravity | 심링크가 가리키는 `macos/agents/.gemini/config/mcp_config.json` | `mcpServers`의 세 서버만 |

Codex의 무관한 설정·주석은 보존한다. TOML 편집은 구조를 인식하는 편집기를
사용하며 정규식으로 테이블 범위를 추정하지 않는다. 의존성·실행 Python 버전은
구현 시 명시하고, 파싱·보존을 확인할 수 없는 파일에는 쓰지 않는다.
JSON은 비관리 키의 값을 보존하고, 의미상 변경이 없으면 재직렬화하지 않는다.
관리 서버에 명세 밖 필드가 있으면 삭제하지 않고 충돌로 보고한다.

## 공통 명세 후보

다음은 `servers.json`의 구체적인 입력 후보다. `${HOME}`은 배포 도구가
사용자 홈으로 치환한다. 다른 환경 변수·셸 표현을 임의로 확장하지 않는다.
현재 Raindrop 명령과 의미를 유지하며 홈 경로는 셸 인자에 맞게 인용한다.

```json
{
  "schema_version": 1,
  "servers": {
    "devonthink": {
      "transport": "stdio",
      "command": "npx",
      "args": ["-y", "mcp-server-devonthink"],
      "enabled": true,
      "targets": ["codex", "claude", "antigravity"]
    },
    "raindrop": {
      "transport": "stdio",
      "command": "bash",
      "args": ["-c", "set -a && source ${HOME}/.config/sejong-mcp/raindrop.env && exec npx @adeze/raindrop-mcp@latest"],
      "auth_file": "${HOME}/.config/sejong-mcp/raindrop.env",
      "enabled": true,
      "targets": ["codex", "claude", "antigravity"]
    },
    "zotero": {
      "transport": "stdio",
      "command": "${HOME}/.cargo/bin/zotero-mcp",
      "args": [],
      "enabled": true,
      "targets": ["codex", "claude", "antigravity"]
    }
  }
}
```

`auth_file`은 사전 조건 검사 전용이다. 인증 내용을 읽거나 출력하거나 배포하지
않는다. 비활성 항목은 대상 설정에서 제외하며 이전에 관리한 항목일 때만 제거
후보로 올린다. 전송 방식은 1차 구현에서 stdio만 지원하고 다른 값은 오류로 처리한다.

`sources.json`은 서버별로 출처, 설치 방식, 실행 경로, 확인 버전, 버전 확인일,
원본 커밋, 로컬 수정 여부, 확인 근거를 기록한다. 확인하지 못한 값은 `null`과
사유로 남긴다. 기존 DEVONthink `0.1.0`, Raindrop `2.4.5`, Zotero `0.4.0`은
이전 연결 검사에서 관측한 값이며 현재 버전으로 재확인했다고 쓰지 않는다.
Zotero의 원본 후보와 커밋·수정 여부 미확인 상태를 유지한다. 서버 업데이트나
Raindrop `@latest` 고정은 이번 구현 범위에 포함하지 않는다.

## 미리보기·적용 인터페이스

아래는 구현할 인터페이스이며 현재 실행 가능한 명령이 아니다.

```text
scripts/sync-agents check
scripts/sync-agents plan --output /private/tmp/global-mcp-plan.json
scripts/sync-agents apply --plan /private/tmp/global-mcp-plan.json
```

- `check`: 명세·출처 기록 구문, 대상 링크·관리 키 일치, 실행 파일·인증 파일 존재,
  관리 상태를 검사한다. 파일을 쓰지 않으며 연결 성공 여부는 미검증으로 구분한다.
- `plan`: 추가·변경·관리 이관·제거·충돌을 키별로 표시한다. 전체 Claude 파일이나
  인증 값을 출력하지 않는다. 명세·대상 파일·심링크 목적지·이전 관리 상태의
  해시를 포함하고, 출력 계획 파일은 `0600`으로 만든다.
- `apply`: 저장한 계획과 현재 해시를 비교한다. 바뀌었거나 충돌이 있으면 적용을
  중단한다. 현재 명세와 동일한 기존 항목만 최초 관리 이관을 허용한다.
  다른 정의를 덮어쓰려면 새 계획에 해당 변경을 명시해야 한다.

상태와 백업 후보 경로는 Git 밖 `~/.local/state/sync-agents/`다. 디렉터리는
`0700`, 파일은 `0600`으로 둔다. Claude 전체 백업에는 계정 정보가 포함될 수
있으므로 저장소·미리보기 출력에 넣지 않는다. 관리 항목 삭제는 이전 배포 값과
현재 값이 같을 때만 허용하고 사용자가 바꾼 값은 충돌로 보고한다.

대상별 백업·임시 파일 생성·구문 검사 후 실제 원본을 교체해 심링크를 유지한다.
적용 직전에도 원본의 변경 여부를 확인한다. 일부 대상 적용 후 실패하면 성공·실패
대상과 백업 위치를 기록하고, 각 대상의 이전 상태로 복원하는 방법을 제공한다.
관리 상태는 실제 성공한 대상만 반영한다. 상태가 손상되면 제거·덮어쓰기를 중단한다.

## 검증·완료 기준

- [x] 명세가 현재 세 설정과 의미상 동일하고 토큰 값을 포함하지 않는다.
- [x] `check`가 파일을 변경하지 않고 누락·충돌·미지원·미검증을 구분한다.
- [x] 비관리 MCP·Codex 주석·Claude 계정/프로젝트 키·추가 JSON 키가 보존된다.
- [x] 최초 관리 이관과 반복 적용에서 불필요한 설정 변경이 없다.
- [x] 계획 후 파일·링크·명세·상태가 바뀌면 적용을 중단한다.
- [x] 관리했던 항목만 제거 후보가 되며 사용자가 수정한 항목은 충돌이다.
- [x] 구문 오류·중간 실패·상태 손상·백업 복원 절차를 임시 홈에서 검증한다.
- [x] 실제 적용은 승인된 계획으로 수행하고 설정 구문·일치·링크를 재검사한다.
- [ ] 볼트 밖 MCP 연결 검사와 각 앱의 발견·재로딩 여부를 각각 기록한다.


## 후속 범위

스킬 원본 이동, Claude 누락 링크, `sejong-wiki` 프로젝트 MCP 제거,
Hermes `edith` 생성과 이벤트·훅은 별도 작업이다. 특히 Hermes는 설치된 형식과
상속 범위를 확인한 뒤 대상 어댑터를 추가하고 기존 프로필·활성 선택을 보존한다.
이번 검토안 작성은 구현·실제 적용·커밋의 완료를 의미하지 않는다.

## 구현 결과

2026-10-05 승인 범위의 명세·출처 기록과 `check·plan·apply·restore`를 구현했다.
복구 명령과 명시적 연결 검증 스크립트 `scripts/tests/verify_mcp_connection.py`를
추가했다. 임시 홈·SDK 회귀 테스트 18개가 통과했고 실제 최초 이관에서 설정 파일 변경은
없었다. 반복 적용은 `unchanged`였다. 자세한 결과·한계는
[적용 기록](../agents/global-mcp.md#정본-전환배포-도구-검증--2026-10-05)을 따른다.
체크리스트에는 구현·검증 결과를 반영했다. 각 앱의 실제 발견·재로딩은 미완료다.
현재 실행·복구 계약의 정본은
[관리 방안](../agents/global-management.md)이다.
