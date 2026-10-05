# macOS 에이전트 설정 동기화 계획

- 상태: 현황 조사 및 범위 합의 완료. 공유 스킬 1차 정리 적용, 전체 동기화는 미완료.
- 작성일 / 현황 확인일: 2026-10-05
- 저장소: `docs/dotfiles`
- 대상: Codex, Claude Code, Antigravity, Hermes **edith 프로필만**
- 목적: 다른 에이전트와 세션이 동일한 근거와 범위로 구현을 이어갈 수 있게 한다.

## 합의된 목표와 범위

Mac에서 네 에이전트가 가능한 한 동일한 사용자 스킬, MCP 서버, 이벤트 처리를
사용하도록 한다. 공통 원본을 한 곳에서 관리하고 각 에이전트가 요구하는 형식으로
연결하거나 변환한다. 동일한 파일을 배포하는 것과 실제로 동일한 기능을 사용할 수
있는 것은 구분하고, 실행 검증까지 완료 기준에 포함한다.

Hermes는 새 `edith` 프로필을 만들고 **이 프로필만 동기화**한다.
기존 프로필과 기본 프로필의 설정, 현재 활성 프로필 선택은 유지한다.
2026-10-05 확인 당시 `active_profile`은 `iris`였고 `edith` 디렉터리는 없었다.
프로필 생성 시 모델·인증·실행 환경의 기본값 및 상속 범위를 먼저 확인한다.
기존 프로필을 통째 복제하여 채널, 예약 작업, 메모리, 인증 파일까지 가져오지 않는다.

공통 사용자 기능에 에이전트별 내장 도구·플러그인·모델·UI 설정을 추가하는 구조를
사용한다. 이 계획은 모델, 계정, 대화 기록, 메모리, Hermes 기존 역할별 프로필을
통일하는 작업을 포함하지 않는다. Antigravity 앱·IDE·CLI는 경로와 지원 범위를
각각 확인하며, SDK의 지원을 앱의 지원으로 간주하지 않는다.

## 조사 결과

### 공유 스킬 1차 적용 결과 — 2026-10-05

- [공유 스킬 관리](../agents/shared-skills.md)에 제작 출처, 선택·제외 기준,
  최신 원본 커밋, 이름 변경, 미설치 목록 및 복구 방법을 기록했다.
- Matt 스킬 최신 선택 25개를 반영했고, 공유 경로에는 총 55개가 있다.
  Claude에는 Matt 25개를 포함한 38개가 연결되어 있다.
- 후속 Google Workspace·kepano 업데이트를 적용했다. 최신 집계는 공유 경로
  56개 / Claude 연결 44개다. 필수 `gws-shared`를 추가했고 Google 9개와 kepano
  5개는 세 에이전트 경로에 존재한다. 미설치 helper와 적용 커밋은 위 관리 문서를 읽는다.
- Raindrop MCP 저장소 스킬 5개, Vercel 1개, UA 9개도 최신 확인 커밋으로 갱신했다.
  UA 원본은 `2.9.7`로 fast-forward했고 외부 링크를 유지했다. 현재 공유 경로 56개 /
  Claude 연결 54개다. 직접 제작 스킬 2개 연결과 Hermes `edith` 적용은 남아 있다.
- `dandacompany` 출처는 제외했다. Hermes는 `edith`만 고려하고 기존
  강의 실습용 프로필은 현황 비교·동기화 대상으로 삼지 않는다.
- MCP·훅·Hermes 프로필은 이번 작업에서 변경하지 않았다. 전체 스킬 로딩과
  다른 출처의 Claude 누락 연결은 후속 작업이다.

### 적용 전 조사 스냅샷

아래는 설정 파일과 링크 및 설치된 Hermes 코드에 대한 정적 조사 결과다.
실제 각 에이전트를 실행하여 스킬 로딩, MCP 연결, 훅 발생을 검증한 결과는 아니다.
구현 세션에서 파일과 설치 버전을 다시 확인한다.

