# 공유 스킬 관리

- 적용일: 2026-10-05
- 대상: Codex, Claude Code, Antigravity, Hermes `edith`만
- 이 문서는 공유 스킬의 선택·제외·재설치 기준을 소유한다.
- 외부 스킬의 설치 출처·경로·폴더 해시·갱신 시각은
  [설치 기록](../../macos/agents/.agents/.skill-lock.json)이 소유한다.
- 원본 위치·에이전트 연결·배포 도구를 전환할 때는
  [전역 스킬·MCP 관리 방안](global-management.md)을 따른다. 직접 제작 Zotero 원본은
  dotfiles로 전환했고 DEVONthink는 볼트 로컬로 유지한다. 스킬 배포 자동화는 후속 범위다.

## 적용 결과

Matt Pocock 스킬을 원본 `main`의 확인된 커밋
`24fe0ef7737efae15c87225755e9f6f5965e4888`로 업데이트했다.
원본 패키지 버전은 `1.3.1`이다. 이후의 `main`과 같은 상태라는 의미는 아니다.
스킬 본문과 보조 파일은 원본 그대로 설치했다.

| 구분 | 출처 | 공유 스킬 수 |
| :--- | :--- | ---: |
| 직접 제작 | Sejong, dotfiles | 1 |
| 외부 제작 | `mattpocock/skills` | 25 |
| 외부 제작 | `googleworkspace/cli` | 9 |
| 외부 제작 | `kepano/obsidian-skills` | 5 |
| 외부 제작 | `adeze/raindrop-mcp` | 5 |
| 외부 제작 | `vercel-labs/skills` | 1 |
| 외부 제작 | Egonex, Understand Anything | 9 |
| 합계 | 직접 제작 1 + 외부 제작 54 | **55** |

직접 제작 글로벌 스킬은 `raindrop-zotero`다. `raindrop-devonthink`는
사용자 결정으로 `sejong-wiki` 로컬에 유지하며 글로벌 공유 목록에서 제외했다.
외부 제작 스킬의 여섯 출처(Matt, Google Workspace, kepano, Raindrop MCP,
Vercel, UA)를 각각 확인한 최신 커밋으로 갱신했다. 직접 제작 스킬은 변경하지 않았다.
별도 합의에 따라 `dandacompany` 출처는 공유 대상에서 제외했다.
현재 해당하는 `magma-support`는 강의 실습용이며 공유 경로에서 이동했다.
Hermes의 강의 실습용 프로필은 비교·동기화 대상이 아니며 변경하지 않았다.

## Google Workspace·kepano 업데이트 — 2026-10-05

| 출처 | 적용한 원본 커밋 | 선택한 글로벌 스킬 |
| :--- | :--- | :--- |
| `googleworkspace/cli` | `a3768d0e82ad83cca2da97724e46bea4ff0e6dbd` | `gws-calendar`, `gws-docs`, `gws-drive`, `gws-forms`, `gws-gmail`, `gws-keep`, `gws-slides`, `gws-tasks`, `gws-shared` |
| `kepano/obsidian-skills` | `3ccff5338ea700537839b21900aa5358a0402c98` | `defuddle`, `json-canvas`, `obsidian-bases`, `obsidian-cli`, `obsidian-markdown` |

기존 13개를 업데이트했고, Google 8개 스킬이 필수로 읽는 인증·보안 공통 참조
`gws-shared` 1개를 추가했다. 글로벌 공유 경로와 Claude의 개별 링크에 반영했다.
서비스별 추가 기능을 자동 설치하는 전체 저장소 설치는 하지 않았다.
스킬 본문·보조 파일 14개 스킬 / 19개 파일은 적용 커밋의 원본과 일치한다.

Google 스킬의 `metadata.version`과 로컬 `gws --version`은 `0.22.5`다.
로컬 `defuddle --version`은 `0.19.4`다. kepano 스킬 버전은 위 커밋으로 식별한다.
CLI 실행 파일은 이번 작업에서 업데이트하지 않았다. 계정 인증, Google 데이터
조회·쓰기, Obsidian vault 접근을 수행하지 않았다.

### 이번에 설치하지 않은 추가 스킬

