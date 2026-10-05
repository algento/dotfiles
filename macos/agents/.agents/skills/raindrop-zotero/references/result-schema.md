# Raindrop → Zotero 결과 스키마

스킬은 각 북마크별로 아래 필드를 채워 채팅에 구조적으로 보고한다. 비밀 값·인증 헤더·로컬 환경 변수는 포함하지 않는다.

```yaml
raindrop_id: 123456789
source_url: https://example.org/article
kind: arxiv | doi | review | code | project | model | video | dataset
status: dry-run | needs-approval | completed | completed-without-pdf | failed
resolution:
  title: "논문 제목"
  authors: ["First Author", "Second Author"]
  year: 2026
  doi: "10.xxxx/example" # 없으면 null
  arxiv_id: "2501.01234" # 없으면 null
  confidence: high | medium | low
  evidence_urls: ["https://..."]
related_links:
  - role: paper | project | code | model | video | dataset | auxiliary
    url: "https://..."
    discovered_from: "https://..." # 시작 북마크 또는 핵심 페이지
    reason: "공식 프로젝트 페이지에서 GitHub 저장소로 확인"
    attachment_key: EFGH5678 # dry-run/needs-approval에서는 null
zotero:
  item_key: ABCD1234 # 변경하지 않은 dry-run/needs-approval에서는 null
  existing_item: false
  link_attachment_keys: ["EFGH5678"]
  pdf_attachment_key: "IJKL9012" # 공개 PDF가 없으면 null
  pdf_path: "/absolute/path/to/file.pdf" # 공개 PDF가 없으면 null
pdf:
  status: attached | unavailable | failed | not-attempted
  source_url: https://... # 없으면 null
  reason: "공개 PDF 없음" # 없으면 null
raindrop_update:
  applied: true
  target_collection: "zotero-imported"
  added_tag: "zotero-imported"
errors: []
```

## 상태 규칙

- `dry-run`: 후보와 예상 변경을 표시하되 Zotero·Raindrop 모두 불변이다.
- `needs-approval`: 모호한 후보 또는 충돌을 표시하되 Zotero·Raindrop 모두 불변이다.
- `completed`: Zotero 항목, 모든 provenance link, 공개 PDF imported attachment와 실제 경로가 검증된 상태다.
- `completed-without-pdf`: Zotero 항목과 provenance link는 검증됐으나 합법적으로 공개된 PDF를 찾지 못한 상태다.
- `failed`: 필수 단계가 실패했으며 Raindrop 완료 처리를 하지 않은 상태다.

## 관련 링크 규칙

- `related_links`는 시작 북마크와 그 페이지에서 확인된 `paper`, `project`, `code`, `model`, `video`, `dataset` 및 필요한 `auxiliary`만 담는다.
- 같은 정규화 URL은 역할과 무관하게 한 번만 기록한다. 역할이 겹치면 더 구체적인 역할을 택한다.
- `dry-run`·`needs-approval`에서는 `attachment_key`가 항상 `null`이다.
- 페이지의 모든 외부 링크를 재귀 수집하지 않는다.