| 항목 | Codex | Claude Code | Antigravity | Hermes |
| :--- | :--- | :--- | :--- | :--- |
| 공유 스킬 | `~/.agents/skills`를 사용자 스킬 경로로 탐색 | `~/.claude/skills`에 공유 스킬 49개 개별 링크 | `~/.gemini/config/skills`가 공유 경로 전체 참조 | 기본 스킬 경로에 GWS 8개 링크. 프로필 중 sophie만 `skills.external_dirs`로 공유 경로 참조 |
| 사용자 MCP | DEVONthink, 앱 전용 `node_repl`; `computer-use` 비활성 | DEVONthink, Raindrop, Zotero | `~/.gemini/config/mcp_config.json`이 빈 파일 | sophie: DEVONthink, Raindrop, Zotero. mia: Canva. oliver: Bright Data. iris: 직접 선언 없음 |
| 시작 관련 등록 | `SessionStart` | `SessionStart` | `PreInvocation` | 기본 설정의 Herdr 플러그인에 `on_session_start`, `on_session_reset`, `pre_llm_call` |
| 공통 종료·턴 완료 처리 | 미등록 | 미등록 | 미등록 | 확인한 사용자 설정에 미등록 |
| dotfiles 관리 | `config.toml` | `settings.json`, `CLAUDE.md` | 레거시 `.gemini/settings.json`, `trusted_hooks.json` | 관리 대상 없음 |

### 스킬

- 공통 경로 `~/.agents/skills`는 `macos/agents/.agents/skills`를 참조한다.
- 유효한 공유 스킬 디렉터리는 67개다. 연결된 Claude 스킬 49개의 `SKILL.md`는
  공유 원본과 같았다. 숫자는 시스템·플러그인 스킬 전체 개수가 아니다.
- Claude에 연결되지 않은 18개:
  `defuddle`, `find-skills`, `json-canvas`, `magma-support`, `obsidian-bases`,
  `obsidian-cli`, `obsidian-markdown`, `raindrop-devonthink`, `raindrop-zotero`,
  `understand`, `understand-chat`, `understand-dashboard`, `understand-diff`,
  `understand-domain`, `understand-explain`, `understand-figma`,
  `understand-knowledge`, `understand-onboard`.
- 11개 공유 스킬은 저장소 밖 원본을 참조한다. `understand*` 9개는
  `~/.understand-anything/repo/understand-anything-plugin/skills` 아래에 있고,
  `raindrop-devonthink`, `raindrop-zotero`는 `sejong-wiki/skills` 아래에 있다.
  다른 Mac에서 재현하려면 해당 원본의 설치 방법과 버전도 필요하다.
- 일부 스킬에는 `Task tool` 같은 특정 도구 표현이나 Claude 전용 절차가 있다.
  경로를 연결한 뒤 도구 이름·실행 방식의 호환성을 검토한다.
- `macos/agents/README.md`의 Claude 스킬 디렉터리 연결 설명은 실제 개별 링크
  구성과 차이가 있으므로 구현 단계에서 정정한다.

### MCP와 훅

- Claude MCP 사용자 설정은 `~/.claude.json`의 `mcpServers`에 있다.
  이 파일에는 계정·런타임 상태도 있으므로 통째로 버전 관리하지 않는다.
- Claude와 Codex의 DEVONthink `command`·`args`는 동일하다.
  Claude의 Zotero와 Hermes sophie의 `zotero-local`도 동일한 실행 설정이다.
- Raindrop은 Claude가 로컬 stdio, Hermes sophie가 원격 연결이다.
  공통 서버 목록을 정할 때 서버 구현, 전송 방식, 버전, 인증 방식을 맞춘다.
- MCP 직접 선언과 플러그인·앱 커넥터가 제공하는 도구를 별도로 기록한다.
- 현재 시작 관련 훅은 Herdr에 재개 가능한 세션 ID를 보고하는 연동이다.
  Herdr 스크립트는 관리 도구가 업데이트 시 덮어쓴다고 명시한다.
  공통 자동화는 별도 훅/스크립트로 추가하고 기존 Herdr 연동과 공존시킨다.
- 글로벌 등록이어도 Herdr 환경 변수 등이 없으면 보고 동작을 수행하지 않는다.
  훅 등록과 실제 동작을 구분한다.

## 공통 이벤트 계약 초안

이벤트 이름은 구현용 후보이며, 아래 의미를 우선한다.

| 공통 이벤트 | 의미 | Codex | Claude Code | Antigravity 앱·IDE·CLI | Hermes edith |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `session.started` | 세션 시작. 재개·리셋은 원인과 기존 세션 ID를 구분 | `SessionStart` | `SessionStart` | `PreInvocation`에서 대화 ID별 최초 관측. 실제 생성 시점과는 차이가 있음 | `on_session_start` 및 재개·리셋 경계 검증 |
| `session.ended` | 대화 세션 자체의 종료 | `SessionEnd` | `SessionEnd` | 전용 이벤트 없음. 지원 불가를 명시하고 별도 감지의 필요성을 판단 | `on_session_finalize` 및 리셋·종료 경계 검증 |
| `turn.finished` | 한 사용자 요청의 실행 종료. 성공·실패·중단은 별도 상태 | `Stop`, 중단·오류 경로 별도 확인 | `Stop`, 오류·중단 경로 별도 확인 | `Stop`의 종료 원인과 `fullyIdle` 확인 | `on_session_end`의 `completed`, `failed`, `interrupted` 등 확인 |
| `task.completed` | 목표의 명시적 완료 조건 충족 | 공통 완료 조건 검사 | 공통 완료 조건 검사 | 공통 완료 조건 검사 | 공통 완료 조건 검사 |

