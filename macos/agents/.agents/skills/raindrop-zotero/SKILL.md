---
name: raindrop-zotero
description: Use when importing paper-related Raindrop bookmarks into a local Zotero library while preserving a bounded graph of paper, project, code, model, video, and dataset links; require approval for ambiguous paper matches and verify local PDF attachments.
version: 0.2.0
author: Sejong
license: MIT
metadata:
  hermes:
    tags: [raindrop, zotero, papers, bibliography, mcp]
    related_skills: []
---

# Raindrop → Zotero 논문 반입

## 개요

이 스킬은 현재 작업 디렉터리와 무관하게 Raindrop의 논문 관련 북마크를 로컬 Zotero 라이브러리로 반입한다. Raindrop 북마크의 논문 정체성을 해소하고, 중복 없는 Zotero 항목·출처 URL 링크·검증된 공개 PDF 첨부를 만든다.

소스는 어떤 저장소에 있어도 되지만 런타임 중에는 현재 Git 저장소, vault, 프로젝트 `.env`, `notes/`, `wiki/`를 읽거나 쓰지 않는다. 필요한 것은 Raindrop과 Zotero-local MCP의 기능뿐이다.

## 사용 시점

- Raindrop에 논문 리뷰 블로그, arXiv 초록/PDF, 논문 코드·프로젝트 페이지를 모아 두었을 때
- 논문을 Zotero에 넣기 전 중복 확인과 관련 링크 보존이 필요할 때
- ZotMoov로 수동 정리하기 전 Zotero 로컬 imported PDF attachment를 검증해야 할 때

다음에는 사용하지 않는다.

- 외부 콘텐츠를 Obsidian·지식 베이스로 캡처하거나 위키로 승격할 때
- 유료·접근 제한 PDF를 우회해서 내려받으려 할 때
- 논문 후보가 모호한데 사용자 승인을 받을 수 없을 때

## 사전 점검

1. Raindrop MCP에서 북마크 조회·상세 조회·갱신 기능을 확인한다.
2. Zotero-local MCP에서 DOI/arXiv 조회, 자유 검색, 중복 검사, 항목 생성, `attach_link`, `attach_file`, 첨부 목록·경로 조회 기능을 확인한다.
3. `dry-run`으로 대상 북마크와 예상 변경을 먼저 제시한다.

**완료 기준:** 필요한 MCP가 연결되어 있고, 완료 대상이 해소되었다. 기본 완료 태그·컬렉션은 기존 `zotero-imported`를 찾고, 없으면 최초의 사용자 승인 완료 처리 때 같은 이름으로 만든다. 링크·PDF 검증에 성공한 항목을 태그만 남기고 원 컬렉션에 유지해서는 안 된다. 연결 또는 능력이 없으면 외부 상태를 변경하지 않고 부족한 기능을 보고한다.

입력은 호출자가 지정한 북마크이며 특정 대기 컬렉션을 전제하지 않는다. 실계정 E2E를 위해 별도 북마크가 필요하면 사용자 승인 뒤 Zotero 전용 `zotero-e2e` 컬렉션을 사용한다.

## 반입 절차

### 1. 북마크 유형과 식별자 파악

- **arXiv 초록/PDF:** URL에서 arXiv ID를 추출하고, arXiv 조회 결과의 DOI가 있으면 함께 보존한다.
- **DOI URL:** DOI를 정규화해 메타데이터를 조회한다.
- **리뷰 블로그·코드·프로젝트 페이지:** 본문과 메타데이터에서 DOI, arXiv ID, 논문 제목, 저자, 연도를 수집한 뒤 후보 검색에 사용한다.

정체성 해소 우선순위는 `DOI → arXiv ID → 제목·저자·연도`다. DOI와 arXiv ID가 함께 있으면 preprint와 출판판이 동일 연구인지 확인한다.

**완료 기준:** 확정 후보에는 제목, 저자, 연도와 DOI 또는 arXiv ID 중 하나 이상의 근거가 있다. 그렇지 않으면 `needs-approval`로 분류한다.

### 2. 중복 검사와 승인 게이트

Zotero에서 다음 순서로 기존 항목을 찾는다.

1. DOI 정확 일치
2. arXiv ID 정확 일치
3. 정규화 제목 + 연도 + 제1저자

