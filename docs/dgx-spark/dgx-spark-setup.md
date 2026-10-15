# DGX Spark 초기 설정 기록

> 작성일: 2026-06-27  
> 사용자: spark01 (<tromberx@gmail.com>)

---

## 하드웨어 / 시스템 환경

| 항목 | 내용 |
|------|------|
| 머신 | NVIDIA DGX Spark |
| GPU | NVIDIA GB10 (Grace Blackwell Superchip) |
| 아키텍처 | ARM64 |
| OS | Ubuntu Linux |
| 커널 | 6.17.0-1032-nvidia |
| 셸 | bash |

---

## 1. 시스템 초기 세팅

### 패키지 업데이트

```bash
sudo apt update
sudo apt upgrade
```

### 로케일 설정

- 시스템 언어: `en_US.UTF-8` (영어)
- 일부 locale(숫자, 시간, 통화 등)은 `ko_KR.UTF-8` 유지
- `~/.pam_environment`에 locale 설정 저장됨
- 사용자 디렉토리명 영어로 강제 갱신:

```bash
LANG=C xdg-user-dirs-update --force
```

### 빌드 필수 패키지 설치

```bash
sudo apt-get install build-essential procps curl file git
```

---

## 2. 패키지 매니저: Homebrew (Linuxbrew)

경로: `/home/linuxbrew/.linuxbrew/`

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

`.bashrc`에 아래 설정 자동 추가됨:

```bash
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"
```

### Homebrew로 설치한 패키지

| 패키지 | 설명 |
|--------|------|
| `bob` | Neovim 버전 매니저 |
| `yazi` | 터미널 파일 매니저 |
| `lazygit` | 터미널 Git TUI |
| `lazydocker` | 터미널 Docker TUI |
| `tmux` | 터미널 멀티플렉서 |
| `tmuxinator` | tmux 세션 관리자 |

---

## 3. Neovim 설치 (bob 사용)

```bash
brew install bob
bob install 0.12.0
bob use 0.12.0
```

- 버전: **NVIM v0.12.0** (LuaJIT 2.1.1774638290)
- 실행 경로: `~/.local/share/bob/nvim-bin/nvim`
- `~/.bashrc`에 PATH 추가:

```bash
export PATH="$PATH:$HOME/.local/share/bob/nvim-bin"
```

- 별도 config 파일 없음 (기본 설정 사용 중)

---

## 4. 터미널: Ghostty

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"
```

- 설정 파일: `~/.config/ghostty/config.ghostty` (현재 비어 있음)

---

## 5. Python 환경

| 항목 | 내용 |
|------|------|
| Python | 3.12.3 (`/usr/bin/python3`) |
| pip | `/usr/bin/pip3` |
| 가상환경 | 별도 설정 없음 (시스템 Python 사용 중) |

---

## 6. Docker

```bash
Docker version 29.2.1, build a5c7197
```

- 경로: `/usr/bin/docker`

---

## 7. VSCode Remote 환경

VSCode의 Remote-SSH로 DGX Spark에 접속하여 사용 중.

### 설치된 확장 프로그램

**AI 코딩 어시스턴트**

- `anthropic.claude-code` — Claude Code
- `openai.chatgpt` — ChatGPT / OpenAI Codex

**Python 개발**

- `ms-python.python` — Python 기본 익스텐션
- `ms-python.vscode-pylance` — Pylance 언어 서버
- `ms-python.debugpy` — Python 디버거
- `ms-python.vscode-python-envs` — Python 환경 관리
- `charliermarsh.ruff` — Ruff 린터/포매터
- `njpwerner.autodocstring` — 자동 docstring 생성
- `njqdev.vscode-python-typehint` — 타입 힌트 자동완성

**C/C++ 개발**

- `ms-vscode.cpptools` — C/C++ 기본 익스텐션
- `ms-vscode.cpptools-extension-pack` — C/C++ 확장 팩
- `ms-vscode.cpp-devtools` — C++ 개발 도구
- `ms-vscode.cpptools-themes` — C/C++ 테마
- `ms-vscode.cmake-tools` — CMake 도구
- `cheshirekow.cmake-format` — CMake 포매터
- `vadimcn.vscode-lldb` — LLDB 디버거

**유틸리티**

- `esbenp.prettier-vscode` — Prettier 코드 포매터
- `editorconfig.editorconfig` — EditorConfig 지원
- `christian-kohler.path-intellisense` — 경로 자동완성
- `redhat.vscode-yaml` — YAML 지원
- `tamasfe.even-better-toml` — TOML 지원
- `davidanson.vscode-markdownlint` — Markdown 린터
- `yzhang.markdown-all-in-one` — Markdown 올인원
- `ryu1kn.partial-diff` — 선택 영역 diff 비교
- `ms-ceintl.vscode-language-pack-ko` — 한국어 언어팩

---

## 8. Isaac ROS 워크스페이스

```bash
~/workspaces/isaac_ros-dev/src/
```

`.bashrc`에 환경변수 설정:

```bash
export ISAAC_ROS_WS="${ISAAC_ROS_WS:-${HOME}/workspaces/isaac_ros-dev/}"
```

---

## 9. Claude Code 설정

- 계정: <tromberx@gmail.com>
- 플랜: Claude Pro
- 최초 시작: 2026-06-27

---

## 10. 환경변수 및 셸 초기화 요약 (`~/.bashrc`)

사용자 추가 설정 전체 (Ubuntu 기본 설정 제외):

```bash
# [1] ble.sh 로드 (대화형 셸에서만, 셸 시작 최상단)
[[ $- == *i* ]] && source ~/.local/share/blesh/ble.sh --noattach