주의: Hermes 플러그인의 `on_session_end`는 설치된 코드에서 매
`run_conversation` 종료에도 발생한다. 이름만 보고 `session.ended`에 매핑하지 않는다.
`post_llm_call`은 성공한 턴의 종료 관측 후보이고, 실패·중단까지 포괄하려면 다른
경로를 포함해야 한다. Gateway의 `session:end`, `agent:end`와 플러그인 이벤트도
서로 구분한다.

`Stop`은 중간 메시지나 개별 도구 호출 완료가 아닌 턴/실행 종료 지점이다.
훅이 실행 계속을 요청하면 같은 턴에서 다시 발생할 수 있다.
목표 달성이나 테스트 통과를 보장하지 않으므로 `task.completed`와 분리한다.

공통 처리에는 에이전트, 실행 표면, 프로필, 세션 ID, 턴 ID 또는 대체 식별자,
이벤트 원인, 종료 상태, 시각을 전달한다. 시작·재개·중복 `Stop`·백그라운드 작업에
대한 중복 방지 규칙을 정한다. 대화 본문을 수집할지는 별도 요구가 생길 때 결정한다.

## 구성과 책임 경계

| 대상 | 공통 원본의 책임 | 에이전트별 설정의 책임 |
| :--- | :--- | :--- |
| 스킬 | 기존 `.agents/skills` 및 외부 원본 의존성 목록 | 검색 경로, 링크, 호환성 예외 |
| MCP | 서버 ID, 구현·버전, 실행 인자, 전송 방식, 로컬 인증 참조 | JSON/TOML/YAML 변환, 활성화, 기존 항목과 병합 |
| 이벤트 | 이벤트 의미, 상태, 중복 방지, 공통 처리 | 원시 이벤트를 공통 형식으로 변환, 지원 차이 명시 |
| 배포·검사 | 변경 미리보기, 백업, 적용, 차이 검사 | 사용자 파일·앱 관리 설정·프로필의 소유권 보존 |

공통 명세와 스크립트의 배치는 구현 단계에서 확정한다. 계획 문서는
`docs/plans`에 두어 Stow의 홈 디렉터리 배포 대상과 분리한다.
`macos/agents`에는 기존 방식과 맞는 배포 설정을 두되,
앱이 자체 갱신하는 파일은 필요한 관리 항목만 병합한다.
인증 토큰·세션 DB·캐시·훅 신뢰 해시 등 머신별 상태를 공통 원본으로 삼지 않는다.
Hermes는 `edith` 전용 설정과 공통 경로 참조로 구성하며 기존 프로필에 쓰지 않는다.

## 단계별 실행 계획과 완료 기준

- [ ] **1. 공통 명세 확정**
  - 설치 버전, 적용 경로, 프로필 상속·플러그인 로딩 범위를 재확인한다.
  - 공통 스킬 대상과 호환성 예외를 정한다.
  - 공통 MCP 후보는 DEVONthink·Raindrop·Zotero다. 최종 목록과 구현을 확정한다.
  - 이벤트별 처리 목적, 지원 불가·대체 방식, 종료 상태를 확정한다.
  - 완료 기준: 대상·예외·원본 소유자·변경 파일·검증 방법을 검토할 수 있다.
- [ ] **2. 스킬 동기화 및 edith 생성**
  - Hermes `edith`를 생성하고 명시적으로 이 프로필을 지정해 작업한다.
  - 공통 스킬 경로를 `skills.external_dirs`로 참조하게 한다.
  - Claude 누락 연결과 외부 스킬 의존성을 정리한다.
  - 특정 에이전트 전용 스킬 및 동일 이름 중복을 검사한다.
  - 완료 기준: 네 대상에서 공통 스킬 목록·대표 스킬 로딩을 확인하고,
    기존 Hermes 프로필과 활성 프로필 선택에 변화가 없다.
- [ ] **3. MCP 동기화**
  - 공통 서버 명세에서 각 형식의 설정을 생성·병합한다.
  - 실행 경로, 버전, 인증 참조, 로컬 서비스·소켓 접근을 검증한다.
  - 에이전트별 추가 MCP와 앱·플러그인 연결을 유지한다.
  - 완료 기준: 네 대상에서 공통 서버에 연결하고 도구 목록을 조회한다.
    서버 미설치·인증 누락·서비스 중단은 실패 원인으로 명확히 기록한다.