- kepano: 신규 `knap`은 기존 선택 목록 밖이라 설치 보류.
- Google: 선택 서비스의 helper `gws-calendar-agenda`, `gws-calendar-insert`,
  `gws-docs-write`, `gws-drive-upload`, `gws-gmail-forward`, `gws-gmail-read`,
  `gws-gmail-reply`, `gws-gmail-reply-all`, `gws-gmail-send`, `gws-gmail-triage`,
  `gws-gmail-watch`는 미설치다. 원본 서비스 스킬의 Helper Commands 링크는
  이 미설치 스킬을 가리킬 수 있다. 기본 서비스의 API 사용과 필수 `gws-shared`
  참조는 가능하며, helper 전용 워크플로가 필요하면 선택 설치한다.
- Google 저장소의 다른 서비스, persona, recipe와 추가 helper도 이번 범위 밖이다.

## 설치한 Matt 스킬

| 용도 | 스킬 |
| :--- | :--- |
| 인터뷰·설계 | `grill-me`, `grill-with-docs`, `grilling`, `codebase-design`, `domain-modeling`, `improve-codebase-architecture` |
| 계획·작업 관리 | `ask-matt`, `setup-matt-pocock-skills`, `wayfinder`, `to-spec`, `to-tickets`, `triage`, `loop-me` |
| 구현·검증·조사 | `implement`, `tdd`, `diagnosing-bugs`, `code-review`, `prototype`, `research` |
| 학습·인수인계 | `teach`, `handoff` |
| 글·에이전트 문서 작성 | `writing-beats`, `writing-fragments`, `writing-shape`, `writing-for-agents` |

`research`는 최신 `wayfinder`의 조사 티켓 처리가 호출하는 의존성이라 추가했다.
나머지 신규 스킬은 자동으로 설치하지 않았다. 라우터의 선택적 추천에 미설치
스킬이 나타날 수 있다. 그 흐름이 필요하면 아래 목록을 보고 설치 범위를 결정한다.

### 이름 변경·통합

| 이전 이름 | 현재 이름·처리 |
| :--- | :--- |
| `review` | `code-review` |
| `to-prd` | `to-spec` |
| `to-issues` | `to-tickets` |
| `decision-mapping` | `wayfinder` |
| `writing-great-skills` | `writing-for-agents` |
| `write-a-skill` | 원본에서 폐기. `writing-great-skills`를 거쳐 `writing-for-agents`로 통합 |

이전 이름의 폴더와 Claude 링크는 제거했다. 별칭 스킬을 남기지 않는다.
최신 Matt 문서는 용어집 이름으로 `GLOSSARY.md`를 사용한다.
이 업데이트는 다른 프로젝트의 `CONTEXT.md`나 운영 문서를 자동으로 바꾸지 않는다.

## 글로벌에서 제외한 스킬

사용자가 승인한 제외 목록이다. 재설치가 필요하면 해당 프로젝트나 에이전트 범위에
한정한다. 원본에서 이미 폐기된 스킬은 최신 대체 스킬을 사용한다.

| 스킬 | 제외 이유 | 필요할 때의 처리 |
| :--- | :--- | :--- |
| `obsidian-vault` | 제작자의 개인 vault 경로가 하드코딩됨. 현재 CLI 운영 규칙과 부적합 | 공유 `obsidian-cli` 사용 |
| `edit-article` | 원본에서 개인용으로 제거됨 | 설치된 `writing-*`를 먼저 검토 |
| `ubiquitous-language` | 원본에서 폐기·통합 | `domain-modeling` |
| `design-an-interface` | 원본에서 폐기·통합 | `codebase-design`의 `DESIGN-IT-TWICE.md` |
| `qa` | 원본에서 폐기·통합 | `triage`, `to-tickets` |
| `request-refactor-plan` | 원본에서 폐기·통합 | `to-spec`, `improve-codebase-architecture` |
| `resolving-merge-conflicts` | 원본에서 전용 스킬이 불필요하다고 판단해 제거 | 에이전트 기본 기능 |
| `scaffold-exercises` | AI Hero 강의 제작 도구·구조 전용 | 해당 강의 프로젝트에만 설치 |
| `migrate-to-shoehorn` | 특정 TypeScript 테스트 마이그레이션 | 해당 TS 프로젝트에만 설치 |
| `setup-pre-commit` | Husky·lint-staged 중심의 JS/TS 설정 | 해당 JS/TS 프로젝트에만 설치 |
| `git-guardrails-claude-code` | Claude 전용 훅 설치 | 필요한 Claude 전용 범위에만 설치 |
| `magma-support` | `dandacompany` 강의 실습용 | 공통 배포 제외. 강의 환경에서 별도 관리 |