# Homebrew
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv bash)"

# Neovim (bob)
export PATH="$PATH:$HOME/.local/share/bob/nvim-bin"

# Isaac ROS
export ISAAC_ROS_WS="${ISAAC_ROS_WS:-${HOME}/workspaces/isaac_ros-dev/}"

# zoxide (스마트 cd 대체)
eval "$(zoxide init bash)"

# [2] Starship 프롬프트 초기화
eval "$(starship init bash)"

# [3] ble.sh와 Starship 프롬프트 동기화 및 셸 부착(attach)
if [[ ${BLE_VERSION-} ]]; then
  ble-attach
fi
```

`~/.bash_profile` (로그인 셸용):

```bash
[ -f ~/.bashrc ] && . ~/.bashrc
```

---

## 11. 셸 환경 고급 설정

### Starship 프롬프트

크로스-셸 프롬프트 커스터마이저.

```bash
brew install starship   # 또는 curl 설치 스크립트 사용
```

`.bashrc`에서 ble.sh 부착 직전에 초기화:

```bash
eval "$(starship init bash)"
```

설정 파일: `~/.config/starship.toml` — 한 줄 프롬프트로 설정함:

```toml
add_newline = false

[line_break]
disabled = true
```

---

### zoxide (스마트 디렉토리 이동)

`cd` 대체 도구. 자주 방문한 디렉토리를 학습해 `z <키워드>`로 빠르게 이동.

```bash
brew install zoxide
```

`.bashrc` 초기화:

```bash
eval "$(zoxide init bash)"
```

주요 사용법:

```bash
z <키워드>    # 학습된 경로 중 가장 높은 점수의 디렉토리로 이동
zi <키워드>   # 인터랙티브 선택 (fzf 필요)
```

---

### ble.sh (Bash Line Editor)

bash 라인 에디터 고급 기능 제공 (구문 강조, 자동완성 UI, vi/emacs 모드 강화 등).

설치:

```bash
# 최신 안정 버전 수동 설치
git clone --filter=blob:none --recurse-submodules https://github.com/akinomyoga/ble.sh.git
make -C ble.sh install PREFIX=~/.local
```

`.bashrc` 설정 (순서가 중요):

```bash
# 최상단: --noattach 옵션으로 소스만 로드
[[ $- == *i* ]] && source ~/.local/share/blesh/ble.sh --noattach

# ... (다른 설정들) ...

# Starship 초기화 후 ble.sh 부착
eval "$(starship init bash)"

if [[ ${BLE_VERSION-} ]]; then
  ble-attach
fi
```

> Starship과 함께 쓸 때는 `--noattach`로 먼저 소스한 뒤, Starship 초기화 후 `ble-attach`를 호출해야 프롬프트가 올바르게 동작함.

---

## 12. Isaac Sim WebRTC 스트리밍 설정

### 환경 정보

| 항목 | 내용 |
|------|------|
| DGX Spark IP | `<DGX_IP>` (WiFi, wlP9s9) |
| Mac IP | `<MAC_IP>` (같은 WiFi 네트워크) |
| 최종 사용 이미지 | `nvcr.io/nvidia/isaac-sim:6.0.1` |
| GPU | NVIDIA GB10 Grace Blackwell (device ID 11794) |

> `<DGX_IP>`는 DHCP로 바뀔 수 있으므로 문서에는 값을 적지 않음. 작업 전에 DGX에서 확인:
>
> ```bash
> hostname -I                  # LAN IP (첫 번째 값이 보통 WiFi/유선 IP)
> ip -4 addr show wlP9s9       # WiFi 인터페이스 IP만
> tailscale ip -4              # Tailscale IP (외부에서 접속할 때)
> ```
>
> 아래 명령의 `<DGX_IP>`는 확인한 값으로 바꿔 실행. 웹 뷰어 빌드 시에는 `--build-arg ISAACSIM_HOST=$(hostname -I | awk '{print $1}')`처럼 치환해도 됨.

---

### 스트리밍 아키텍처

```
Isaac Sim 컨테이너 (--network=host)
  └── runheadless.sh
       └── isaac-sim.streaming.sh
            └── kit isaacsim.exp.full.streaming.kit --no-window
                 ├── omni.kit.livestream.webrtc-10.3.2  (StreamSDK 04.86)
                 └── HTTP API 서버 (포트 8011)

웹 뷰어 컨테이너 (--network=host)
  └── Vite 정적 서버 (포트 8210)
       └── @nvidia/create-ov-web-rtc-app@1.14.2
            └── 브라우저에서 49100으로 WebRTC 시그널 연결