- [ ] **4. 이벤트·훅 동기화**
  - 공통 처리 스크립트와 에이전트별 변환을 구현한다.
  - Herdr 관리 파일과 별도로 등록하고 필요한 훅 신뢰 설정을 처리한다.
  - 시작·재개·리셋·정상 종료·턴 완료·오류·중단·반복 Stop·백그라운드 작업을 검증한다.
  - 완료 기준: 지원되는 경로에 기대한 이벤트와 상태가 발생한다.
    지원되지 않는 경로를 동일하게 구현됐다고 표시하지 않는다.
- [ ] **5. 재현과 설정 차이 검사**
  - 백업, 변경 미리보기, 적용, 차이 검사 절차를 제공한다.
  - 반복 적용과 실패 후 복구, 앱의 설정 갱신 후 차이 검사를 확인한다.
  - README를 실제 경로·공통 설정 소유권·Hermes edith 범위에 맞춰 갱신한다.
  - 완료 기준: 재적용에 불필요한 변경이 없고, 기존 설정 보존과 설정 이탈을 확인할 수 있다.

검증 기록에는 날짜, 설치 버전, 실행 표면, 명령/재현 절차, 실제 결과,
통과·실패·미지원·미검증 상태를 남긴다. 설정이 존재한다는 이유만으로 통과 처리하지 않는다.

## 다음 세션 인수인계

1. 이 문서와 `macos/agents/README.md`, 작업 대상에 적용되는 지시를 읽는다.
2. `git status`로 사용자 작업을 확인한다. 조사 당시 공유 스킬과 Claude·Codex
   설정 등에 기존 수정·미추적 파일이 많았다. 기존 변경을 덮어쓰거나 함께 커밋하지 않는다.
3. 위 조사 결과는 2026-10-05 스냅샷이므로 현재 파일과 설치 버전을 재확인한다.
4. 공유 스킬 1차 정리는 별도 승인으로 적용했다. 선택·제외 기준은
   [공유 스킬 관리](../agents/shared-skills.md)를 읽는다. 다음 작업은 나머지
   공통 명세 확정 및 스킬 동기화이며, 활성 프로필 변경과 커밋은 별도 요청을 따른다.
5. 구현 후 각 단계 체크박스와 실제 검증 결과를 갱신한다.

### 참고할 스킬

- `openai-docs`: Codex 경로·MCP·훅의 현재 공식 지원 확인.
- `diagnosing-bugs`: 설정과 실행 결과가 다르거나 연결 실패가 발생할 때 진단.
- `handoff`: 새 세션에 이 계획과 진행 상태를 연결하는 인수인계 작성.
- `skill-creator` / `writing-for-agents`: 공통 스킬의 호환성 수정이 필요할 때.

## 근거와 재확인 위치

- [에이전트 설정 README](../../macos/agents/README.md)
- [공유 스킬](../../macos/agents/.agents/skills/)
- [Codex 관리 설정](../../macos/agents/.codex/config.toml)
- [Claude 관리 설정](../../macos/agents/.claude/settings.json)
- 로컬 확인 파일: `~/.claude.json`, `~/.codex/hooks.json`,
  `~/.gemini/config/mcp_config.json`, `~/.gemini/config/hooks.json`,
  `~/.hermes/config.yaml`, `~/.hermes/active_profile`,
  `~/.hermes/profiles/*/config.yaml`, `~/.hermes/plugins/herdr-agent-state/`.
- Hermes 설치 코드: `agent/skill_utils.py`, `agent/turn_finalizer.py`,
  `hermes_cli/plugins.py`, `hermes_cli/lifecycle.py`, `gateway/hooks.py`
  (조사 당시 저장소: `~/.hermes/hermes-agent`).
- 공식 문서: [Codex 스킬](https://learn.chatgpt.com/docs/build-skills),
  [Codex MCP](https://developers.openai.com/codex/mcp),
  [Codex 훅](https://learn.chatgpt.com/docs/hooks),
  [Claude MCP](https://code.claude.com/docs/en/mcp),
  [Claude 훅](https://code.claude.com/docs/en/hooks),
  [Antigravity MCP](https://antigravity.google/docs/mcp),
  [Antigravity 훅](https://antigravity.google/docs/hooks),
  [Hermes 플러그인](https://hermes-agent.nousresearch.com/docs/developer-guide/plugins),
  [Hermes 이벤트 훅](https://hermes-agent.nousresearch.com/docs/user-guide/features/hooks).