### 최신 원본에 있지만 이번에 설치하지 않은 신규 스킬

| 스킬 | 판단 |
| :--- | :--- |
| `implement-spec` | 전체 spec 병렬 구현. 기존 설치의 업데이트 범위를 넘어 선택 보류 |
| `pr` | PR 본문 작성. 필요할 때 별도 선택 |
| `retro` | 작업 회고·에이전트 환경 개선. 필요할 때 별도 선택 |
| `wizard` | 사람의 수동 설정을 돕는 스크립트 생성. 필요할 때 별도 선택 |
| `wait-what` | 답변 재설명용 명령. 필요할 때 별도 선택 |
| `to-questionnaire` | 다른 사람에게 보낼 질문지 작성. 필요할 때 별도 선택 |
| `setup-ts-deep-modules` | TypeScript 프로젝트 설정, 원본의 in-progress 항목 |
| `claude-handoff` | Claude 중심 인수인계, 원본의 in-progress 항목 |

원본의 현재 37개 중 25개를 설치했다. 나머지 12개는 프로젝트·전용 4개와
위 신규 8개다. 폐기된 옛 이름은 이 37개 집계에 포함하지 않는다.
`loop-me`, `writing-beats`, `writing-fragments`, `writing-shape`는 원본의
in-progress 항목이지만 기존 사용 목록을 유지했으므로 설치되어 있다.

## Raindrop MCP·UA·Vercel 업데이트 — 2026-10-05

| 출처 | 적용한 원본 커밋 | 글로벌 스킬 |
| :--- | :--- | :--- |
| `adeze/raindrop-mcp` | `5b1e7f96cf82c96050df6347835a3c7b3a6ac162` | `dxt-packaging`, `mcp-development`, `mcp-inspector`, `mcp-refactoring`, `mcp-testing` |
| `vercel-labs/skills` | `18f96ea131dab3b0fcc9b27cf7c6f6cbb6174680` | `find-skills` |
| `Egonex-AI/Understand-Anything` | `1d7418b8abfa543744ae029e63a482aee03f9022` | `understand`, `understand-chat`, `understand-dashboard`, `understand-diff`, `understand-domain`, `understand-explain`, `understand-figma`, `understand-knowledge`, `understand-onboard` |

Raindrop MCP는 이 저장소의 스킬 업데이트를 의미한다. MCP 서버 실행 파일,
서버 설정·전송 방식·인증은 변경하지 않았다. 해당 저장소의 추가 스킬
`publishing`, `raindrop-mcp-publishing`은 기존 선택 밖이라 설치하지 않았다.
Vercel은 현재 선택된 `find-skills`만 유지했다.

UA는 `~/.understand-anything/repo`에 미커밋 변경이 없는 것을 확인하고,
저장소를 `fe8c5bc591716aafd79b4765549328f08ef5a52e`에서 위 커밋으로
fast-forward했다. 플러그인 버전은 `2.9.4 → 2.9.7`이다. 스킬과 보조 스크립트,
플러그인 내부 참조를 같은 버전으로 유지하기 위해 원본 저장소 전체를 갱신했다.
기존 공유 스킬 9개의 외부 링크는 유지했고, 설치 기록에 출처·경로·폴더 해시를
추가했다. 다른 Mac에서는 원본 저장소를 위 커밋으로 준비한 뒤 링크해야 한다.
계정별 글로벌 훅 등록은 변경하지 않았다.

Claude에는 `find-skills`와 UA 9개의 누락 링크를 추가했다. 이 단계에서 공유 경로는
당시 56개, Claude 연결은 54개였다. 아래 글로벌·로컬 분리 적용 뒤에는 모두 55개다.

검증: 15개 스킬 / 73개 파일의 원본 일치, YAML·JSON·폴더 해시,
세 에이전트 경로에 15개 존재 및 깨진 심링크 부재를 확인했다.
UA 보조 JavaScript·Python 스크립트는 문법 검사를 통과했다.
임시 원본에서 증분 스킬 계약·심볼 테스트를 시도했지만 `vitest` 의존성이 없어
실행되지 않았다(`ERR_MODULE_NOT_FOUND`). 테스트 통과 또는 dashboard 실행 검증으로
표시하지 않는다. UA의 개발 의존성 설치·빌드·실제 분석 실행은 이번 범위에 포함하지 않았다.