단일 고신뢰 후보 또는 기존 항목이 있으면 다음 단계로 진행한다. 후보가 복수이거나 낮은 신뢰도·preprint/출판판 충돌이 있으면, 후보별 제목·저자·연도·DOI/arXiv ID·근거 URL을 표로 보여 주고 사용자의 명시적 선택을 기다린다.

이미 `zotero-imported` 완료 상태인 Raindrop 북마크는 기존 Zotero 부모·출처 URL·필수 첨부를 읽기 전용으로 재검증한다. 모두 있으면 `completed`를 반환하되 새 항목·링크·PDF·Raindrop 변경을 만들지 않는다.

**금지:** `needs-approval` 상태에서 Zotero 항목 생성, PDF 첨부, Raindrop 이동·태깅을 하지 않는다.

### 3. 핵심 관련 링크 해소

논문 하나를 Zotero 부모 항목으로 삼고, 시작 북마크와 그 페이지에서 확인되는 **논문 관련 핵심 링크만** 수집한다. 이 단계는 웹 전체 크롤링이 아니다.

| 역할 | 판정 기준 예시 | 반입 방식 |
|---|---|---|
| `paper` | DOI, arXiv, 출판사·공식 논문 랜딩 페이지 | 정체성 해소의 근거 및 provenance link |
| `project` | 저자·기관의 공식 프로젝트 페이지 | provenance link |
| `code` | GitHub·GitLab 등 구현 저장소 | provenance link |
| `model` | Hugging Face 모델·Space 등 배포 페이지 | provenance link |
| `video` | YouTube·공식 발표 영상 | provenance link |
| `dataset` | 공식 데이터셋 페이지·저장소 | provenance link |
| `auxiliary` | 블로그·뉴스·기타 보조 설명 | 시작 북마크이거나 논문 식별 근거일 때만 provenance link |

- 프로젝트 페이지로 시작했으면 위 역할로 식별되는 링크만 추출한다. 논문 URL이 있으면 그 링크에서 DOI·arXiv ID·메타데이터를 다시 확인한다.
- `paper`가 없거나 둘 이상의 논문으로 연결되면 링크 묶음과 각 후보의 근거를 보여 주고 사용자 선택을 받는다. 이 상태에서는 외부 변경을 하지 않는다.
- URL은 추적 파라미터·말단 슬래시 등 안전한 정규화 뒤 역할과 무관하게 한 번만 기록한다. 하나의 URL이 여러 역할 후보에 걸치면 더 구체적인 역할 하나를 보고한다.
- 페이지 안의 임의 외부 링크, 광고, 일반 참고문헌, 관련 논문 전체 목록은 추적하지 않는다. 보조 링크의 자동 재귀 탐색·반입은 금지한다.

**완료 기준:** `paper`와 시작 북마크를 포함해 확인된 핵심 링크별 역할·발견 근거·정규화 URL을 dry-run 결과에 나열한다.

### 4. Zotero 항목과 출처 링크 기록

- 확정된 논문은 기존 Zotero 항목을 사용하거나 새 항목을 생성한다.
- **기존 항목의 출처 링크만 반입하는 경우:** DOI·arXiv·제목으로 단일 기존 부모를 확정했고 해당 URL만 없으면, 그 `link` attachment만 추가한다. 부모 메타데이터·기존 PDF는 바꾸지 않고, PDF를 다시 다운로드·첨부하지 않는다. ZotMoov 후처리로 기존 PDF가 `linked_file`로 보일 수 있으므로 이 분기에서는 PDF link mode를 변경·복구하지 않고 관측값만 보고한다.
- DOI 조회 결과의 item type별 필드 스키마를 먼저 검증한다. 예를 들어 `bookSection`은 `publicationTitle`을 받을 수 없으므로 값이 있으면 `bookTitle`로 정규화하고, 거부된 필드만 제거·재시도한다.
- 필드 검증 재시도 전과 후 모두 DOI·arXiv ID·제목으로 중복을 다시 확인해 부모 중복 생성을 막는다.
- canonical 논문 URL, 원 Raindrop URL, 그리고 §3에서 확정한 project·code·model·video·dataset 링크를 Zotero의 자식 `link` attachment로 붙인다. attachment 제목에는 역할을 사람이 읽을 수 있게 표기한다(예: `Code — GitHub`, `Dataset — 공식 페이지`).
- 동일 URL의 링크 첨부가 이미 있으면 새로 만들지 않는다.

