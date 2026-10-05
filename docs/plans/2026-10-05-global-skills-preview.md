# 글로벌 스킬 분류와 전환 기록

- 날짜: 2026-10-05
- 상태: 전체 8개 검토·사용자 범위 승인·Zotero 글로벌 전환과 DEVONthink 로컬 분리 적용.
- 기준: [전역 관리 방안](../agents/global-management.md), [공유 선택 기준](../agents/shared-skills.md).
- 스킬 배포 자동화·Hermes 생성은 이번 적용 범위에 포함하지 않는다.

## 전체 검토 결과

| 스킬 | 결정 | 판단 근거 |
| :--- | :--- | :--- |
| `raindrop-zotero` | 글로벌 | Raindrop·Zotero MCP로 반입·중복 검사·PDF 검증 수행. 볼트 파일 읽기·쓰기 없음 |
| `raindrop-devonthink` | 로컬 | `Sejong-2ndBrain/Inbox` 대상 검증과 볼트 Capture 후속 흐름에 결합. 사용자 결정으로 로컬 유지 |
| `capture` | 로컬 | 볼트 `notes/external/`에 적재, `to-ingest` 트리아지·frontmatter·수명주기 규칙 사용 |
| `ingest` | 로컬 | `wiki/` 승격·소스 해시·보존/삭제와 authored 보호 계약 사용 |
| `graph` | 로컬 | 볼트 Markdown·스펙·운영 코드에서 `.graph/` Kuzu DB와 manifest 구축 |
| `lint` | 로컬 | 볼트 폴더·문서 스펙·정책·변경 전파·지식 구조 검사 |
| `workspace` | 로컬 | 볼트 프로젝트·세션 장부·기록·계획 롤업을 관리 |
| `sync` | 로컬 | 볼트 `wiki/`와 frontmatter를 OKF 번들로 빌드 |

본문뿐 아니라 CLI와 구현의 경로·규칙 의존성도 확인했다. 범용적으로 보이는 URL
추출·그래프·프로젝트 기능도 현재 스킬 전체는 볼트에 결합되어 있다. 일반 도구로
분리하려면 별도 인터페이스 설계가 필요하므로 이번에 그대로 글로벌 설치하지 않는다.

기존 `.agents/skills → ../skills`는 로컬 발견 경로다. 이 연결을 유지하며 새 로컬
Claude 링크는 추가하지 않았다. 기존 `.claude/skills`의 Obsidian 외부 스킬 링크 5개는
깨진 상태였으며 이번 분리의 변경 대상에 포함하지 않았다.

## 승인과 적용 범위

최초 미리보기의 직접 제작 2개 글로벌 전환 제안은 사용자 결정으로 수정했다.
Zotero만 글로벌로 전환하고 DEVONthink는 원래 로컬 배치를 유지한다. 전체 스킬을
검토한 결과 추가 글로벌 후보가 없어 이미 선택한 Zotero 하나를 적용했다.

| 경로 | 적용 결과 |
| :--- | :--- |
| `dotfiles/macos/agents/.agents/skills/raindrop-zotero/` | 기존 볼트 방향 링크를 전체 물리 원본으로 전환. 본문·결과 스키마 2개 파일 바이트 보존 |
| `dotfiles/macos/agents/.agents/skills/raindrop-devonthink` | 글로벌 공유 링크 제거. 볼트 원본은 그대로 유지 |
| `~/.claude/skills/raindrop-zotero` | `../../.agents/skills/raindrop-zotero` 개별 링크 추가 |
| `sejong-wiki/skills/raindrop-zotero` | 원본 이동 후 호환 링크도 제거. 글로벌 스킬만 사용 |
| `sejong-wiki/skills/raindrop-devonthink/` | 로컬 유지. 본문의 글로벌 Zotero 라우팅 경로·미설치 시 보류 안내 보강, 구현·테스트 보존 |
| `sejong-wiki/.agents/skills` | 기존 `../skills` 링크 유지 |
| `sejong-wiki/global-setup.sh` | 백업 후 제거. 기존 `--all` 설치 방식을 dotfiles로 이동하지 않음 |
| `sejong-wiki/local-setup.sh` | 제거한 글로벌 스크립트의 질문·실행을 dotfiles 관리 문서 안내로 대체 |
| 볼트 README·스킬 README·ADR-0002 | 글로벌 원본·설치 책임은 dotfiles, 볼트는 로컬만 관리함을 명시 |
| 관리 문서·핸드오프 | 현재 55개·출처·전체 분류·남은 작업 반영 |