```

#### 포트 구성

| 포트 | 프로토콜 | 용도 |
|------|---------|------|
| **8210** | TCP | 웹 뷰어 (브라우저 접속) |
| **49100** | TCP | WebRTC 시그널링 |
| **47998** | UDP | WebRTC 미디어 스트림 |
| 8011 | TCP | Isaac Sim HTTP API (내부용) |

#### 핵심 환경변수

| 변수 | 역할 |
|------|------|
| `ISAACSIM_HOST` | WebRTC SDP publicIp 설정. 미설정 시 맥 클라이언트가 잘못된 IP로 협상 → 연결 실패 |
| `ISAACSIM_SIGNAL_PORT` | 시그널 포트 (기본 49100) |
| `ISAACSIM_STREAM_PORT` | 미디어 포트 (기본 47998) |
| `ACCEPT_EULA=Y` | 필수 |
| `PRIVACY_CONSENT=Y` | 필수 |

---

### 최종 동작 확인된 실행 절차

#### 0단계: Docker 권한 우회 (로그아웃/재로그인 전까지)

`spark01`은 `docker` 그룹에 속하지만 현재 셸에 미반영. 모든 docker 명령 앞에 `sg docker -c "..."` 사용.

```bash
# 영구 해결: 재로그인
logout
```

#### 1단계: 웹 뷰어 Docker 이미지 빌드 (최초 1회)

Dockerfile 위치: `~/isaac-sim-webviewer/Dockerfile`

```dockerfile
FROM nvcr.io/nvidia/base/ubuntu:noble-20251013 AS builder
WORKDIR /app
RUN apt-get update && apt-get install -y --no-install-recommends git curl ca-certificates \
    && curl -fsSL --proto '=https' https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*
RUN echo '@nvidia:registry=https://edge.urm.nvidia.com/artifactory/api/npm/omniverse-client-npm/' >> /root/.npmrc \
    && npx @nvidia/create-ov-web-rtc-app@1.14.2 --name web-viewer --sample local-sample --outputDir /app \
    && rm -f /root/.npmrc
WORKDIR /app/web-viewer
ARG ISAACSIM_HOST=127.0.0.1
ARG ISAACSIM_SIGNAL_PORT=49100
ARG ISAACSIM_STREAM_PORT=47998
RUN sed -i "s/signalingServer: [^,]*/signalingServer: '${ISAACSIM_HOST}'/" src/main.ts \
    && sed -i "/signalingServer:/a\\    signalingPort: ${ISAACSIM_SIGNAL_PORT},\n    mediaServer: '${ISAACSIM_HOST}',\n    mediaPort: ${ISAACSIM_STREAM_PORT},\n    forceWSS: false," src/main.ts
RUN npm install --ignore-scripts && npm run build