## 배포와 검증

| 에이전트 | 실제 적용 상태 |
| :--- | :--- |
| Codex | `~/.agents/skills`가 공유 폴더를 참조. 사용자 스킬 55개가 파일 기준 존재 |
| Claude Code | 외부 제작 54개와 직접 제작 Zotero 1개, 총 55개 개별 링크 |
| Antigravity | `~/.gemini/config/skills`가 공유 폴더 전체 참조. 파일 기준 55개 |
| Hermes `edith` | 아직 생성·연결하지 않음 |

Matt 원본의 `agents/openai.yaml`도 함께 갱신했다. 명시적 호출 전용 스킬은
자동 호출 목록에 보이지 않을 수 있으므로, 파일 설치 수와 자동 노출 수를 구분한다.
스킬이 새 턴에 노출되는지 확인하고, 반영되지 않으면 에이전트를 재시작한다.

검증 결과(2026-10-05): 원본 25개·73개 파일의 바이트 일치, Matt frontmatter와
Codex 메타데이터 YAML 파싱, 설치 기록 JSON 및 폴더 해시, 실제 문서 링크,
Claude·공유 경로의 깨진 링크 검사, 제외 항목 부재 확인을 통과했다.
`git diff --check`도 통과했다. 코드 블록·템플릿의 예시 경로는 실제 파일 링크로
판정하지 않았다.
각 스킬의 작업 흐름 실행과 Hermes 로딩 검증은 이번 설치 검증에 포함하지 않는다.

Google·kepano 검증 결과: 14개·19개 파일의 원본 바이트 일치, frontmatter YAML,
설치 기록 JSON 및 폴더 해시를 확인했다. 세 에이전트 경로에 14개가 모두 존재하고
깨진 심링크가 없다. 실제 보조 파일 링크를 확인했고, 위 미설치 helper 링크는
선택적 참조로 별도 기록했다. UA·Vercel 업데이트 당시에는 Claude에
`raindrop-devonthink`, `raindrop-zotero` 2개가 없었다. 이후 Zotero는 연결했고
DEVONthink는 글로벌 대상에서 제외했다.

### 글로벌·로컬 분리 — 2026-10-05

`sejong-wiki`의 스킬 8개 전체를 검토한 뒤 사용자가 Zotero 글로벌·DEVONthink 로컬
구분을 승인했다. [분류·전환 기록](../plans/2026-10-05-global-skills-preview.md)이
8개의 판단 근거와 실제 변경·검증·복구 기록을 소유한다.

직접 제작 글로벌 원본은 [raindrop-zotero](../../macos/agents/.agents/skills/raindrop-zotero/SKILL.md)와
같은 폴더의 `references/result-schema.md`다. 파일 2개를 바이트 변경 없이 이동했다.
출처는 기존 `sejong-wiki/skills/raindrop-zotero`이며 저자·버전은 본문 frontmatter를 따른다.
이 직접 제작 원본은 Git으로 관리하며 외부 설치 도구의 `.skill-lock.json`에 넣지 않는다.
해당 설치 기록의 54개와 직접 제작 1개가 공통 55개를 구성한다.

볼트의 기존 Zotero 경로는 제거했다. DEVONthink는 볼트의
물리 원본과 기존 `.agents/skills → ../skills`로 사용하며 새로운 로컬 링크를 추가하지
않았다. DEVONthink 본문은 글로벌 Zotero의 실제 경로와 미설치 시 보류 안내를
명시한다. 볼트의 `global-setup.sh`는 제거했고 `local-setup.sh`는 글로벌 설치를
실행하지 않으며 dotfiles 관리 문서를 안내한다.
UA 9개의 외부 체크아웃·커밋과 외부 54개 본문은 그대로 유지했다.

파일 기준 배포 검증과 앱 내부 실제 발견·워크플로 실행은 구분한다. 후자는 이번
분리에서 검증하지 않았다. `scripts/sync-agents`는 여전히 MCP만 관리한다.

커밋 전 스테이징 검사에서는 Google 서비스 스킬 8개의 원본에 파일 끝 빈 줄
경고가 확인됐다. 원본 바이트 일치를 유지했고, `blank-at-eof`만 제외한
`git -c core.whitespace=-blank-at-eof diff --cached --check`로 나머지 공백 오류를 검사했다.