Zotero 원본은 dotfiles에서 편집한다. 볼트 내부 원본·호환 링크는 두지 않는다.
외부 스킬 54개·UA 체크아웃·MCP 설정·인증·계정·활성 프로필은 변경하지 않았다.
외부 설치 도구의 `.skill-lock.json`은 기존 미커밋 상태 그대로 유지했으며, 직접 제작
Zotero는 Git으로 관리한다. 스킬 배포 도구 구현·외부 전체 갱신·프로젝트 중복 링크
정리는 이번 적용 범위에 포함하지 않았다. 이후 별도 커밋 요청으로 볼트 변경은
`30da3e0`, 로컬 workspace 스킬의 세션 로그·hot 요약은 `d845840`으로 커밋했다.
dotfiles 변경도 후속 요청에 따라 선별 커밋하며 push는 수행하지 않는다.

최초 적용에서는 `global-setup.sh`의 Raindrop 등록만 제거했다. 후속 사용자 요청으로
스크립트 전체를 제거했다. 외부 Matt·kepano `--all` 설치·갱신은 승인된 공유 선택·제외
목록을 자동 집행하지 못하므로 dotfiles로 그대로 이동하지 않았다. 선택 설치 도구의
구현은 별도 후속 범위이며 현재 사용법은 공유 스킬 관리 문서를 따른다.

## 검증과 복구

- 공통 글로벌 목록: 직접 제작 Zotero 1개 + 외부 54개 = 55개.
- Codex·Claude·Antigravity 파일 연결: 같은 55개, 깨진 글로벌 링크 없음.
- Zotero 본문·결과 스키마: 전환 전 SHA-256과 동일, 상대 참조 유효.
- DEVONthink 구현·테스트 10개 파일: 전환 전 해시와 동일. 본문은 라우팅 안내만 보강.
- 볼트 `.agents/skills → ../skills` 유지, 로컬 Zotero·글로벌 설치 스크립트는 부재.
- 남긴 `local-setup.sh`: `bash -n` 통과, 글로벌 스크립트 호출 없음.
  실제 로컬 환경 설치와 외부 서비스 쓰기는 수행하지 않았다.
- 문서 링크·구문·공백 검사 통과. 실제 앱 내부 스킬 발견·워크플로 실행은 미검증.

이전 조사에서 DEVONthink 임시 복사본의 테스트 56개·CLI 도움말이 통과했지만,
이 결과를 DEVONthink 글로벌화 또는 실제 서비스 검증의 근거로 사용하지 않는다.

로컬 백업은 `/private/tmp/global-skills-split-20261005/`다.

- `before.json`: 원래 글로벌 링크 대상과 두 스킬 파일 해시.
- `zotero-original/`: 전환한 볼트의 원래 Zotero 폴더. `zotero-before/`도 별도 복사 보존.
- `global-setup.sh.before`, `skills-README.md.before`: 변경 전 설치 스크립트·볼트 안내.
- `global-setup.sh.retired`: 제거 직전 스크립트, `local-setup.sh.before`: 호출부 수정 전 스크립트.

복구 시 현재 변경을 먼저 비교하고, Claude 신규 Zotero 링크·볼트 경로와
원본을 이 작업의 적용 값일 때만 되돌린다. DEVONthink 글로벌 복구는 사용자가
로컬 유지 결정을 변경한 경우에만 수행한다. 임시 백업은 OS 정리로 사라질 수 있다.

## 완료 기준

- [x] 8개 전체 본문·구현 의존성 검토와 글로벌·로컬 분류.
- [x] 사용자 선택: Zotero 글로벌·DEVONthink 로컬, 기존 프로젝트 연결 유지.
- [x] 원본·링크·설치 스크립트 백업 후 Zotero 2개 파일 전환.
- [x] Claude 글로벌 연결·볼트 호환 링크 제거·글로벌 설치 책임 분리.
- [x] 55개 글로벌 경로·보조 참조·로컬 원본 보존 검증.
- [x] 관리 문서·핸드오프에 실제 결과와 검증 한계 반영.

스킬 배포 자동화·UA 준비 자동화·Hermes·각 앱의 실제 발견·깨진 기존 프로젝트
링크 정리는 후속 작업이다. MCP 배포 도구 완료와 구분해서 기록한다.