FROM nvcr.io/nvidia/base/ubuntu:noble-20251013
RUN apt-get update && apt-get install -y --no-install-recommends curl ca-certificates \
    && curl -fsSL --proto '=https' https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get install -y --no-install-recommends nodejs \
    && rm -rf /var/lib/apt/lists/*
RUN groupadd -r appuser --gid 1234 && useradd --no-log-init -r -g appuser --uid 1234 -d /app -s /usr/sbin/nologin appuser
WORKDIR /app
COPY --from=builder --chmod=755 /app/web-viewer/package.json ./
RUN echo '@nvidia:registry=https://edge.urm.nvidia.com/artifactory/api/npm/omniverse-client-npm/' >> /root/.npmrc \
    && npm install --ignore-scripts && npm cache clean --force && rm -f /root/.npmrc \
    && chown -R appuser:appuser node_modules
COPY --from=builder --chmod=755 /app/web-viewer/dist ./dist
USER appuser
EXPOSE 8210
CMD ["npx", "vite", "preview", "--host", "--port", "8210"]
```

빌드 명령 (`ISAACSIM_HOST`를 DGX IP로 반드시 지정):

```bash
sg docker -c "docker build \
  --build-arg ISAACSIM_HOST=<DGX_IP> \
  --build-arg ISAACSIM_SIGNAL_PORT=49100 \
  --build-arg ISAACSIM_STREAM_PORT=47998 \
  -t isaac-sim-webviewer \
  ~/isaac-sim-webviewer/"
```

#### 2단계: Isaac Sim 6.0.1 실행

```bash
sg docker -c "docker run --name isaac-sim \
  --gpus all \
  --network=host \
  -e ACCEPT_EULA=Y \
  -e PRIVACY_CONSENT=Y \
  -e ISAACSIM_HOST=<DGX_IP> \
  -e ISAACSIM_SIGNAL_PORT=49100 \
  -e ISAACSIM_STREAM_PORT=47998 \
  -v ~/docker/isaac-sim/cache/kit:/root/.cache/ov/kit:rw \
  -v ~/docker/isaac-sim/cache/ov:/root/.cache/nvidia/Omniverse:rw \
  -v ~/docker/isaac-sim/data:/root/.local/share/ov/data:rw \
  -v ~/docker/isaac-sim/documents:/root/Documents:rw \
  nvcr.io/nvidia/isaac-sim:6.0.1"
```

앱 준비 확인 (약 3~4분 소요):

```bash
# 로그에서 "app ready" 메시지 확인
sg docker -c "docker logs -f isaac-sim 2>&1 | grep 'app ready'"
```

#### 3단계: 웹 뷰어 실행

```bash
sg docker -c "docker run --name isaac-sim-webviewer --network=host isaac-sim-webviewer"
```

#### 4단계: 맥 Chrome 브라우저에서 접속

```
http://<DGX_IP>:8210
```

> Safari는 미확인. Chrome 권장.  
> VSCode 포트 포워딩 불필요 — 맥과 DGX가 같은 WiFi 네트워크.

#### 연결 성공 확인 로그

```
[omni.kit.livestream.webrtc.plugin] Processing 11 signaling headers
[omni.kit.livestream.webrtc.plugin] Processed static resize of video stream to 1920x1080
[omni.kit.livestream.webrtc.plugin] Client connected to WebRTC server
```

---

### 트러블슈팅 전체 기록

#### 문제 1: `--gpus all` 누락

**증상:** `libcuda.so.1: cannot open shared object file` 오류와 함께 WebRTC, HydraRTX 등 모든 CUDA 의존 플러그인 로드 실패.

**원인:** `docker run` 시 `--gpus all` 플래그 누락. CUDA 라이브러리가 컨테이너에 주입되지 않음 (`cuda-compat-mode = "ldconfig"` 방식 사용).

**해결:** 반드시 `--gpus all` 추가.

---

#### 문제 2: 포트 충돌 (여러 컨테이너 동시 실행)

**증상:** `http://<DGX_IP>:8011/streaming/webrtc-demo/` 에서 "details not found" 표시.

**원인:** `--gpus all` 없이 먼저 실행된 컨테이너(`busy_meitner`)가 포트 8011, 49100을 선점. 이후 정상 컨테이너들은 다른 포트 사용. 브라우저가 8011에 접속하면 GPU 없는 컨테이너에 연결됨.

**해결:**

```bash
sg docker -c "docker stop busy_meitner hungry_franklin isaac-sim-webrtc"
# 단일 컨테이너로 재시작
```

---

#### 문제 3: `--entrypoint /bin/bash` 사용

**증상:** 컨테이너는 실행됐지만 스트리밍 서버가 시작되지 않음.

**원인:** `--entrypoint /bin/bash` 옵션이 기본 엔트리포인트 `runheadless.sh`를 우회. 스트리밍 서버가 자동 시작되지 않음.

**해결:** `--entrypoint` 옵션 제거. 기본 엔트리포인트 그대로 사용.

---

#### 문제 4: Isaac Sim 6.0.0 + 브라우저 기반 webrtc-demo 페이지 없음

**증상:** `http://<DGX_IP>:8011/streaming/webrtc-demo/` → 404 Not Found.

**원인:** Isaac Sim 6.0.0부터 브라우저용 webrtc-demo 페이지가 제거됨. 이전 버전(4.x, 5.x)에만 존재했던 기능.

**해결:** 네이티브 클라이언트 또는 별도 웹 뷰어 컨테이너 사용.

---

#### 문제 5: Isaac Sim WebRTC Streaming Client 2.0.0 — "Discarding Request"

**증상:** 네이티브 Mac 앱(버전 2.0.0)으로 `<DGX_IP>:49100` 연결 시 화면 없음. 서버 로그에 `Discarding Request` 경고.

**원인 1 — 프로토콜 버전 불일치:** Isaac Sim 6.0.0 서버는 **StreamSDK 04.86 (extension 10.3.2)** 사용. 클라이언트 2.0.0은 Isaac Sim 4.x 시대의 구버전 프로토콜 사용. → 요청 파싱 불가로 폐기.

**원인 2 — GB10 GPU 화이트리스트 미등록:** 서버 시작 로그에 30회 이상 반복:

```
[omni.kit.livestream.streamsdk] The GPU with device ID 11794 is not white-listed.
[omni.kit.livestream.streamsdk] VideoEncoder was not deinitialized prior to destruction!
```

GB10 Grace Blackwell (device ID 11794 = 0x2E12)이 StreamSDK 04.86의 GPU 화이트리스트에 없음 → 하드웨어 비디오 인코더 초기화 실패.

**해결:** Isaac Sim 6.0.1 + 웹 뷰어 방식으로 전환. (6.0.1에서 GB10 화이트리스트 경고 미발생 확인)

> **참고:** 클라이언트 2.0.0이 현재(2026-06 기준) NVIDIA 공식 페이지의 최신 버전임.

---

#### 문제 6: 웹 뷰어 빌드 시 `ISAACSIM_HOST` 기본값 문제

**증상:** 웹 뷰어(`http://<DGX_IP>:8210`) 접속은 되지만 스트림 화면이 나오지 않음.

**원인:** 웹 뷰어를 `--build-arg ISAACSIM_HOST` 없이 빌드하면 기본값 `127.0.0.1`이 JavaScript 소스에 하드코딩됨. 브라우저(맥)에서 실행되는 JS가 `127.0.0.1:49100`(맥 자신의 로컬호스트)으로 WebRTC 시그널 연결 시도 → 연결 없음.

**해결:** `--build-arg ISAACSIM_HOST=<DGX_IP>`로 재빌드. DGX IP가 JavaScript에 하드코딩됨.

```bash
sg docker -c "docker build --build-arg ISAACSIM_HOST=<DGX_IP> -t isaac-sim-webviewer ~/isaac-sim-webviewer/"
```

> **참고:** VSCode 포트 포워딩으로 `localhost:8210` 방식을 쓰려면 웹 뷰어를 `127.0.0.1`로 빌드하고 포트 8210, 49100을 모두 포워딩해야 함. 단, UDP 미디어 포트(47998)는 VSCode 터널 불가 → 직접 IP 방식(`<DGX_IP>`)이 권장.

---

#### 무시해도 되는 정상 경고

| 메시지 | 설명 |
|--------|------|
| `Cannot setup ExternalDragDrop without a default window` | headless 스트리밍 모드에서 항상 발생. 무해함 |
| `director_window.py: AttributeError: '_agent_combo'` | headless 모드 UI 컴포넌트 미초기화로 발생. 무해함 |
| `OmniHub: Hub encountered error` | Omniverse Hub 연결 실패. 스트리밍과 무관 |
| `Unable to detect Omniverse Cache Server` | 캐시 서버 미설치. 성능 영향은 있으나 동작에는 무관 |

---

## 13. RustDesk 원격 접속 설정

### 구성

- 패키지: `/usr/bin/rustdesk`, `/usr/share/rustdesk/rustdesk`
- 서비스: `rustdesk.service` (`enabled`, `multi-user.target`) — `--service` 실행 시 `--server`(spark01 권한), `--tray`를 함께 띄움
- ID/릴레이 서버: `rs-ny.rustdesk.com` (공개 서버, NAT 유형 ASYMMETRIC)
- 설정 파일: `~/.config/rustdesk/` (`RustDesk.toml`, `RustDesk2.toml`, `RustDesk_local.toml`, 권한 600)
- 로그: `~/.local/share/logs/RustDesk/{server,service,tray}/`

### 처음부터 설정하는 절차 (재설치/새 머신용)

셸 history(`~/.bash_history`)에서 실제로 성공한 순서를 정리한 것. aarch64(DGX Spark) 기준.

**1) 설치: Homebrew가 아니라 공식 .deb 사용**

```bash
wget --content-disposition https://github.com/rustdesk/rustdesk/releases/download/1.3.8/rustdesk-1.3.8-aarch64.deb
sudo apt install -y ./rustdesk-1.3.8-aarch64.deb   # 앞의 ./ 필수 (없으면 패키지 이름으로 해석됨)
rm -f rustdesk-1.3.8-aarch64.deb
```

> history상 `brew install rustdesk`를 여러 번 시도한 뒤 `brew uninstall rustdesk`로 제거하고 .deb로 교체함 (정확한 실패 사유는 history에 없음. systemd 서비스 유닛이 필요해서였을 가능성이 높음). 최신 버전은 releases 페이지에서 확인.

**2) X11 세션 확보 (화면 공유 전제)**

```bash
echo $XDG_SESSION_TYPE                      # x11 이어야 함
ps aux | grep -E "gdm|lightdm|Xorg"
ls -la /tmp/.X11-unix/                      # X0 소켓 확인
sudo nvim /etc/gdm3/custom.conf             # WaylandEnable=false, AutomaticLogin 설정 (아래 "GDM 자동 로그인")
sudo systemctl start gdm3                   # history 기준. 재시작(restart)하면 로그인 세션이 끊기므로 주의
```

**3) 서비스 활성화**

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now rustdesk
systemctl status rustdesk
```

**4) 접속 비밀번호 설정 및 ID 확인 (무인 접속용)**

```bash
sudo rustdesk --password '<영구 비밀번호>'
sudo rustdesk --get-id
```

> 비밀번호를 명령줄에 쓰면 `~/.bash_history`에 평문으로 남음. 이전 설정 때도 남아 있으므로 `history -d`나 `~/.bash_history`에서 해당 줄을 지우고, 비밀번호를 바꾸는 것을 권장. 문서에는 비밀번호를 기록하지 않음.

**5) 직접 IP 접속(direct-server) 켜기**

```bash
sudo rustdesk --option direct-server Y      # root 설정에 반영 (서비스 재시작 시 덮어써지지 않음)
sudo systemctl restart rustdesk
ss -tlnp | grep 21118                       # LISTEN 확인
```

사용자 설정 파일(`~/.config/rustdesk/RustDesk2.toml`)에만 쓰면 서비스 재시작 때 root 설정에 덮어써져 사라짐. history에서는 이 파일에 직접 `[options]` 아래 `direct-server = 'Y'`(및 `direct_server = 'Y'`)를 써 넣고 수동으로 `rustdesk --service`를 띄우는 방식을 썼음 (임시 방편).

**6) 서비스 `ExecStop` 수정** → 아래 "자동 시작 확인 및 수정" 참고.

**7) 접속 확인**

- ID 접속: 다른 PC의 RustDesk에서 `--get-id`로 얻은 ID + 비밀번호
- 직접 IP 접속: `<DGX IP>:21118` (같은 LAN 또는 Tailscale `tailscale ip -4`)
- 재부팅 후 점검 명령은 아래 참고

**수동으로 서비스를 띄웠던 방법 (비권장, 디버깅용)**

systemd 없이 사용자 세션에서 직접 실행할 때는 X 접근 정보가 필요함. `DISPLAY=:0`만으로는 부족하고 gdm의 Xauthority를 지정해야 했음.

```bash
loginctl list-sessions
loginctl show-session <ID> -p Type -p Display -p Remote -p Leader
sudo cat /proc/<LeaderPID>/environ | tr '\0' '\n' | grep -E '^(DISPLAY|XAUTHORITY)='
# 결과: DISPLAY=:0, XAUTHORITY=/run/user/1000/gdm/Xauthority
DISPLAY=:0 XAUTHORITY=/run/user/1000/gdm/Xauthority nohup rustdesk --service > /tmp/rustdesk_srv.log 2>&1 &
```

`XAUTHORITY=$HOME/.Xauthority`는 동작하지 않았음. 수동 실행 프로세스는 systemd 관리 밖이라 `systemctl status`가 `failed`로 보이는 원인이 됨 → 정리하려면 `sudo pkill -f "rustdesk --"` 후 `sudo systemctl restart rustdesk`.

**정리된 시행착오**

| 시도 | 결과 |
|------|------|
| `brew install rustdesk` | 제거 후 .deb로 교체 |
| TigerVNC(`vncserver`) | RustDesk로 방향 전환하며 제거 (`apt remove tigervnc-*`, `rm -rf ~/.vnc`) |
| `XAUTHORITY=$HOME/.Xauthority` | X 접근 실패 → `/run/user/1000/gdm/Xauthority` 사용 |
| 사용자 설정 파일에만 `direct-server` 기록 | 서비스 재시작 시 root 설정으로 덮어써짐 → `rustdesk --option`으로 root에 설정 |

### 자동 시작 확인 및 수정

문제: 기본 유닛의 `ExecStop=/usr/bin/pkill -f "rustdesk --"`가 자기 자신/sudo 프로세스까지 매칭해 exit 1로 종료 → 서비스가 `failed` 상태로 남음.

해결: systemd drop-in으로 `ExecStop` 교체 (`/usr/lib` 원본 유닛은 수정하지 않음, 패키지 업데이트에도 유지).

`/etc/systemd/system/rustdesk.service.d/override.conf`:

```ini
[Service]
ExecStop=
ExecStop=/bin/sh -c 'pkill -f "^/usr/share/rustdesk/rustdesk --(tray|server)" || true'
```

```bash
sudo systemctl daemon-reload
sudo systemctl reset-failed rustdesk
sudo systemctl restart rustdesk
```

### 직접 IP 접속 (direct-server)

문제: systemd로 서비스를 재시작하면 `sync config2 from root`로 root 설정이 사용자 설정을 덮어써서 `direct-server = 'Y'`가 사라지고 포트 21118이 닫힘 (로그: `Exit direct access listen`).

해결: GUI(설정 → 보안 → IP 직접 접속 허용) 또는 `sudo rustdesk --option direct-server Y`로 root 설정에 반영. 재시작 후 `~/.config/rustdesk/RustDesk2.toml`의 `[options]`에 `direct-server = 'Y'` 유지, 포트 21118 LISTEN 확인.

### 재부팅 후 점검 명령

```bash
systemctl status rustdesk
ss -tlnp | grep 21118
tail ~/.local/share/logs/RustDesk/server/rustdesk_rCURRENT.log
```

### GDM 자동 로그인

화면 공유에는 로그인된 X 세션(`DISPLAY=:0`, `XAUTHORITY=/run/user/1000/gdm/Xauthority`)이 필요함. `/etc/gdm3/custom.conf`에 이미 설정됨:

```ini
[daemon]
WaylandEnable=false
AutomaticLoginEnable = true
AutomaticLogin = spark01
```

`WaylandEnable=false`는 RustDesk가 X11에서 안정적으로 동작하도록 한 설정. 화면 자동 잠금이 걸리면 접속 시 잠금 화면이 보이므로 필요 시 해제.

---

## 14. 셸 문제 해결 기록 (RustDesk 터미널)

### 증상 1: ble.sh 오류 메시지

RustDesk 터미널(`TERM=xterm-ghostty`)에서 셸 시작 시:

```
bash: ((: _ble_hook_c_prompt_command/_load: division by 0 ...
blehook: invalid hook spec "prompt_command/_load+=..."
```

원인: `~/.bashrc`의 `blehook/eval-after-load prompt_command/ ...` 줄이 잘못된 훅 지정. ble.sh는 `ble-attach` 시 starship의 `PROMPT_COMMAND`를 자동 처리하므로 불필요.

조치: 해당 줄 삭제 (백업: `~/.bashrc.bak-20261015`). 최종 구조: `ble.sh --noattach` 로드 → `starship init` → `ble-attach`.

> `ble/term.sh: updating tput cache for TERM=xterm-ghostty... done`은 새로운 TERM 값에 대한 캐시 생성 안내이며 한 번만 나오는 정상 메시지.

### 증상 2: 시작 시 `~` 줄이 여러 번 표시

starship 기본 프롬프트는 2줄(디렉터리 줄 + `❯` 줄)이고 `add_newline = true`가 기본값. `clear` 후 맨 위에 남는 `~`는 새로 그려진 프롬프트의 디렉터리 줄.

조치: `~/.config/starship.toml`로 한 줄 프롬프트 적용 (섹션 11 참고). 새 터미널에서 정상 표시 확인.

---

## 15. Docker / NVIDIA Container Toolkit 검증

`~/.bash_history` 기준 순서. history에는 Docker/NVIDIA 런타임 설치 명령이 없고 검증 명령만 있음 (OS에 기본 포함으로 보임).

```bash
nvidia-smi
docker --version
nvcc -V
dpkg -l | grep nvidia-container-toolkit        # 툴킷 설치 여부
docker info | grep -i runtime                  # nvidia 런타임 확인
docker run --rm --gpus all nvidia/cuda:12.0.0-base-ubuntu22.04 nvidia-smi
```

현재 사용자를 docker 그룹에 추가 (매번 sudo 불필요하게):

```bash
sudo usermod -aG docker $USER
newgrp docker                                   # 현재 셸에만 즉시 반영. 완전 적용은 재로그인
sudo systemctl daemon-reload && sudo systemctl restart docker
docker info | grep -E "Runtimes|Default Runtime"
docker run --rm hello-world
docker run --rm --gpus all ubuntu:24.04 bash -lc 'echo "NVIDIA runtime OK"'
```

> 재로그인 전에는 `sg docker -c "docker ..."`로 우회 (섹션 12 참고). 테스트용 `nvidia/cuda` 이미지는 `docker rmi <IMAGE_ID>`로 정리함 (`docker rm`은 컨테이너용이라 이미지에는 `rmi`).

---

## 16. Isaac ROS 설치 (NVIDIA apt 저장소 + CLI)

워크스페이스 생성과 `ISAAC_ROS_WS` 환경변수는 섹션 8 참고.

```bash
sudo apt update && sudo apt install curl gnupg software-properties-common
sudo add-apt-repository universe

k="/usr/share/keyrings/nvidia-isaac-ros.gpg"
curl -fsSL https://isaac.download.nvidia.com/isaac-ros/repos.key | sudo gpg --dearmor | sudo tee -a $k > /dev/null
f="/etc/apt/sources.list.d/nvidia-isaac-ros.list"
sudo touch $f
s="deb [signed-by=$k] https://isaac.download.nvidia.com/isaac-ros/release-4.4 noble-fastos main"
grep -qxF "$s" $f || echo "$s" | sudo tee -a $f

sudo apt-get update
sudo apt-get install isaac-ros-cli
sudo isaac-ros init docker
```

- 저장소는 Ubuntu 24.04(noble) / `release-4.4` 기준. 버전이 바뀌면 `s=` 줄의 `release-4.4`를 수정.
- `isaac-sim:6.0.0` 이미지는 `docker pull nvcr.io/nvidia/isaac-sim:6.0.0`으로 받음 (NGC 로그인 필요할 수 있음). 스트리밍 실행은 섹션 12 참고.

---

## 17. 3DGS 개발 환경 (uv + PyTorch + gsplat)

프로젝트 위치: `~/workspaces/3dgs-lab` (Python 3.12, `uv` 관리).

```bash
brew install uv
mkdir -p ~/workspaces/3dgs-lab && cd ~/workspaces/3dgs-lab
uv init --bare --python 3.12
uv add torch --index pytorch-cu130=https://download.pytorch.org/whl/cu130   # CUDA 13.0 빌드 (GB10/Blackwell, aarch64)
uv add numpy pillow packaging
uv add gsplat
```

gsplat은 CUDA 확장을 JIT 빌드하므로 Python 헤더가 필요함:

```bash
sudo apt install -y python3.12-dev
test -f /usr/include/python3.12/Python.h && echo "Python headers: OK"
```

**트러블슈팅: `python3.12-dev` 설치 중 의존성 충돌**

`apt --fix-broken install`이 `python3-markdown-it` 관련 충돌로 실패했을 때, history 순서:

```bash
apt -s remove python3-markdown-it                  # 시뮬레이션으로 영향 확인
apt-cache policy python3-markdown-it python3-markdown-it-py python3-rich
dpkg -S /usr/bin/markdown-it
sudo dpkg --remove python3-markdown-it             # 충돌 패키지만 제거
sudo apt --fix-broken install
sudo apt install -y python3.12-dev
```

**동작 검증** (history에서 사용한 스모크 테스트 요약)

```bash
uv run python -c "import torch; print(torch.__version__, torch.version.cuda, torch.cuda.is_available(), torch.cuda.get_device_name(0))"
uv run python -c "import gsplat; print(gsplat.__version__)"
```

Gaussian 3개를 `gsplat.rasterization`으로 256x256 렌더링(`render_mode="RGB+ED"`)해 `renders/smoke-test/rgb.png`, `depth.png`를 저장하는 테스트까지 수행. 결과 파일은 프로젝트의 `renders/` 아래에 있음.

> 주의: `~/workspaces/3dgs-lab/ble.sh/`에 ble.sh 저장소 클론이 남아 있음 (섹션 11 설치 때 해당 디렉터리에서 `git clone`을 실행한 것으로 보임). `~/.local/share/blesh`에 설치가 끝났으므로 삭제해도 됨.

---

## 18. 터미널 / 브라우저 설치 시행착오

### Ghostty 렌더링 문제

- Homebrew 버전(`brew install ghostty`)과 `mkasberg/ghostty-ubuntu` 스크립트 설치를 모두 시도. 최종적으로 `brew uninstall ghostty` 후 스크립트(apt) 버전 사용.
- GPU/GL 렌더링 문제 때문에 아래 환경변수를 조합해 시험함 (GL 문제 회피용으로 보이며, 정확한 증상은 history에 없음):

```bash
GDK_DISABLE=color-mgmt GTK_THEME=Adwaita GHOSTTY_RENDERER=software LIBGL_ALWAYS_SOFTWARE=true ghostty
```

- 현재 `~/.config/ghostty/config`:

```
gtk-single-instance = true
quit-after-last-window-closed = false
```

  (`config.ghostty`도 같은 디렉터리에 있음. 어느 파일이 우선인지는 Ghostty 버전에 따라 다르니 하나만 유지 권장)
- 대체 터미널로 `kitty`도 설치 시도 (`brew install kitty`, `sudo apt install kitty`). 현재 사용 여부는 history에 없음.
- 원격(RustDesk)에서 접속한 터미널의 `TERM`은 `xterm-ghostty`. 이 값에 대한 terminfo는 이미 있어 문제없음 (섹션 14).

### 웹 브라우저

- history상 `brew install google-chrome` 시도 후 구글 공식 `.deb`(`google-chrome-stable_current_amd64.deb`)를 받아 설치하려 했음.
  **주의:** DGX Spark는 ARM64라서 amd64 `.deb`는 설치되지 않음. 결과는 history에 없음. ARM64용 브라우저는 `firefox`(apt)나 `chromium`을 사용.
- 이후 `google-chrome --no-sandbox`, `chromium-browser --no-sandbox`, `firefox` 순으로 실행을 시도함 (VNC `DISPLAY=:1`에서 `xhost +`로 접근 허용 후 실행).
- Isaac Sim 스트리밍 클라이언트는 맥 Chrome에서 접속 (섹션 12).

---

## 19. VNC 원격 데스크톱 시도 (폐기)

RustDesk 이전에 TigerVNC + XFCE로 원격 데스크톱을 구성해 봤으나 모두 제거함. 같은 시도를 반복하지 않기 위한 기록.

```bash
sudo apt install -y xfce4 xfce4-goodies tigervnc-standalone-server
vncpasswd
mkdir -p ~/.vnc && nvim ~/.vnc/xstartup && chmod +x ~/.vnc/xstartup
vncserver -localhost no :1 -geometry 1920x1080 -depth 24
ss -tlnp | grep 5901
vncserver -kill :1
```

- XFCE 세션에서 반복되는 polkit 인증 창을 없애려고 `/etc/polkit-1/rules.d/`에 규칙 파일을 만들었다 지웠다 함:
  `45-allow-vnc-actions.rules`, `45-allow-colord-complete.rules`, `45-allow-networkmanager-complete.rules` (그리고 `localauthority/50-local.d/*.pkla`).
- 이 과정에서 `sudo nvim`이 PATH에 없어 `sudo ln -s ~/.local/share/bob/nvim-bin/nvim /usr/local/bin/nvim` 심볼릭 링크를 만듦 (이 링크는 아직 유효할 수 있음).
- 정리: `sudo apt remove xfce4-terminal tigervnc-common tigervnc-standalone-server`, `rm -rf ~/.vnc`, `sudo apt autoremove`.

> 확인 필요: polkit 규칙 파일 중 `*-complete.rules` 두 개는 삭제 명령이 history에 없음. root 권한으로 `ls /etc/polkit-1/rules.d/`를 확인하고 불필요하면 지울 것 (보안상 인증 없이 허용하는 규칙일 수 있음).

---

## 20. 기타 셸 도구 / 설정

| 항목 | 내용 |
|------|------|
| `~/.inputrc` | 대소문자 무시 완성, 탭 메뉴 순회(`menu-complete`), Shift-Tab 역방향, 위/아래 화살표 접두사 히스토리 검색, `"\C-@": accept-line` |
| `fzf`, `zoxide` | `brew install fzf zoxide` (zoxide는 `.bashrc`에서 init, 섹션 10) |
| `btop` | `brew install btop` — 시스템 모니터 |
| `xdotool` | `brew install xdotool` — X11 입력 자동화 (RustDesk 작업 직전에 설치. 용도는 history에 없음) |
| `tailscale` | 설치되어 있고 `tailscale ip -4`로 IP를 확인함. 외부 접속용 주소로 활용 가능 (RustDesk 직접 접속에도) |
| Claude Code | `brew install claude-code` 후 `claude` |
| GitHub Copilot CLI | `copilot` 실행 시도 (설치 방법은 history에 없음) |
| dotfiles | `git clone https://github.com/algento/dotfiles.git` 시도. 단 `mkdir -p ./github`(점 없는 상대경로)라 현재 `~/github`는 없음. 클론 결과 위치는 확인 필요 |
| `~/.bash_profile` | `[ -f ~/.bashrc ] && . ~/.bashrc` (로그인 셸에서도 `.bashrc` 로드) |
| 재부팅 | history에 `sudo reboot` 1회 기록 (이유는 불명) |

---

## 향후 설정 예정 (미완료)

- [ ] Neovim 플러그인 / config 설정
- [ ] Ghostty 터미널 설정 파일 작성
- [ ] tmux / tmuxinator 세션 설정
- [ ] Isaac ROS 패키지 빌드 환경 구성
- [ ] SSH config 파일 작성 (원격 서버 등록)