**완료 기준:** Zotero item key와 새로 만들었거나 이미 존재한 모든 link attachment의 key를 수집한다.

### 5. 공개 PDF 첨부와 로컬 검증

- arXiv, OpenReview, 저자 공식 페이지 등 공개 접근이 확인된 PDF만 다운로드한다.
- PDF를 Zotero `imported attachment`로 붙인다. linked file은 사용하지 않는다.
- 첨부 뒤 `list_attachments`에서 attachment key, `linkMode=imported_file`, MIME 유형과 저장 경로를 확인하고, 해당 실제 파일의 존재·크기를 검증한다.
- `get_pdf_path`가 attachment child key를 지원하면 추가로 조회한다. 이 MCP가 child key를 거부하는 경우에는 `list_attachments`가 반환한 Zotero storage 경로와 직접 파일 검증을 완료 근거로 기록하며, 그 API 제한을 결과에 명시한다.

공개 PDF가 없으면 `completed-without-pdf`로 기록한다. 유료 출판사·권한 제한 PDF의 우회 취득은 금지한다.

**완료 기준:** PDF가 있는 경우 로컬 경로가 실제 파일을 가리킨다. 없는 경우 그 사유가 결과에 기록된다.

### 6. Raindrop 완료 반영

`completed` 또는 `completed-without-pdf`의 모든 필수 Zotero 기록이 검증된 뒤에만, 해당 Raindrop 북마크에 완료 태그를 붙이고 `zotero-imported` 완료 컬렉션으로 이동한다. 이미 완료 태그가 있으나 원 컬렉션에 남아 있으면, 필수 Zotero 검증을 재확인한 뒤 완료 컬렉션 이동을 복구한다.

**완료 기준:** 사용자 보고에는 Raindrop ID, Zotero item key, link attachment key, PDF attachment key·경로 또는 PDF 부재 사유, 최종 상태가 포함된다. 실패·보류 항목은 원 컬렉션에 남긴다.

## 결과 상태

세부 필드는 [결과 스키마](references/result-schema.md)를 따른다.

| 상태 | 의미 | Raindrop 변경 |
| :--- | :--- | :--- |
| `dry-run` | 예상 후보·변경만 제시 | 없음 |
| `needs-approval` | 후보가 모호하거나 충돌 | 없음 |
| `completed` | Zotero 항목·링크·공개 PDF 첨부 검증 완료 | 완료 처리 |
| `completed-without-pdf` | Zotero 항목·링크 검증 완료, 공개 PDF 없음 | 완료 처리 |
| `failed` | 필수 단계 실패 | 없음 |

## 주의사항

1. Raindrop 이동·태깅은 되돌릴 수 있지만 외부 상태 변경이다. 항상 완료 게이트 후에만 수행한다.
2. Raindrop과 Zotero의 인증 정보·API 키를 채팅, 결과물, Git 파일에 기록하지 않는다.
3. ZotMoov 실행·파일 이동은 이 스킬의 책임이 아니다.
4. 이 스킬의 소스 위치가 `sejong-wiki`여도 실행 중 해당 저장소에 파일을 쓰거나 읽어서는 안 된다.

## 검증 체크리스트

- [ ] Raindrop과 Zotero-local MCP 사전 점검을 마쳤다.
- [ ] 대상 북마크를 `dry-run`으로 먼저 분류했다.
- [ ] DOI/arXiv/제목 기반 중복 검사를 모두 수행했다.
- [ ] 모호 후보는 사용자 승인 없이 변경하지 않았다.
- [ ] 관련 링크는 paper·project·code·model·video·dataset 및 필요한 auxiliary로만 한정했고, 역할·URL 중복을 제거했다.
- [ ] 모든 provenance URL을 중복 없이 `link` attachment로 기록했다.
- [ ] 공개 PDF는 imported attachment와 실제 로컬 경로까지 확인했다.
- [ ] 완료 게이트를 통과한 항목만 Raindrop 상태를 갱신했다.
- [ ] 결과에 모든 외부 변경 ID와 실패·보류 사유를 남겼다.
