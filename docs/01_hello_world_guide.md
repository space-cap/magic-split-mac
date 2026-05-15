# 🚀 Phoenix 기초 가이드: Hello World 페이지 만들기

이 문서는 Phoenix 프레임워크에서 새로운 페이지를 만들고 실시간 기능을 이해하기 위한 기초 가이드입니다.

---

## 1. 새로운 페이지를 만드는 2단계 흐름

Phoenix에서 새로운 페이지를 만들 때는 보통 다음 두 가지만 기억하면 됩니다.

### ① 주소 등록하기 (Router)
브라우저 주소창에 입력할 경로를 설정합니다.
- **파일**: `lib/magic_split_mac_web/router.ex`
- **코드**: `live "/hello", HelloLive`
- **의미**: "누가 `/hello`로 들어오면 `HelloLive`라는 모듈(파일)을 보여줘!"

### ② 내용 작성하기 (LiveView)
실제로 화면에 보여줄 데이터와 디자인을 작성합니다.
- **파일**: `lib/magic_split_mac_web/live/hello_live.ex`
- **구성 요소**:
  - `mount`: 페이지가 열릴 때 초기 데이터를 준비하는 곳 (예: 메시지 설정)
  - `render`: HTML 디자인을 작성하는 곳 (`~H` 안에 작성)

---

## 2. 핵심 개념 이해하기

### 📡 get vs live
- **get**: 전통적인 방식. 한 번 보여주면 끝 (새로고침 필요).
- **live**: 현대적인 방식. 서버와 계속 연결되어 있어 데이터가 바뀌면 화면이 **실시간**으로 자동 업데이트됨.

### 🏗️ 레이아웃(Layout) 구조 (인형 뽑기 구조)
화면은 여러 겹의 층으로 구성되어 있습니다.

1.  **Root Layout (`root.html.heex`)**: 가장 바깥쪽 뼈대. HTML 헤더, CSS/JS 로드 등을 담당.
2.  **App Layout (`layouts.ex`의 `app` 함수)**: 중간 단계의 옷. 상단 메뉴바, 로고 등 공통 디자인 담당.
3.  **Page (`hello_live.ex`)**: 실제 알맹이 내용.

> **💡 참고**: `<Layouts.app>`은 `layouts.ex` 파일 안에 정의된 `app` 함수를 호출하는 것입니다.

---

## 3. 자주 쓰는 명령어

- `mix deps.get`: 필요한 라이브러리 설치
- `mix phx.server`: 로컬 개발 서버 실행 (기본 주소: `http://localhost:4000`)

---

## 4. 에러 해결 팁
- **Module undefined**: 새로운 파일을 만들었는데 인식을 못 한다면 서버를 껐다가(`Ctrl+C`) 다시 켜보세요.
- **Syntax Error**: 태그를 열고 닫을 때 마침표(`.`)를 주의하세요. (예: `<.link>` -> `</.link>`)