## 갱신·선택 설치·복구

다음 갱신은 이 문서의 선택 목록을 먼저 확인하고, 원본 커밋을 고정하여 임시 폴더에
받는다. 기존 파일·설치 기록·에이전트 링크를 백업한 뒤 선택한 스킬만 반영한다.
이름 변경과 의존성을 확인하고 설치 기록 및 이 문서의 커밋·결과를 갱신한다.
설치 도구의 전체 선택으로 제외 항목을 다시 추가하지 않는다.
이 문서는 선택 기준이지 설치 도구가 자동으로 읽는 차단 설정은 아니다.

프로젝트에 선택 설치하는 예:

```sh
# 해당 프로젝트 루트에서 실행한다. --global은 사용하지 않는다.
npx skills add mattpocock/skills --skill setup-pre-commit
```

설치 화면에서 프로젝트 범위·에이전트를 확인한다. Claude 전용 스킬은 Claude만
선택한다. 최신 원본에서 폐기된 옛 이름은 이 명령으로 설치하려고 하지 않는다.

Matt 정리의 복구 자료는 로컬 임시 디렉터리에 보관했다:

- `/private/tmp/matt-skills-update.eZthZY/before-update.tar.gz`: 적용 전 공유 스킬,
  설치 기록, README, 동기화 계획. 미커밋 변경도 포함한다.
- `/private/tmp/matt-skills-update.eZthZY/claude-skill-links.tar.gz`: 적용 전 Claude 링크.
- `/private/tmp/matt-skills-update.eZthZY/retired-skills/`: 제외·구버전 폴더 18개.

Google·kepano 업데이트의 복구 자료:

- `/private/tmp/workspace-kepano-update.jwpt4J/before-update.tar.gz`: 적용 전
  공유 스킬·설치 기록·관리 문서·동기화 계획. 기존 미커밋 변경도 포함한다.
- `/private/tmp/workspace-kepano-update.jwpt4J/claude-links.tar.gz`: 적용 전 Claude 링크.

Raindrop MCP·UA·Vercel 업데이트의 복구 자료:

- `/private/tmp/remaining-skills-update.PRo6Vq/before-update.tar.gz`: 적용 전 공유 스킬,
  설치 기록, 관리 문서, 동기화 계획. UA 링크는 포함하지만 외부 원본 내용은 포함하지 않는다.
- `/private/tmp/remaining-skills-update.PRo6Vq/claude-links.tar.gz`: 적용 전 Claude 링크.
- `/private/tmp/remaining-skills-update.PRo6Vq/ua-before.bundle`: 업데이트 전 UA HEAD와
  그 이력. 복구 시 별도 clone에서 이전 커밋을 확인하고 복원 범위를 결정한다.

원본 파일을 영구 삭제하지 않았다. 임시 자료는 OS 정리로 사라질 수 있으므로
장기 복구가 필요하면 별도 보관한다. 복구 시 별도 폴더에 압축을 풀어 비교하고
필요한 파일·링크만 복원한다. 현재 작업 위에 전체 압축을 바로 덮어쓰지 않는다.

원본: [Matt Pocock 스킬](https://github.com/mattpocock/skills),
[적용 커밋의 변경 이력](https://github.com/mattpocock/skills/blob/24fe0ef7737efae15c87225755e9f6f5965e4888/CHANGELOG.md).
Google·kepano 원본:
[Google Workspace 적용 커밋](https://github.com/googleworkspace/cli/tree/a3768d0e82ad83cca2da97724e46bea4ff0e6dbd/skills),
[kepano 적용 커밋](https://github.com/kepano/obsidian-skills/tree/3ccff5338ea700537839b21900aa5358a0402c98/skills).
추가 적용 원본:
[Raindrop MCP 스킬](https://github.com/adeze/raindrop-mcp/tree/5b1e7f96cf82c96050df6347835a3c7b3a6ac162/.github/skills),
[Vercel 스킬](https://github.com/vercel-labs/skills/tree/18f96ea131dab3b0fcc9b27cf7c6f6cbb6174680/skills),
[UA 적용 커밋](https://github.com/Egonex-AI/Understand-Anything/tree/1d7418b8abfa543744ae029e63a482aee03f9022).
